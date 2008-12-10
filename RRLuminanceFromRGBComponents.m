// RRUtils RRLuminanceFromRGBComponents.m
//
// Copyright © 2008, Roy Ratcliffe, Lancaster, United Kingdom
// All rights reserved
//
//------------------------------------------------------------------------------

#import "RRLuminanceFromRGBComponents.h"

// http://www.opengl.org/resources/code/samples/advanced/advanced97/notes/node140.html
CGFloat RRLuminanceFromRGBComponents(const CGFloat *rgb)
{
	// 0.3086 + 0.6094 + 0.0820 = 1.0
	return 0.3086f*rgb[0] + 0.6094f*rgb[1] + 0.0820f*rgb[2];
}
