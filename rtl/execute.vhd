library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.std_logic_textio.all;          -- I/O for logic types

library work;
use work.rv_components.all;
use work.utils.all;

library STD;
use STD.textio.all;                     -- basic I/O

entity execute is
  generic(
    REGISTER_SIZE       : positive;
    REGISTER_NAME_SIZE  : positive;
    INSTRUCTION_SIZE    : positive;
    SIGN_EXTENSION_SIZE : positive;
    RESET_VECTOR        : integer;
    MULTIPLY_ENABLE     : boolean;
    DIVIDE_ENABLE       : boolean;
    SHIFTER_MAX_CYCLES  : natural;
    COUNTER_LENGTH      : natural;
    ENABLE_EXCEPTIONS   : boolean;
    LVE_ENABLE          : boolean;
    SCRATCHPAD_SIZE     : integer := 1024;
    FAMILY              : string  := "ALTERA");
  port(
    clk            : in std_logic;
    scratchpad_clk : in std_logic;
    reset          : in std_logic;
    valid_input    : in std_logic;

    br_taken_in  : in std_logic;
    pc_current   : in std_logic_vector(REGISTER_SIZE-1 downto 0);
    instruction  : in std_logic_vector(INSTRUCTION_SIZE-1 downto 0);
    subseq_instr : in std_logic_vector(INSTRUCTION_SIZE-1 downto 0);

    rs1_data       : in std_logic_vector(REGISTER_SIZE-1 downto 0);
    rs2_data       : in std_logic_vector(REGISTER_SIZE-1 downto 0);
    sign_extension : in std_logic_vector(SIGN_EXTENSION_SIZE-1 downto 0);

    wb_sel       : buffer std_logic_vector(REGISTER_NAME_SIZE-1 downto 0);
    wb_data      : buffer std_logic_vector(REGISTER_SIZE-1 downto 0);
    wb_enable    : buffer std_logic;
    valid_output : buffer std_logic;

    instruction_fetch_pc : in std_logic_vector(REGISTER_SIZE-1 downto 0);

    branch_pred        : out    std_logic_vector(REGISTER_SIZE*2+3 -1 downto 0);
    stall_from_execute : buffer std_logic;
    pipeline_empty     : in     std_logic;

--memory-bus
    address   : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    byte_en   : out std_logic_vector(REGISTER_SIZE/8 -1 downto 0);
    write_en  : out std_logic;
    read_en   : out std_logic;
    writedata : out std_logic_vector(REGISTER_SIZE-1 downto 0);
    readdata  : in  std_logic_vector(REGISTER_SIZE-1 downto 0);
    data_ack  : in  std_logic;

    mtime_i    : in std_logic_vector(63 downto 0);
    mip_mtip_i : in std_logic;
    mip_msip_i : in std_logic;
    mip_meip_i : in std_logic;

    interrupt_pending_o : out std_logic);


end entity execute;

architecture behavioural of execute is

  alias rd : std_logic_vector(REGISTER_NAME_SIZE-1 downto 0) is
    instruction(11 downto 7);
  alias rs1 : std_logic_vector(REGISTER_NAME_SIZE-1 downto 0) is
    instruction(19 downto 15);
  alias rs2 : std_logic_vector(REGISTER_NAME_SIZE-1 downto 0) is
    instruction(24 downto 20);
  alias opcode : std_logic_vector(4 downto 0) is
    instruction(6 downto 2);

  signal predict_corr    : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal predict_corr_en : std_logic;


  signal ls_address    : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal ls_byte_en    : std_logic_vector(REGISTER_SIZE/8 -1 downto 0);
  signal ls_write_en   : std_logic;
  signal ls_read_en    : std_logic;
  signal ls_write_data : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal ls_read_data  : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal ls_ack        : std_logic;


  -- various writeback sources
  signal br_data_out  : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal alu_data_out : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal ld_data_out  : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal upp_data_out : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal sys_data_out : std_logic_vector(REGISTER_SIZE-1 downto 0);

  signal br_data_enable     : std_logic;
  signal alu_data_out_valid : std_logic;
  signal ld_data_enable     : std_logic;
  signal upp_data_enable    : std_logic;
  signal sys_data_enable    : std_logic;
  signal less_than          : std_logic;
  signal wb_mux             : std_logic_vector(1 downto 0);

  signal stall_to_alu   : std_logic;
  signal stall_from_alu : std_logic;

  signal br_bad_predict : std_logic;
  signal br_new_pc      : std_logic_vector(REGISTER_SIZE-1 downto 0);

  signal predict_pc     : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal syscall_en     : std_logic;
  signal syscall_target : std_logic_vector(REGISTER_SIZE-1 downto 0);

  signal rs1_data_fwd : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal rs2_data_fwd : std_logic_vector(REGISTER_SIZE-1 downto 0);

  signal stall_to_lsu    : std_logic;
  signal ls_unit_waiting : std_logic;

  signal fwd_sel  : std_logic_vector(REGISTER_NAME_SIZE-1 downto 0);
  signal fwd_data : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal fwd_en   : std_logic;
  signal fwd_mux  : std_logic;

  signal stall_from_lve   : std_logic;
  signal lve_data1        : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal lve_data2        : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal lve_result       : std_logic_vector(REGISTER_SIZE-1 downto 0);
  signal lve_result_valid : std_logic;
  signal lve_source_valid : std_logic;
  signal stall_to_lve     : std_logic;

  signal valid_instr : std_logic;
  signal rd_latch    : std_logic_vector(REGISTER_NAME_SIZE-1 downto 0);

  signal valid_input_latched : std_logic;


  constant ZERO : std_logic_vector(REGISTER_NAME_SIZE-1 downto 0) := (others => '0');

  type fwd_mux_t is (ALU_FWD, NO_FWD);
  signal rs1_mux : fwd_mux_t;
  signal rs2_mux : fwd_mux_t;

  signal finished_instr : std_logic;

  signal illegal_alu_instr : std_logic;

  signal is_branch    : std_logic;
  signal br_taken_out : std_logic;

  constant JAL_OP   : std_logic_vector(4 downto 0) := "11011";
  constant JALR_OP  : std_logic_vector(4 downto 0) := "11001";
  constant LUI_OP   : std_logic_vector(4 downto 0) := "01101";
  constant AUIPC_OP : std_logic_vector(4 downto 0) := "00101";
  constant ALU_OP   : std_logic_vector(4 downto 0) := "01100";
  constant ALUI_OP  : std_logic_vector(4 downto 0) := "00100";
  constant CSR_OP   : std_logic_vector(4 downto 0) := "11100";
  constant LD_OP    : std_logic_vector(4 downto 0) := "00000";
  constant LVE_OP   : std_logic_vector(4 downto 0) := "01010";

  alias ni_rs1 : std_logic_vector(REGISTER_NAME_SIZE-1 downto 0) is subseq_instr(19 downto 15);
  alias ni_rs2 : std_logic_vector(REGISTER_NAME_SIZE-1 downto 0) is subseq_instr(24 downto 20);

  constant SP_ADDRESS : unsigned(REGISTER_SIZE-1 downto 0) := x"80000000";

  signal use_after_produce_stall      : std_logic;
  signal use_after_produce_stall_mask : std_logic;

  function bool_to_int (
    signal a : std_logic)
    return integer is
  begin  -- function bool_to_int
    if a = '1' then
      return 1;
    end if;
    return 0;
  end function bool_to_int;

begin
  valid_instr <= valid_input and not use_after_produce_stall;
  -----------------------------------------------------------------------------
  -- REGISTER FORWADING
  -- Knowing the next instruction coming downt the pipeline, we can
  -- generate the mux select bits for the next cycle.
  -- there are several functional units that could generate a writeback. ALU,
  -- JAL, Syscalls, load_store. the Alu forward directly to the next
  -- instruction, The others stall the pipeline to wait for the registers to
  -- propogate if the next instruction uses them.
  --
  -----------------------------------------------------------------------------
  with rs1_mux select
    rs1_data_fwd <=
    alu_data_out when ALU_FWD,
    rs1_data     when others;
  with rs2_mux select
    rs2_data_fwd <=
    alu_data_out when ALU_FWD,
    rs2_data     when others;


  -------------------------------------------------------------------------------
  -- This process is useful for finding bugs in simulation
  -------------------------------------------------------------------------------
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '0' then
        assert (bool_to_int(sys_data_enable) +
                bool_to_int(ld_data_enable) +
                bool_to_int(br_data_enable) +
                bool_to_int(alu_data_out_valid)) <=1  and reset = '0' report "Multiple Data Enables Asserted" severity failure;
      end if;
    end if;
  end process;

  wb_mux <= "00" when sys_data_enable = '1' else
            "01" when ld_data_enable = '1' else
            "10" when br_data_enable = '1' else
            "11";                       --when alu_data_out_valid = '1'

  with wb_mux select
    wb_data <=
    sys_data_out when "00",
    ld_data_out  when "01",
    br_data_out  when "10",
    alu_data_out when others;

  wb_enable <= sys_data_enable or ld_data_enable or br_data_enable or (alu_data_out_valid and (not stall_from_lve)) when wb_sel /= ZERO else '0';
  wb_sel    <= rd_latch;

  fwd_data <= sys_data_out when sys_data_enable = '1' else
              alu_data_out when alu_data_out_valid = '1' else
              br_data_out;

  use_after_produce_stall <= wb_enable and valid_input and use_after_produce_stall_mask;
  stall_to_lve            <= (ls_unit_waiting or use_after_produce_stall) and valid_input;
  stall_to_alu            <= (ls_unit_waiting or use_after_produce_stall) and valid_input;
  stall_from_execute      <= (ls_unit_waiting or stall_from_alu or use_after_produce_stall or stall_from_lve) and valid_input;
  stall_to_lsu            <= (ls_unit_waiting or stall_from_alu or use_after_produce_stall or stall_from_lve) and valid_input;

  --TODO clean this up.
  -- There was a bug here that valid output would not go high if a load was followed
  -- by a pipeline bubble, the "or ld_data_enable" belwo fixes that, but it
  -- doesn't seem to be the right fix.
  valid_output <= valid_input_latched or ls_ack;

  process(clk)
    variable current_alu  : boolean;
    variable rs1_mux_var  : fwd_mux_t;
    variable rs2_mux_var  : fwd_mux_t;
    variable rd_latch_var : std_logic_vector(rd'range);
  begin
    if rising_edge(clk) then

      valid_input_latched <= valid_input and not stall_from_execute;
      --calculate where the next forward data will go
      current_alu         := opcode = LUI_OP or
                             opcode = AUIPC_OP or
                             opcode = ALU_OP or
                             opcode = ALUI_OP;

      rs1_mux_var := NO_FWD;
      rs2_mux_var := NO_FWD;
      if (current_alu) and valid_instr = '1' and stall_from_execute = '0' then
        if rd = ni_rs1 and rd /= ZERO then
          rs1_mux_var := ALU_FWD;
        end if;
        if rd = ni_rs2 and rd /= ZERO then
          rs2_mux_var := ALU_FWD;
        end if;
      end if;
      rd_latch_var := rd_latch;
      if stall_from_execute = '0' then
        rd_latch_var := rd;
      end if;

      if ((rd_latch_var = ni_rs1 and rs1_mux_var = NO_FWD) or (rd_latch_var = ni_rs2 and rs2_mux_var = NO_FWD)) then
        use_after_produce_stall_mask <= '1';
      end if;
      if use_after_produce_stall = '1' and wb_enable = '1' then
        use_after_produce_stall_mask <= '0';
      end if;

      rd_latch <= rd_latch_var;
      rs1_mux  <= rs1_mux_var;
      rs2_mux  <= rs2_mux_var;
    end if;
  end process;

  alu : component arithmetic_unit
    generic map (
      INSTRUCTION_SIZE    => INSTRUCTION_SIZE,
      REGISTER_SIZE       => REGISTER_SIZE,
      SIGN_EXTENSION_SIZE => SIGN_EXTENSION_SIZE,
      MULTIPLY_ENABLE     => MULTIPLY_ENABLE,
      DIVIDE_ENABLE       => DIVIDE_ENABLE,
      SHIFTER_MAX_CYCLES  => SHIFTER_MAX_CYCLES,
      FAMILY              => FAMILY)
    port map (
      clk                => clk,
      stall_to_alu       => stall_to_alu,
      stall_from_execute => stall_from_execute,
      valid_instr        => valid_instr,
      rs1_data           => rs1_data_fwd,
      rs2_data           => rs2_data_fwd,
      instruction        => instruction,
      sign_extension     => sign_extension,
      program_counter    => pc_current,
      data_out           => alu_data_out,
      data_out_valid     => alu_data_out_valid,
      illegal_alu_instr  => illegal_alu_instr,
      less_than          => less_than,
      stall_from_alu     => stall_from_alu,

      lve_data1        => lve_data1,
      lve_data2        => lve_data2,
      lve_source_valid => lve_source_valid
      );


  branch : entity work.branch_unit(latch_middle)
    generic map (
      REGISTER_SIZE       => REGISTER_SIZE,
      INSTRUCTION_SIZE    => INSTRUCTION_SIZE,
      SIGN_EXTENSION_SIZE => SIGN_EXTENSION_SIZE)
    port map(
      clk            => clk,
      reset          => reset,
      valid          => valid_instr,
      stall          => stall_from_execute,
      rs1_data       => rs1_data_fwd,
      rs2_data       => rs2_data_fwd,
      current_pc     => pc_current,
      br_taken_in    => br_taken_in,
      instr          => instruction,
      less_than      => less_than,
      sign_extension => sign_extension,
      data_out       => br_data_out,
      data_out_en    => br_data_enable,
      new_pc         => br_new_pc,
      is_branch      => is_branch,
      br_taken_out   => br_taken_out,
      bad_predict    => br_bad_predict);

  ls_unit : component load_store_unit
    generic map(
      REGISTER_SIZE       => REGISTER_SIZE,
      SIGN_EXTENSION_SIZE => SIGN_EXTENSION_SIZE,
      INSTRUCTION_SIZE    => INSTRUCTION_SIZE)
    port map(
      clk            => clk,
      reset          => reset,
      valid          => valid_instr,
      stall_to_lsu   => stall_to_lsu,
      rs1_data       => rs1_data_fwd,
      rs2_data       => rs2_data_fwd,
      instruction    => instruction,
      sign_extension => sign_extension,
      stalled        => ls_unit_waiting,
      data_out       => ld_data_out,
      data_enable    => ld_data_enable,
      --memory bus
      address        => ls_address,
      byte_en        => ls_byte_en,
      write_en       => ls_write_en,
      read_en        => ls_read_en,
      write_data     => ls_write_data,
      read_data      => ls_read_data,
      ack            => ls_ack);

  syscall : component system_calls
    generic map (
      REGISTER_SIZE     => REGISTER_SIZE,
      INSTRUCTION_SIZE  => INSTRUCTION_SIZE,
      RESET_VECTOR      => RESET_VECTOR,
      ENABLE_EXCEPTIONS => ENABLE_EXCEPTIONS,
      COUNTER_LENGTH    => COUNTER_LENGTH)
    port map (
      clk            => clk,
      reset          => reset,
      valid          => valid_instr,
      rs1_data       => rs1_data_fwd,
      instruction    => instruction,
      finished_instr => finished_instr,
      wb_data        => sys_data_out,
      wb_enable      => sys_data_enable,

      current_pc           => pc_current,
      pc_correction        => syscall_target,
      pc_corr_en           => syscall_en,
      illegal_alu_instr    => illegal_alu_instr,
      use_after_load_stall => '0',
      load_stall           => stall_from_execute,
      predict_corr         => predict_corr_en,

      mtime_i    => mtime_i,
      mip_mtip_i => mip_mtip_i,
      mip_msip_i => mip_msip_i,
      mip_meip_i => mip_meip_i,

      interrupt_pending_o => interrupt_pending_o,
      pipeline_empty      => pipeline_empty,

      instruction_fetch_pc => instruction_fetch_pc,
      br_bad_predict       => br_bad_predict,
      br_new_pc            => br_new_pc);

  enable_lve : if LVE_ENABLE generate
    signal sp_read_en          : std_logic;
    signal sp_write_en         : std_logic;
    signal sp_read_data        : std_logic_vector(REGISTER_SIZE-1 downto 0);
    signal sp_wait             : std_logic;
    signal sp_ack              : std_logic;
    signal use_scratchpad      : std_logic;
    signal last_use_scratchpad : std_logic;
  begin
    lve : component lve_top
      generic map (
        REGISTER_SIZE    => REGISTER_SIZE,
        INSTRUCTION_SIZE => INSTRUCTION_SIZE,
        SCRATCHPAD_SIZE  => SCRATCHPAD_SIZE,
        SLAVE_DATA_WIDTH => REGISTER_SIZE,
        FAMILY           => FAMILY)
      port map (
        clk            => clk,
        scratchpad_clk => scratchpad_clk,
        reset          => reset,
        instruction    => instruction,
        valid_instr    => valid_instr,
        stall_to_lve   => stall_to_lve,
        rs1_data       => rs1_data_fwd,
        rs2_data       => rs2_data_fwd,
        slave_address  => ls_address,
        slave_read_en  => sp_read_en,
        slave_write_en => sp_write_en,
        slave_byte_en  => ls_byte_en,
        slave_data_in  => ls_write_data,
        slave_data_out => sp_read_data,
        slave_wait     => sp_wait,

        stall_from_lve   => stall_from_lve,
        lve_data1        => lve_data1,
        lve_data2        => lve_data2,
        lve_source_valid => lve_source_valid,
        lve_result       => alu_data_out,
        lve_result_valid => alu_data_out_valid
        );

    -----------------------------------------------------------------------------
    -- data bus splitter
    -----------------------------------------------------------------------------

    use_scratchpad <= ls_write_en or ls_read_en when
                      (unsigned(ls_address) and not to_unsigned(SCRATCHPAD_SIZE-1, REGISTER_SIZE)) = SP_ADDRESS and LVE_ENABLE else '0';
    process(clk)
    begin
      if rising_edge(clk) then

        last_use_scratchpad <= use_scratchpad;
        sp_ack              <= (not sp_wait and (ls_read_en or ls_write_en));
      end if;
    end process;
    sp_read_en  <= use_scratchpad and ls_read_en;
    sp_write_en <= use_scratchpad and ls_write_en;

    ls_read_data <= sp_read_data when last_use_scratchpad = '1' else readdata;
    ls_ack       <= sp_ack       when last_use_scratchpad = '1' else data_ack;

    byte_en   <= ls_byte_en;
    address   <= ls_address;
    write_en  <= not use_scratchpad and ls_write_en;
    read_en   <= not use_scratchpad and ls_read_en;
    writedata <= ls_write_data;
  end generate enable_lve;

  n_enable_lve : if not LVE_ENABLE generate
    stall_from_lve <= '0';

    ls_read_data <= readdata;
    ls_ack       <= data_ack;

    byte_en   <= ls_byte_en;
    address   <= ls_address;
    write_en  <= ls_write_en;
    read_en   <= ls_read_en;
    writedata <= ls_write_data;

    lve_source_valid <= '0';
    lve_data1        <= (others => '-');
    lve_data2        <= (others => '-');
  end generate n_enable_lve;


  finished_instr <= valid_instr and (not stall_from_execute);

  predict_corr_en <= syscall_en or br_bad_predict;
  predict_corr    <= br_new_pc  when syscall_en = '0' else syscall_target;
  predict_pc      <= pc_current when rising_edge(clk);

  branch_pred <= branch_pack_signal(predict_pc,       --this pc
                                    predict_corr,     --branch target
                                    br_taken_out,     --taken
                                    predict_corr_en,  --flush
                                    is_branch);       --is_branch
--pragma translate_off
  my_print : process(clk)
    variable my_line          : line;   -- type 'line' comes from textio
    variable last_valid_pc    : std_logic_vector(pc_current'range);
    type register_list is array(0 to 31) of std_logic_vector(REGISTER_SIZE-1 downto 0);
    variable shadow_registers : register_list := (others => (others => '0'));

    constant DEBUG_WRITEBACK : boolean := false;

  begin
    if rising_edge(clk) then

      if valid_output = '1' and DEBUG_WRITEBACK then
        write(my_line, string'("WRITEBACK: PC = "));
        hwrite(my_line, last_valid_pc);
        if wb_enable = '1' then
          shadow_registers(to_integer(unsigned(wb_sel))) := wb_data;
        end if;
        write(my_line, string'(" REGISTERS = {"));
        for i in shadow_registers'range loop
          hwrite(my_line, shadow_registers(i));
          if i /= shadow_registers'right then
            write(my_line, string'(","));
          end if;

        end loop;  -- i
        write(my_line, string'("}"));
        writeline(output, my_line);
      end if;


      if valid_instr = '1' then
        write(my_line, string'("executing pc = "));  -- formatting
        hwrite(my_line, (pc_current));  -- format type std_logic_vector as hex
        write(my_line, string'(" instr =  "));       -- formatting
        hwrite(my_line, (instruction));  -- format type std_logic_vector as hex
        if stall_from_execute = '1' then
          write(my_line, string'(" stalling"));      -- formatting
        else
          last_valid_pc := pc_current;
        end if;
        writeline(output, my_line);     -- write to "output"
      else
      --write(my_line, string'("bubble"));  -- formatting
      --writeline(output, my_line);     -- write to "output"
      end if;

    end if;
  end process my_print;
--pragma translate_on
end architecture;
