// GlossCausticShader GlossCausticShaderView.h
//
// Copyright © 2008, Roy Ratcliffe, Lancaster, United Kingdom
// All rights reserved
//
//------------------------------------------------------------------------------

#import <Cocoa/Cocoa.h>

@class RRGlossCausticShader;

@interface GlossCausticShaderView : NSView
{
	IBOutlet RRGlossCausticShader *shader;
}

- (IBAction)update:sender;
	// The nib wires all the controls to this action, as well as binding them to their respective key paths on the shader instance. That way, the controls update correctly and the view receives notification of changes.

@end
