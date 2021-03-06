###########################################################################
# To restrict GridEngine execution to a set of hosts, use e.g.
# QSUB_QLIST = 'main.q@altivec,main.q@avx'
# QSUB_QLIST = '*@altivec,*@avx'
# See qsub(1) man page for info on "-q wc_queue_list" option
# and sge_types(1) man page for wc_queue_list, wc_queue specification.
QSUB_QLIST = '*@neon,*@asc,*@altivec'
# QSUB_QLIST = '*@star-100'

###########################################################################
# List of additional e-mail addresses to send build results to.
# You don't need to add your own e-mail address if you have registered it
# with git.
#
#NOTIFY_LIST = ['ryan@vectorblox.com']
NOTIFY_LIST = []
###########################################################################
# If more than one programming cable is connected to the local PC,
# specify which one you want used by quartus_pgm, nios2-download and
# nios2-terminal.
#
# Use "quartus_pgm --list" or "jtagconfig" to see a list of cables connected
# to the PC. Example output of jtagconfig:
#     1) USB-Blaster [2-1.1.2]
#       024030DD   EP4SGX530(.|ES)
#
#     2) USB-Blaster [2-1.2]
#       024090DD   EP4SGX230(.|ES)
#
# You can use either the cable number or the cable name to identify the cable:
#
# PGM_CABLE = "USB-Blaster [2-1.1.2]"
# or
# PGM_CABLE = "1"

###########################################################################
# BUILDS is the list of build configurations.
#
# To inform GridEngine that a build will require a Quartus license, create
# the Alt_Mxp_BuildCfg object with use_lic=True, e.g.
#
#    Alt_Mxp_BuildCfg('de2', 16, 1, 64, 8, True, 'BYTE', use_lic=True)
#
# At the moment, all this option does is make the qsub job request a
# virtual "consumable resource" called "quartus_license", so that the
# number of simultaneously running jobs that require this resource
# does not exceed the maximum number of licenses available.
#
# This option does NOT (yet) automatically set the LM_LICENSE_FILE
# environment variable or configure PATH so that the subscription
# edition of quartus is used instead of the web edition.

ZEDBOARD_UART_CFG = Xil_Uart_Cfg('/dev/ttyACM0', 115200)
M2S150_UART_CFG = Mcsm_Uart_Cfg('/dev/ttyUSB2', 115200)

TEST_IGNORE_LIST = [
    #Should work on LVE systems
    'rv.*-vbx_test',          #LVE (VBX)
    'rv.*-cmov_test',         #LVE CMOV (VBX)
    
    #Requires traps that aren't set up (may also be unsupported and/or broken)
    'rv.*-interrupt_test',    #Interrupt test (VBX)
    'rv.*-illegal',           #Illegal instructions
    'rv.*-ma_fetch',          #Misaligned instruction fetch
    'rv.*-scall',             #Syscall trap
    'rv.*-shamt',             #slli with shamt[4/5] illegal instruction

    #May someday be supported
    'rv.*-csr',               #CSRs; we do not support them all
    'rv.*-mcsr',              #M-mode CSRs
    'rv.*-ma_addr',           #Misaligned addresses; not yet supported but should be as a parameter
    'rv.*-rvc',               #Compressed instruction corner cases
    
    #Will likely never be supported
    'rv.*-sbreak',            #Syscall breakpoint; not supported
    'rv.*-dirty',             #VM referenced/dirty bits
    'rv.*-amo.*_w',           #Atomic instructions
    'rv.*-lrsc',              #Load reserved/store conditional
    'rv32uf-.*',              #Floating point
]

ORCA_BUILDS = \
              [
                  #Default Altera system
                  Alt_ORCA_BuildCfg(system='de2-115'),
                  #No BTB
                  Alt_ORCA_BuildCfg(system='de2-115',
                                    btb_entries=0),
                  #Default Xilinx system
                  Xil_ORCA_BuildCfg(system='zedboard'),
                  #No I$ system
                  Xil_ORCA_BuildCfg(system='zedboard',
                                    icache_size=0),
                  #No D$ system
                  Xil_ORCA_BuildCfg(system='zedboard',
                                    dcache_size=0),
                  #Writethrough D$ system
                  Xil_ORCA_BuildCfg(system='zedboard',
                                    dcache_writeback=0),
                  #LMB, no $
                  Xil_ORCA_BuildCfg(system='zedboard',
                                    amr0_addr_base=0xA0000000,
                                    amr0_addr_last=0xBFFFFFFF,
                                    icache_size=0,
                                    dcache_size=0),
                  #IUC, no $
                  Xil_ORCA_BuildCfg(system='zedboard',
                                    umr0_addr_base=0xA0000000,
                                    icache_size=0,
                                    dcache_size=0),
                  #Minimal system (should fail mul/consective_instr (needs CSRs disabled with no exceptions)):
                  #UC only, no I$ or D$, no BTB, 4 stage, 1 ifetch in flight, no AMR, no exceptions, no divide
                  Xil_ORCA_BuildCfg(system='zedboard',
                                    umr0_addr_base=0xA0000000,
                                    max_ifetches_in_flight=1,
                                    btb_entries=0,
                                    divide_enable=0,
                                    enable_exceptions=0,
                                    pipeline_stages=4,
                                    aux_memory_regions=0,
                                    icache_size=0,
                                    dcache_size=0),
                  #Bare system (should fail mul/div/rem/consective_instr (needs CSRs disabled with no exceptions)):
                  #Minimal system, no multiply, 32-cycle shifter, no counters, no iuc_request_register
                  Xil_ORCA_BuildCfg(system='zedboard',
                                    umr0_addr_base=0xA0000000,
                                    max_ifetches_in_flight=1,
                                    btb_entries=0,
                                    multiply_enable=0,
                                    divide_enable=0,
                                    shifter_max_cycles=32,
                                    counter_length=0,
                                    enable_exceptions=0,
                                    pipeline_stages=4,
                                    aux_memory_regions=0,
                                    icache_size=0,
                                    iuc_request_register=0,
                                    dcache_size=0,
                                    duc_request_register=0,
                                    duc_return_register=0),
              ]


BUILDS = ORCA_BUILDS

###########################################################################
# You can also specify different Quartus optimization settings for each
# build. The optimization settings are specified by a QSFOpt class instance,
# which consists of an identifier string and a list of
# (option_name, option_value) tuples.
#
# option_list = [(opt1_name, opt1_val), (opt2_name, opt2_val)]
# QSF1 = QSFOpts(id_string, option_list)
#
# The option list is used to override/assign settings in a build's QSF file.
# The settings appear in the QSF file in the form:
#     set_global_assignment -name <option_name> <option_value>
# Any options that are already present in the QSF file but are not specified
# in the QSFOpt option list are left unmodified.
#
# The QSFOpt instance identifier string will be appended to the build directory
# name. YOU SHOULD THEREFORE ENSURE THAT EACH INSTANCE HAS A UNIQUE IDENTIFIER
# STRING.
#
# Here is an example of how to create two builds with different optimization
# settings:
#
# QSF1 = QSFOpts('',     [('PLACEMENT_EFFORT_MULTIPLIER', '2.0')])
# QSF2 = QSFOpts('qsf2', [('PLACEMENT_EFFORT_MULTIPLIER', '2.0'),
#                         ('FITTER_AGGRESSIVE_ROUTABILITY_OPTIMIZATION', 'ALWAYS')])
# BUILDS = \
    #   [Alt_Mxp_BuildCfg('de4_230_dvi_b', 16, 8,  64,  4, 'BYTE', use_lic=True, qsf_opts=QSF1),
#    Alt_Mxp_BuildCfg('de4_230_dvi_b', 16, 8,  64,  4, 'BYTE', use_lic=True, qsf_opts=QSF2)]
#
# The build directories will be named
#   de4_230_dvi_b_v64_w8_k256_b4_s1_mbyte
#   de4_230_dvi_b_v64_w8_k256_b4_s1_mbyte_qsf2
#
# Here is another example showing how to make builds with different placement seeds:
#
# COMMON_OPTS = [('PLACEMENT_EFFORT_MULTIPLIER', '2.0'),
#                ('PHYSICAL_SYNTHESIS_COMBO_LOGIC', 'ON'),
#                ('PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION', 'ON'),
#                ('PHYSICAL_SYNTHESIS_REGISTER_RETIMING', 'ON')]
# BUILDS = []
# for i in range(6):
#     n = i+1
#     qsf_opts = QSFOpts('seed%d' % n, COMMON_OPTS + [('SEED', str(n)) ])
#     BUILDS += [Alt_Mxp_BuildCfg('de4_230_dvi_b', 16, 8, 64,  4, 'BYTE',
#                use_lic=True, qsf_opts=qsf_opts)]

###########################################################################
# By default, all tests in software/test and software/hwtest are run.
# You can specify a list of tests to ignore (not run). Regular expressions
# are allowed.
#
# TEST_IGNORE_LIST = [
#     'test/.*',
#     'hwtest/stream.*',
#     ]
#
# TEST_IGNORE_LIST = ['hwtest/.*']

###########################################################################
# Optionally specify a test timeout value in seconds.
# If nios2-terminal does not exit within this amount of time (because
# a test hasn't yet output Control-D), it will be killed and the script will
# continue with the next task.
#
# TEST_TIMEOUT = 5*60

###########################################################################
