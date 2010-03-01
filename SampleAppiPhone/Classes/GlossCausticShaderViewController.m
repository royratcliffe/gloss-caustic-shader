// GlossCausticShader GlossCausticShaderViewController.m
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

#import "GlossCausticShaderViewController.h"

@implementation GlossCausticShaderViewController

// designated initialiser
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
	{
		// Custom initialisation. Override here to perform set-up that executes
		// before the view loads.
	}
	return self;
}

- (void)viewDidLoad
{
	// Called after the view has been loaded. For view controllers created in
	// code, this is after -loadView. For view controllers unarchived from a
	// nib, this is after the view is set.
	[super viewDidLoad];
}

// (starting with iPhone OS 3.0)
- (void)viewDidUnload
{
	// Called after the view controller's view is released and set to nil. For
	// example, a memory warning which causes the view to be purged. Not invoked
	// as a result of -dealloc.
}

- (void)didReceiveMemoryWarning
{
	// Called when the parent application receives a memory warning. Default
	// implementation releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
}

//------------------------------------------------------------------------------
#pragma mark                                         UI View Controller Rotation
//------------------------------------------------------------------------------

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	// Override to allow rotation. Default returns YES only for
	// UIDeviceOrientationPortrait.
	return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

@end
