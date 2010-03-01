// $Id: main.m,v 1.4 2008/06/29 17:53:46 royratcliffe Exp $
//
// Copyright © 2008, Roy Ratcliffe, Lancaster, United Kingdom
// All rights reserved
//
//------------------------------------------------------------------------------

#import <Cocoa/Cocoa.h>

int main(int argc, char *argv[])
{
	return NSApplicationMain(argc, (const char **)argv);
	// Cast argv to "const char star-star" because NSApplicationMain requires
	// const char, meaning it does not modify individual arguments; it may
	// modify the vector but not its elements. Otherwise, without the cast, the
	// compiler throws a warning: passing argument 2 from incompatible pointer
	// type!
}
