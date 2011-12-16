// RRUIKit UIColor+RRUIKit.m
//
// Copyright © 2010, Roy Ratcliffe, Pioneering Software, United Kingdom
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

#import "UIColor+RRUIKit.h"

@implementation UIColor(RRUIKit)

- (UIColor *)colorUsingColorSpaceModel:(CGColorSpaceModel)model
{
	UIColor *color = nil;
	switch ([self colorSpaceModel])
	{
		case kCGColorSpaceModelMonochrome:
			switch (model)
			{
				case kCGColorSpaceModelMonochrome:
					// monochrome --> monochrome
					color = self;
					break;
				case kCGColorSpaceModelRGB:
				{
					// monochrome --> RGB
					CGFloat components[[self numberOfComponents]];
					[self getComponents:components];
					color = [UIColor colorWithRed:components[0] green:components[0] blue:components[0] alpha:components[1]];
					break;
				}
				default:
					;
			}
			break;
		case kCGColorSpaceModelRGB:
			switch (model)
			{
				case kCGColorSpaceModelRGB:
					// RGB --> RGB
					color = self;
					break;
				default:
					;
			}
			break;
		default:
			;
	}
	return color;
}

- (CGColorSpaceRef)colorSpace
{
	return CGColorGetColorSpace([self CGColor]);
}
- (CGColorSpaceModel)colorSpaceModel
{
	return CGColorSpaceGetModel([self colorSpace]);
}

- (NSUInteger)numberOfComponents
{
	// NSColor has some unexpected types, e.g. NSInteger for number of colour
	// components. Should this not have NSUInteger type? Or can you have
	// negative numbers of colours? The implementation diverges from NSColor on
	// this point, since CGColorGetNumberOfComponents returns an unsigned
	// integer.
	return CGColorGetNumberOfComponents([self CGColor]);
}
- (void)getComponents:(CGFloat *)components
{
	memcpy(components, CGColorGetComponents([self CGColor]), [self numberOfComponents]*sizeof(CGFloat));
}

- (CGFloat)redComponent
{
	NSAssert1([self colorSpaceModel] == kCGColorSpaceModelRGB, @"%@ must be an RGB color", self);
	return CGColorGetComponents([self CGColor])[0];
}
- (CGFloat)greenComponent
{
	NSAssert1([self colorSpaceModel] == kCGColorSpaceModelRGB, @"%@ must be an RGB color", self);
	return CGColorGetComponents([self CGColor])[1];
}
- (CGFloat)blueComponent
{
	NSAssert1([self colorSpaceModel] == kCGColorSpaceModelRGB, @"%@ must be an RGB color", self);
	return CGColorGetComponents([self CGColor])[2];
}

- (CGFloat)alphaComponent
{
	// Core Graphics offers a separate and distinct function for accessing a
	// colour's alpha channel. Let's use it. Doubtless it works out equivalent
	// to the last component. Nevertheless, let Core Graphics answer the
	// question, as it were.
	return CGColorGetAlpha([self CGColor]);
}

//------------------------------------------------------------------------------
#pragma mark                                           Hue-Saturation-Brightness
//------------------------------------------------------------------------------

// http://www.cs.rit.edu/~ncs/color/t_convert.html
- (void)getHue:(CGFloat *)hue saturation:(CGFloat *)saturation brightness:(CGFloat *)brightness alpha:(CGFloat *)alpha
{
	const CGFloat *rgba = CGColorGetComponents([self CGColor]);
	// Let max become an index referencing the maximum RGB component; rgba[max]
	// gives the maximum's component value. Later, hue value depends on which
	// RGB component was the maximum; hue depends on the difference between the
	// other two non-maximum components.
	NSUInteger max = 0;
	for (NSUInteger i = 1; i < 3; i++)
	{
		if (rgba[i] > rgba[max]) max = i;
	}
	if (brightness) *brightness = rgba[max];
	if (rgba[max] != 0)
	{
		CGFloat delta = rgba[max] - MIN(rgba[0], MIN(rgba[1], rgba[2]));
		if (saturation) *saturation = delta/rgba[max];
		if (hue)
		{
			switch (max)
			{
				case 0:
					*hue = (rgba[1] - rgba[2])/delta;
					break;
				case 1:
					*hue = 2 + (rgba[2] - rgba[0])/delta;
					break;
				case 2:
					*hue = 4 + (rgba[0] - rgba[1])/delta;
			}
			*hue /= 6;
			if (*hue < 0) *hue += 1;
		}
	}
	else
	{
		if (saturation) *saturation = 0;
		if (hue) *hue = -1;
	}
	if (alpha) *alpha = [self alphaComponent];
}

@end
