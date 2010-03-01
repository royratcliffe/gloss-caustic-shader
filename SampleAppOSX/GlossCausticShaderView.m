// GlossCausticShader GlossCausticShaderView.m
//
// Copyright © 2008, Roy Ratcliffe, Lancaster, United Kingdom
// All rights reserved
//
//------------------------------------------------------------------------------

#import "GlossCausticShaderView.h"

#import "RRGlossCausticShader.h"

@implementation GlossCausticShaderView

- (void)drawRect:(NSRect)rect
{
	// Shade from the top-left corner of the bounds to the bottom-left.
	NSRect bounds = [self bounds];
	[shader drawShadingFromPoint:NSMakePoint(NSMinX(bounds), NSMaxY(bounds)) toPoint:NSMakePoint(NSMinX(bounds), NSMinY(bounds)) inContext:[[NSGraphicsContext currentContext] graphicsPort]];
}

- (IBAction)update:sender
{
	// First update the shader. Something has changed.
	[shader update];
	
	[self setNeedsDisplay:YES];
}

@end
