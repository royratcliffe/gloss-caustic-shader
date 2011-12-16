// GlossCausticShader ShaderView.m
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

#import "ShaderView.h"
#import "RRGlossCausticShader.h"

// for access to Core Animation layer
#import <QuartzCore/QuartzCore.h>

@implementation ShaderView

@synthesize shader;

- (void)awakeFromNib
{
	shader = [[RRGlossCausticShader alloc] init];
	
	self.layer.masksToBounds = YES;
	self.layer.cornerRadius = 10.0f;
	self.layer.borderColor = [[UIColor blackColor] CGColor];
	self.layer.borderWidth = 1.0f;
}

- (void)dealloc
{
	[shader release];
	[super dealloc];
}

- (void)update
{
	[shader update];
	[self setNeedsDisplay];
}

//------------------------------------------------------------------------------
#pragma mark                                                   UI View Rendering
//------------------------------------------------------------------------------

- (void)drawRect:(CGRect)rect
{
	CGRect bounds = self.bounds;
	
	// If you want to draw gloss shading within a rounded rectangle, first set
	// up a rounded-rectangle clipping path. This is how you can do that using
	// Core Graphics. Layer masking makes this redundant here however.
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:10.0f];
	CGContextAddPath(context, [path CGPath]);
	CGContextClip(context);
	
	[shader drawShadingFromPoint:bounds.origin
						 toPoint:CGPointMake(bounds.origin.x, bounds.origin.y + bounds.size.height)
					   inContext:context];
}

@end
