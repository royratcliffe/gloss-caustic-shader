// RRUtils RRCausticColorMatcher.m
//
// Copyright © 2008-2010, Roy Ratcliffe, Pioneering Software, United Kingdom
// All rights reserved
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS," WITHOUT WARRANTY OF ANY KIND, EITHER
// EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO
// EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
// OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.
//
//------------------------------------------------------------------------------

#import "RRCausticColorMatcher.h"

#if TARGET_OS_IPHONE
#import "UIColor+RRUIKit.h"
#endif

@implementation RRCausticColorMatcher

- (id)init
{
	if ((self = [super init]))
	{
		causticHue = 60.0f/360; // yellow
		graySaturationThreshold = 0.001f;
		causticSaturationForGrays = 0.2f;
		redHueThreshold = (360.0f-18)/360; // red-18°
		blueHueThreshold = (240.0f+12)/360; // blue+12°
		blueCausticHue = 300.0f/360; // magenta
		causticFractionDomainFactor = 1.4f;
		causticFractionRangeFactor = 0.6f;
	}
	return self;
}

#if TARGET_OS_IPHONE
- (UIColor *)matchForColor:(UIColor *)aColor
#else
- (NSColor *)matchForColor:(NSColor *)aColor
#endif
{
	CGFloat hsba[4];
	
	// The given colour, aColor, may not have an RGB triple hence not directly
	// possible to convert to HSB; the conversion requires access to red, green
	// and blue components. Start by moving the incoming colour to RGB space.
#if TARGET_OS_IPHONE
	aColor = [aColor colorUsingColorSpaceModel:kCGColorSpaceModelRGB];
#else
	aColor = [aColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
#endif
	
	[aColor getHue:hsba+0 saturation:hsba+1 brightness:hsba+2 alpha:hsba+3];
	[self matchForHSB:hsba caustic:hsba];
	
#if TARGET_OS_IPHONE
	return [UIColor colorWithHue:hsba[0] saturation:hsba[1] brightness:hsba[2] alpha:hsba[3]];
#else
	return [NSColor colorWithCalibratedHue:hsba[0] saturation:hsba[1] brightness:hsba[2] alpha:hsba[3]];
#endif
}

- (void)matchForHSB:(const CGFloat *)hsb caustic:(CGFloat *)outHSB
{
#define HCOMP (0) // hue component
#define SCOMP (1) // saturation component
#define BCOMP (2) // brightness component
	// Derive and blend two colours: non-caustic and caustic. The first,
	// non-caustic, derives directly from the input triple (hsb argument). Each
	// triple has three components, of course: hue, saturation and brightness,
	// in that order.
	// If the saturation is too low, pretend the input colour exactly matches
	// the caustic colour (yellow by default). Increase the saturation
	// too. Therefore, all low-saturation colours snap to caustic yellow. Low
	// saturation amounts to grey.
	
	// non-caustic
	CGFloat noncaustic[3];
	if (hsb[SCOMP] < graySaturationThreshold)
	{
		noncaustic[HCOMP] = causticHue;
		noncaustic[SCOMP] = causticSaturationForGrays;
	}
	else
	{
		noncaustic[HCOMP] = hsb[HCOMP];
		noncaustic[SCOMP] = hsb[SCOMP];
	}
	noncaustic[BCOMP] = hsb[BCOMP];
	// Red-hue threshold marks the dividing line between blue and red. Every hue
	// at the threshold or above shifts down and becomes a negative hue. It
	// thereby escapes the blue-hue threshold and receives the default yellow
	// caustic hue.
	if (noncaustic[HCOMP] >= redHueThreshold)
	{
		noncaustic[HCOMP] -= 1.0f;
	}
	
	// caustic
	CGFloat caustic[3];
	if (noncaustic[HCOMP] < blueHueThreshold)
	{
		caustic[HCOMP] = causticHue;
	}
	else
	{
		caustic[HCOMP] = blueCausticHue;
	}
	caustic[SCOMP] =
	caustic[BCOMP] = 1.0f;
	
	CGFloat causticFraction = noncaustic[HCOMP] - caustic[HCOMP];
	// At this point, the caustic fraction lies in the range -1 to 1. Caustic
	// hues equate to 1/6 or 5/6 for yellow or magenta, respectively. Input
	// comparison hue equates to (redHueThreshold-1) to redHueThreshold, low to
	// high range. Where, since 0<=redHueThreshold<=1 holds true, the caustic
	// fraction easily falls within the -1,1 interval. The fraction measures the
	// different between the caustic hue and the input hue.
	causticFraction *= causticFractionDomainFactor;
	causticFraction = cosf((CGFloat)M_PI*causticFraction);
	causticFraction += 1.0f;
	causticFraction *= 0.5f;
	causticFraction *= causticFractionRangeFactor;
	
	// blend
	CGFloat noncausticFraction = 1.0f - causticFraction;
	outHSB[HCOMP] = noncaustic[HCOMP]*noncausticFraction + caustic[HCOMP]*causticFraction;
	outHSB[BCOMP] = noncaustic[BCOMP]*noncausticFraction + caustic[BCOMP]*causticFraction;
	
	outHSB[SCOMP] = noncaustic[SCOMP];
}

@synthesize causticHue;
@synthesize graySaturationThreshold;
@synthesize causticSaturationForGrays;
@synthesize redHueThreshold;
@synthesize blueHueThreshold;
@synthesize blueCausticHue;
@synthesize causticFractionDomainFactor;
@synthesize causticFractionRangeFactor;

//------------------------------------------------------------------------------
#pragma mark                                                              Coding
//------------------------------------------------------------------------------

static NSString *const kCausticHue = @"RRCausticHue";
static NSString *const kGraySaturationThreshold = @"RRGraySaturationThreshold";
static NSString *const kCausticSaturationForGrays = @"RRCausticSaturationForGrays";
static NSString *const kRedHueThreshold = @"RRRedHueThreshold";
static NSString *const kBlueHueThreshold = @"RRBlueHueThreshold";
static NSString *const kBlueCausticHue = @"RRBlueCausticHue";
static NSString *const kCausticFractionDomainFactor = @"RRCausticFractionDomainFactor";
static NSString *const kCausticFractionRangeFactor = @"RRCausticFractionRangeFactor";

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeFloat:[self causticHue] forKey:kCausticHue];
	[aCoder encodeFloat:[self graySaturationThreshold] forKey:kGraySaturationThreshold];
	[aCoder encodeFloat:[self causticSaturationForGrays] forKey:kCausticSaturationForGrays];
	[aCoder encodeFloat:[self redHueThreshold] forKey:kRedHueThreshold];
	[aCoder encodeFloat:[self blueHueThreshold] forKey:kBlueHueThreshold];
	[aCoder encodeFloat:[self blueCausticHue] forKey:kBlueCausticHue];
	[aCoder encodeFloat:[self causticFractionDomainFactor] forKey:kCausticFractionDomainFactor];
	[aCoder encodeFloat:[self causticFractionRangeFactor] forKey:kCausticFractionRangeFactor];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super init]))
	{
		[self setCausticHue:[aDecoder decodeFloatForKey:kCausticHue]];
		[self setGraySaturationThreshold:[aDecoder decodeFloatForKey:kGraySaturationThreshold]];
		[self setCausticSaturationForGrays:[aDecoder decodeFloatForKey:kCausticSaturationForGrays]];
		[self setRedHueThreshold:[aDecoder decodeFloatForKey:kRedHueThreshold]];
		[self setBlueHueThreshold:[aDecoder decodeFloatForKey:kBlueHueThreshold]];
		[self setBlueCausticHue:[aDecoder decodeFloatForKey:kBlueCausticHue]];
		[self setCausticFractionDomainFactor:[aDecoder decodeFloatForKey:kCausticFractionDomainFactor]];
		[self setCausticFractionRangeFactor:[aDecoder decodeFloatForKey:kCausticFractionRangeFactor]];
	}
	return self;
}

@end
