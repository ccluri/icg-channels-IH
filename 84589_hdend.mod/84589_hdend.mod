: Copyright (c) California Institute of Technology, 2006 -- All Rights Reserved
: Royalty free license granted for non-profit research and educational purposes.

TITLE HDEND

NEURON {
	SUFFIX hdend
	:USEION na READ ena WRITE ina
	:USEION k  READ ek  WRITE ik
	NONSPECIFIC_CURRENT i
	RANGE gbar
	RANGE ninf, ntau
	GLOBAL eh

	GLOBAL vhalf_n, vsteep_n, exp_n 
	GLOBAL tskew_n, tscale_n, toffset_n 

}

INCLUDE "custom_code/inc_files/84589_noinact_nak_currs.inc"

INCLUDE "custom_code/inc_files/84589_hdend_noinact_gate_states.inc"

INCLUDE "custom_code/inc_files/84589_var_funcs.inc"


