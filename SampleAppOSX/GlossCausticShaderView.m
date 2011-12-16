// GlossCausticShader GlossCausticShaderView.m
//
// Copyright © 2008, Roy Ratcliffe, Pioneering Software, United Kingdom
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

#import "GlossCausticShaderView.h"

#import "RRGlossCausticShader.h"

@implementation GlossCausticShaderView

- (void)drawRect:(NSRect)rect
{
	// Shade from the top-left corner of the bounds to the bottom-left.
	NSRect bounds = [self bounds];
	[[NSBezierPath bezierPathWithRoundedRect:bounds xRadius:10.0 yRadius:10.0] setClip];
	[shader drawShadingFromPoint:CGPointMake(NSMinX(bounds), NSMaxY(bounds)) toPoint:CGPointMake(NSMinX(bounds), NSMinY(bounds)) inContext:[[NSGraphicsContext currentContext] graphicsPort]];
}

- (IBAction)update:sender
{
	// First update the shader. Something has changed.
	[shader update];
	
	[self setNeedsDisplay:YES];
}

@end
