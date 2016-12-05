TITLE I-h channel from Magee 1998 for distal dendrites
: default values are for dendrites and low Na

UNITS {
	(mA) = (milliamp)
	(mV) = (millivolt)

}

PARAMETER {
	v 		(mV)
	eh  		(mV)        
	celsius 	(degC)
	gmax=.0001 	(mho/cm2)
	vhalfl=-90   	(mV)  : very insensitive to this param
	vhalft=-75   	(mV)  : very insensitive to this param, although at both -200 and 0, it is much different
	a0t= .007 (/ms) : .005  (/ms) : 0.011      	(/ms)
	zetal= 2 (1) :5 (1) : 2 (1) :4    	(1) : smaller values makes back slope of sag shallower, steady state more hyperpol
	zetat= 1.1 (1) : 1.1 (1) : 2.2 (1) : 2.2    	(1)  :(larger values make sag smaller, steady state more hyperpol)
	gmt=.4 (1): .2 (1) :.2 (1) :.4   	(1)
	q10=4.5
	qtl=1
	myslope=0.07 :0.0378
}


NEURON {
	SUFFIX ch_HCNp
	NONSPECIFIC_CURRENT i
	RANGE gmax, vhalfl, myi
	GLOBAL linf,taul, eh
}

STATE {
	l
}

ASSIGNED {
	i (mA/cm2)
	myi (mA/cm2)
	linf      
	taul
	g
}

INITIAL {
	rate(v)
	l=linf
}


BREAKPOINT {
	SOLVE states METHOD cnexp
	g = gmax*l
	i = g*(v-eh)
	myi = i
}


FUNCTION alpl(v(mV)) {
	alpl = exp(myslope*zetal*(v-vhalfl)) 
}

FUNCTION alpt(v(mV)) {
	alpt = exp(myslope*zetat*(v-vhalft)) 
}

FUNCTION bett(v(mV)) {
	bett = exp(myslope*zetat*gmt*(v-vhalft)) 
}

DERIVATIVE states {     : exact when v held constant; integrates over dt step
	rate(v)
	l' =  (linf - l)/taul
}

PROCEDURE rate(v (mV)) { :callable from hoc
	LOCAL a,qt
	qt=q10^((celsius-33)/10)
	a = alpt(v)
	linf = 1/(1+ alpl(v))
	taul = bett(v)/(qtl*qt*a0t*(1+a))
}
