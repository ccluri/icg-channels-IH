TITLE Ih-current

UNITS {
	(mA) = (milliamp)
	(mV) = (millivolt)
     (mM) = (milli/liter)

}

INDEPENDENT {t FROM 0 TO 1 WITH 1 (ms)}

PARAMETER {
	dt (ms)
	v (mV)
     eh  			(mV)
	ghdbar=0.00015 		(S/cm2)	:density on dendrite assuming 150pA current and 150mV driving force (=200pS/um2)
	gamma_ih	:not used
	seed		:not used
}


NEURON {
	SUFFIX ih
	NONSPECIFIC_CURRENT i  :Iqq
	RANGE Iqq,ghdbar,eh
}

STATE {
	qq
}

ASSIGNED {
	i (mA/cm2)
}

INITIAL {
	qq=alpha(v)/(beta(v)+alpha(v))
}

BREAKPOINT {
	SOLVE state METHOD cnexp
	i = ghdbar*qq*(v-eh)
}

FUNCTION alpha(v(mV)) {
	alpha = 0.001*6.43*(v+154.9)/(exp((v+154.9)/11.9)-1)			:parameters are estimated by direct fitting of HH model to activation time constants and voltage actication curve recorded at  34C by M. Kole
}

FUNCTION beta(v(mV)) {
	beta = 0.001*193*exp(v/33.1)			
}

DERIVATIVE state {     : exact when v held constant; integrates over dt step
	qq' = (1-qq)*alpha(v) - qq*beta(v)
}


