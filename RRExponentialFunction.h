// RRUtils RRExponentialFunction.h
//
// Copyright © 2008, Roy Ratcliffe, Lancaster, United Kingdom
// All rights reserved
//
//------------------------------------------------------------------------------

// Encapsulates an optimising generic Exponential Function where
//		y=1-(exp(x*-c)-exp(-c))/(1-exp(-c))
// and where 0<c is a general coefficient describing the exponential curvature. The function's input domain lies within the 0..1 interval, its output range likewise. The implementation optimises by pre-computing those constant terms depending only on the coefficient whenever the coefficient changes. Repeated evaluation takes less computing time thereafter.
struct RRExponentialFunction
{
	float coefficient;
	float exponentOfMinusCoefficient;
	float oneOverOneMinusExponentOfMinusCoefficient;
};

typedef struct RRExponentialFunction RRExponentialFunction;

void RRExponentialFunctionSetCoefficient(RRExponentialFunction *f, float c);
float RRExponentialFunctionEvaluate(RRExponentialFunction *f, float x);
