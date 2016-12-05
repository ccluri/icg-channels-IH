COMMENT

ih.mod

Hyperpolarization-activated channel; mixed cation current; Hodgkin-Huxley style kinetics.  

Based on results from Magee, 1998. (J. Neurosci. 18(19):7613-7624. 1 October, 1998.

Authors: Tim Mickus, Bill Kath, Nelson Spruston: Northwestern University, 2000.
Modification of original Iq model by Nelson Spruston, used in Stuart & Spruston, 1998.
That file was originally modified from one provided by Michele Migliore.

Modified 8/16/02 to work with CVODE (one day, I hope) - Nelson

ENDCOMMENT

TITLE H current

INDEPENDENT {t FROM 0 TO 1 WITH 1 (ms)}

NEURON {
	SUFFIX h
	NONSPECIFIC_CURRENT i
    RANGE gbar
    GLOBAL inf,tau
    GLOBAL eh
}

PARAMETER {
	gbar=8.0			(pS/um2) 	: maximum conductance
									: ranges from 8-10 pS/um2 in dend, 1-2 pS/um2 in soma (Magee, 1998, p. 7615)
	:erevh=-13			(mV)		: this value from Magee, table 1 higher Na+ (nelson used -35)
	vhalf=-81			(mV)		: this value from Magee, table 1 higher Na+ (nelson used -88)
    a0=0.00057			(/ms)		: this is essentially a scale factor for the time constant
	zeta=7				(1)
    ab=0.4   			(1)
	qten=4.5			(1)			: Magee value 4.5 activation, 4.7 deactivation
	v					(mV)
    dt					(ms)
    temp = 33			(degC)		: reference temperature from Magee 1998
	gas = 8.315			(J/degC)	: universal gas constant (joules/mol/K)
	farad = 9.648e4		(coul)		: Faraday's constant (coulombs/mol)
}

UNITS {
	(mA) = (milliamp)
	(mV) = (millivolt)
	(mM) = (milli/liter)
	(S) = (siemens)
	(pS) = (picosiemens)
	(um) = (micron)
	(J) = (joules)
}

ASSIGNED {
	eh (mV)
	i (mA/cm2)
    inf
    tau (ms)
	celsius (degC)		: actual temperature for simulation, defined in Neuron, usually about 35
}

STATE { 
		hh
}

INITIAL {
	rate(v)
	hh=inf
}

FUNCTION alpha(v(mV)) (1/ms) {
	alpha = a0*exp((0.001)*(-ab)*zeta*(v-vhalf)*farad/(gas*(273.16+celsius))) 
}

FUNCTION beta(v(mV)) (1/ms) {
	beta = a0*exp((0.001)*(1-ab)*zeta*(v-vhalf)*farad/(gas*(273.16+celsius)))
}

BREAKPOINT {
    SOLVE state METHOD cnexp
    i = (0.0001)*gbar*hh*(v-eh)
}

DERIVATIVE state {
    rate(v)
    hh' = (inf-hh)/tau
}

PROCEDURE rate(v (mV)) { : callable from hoc
    LOCAL a, b, q10
    q10 = qten^((celsius-temp)/10(degC))
    a = q10*alpha(v)
    b = q10*beta(v)
    inf = a/(a+b)
    tau = 1/(a+b)
    if (tau<2) {tau=2}
}

