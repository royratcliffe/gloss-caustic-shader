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
#import "GlossCausticShaderView.h"

#import "RRGlossCausticShader.h"
#import "UIColor+RRUIKit.h"

#import <QuartzCore/QuartzCore.h>

@implementation GlossCausticShaderViewController

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

static NSString *const keyPaths[] =
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

- (void)syncUIWithShaderSettings
{
	UIColor *color = [self.shaderView.shader noncausticColor];
	self.colorButton.backgroundColor = color;
	self.redLabel.text = [NSString stringWithFormat:@"%.3f", self.redSlider.value = [color redComponent]];
	self.greenLabel.text = [NSString stringWithFormat:@"%.3f", self.greenSlider.value = [color greenComponent]];
	self.blueLabel.text = [NSString stringWithFormat:@"%.3f", self.blueSlider.value = [color blueComponent]];
	for (NSUInteger i = 0; i < sizeof(keyPaths)/sizeof(keyPaths[0]); i++)
	{
		float value = [[self.shaderView.shader valueForKeyPath:keyPaths[i]] floatValue];
		NSString *key = [[keyPaths[i] componentsSeparatedByString:@"."] lastObject];
		UISlider *slider = [self valueForKeyPath:[key stringByAppendingString:@"Slider"]];
		UILabel *label = [self valueForKeyPath:[key stringByAppendingString:@"Label"]];
		label.text = [NSString stringWithFormat:@"%.3f", slider.value = value];
	}
	[self.shaderView update];
}

- (void)loadSettingsFromUserDefaults
{
	NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"Shader"];
	if (data)
	{
		RRGlossCausticShader *shader = [NSKeyedUnarchiver unarchiveObjectWithData:data];
		if (shader)
		{
			shaderView.shader = shader;
		}
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
	
	self.redLabel.text   = [NSString stringWithFormat:@"%.3f", [newColor redComponent]];
	self.greenLabel.text = [NSString stringWithFormat:@"%.3f", [newColor greenComponent]];
	self.blueLabel.text  = [NSString stringWithFormat:@"%.3f", [newColor blueComponent]];
	
	[self.shaderView.shader setNoncausticColor:newColor];
	[self.shaderView update];
	[self saveSettingsToUserDefaults];
}

// non-colour sliders

- (IBAction)sliderChanged:(id)sender
{
	UISlider *slider = sender;
	NSString *keyPath = keyPaths[slider.tag];
	NSString *key = [[keyPath componentsSeparatedByString:@"."] lastObject];
	UILabel *label = [self valueForKeyPath:[key stringByAppendingString:@"Label"]];
	label.text = [NSString stringWithFormat:@"%.3f", slider.value];
	
	[self.shaderView.shader setValue:[NSNumber numberWithFloat:slider.value] forKeyPath:keyPath];
	[self.shaderView update];
	[self saveSettingsToUserDefaults];
}

@end
