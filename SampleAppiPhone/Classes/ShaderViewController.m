// GlossCausticShader ShaderViewController.m
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

#import "ShaderViewController.h"
#import "ShaderView.h"

#import "RRGlossCausticShader.h"
#import "UIColor+RRUIKit.h"

#import <QuartzCore/QuartzCore.h>

// iPhone OS makes binding more difficult. It lacks Cocoa's key-value bindings,
// at the current version. However, it does not lack key-value coding. The
// controller can access shader and matcher properties using KVC. This
// simplifies the controller to some extent. Slider tags identify which key-path
// the slider value modifies. Tags are integers only, on iPhone.

static NSString *const kKeyPaths[] =
{
	@"exponentialCoefficient",
	@"glossReflectionPower",
	@"glossStartingWhite",
	@"glossEndingWhite",
	@"matcher.causticHue",
	@"matcher.graySaturationThreshold",
	@"matcher.causticSaturationForGrays",
	@"matcher.redHueThreshold",
	@"matcher.blueHueThreshold",
	@"matcher.blueCausticHue",
	@"matcher.causticFractionDomainFactor",
	@"matcher.causticFractionRangeFactor",
};

// Make it easier to add a digit of precision, or remove one!
static NSString *const kFloatFormat = @"%.3f";

@implementation ShaderViewController

@synthesize shaderView;
@synthesize controlsView;
@synthesize scrollView;
@synthesize colorButton;
@synthesize settingsTab;

@synthesize redSlider;
@synthesize greenSlider;
@synthesize blueSlider;
@synthesize redLabel;
@synthesize greenLabel;
@synthesize blueLabel;

@synthesize exponentialCoefficientSlider;
@synthesize glossReflectionPowerSlider;
@synthesize glossStartingWhiteSlider;
@synthesize glossEndingWhiteSlider;
@synthesize exponentialCoefficientLabel;
@synthesize glossReflectionPowerLabel;
@synthesize glossStartingWhiteLabel;
@synthesize glossEndingWhiteLabel;

@synthesize causticHueSlider;
@synthesize graySaturationThresholdSlider;
@synthesize causticSaturationForGraysSlider;
@synthesize redHueThresholdSlider;
@synthesize blueHueThresholdSlider;
@synthesize blueCausticHueSlider;
@synthesize causticFractionDomainFactorSlider;
@synthesize causticFractionRangeFactorSlider;
@synthesize causticHueLabel;
@synthesize graySaturationThresholdLabel;
@synthesize causticSaturationForGraysLabel;
@synthesize redHueThresholdLabel;
@synthesize blueHueThresholdLabel;
@synthesize blueCausticHueLabel;
@synthesize causticFractionDomainFactorLabel;
@synthesize causticFractionRangeFactorLabel;

- (void)syncUIWithShaderSettings
{
	UIColor *color = [self.shaderView.shader noncausticColor];
	self.colorButton.backgroundColor = color;
	self.redLabel.text = [NSString stringWithFormat:kFloatFormat, self.redSlider.value = [color redComponent]];
	self.greenLabel.text = [NSString stringWithFormat:kFloatFormat, self.greenSlider.value = [color greenComponent]];
	self.blueLabel.text = [NSString stringWithFormat:kFloatFormat, self.blueSlider.value = [color blueComponent]];
	for (NSUInteger i = 0; i < sizeof(kKeyPaths)/sizeof(kKeyPaths[0]); i++)
	{
		float value = [[self.shaderView.shader valueForKeyPath:kKeyPaths[i]] floatValue];
		NSString *key = [[kKeyPaths[i] componentsSeparatedByString:@"."] lastObject];
		UISlider *slider = [self valueForKeyPath:[key stringByAppendingString:@"Slider"]];
		UILabel *label = [self valueForKeyPath:[key stringByAppendingString:@"Label"]];
		label.text = [NSString stringWithFormat:kFloatFormat, slider.value = value];
	}
	[self.shaderView update];
}

- (void)loadSettingsFromUserDefaults
{
	NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"Shader"];
	if (data)
	{
		shaderView.shader = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	}
}
- (void)saveSettingsToUserDefaults
{
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:shaderView.shader];
	[[NSUserDefaults standardUserDefaults] setObject:data forKey:@"Shader"];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.scrollView.contentSize = self.controlsView.bounds.size;
	[self.scrollView addSubview:self.controlsView];
	
	self.colorButton.layer.borderColor = [[UIColor blackColor] CGColor];
	self.colorButton.layer.borderWidth = 1.0f;
	
	self.settingsTab.layer.borderColor = [[UIColor blackColor] CGColor];
	self.settingsTab.layer.borderWidth = 1.0f;
	self.settingsTab.layer.cornerRadius = 5.0f;
	
	[self loadSettingsFromUserDefaults];
	[self syncUIWithShaderSettings];
}

//------------------------------------------------------------------------------
#pragma mark                                                             Actions
//------------------------------------------------------------------------------

- (IBAction)printToConsoleButtonTapped:(id)sender
{
	// Access by key paths simplifies the print-to-console method.
	RRGlossCausticShader *shader = self.shaderView.shader;
	NSString *format = [kFloatFormat stringByAppendingString:@"f"];
	NSLog(@"UIColor *baseColor = [UIColor colorWithRed:%@ green:%@ blue:%@ alpha:1.0f];",
		  [NSString stringWithFormat:format, [[shader noncausticColor] redComponent]],
		  [NSString stringWithFormat:format, [[shader noncausticColor] greenComponent]],
		  [NSString stringWithFormat:format, [[shader noncausticColor] blueComponent]]);
	NSLog(@"[shader setNoncausticColor:baseColor];");
	for (NSUInteger i = 0; i < sizeof(kKeyPaths)/sizeof(kKeyPaths[0]); i++)
	{
		float value = [[shader valueForKeyPath:kKeyPaths[i]] floatValue];
		NSArray *components = [kKeyPaths[i] componentsSeparatedByString:@"."];
		NSString *subKeyPath = [components count] == 1 ? @"" : [@"." stringByAppendingString:[components objectAtIndex:0]];
		NSString *setName = [[components lastObject] capitalizedString];
		NSLog(@"[shader%@ set%@:%@];", subKeyPath, setName, [NSString stringWithFormat:format, value]);
	}
}

- (IBAction)resetToDefaultsButtonTapped:(id)sender
{
	self.shaderView.shader = [[[RRGlossCausticShader alloc] init] autorelease];
	[self syncUIWithShaderSettings];
	[self saveSettingsToUserDefaults];
}

// non-caustic a.k.a. base colour slider

- (IBAction)colorSliderChanged:(id)sender
{
	UIColor *newColor = [UIColor colorWithRed:self.redSlider.value
										green:self.greenSlider.value
										 blue:self.blueSlider.value
										alpha:1.0f];
	
	self.colorButton.backgroundColor = newColor;
	
	self.redLabel.text   = [NSString stringWithFormat:kFloatFormat, [newColor redComponent]];
	self.greenLabel.text = [NSString stringWithFormat:kFloatFormat, [newColor greenComponent]];
	self.blueLabel.text  = [NSString stringWithFormat:kFloatFormat, [newColor blueComponent]];
	
	[self.shaderView.shader setNoncausticColor:newColor];
	[self.shaderView update];
	[self saveSettingsToUserDefaults];
}

// non-colour sliders

- (IBAction)sliderChanged:(id)sender
{
	UISlider *slider = sender;
	NSString *keyPath = kKeyPaths[slider.tag];
	NSString *key = [[keyPath componentsSeparatedByString:@"."] lastObject];
	UILabel *label = [self valueForKeyPath:[key stringByAppendingString:@"Label"]];
	
	// Slider adjustments update the shader, shader view, label and
	// defaults. That is, everything else apart from the slider.
	label.text = [NSString stringWithFormat:kFloatFormat, slider.value];
	[self.shaderView.shader setValue:[NSNumber numberWithFloat:slider.value] forKeyPath:keyPath];
	[self.shaderView update];
	[self saveSettingsToUserDefaults];
}

@end
