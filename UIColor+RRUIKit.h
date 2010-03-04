// RRUIKit UIColor+RRUIKit.h
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

#import <UIKit/UIKit.h>

// Fill in some of the "missing" UIColor methods, making UIColor more compatible
// with NSColor. This includes access to individual colour components and HSV
// conversion. Use similar method signatures and semantics as far as possible.

@interface UIColor(RRUIKit)

- (UIColor *)colorUsingColorSpaceModel:(CGColorSpaceModel)model;

- (CGColorSpaceRef)colorSpace;
- (CGColorSpaceModel)colorSpaceModel;

- (NSUInteger)numberOfComponents;
- (void)getComponents:(CGFloat *)components;

// The RGB component accessor methods deliberately presume the colour has the
// necessary red, green and blue components. This is a design-by-contract
// assumption. First determine RGB compliance before asking for the components,
// or guarantee compliance by applying the methods only to known RGB
// colours. NSColor interface takes this approach; Cocoa's methods throw
// exceptions if not applied to RGB colours.

- (CGFloat)redComponent;
- (CGFloat)greenComponent;
- (CGFloat)blueComponent;

- (CGFloat)alphaComponent;

//---------------------------------------------------- Hue-Saturation-Brightness

- (void)getHue:(CGFloat *)hue saturation:(CGFloat *)saturation brightness:(CGFloat *)brightness alpha:(CGFloat *)alpha;
	// Answers the components of RGB colours as hue, saturation and
	// brightness. Adds the missing UIColor method for converting RGB to
	// HSB. This method assumes that self (an instance of UIColor) has RGB
	// colour model.

@end
