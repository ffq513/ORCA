#define output_vec_sum(vec_name,length) do{				\
  int i,total=0;													\
  for(i=0;i<length;i++) {										\
	 total+=(vec_name)[i];					\
  }debug(total); } while(0)

#define output_vec(vec_name,length) do{			\
	 int i;										\
	 for(i=0;i<length;i++) {							\
		debug((vec_name)[i]);					\
	 } } while(0)

#define USE_MICS 1
printf("\n");


while (1) {
  k++;
  // Collect WINDOW_LENGTH samples.
  // Apply the FIR filter after acquiring each sample.
  // FIR filter is symmetric, applying cross-correlation is simpler than
  // convolution (no need for array flipping).

  //empty fifo of possibly old data
  for(i=0;i<32;i++){
	 i2s_get_data();
  }

  for (i = 0; i < WINDOW_LENGTH; i++) {
	 // Insert new sample at the end of the temporary vector.
	 vbx_set_vl(BUFFER_LENGTH - 1);
	 vbx(SVWS, VADD, temp_l, 0, temp_l + 1);
	 vbx(SVWS, VADD, temp_r, 0, temp_r + 1);
#if USE_MICS
	 i2s_data_t mic_data;
	 mic_data=i2s_get_data();
	 temp_l[BUFFER_LENGTH - 1]=mic_data.left;
	 temp_r[BUFFER_LENGTH - 1]=mic_data.right;
#else
	 temp_l[BUFFER_LENGTH - 1] = samples_l[sample_count];
	 temp_r[BUFFER_LENGTH - 1] = samples_r[sample_count];
#endif
	 //debug(temp_l[BUFFER_LENGTH - 1]);
	 sample_count++;
	 if (sample_count >= NUM_SAMPLES) {
		sample_count = 0;
	 }

	 // Apply the FIR filter to the last NUM_TAPS samples of the temp buffer.
	 // Write to the accumulated result to the mic buffer for beamforming.
	 vbx_set_vl(NUM_TAPS);
	 vbx_acc(VVWS, VMUL, fir_acc_l, temp_l + BUFFER_LENGTH - NUM_TAPS, fir_vector);
	 vbx_acc(VVWS, VMUL, fir_acc_r, temp_r + BUFFER_LENGTH - NUM_TAPS, fir_vector);
	 //debug(*fir_acc_l);
	 *fir_acc_l >>= FIR_PRECISION;
	 *fir_acc_r >>= FIR_PRECISION;

	 mic_buffer_l[buffer_count] = *fir_acc_l;
	 mic_buffer_r[buffer_count] = *fir_acc_r;

	 buffer_count++;
	 if (buffer_count >= BUFFER_LENGTH) {
		buffer_count = 0;
	 }
  }
  transfer_offset = buffer_count - WINDOW_LENGTH - SAMPLE_DIFFERENCE;
  if (transfer_offset < 0) {
	 transfer_offset += BUFFER_LENGTH;
  }

  vbx_set_vl(SAMPLE_DIFFERENCE);
  vbx(SVWS, VADD, sound_vector_l, 0, (mic_buffer_l + transfer_offset));
  vbx(SVWS, VADD, sound_vector_r, 0, (mic_buffer_r + transfer_offset));

  transfer_offset = buffer_count - WINDOW_LENGTH;
  if (transfer_offset < 0) {
	 transfer_offset += BUFFER_LENGTH;
  }
  //MOV mic_buffer to sound_vector_l
  vbx_set_vl(WINDOW_LENGTH);
  vbx(SVWS, VADD, (sound_vector_l + SAMPLE_DIFFERENCE), 0, (mic_buffer_l + transfer_offset));
  vbx(SVWS, VADD, (sound_vector_r + SAMPLE_DIFFERENCE), 0, (mic_buffer_r + transfer_offset));
  // Calculate the power assuming the sound is coming from the center.
  vbx(VVWS, VADD, sum_vector, (sound_vector_l + SAMPLE_DIFFERENCE), (sound_vector_r + SAMPLE_DIFFERENCE));
  for (j = 0; j < WINDOW_LENGTH; j++) {
	 sum_vector[j] = sum_vector[j] >> PRESCALE;
  }
  //vbx(SVWS, VSRA, sum_vector, PRESCALE, sum_vector);
  vbx_acc(VVWS, VMUL, power_center, sum_vector, sum_vector);

  // Calculate the power assuming the sound is coming from the left (right microphone is
  // delayed during sampling, so delay left microphone to compensate).
  vbx(VVWS, VADD, sum_vector, sound_vector_l, (sound_vector_r + SAMPLE_DIFFERENCE));
  for (j = 0; j < WINDOW_LENGTH; j++) {
	 sum_vector[j] = sum_vector[j] >> PRESCALE;
  }
  //vbx(SVWS, VSRA, sum_vector, PRESCALE, sum_vector);
  vbx_acc(VVWS, VMUL, power_left, sum_vector, sum_vector);

  // Calculate the power assuming the sound is coming from the right (left microphone is delayed
  // during sampling, so delay right microphone to compensate).
  vbx(VVWS, VADD, sum_vector, (sound_vector_l + SAMPLE_DIFFERENCE), sound_vector_r);
  for (j = 0; j < WINDOW_LENGTH; j++) {
	 sum_vector[j] = sum_vector[j] >> PRESCALE;
  }
  //vbx(SVWS, VSRA, sum_vector, PRESCALE, sum_vector);

  vbx_acc(VVWS, VMUL, power_right, sum_vector, sum_vector);

  char* position_str[3] = { " C \r\n",
									 "  R\r\n",
									 "L  \r\n"};
  int position ;
  if (*power_center > *power_left) {
	 if (*power_center > *power_right) {
		position = 0;
	 }
	 else {
		position = 1;
	 }
  }
  else {
	 if (*power_left > *power_right) {
		position = 2;
	 }
	 else {
		position = 1;
	 }
  }
  printf(position_str[position]);
 }
