// RRUtils RRCausticColorMatcher.h
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

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#if !defined(NS_NONATOMIC_IPHONEONLY)
	#if TARGET_OS_IPHONE
	#define NS_NONATOMIC_IPHONEONLY nonatomic
	#else
	#define NS_NONATOMIC_IPHONEONLY
	#endif
#endif
#endif

@interface RRCausticColorMatcher : NSObject<NSCoding>
{
	CGFloat causticHue;
		// Yellow by default.
	CGFloat graySaturationThreshold;
		// Saturation level at which colours appear grey. Below this level,
		// matcher response snaps to pure caustic.
	CGFloat causticSaturationForGrays;
		// Defines the caustic saturation for grey colours. Grey colours fall
		// below the grey saturation threshold. When saturation drops too low,
		// everything looks grey.
	CGFloat redHueThreshold;
		// Colours at this threshold and above match to default caustics rather
		// than default magenta for blues.
	CGFloat blueHueThreshold;
		// Triggers a switch to magenta caustics. Hues at blue and beyond
		// display magenta-modulated caustics by default.
	CGFloat blueCausticHue;
		// Magenta by default. Magenta caustics for blue colours.
	CGFloat causticFractionDomainFactor;
		// Expands or contracts the caustic fraction's domain. With factor equal
		// to 1, non-caustic and caustic hues blend according to the cosine of
		// their difference. Smaller the difference, greater the amount of
		// caustic hue. Defaults to 1.4 meaning that the point of absolutely no
		// caustic blending occurs at 1/1.4 difference from caustic hue. Try
		// plotting cos(x*pi*1.4) in the -1,1 interval.
	CGFloat causticFractionRangeFactor;
		// Scales the caustic fraction which without a factor outputs a blending
		// fraction between 0 and 1 in favour of the caustic blend. Defaults to
		// 0.6 which scales down the amount of caustic hue-and-brightness by
		// that amount.
}

#if TARGET_OS_IPHONE
- (UIColor *)matchForColor:(UIColor *)aColor;
#else
- (NSColor *)matchForColor:(NSColor *)aColor;
#endif
	// Matches the given colour. Answers a matching caustic colour. The result
	// shifts hue and brightness towards yellow. Saturation remains unchanged.

- (void)matchForHSB:(const CGFloat *)hsb caustic:(CGFloat *)outHSB;
	// Does the work.

@property(assign, NS_NONATOMIC_IPHONEONLY) CGFloat causticHue;
@property(assign, NS_NONATOMIC_IPHONEONLY) CGFloat graySaturationThreshold;
@property(assign, NS_NONATOMIC_IPHONEONLY) CGFloat causticSaturationForGrays;
@property(assign, NS_NONATOMIC_IPHONEONLY) CGFloat redHueThreshold;
@property(assign, NS_NONATOMIC_IPHONEONLY) CGFloat blueHueThreshold;
@property(assign, NS_NONATOMIC_IPHONEONLY) CGFloat blueCausticHue;
@property(assign, NS_NONATOMIC_IPHONEONLY) CGFloat causticFractionDomainFactor;
@property(assign, NS_NONATOMIC_IPHONEONLY) CGFloat causticFractionRangeFactor;

@end
