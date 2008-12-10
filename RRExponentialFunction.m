// RRUtils RRExponentialFunction.m
//
// Copyright © 2008, Roy Ratcliffe, Lancaster, United Kingdom
// All rights reserved
//
//------------------------------------------------------------------------------

#import "RRExponentialFunction.h"

#import <math.h> // for expf

void RRExponentialFunctionSetCoefficient(RRExponentialFunction *f, float c)
{
	f->coefficient = c;
	f->exponentOfMinusCoefficient = expf(-c);
	f->oneOverOneMinusExponentOfMinusCoefficient = 1.0f / (1.0f - f->exponentOfMinusCoefficient);
	// Computing "one over one minus exponent of minus coefficient" optimises for multiplication over division. Effectively, the exponential function divides by one minus the exponent of the coefficient. Deriving the reciprocal upfront changes the divide to multiply during evaluation. Multiply typically beats divide when it comes to performance.
}

float RRExponentialFunctionEvaluate(RRExponentialFunction *f, float x)
{
	return 1.0f - ((expf(x * -f->coefficient) - f->exponentOfMinusCoefficient) * f->oneOverOneMinusExponentOfMinusCoefficient);
}
