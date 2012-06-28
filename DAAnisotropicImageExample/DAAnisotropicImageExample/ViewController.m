//
//  ViewController.m
//  DAAnisotropicImageExample
//
//  Created by Daniel Amitay on 6/26/12.
//  Copyright (c) 2012 Daniel Amitay. All rights reserved.
//

#import "ViewController.h"

#import "DAAnisotropicImage.h"

#import "NSProcessInfo+CPU.h"

@interface ViewController ()
{
    UIImageView *_anisotropicImageView;
    UISlider *_anisotropicSlider;
    
    UILabel *_cpuLabel;
}

@end

@implementation ViewController

- (void)toggle:(UIButton *)button
{
    if ([DAAnisotropicImage anisotropicUpdatesActive])
    {
        [button setTitle:@"Turn Anisotropic Images ON" forState:UIControlStateNormal];
        [DAAnisotropicImage stopAnisotropicUpdates];
    }
    else
    {
        [button setTitle:@"Turn Anisotropic Images OFF" forState:UIControlStateNormal];
        [DAAnisotropicImage startAnisotropicUpdatesWithHandler:^(UIImage *image) {
            [_anisotropicImageView setImage:image];
            [_anisotropicSlider setThumbImage:image forState:UIControlStateNormal];
            [_anisotropicSlider setThumbImage:image forState:UIControlStateHighlighted];
        }];
    }
}

- (void)updateCPULabel
{
    // CPU information to demonstrate how much CPU DAAnisotropicImage uses
    // Note that this is only app-wide CPU usage, not system-wide
    // DAAnisotropicImage uses about the same amount as moving two UISliders from side to side
    // In other words, it is pretty reasonable
    float cpuUsage = [[NSProcessInfo processInfo] cpuUsage];
    _cpuLabel.text = [NSString stringWithFormat:@"Allocated CPU Usage: %.1f%%", (cpuUsage*100.0f)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _anisotropicImageView = [[UIImageView alloc] initWithFrame:CGRectMake(102.0f, 40.0f, 116.0f, 116.0f)];
    [self.view addSubview:_anisotropicImageView];
    
    _anisotropicSlider = [[UISlider alloc] initWithFrame:CGRectMake(20.0f, 180.0f, 280.0f, 40.0f)];
    [self.view addSubview:_anisotropicSlider];
    [_anisotropicSlider setValue:0.5f];
    
    // The following is for aesthetic purposes, so it looks like the iOS6 Music player
    UIImage *stretchableFillImage = [[UIImage imageNamed:@"slider-fill"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 6.0f)];
    UIImage *stretchableTrackImage = [[UIImage imageNamed:@"slider-track"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 6.0f)];
    [_anisotropicSlider setMinimumTrackImage:stretchableFillImage forState:UIControlStateNormal];
    [_anisotropicSlider setMaximumTrackImage:stretchableTrackImage forState:UIControlStateNormal];
    
    
    // Set the image with a default state (nil accelerometer data)
    UIImage *initialImage = [DAAnisotropicImage imageFromAccelerometerData:nil];
    [_anisotropicImageView setImage:initialImage];
    [_anisotropicSlider setThumbImage:initialImage forState:UIControlStateNormal];
    [_anisotropicSlider setThumbImage:initialImage forState:UIControlStateHighlighted];
    
    
    // Let's present information on how much CPU is being used
    _cpuLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 320.0f, 280.0f, 20.0f)];
    _cpuLabel.backgroundColor = [UIColor clearColor];
    _cpuLabel.textColor = [UIColor whiteColor];
    _cpuLabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:_cpuLabel];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self
                                   selector:@selector(updateCPULabel)
                                   userInfo:nil
                                    repeats:YES];
    
    UIButton *toggleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [toggleButton setFrame:CGRectMake(40.0f, 360.0f, 240.0f, 36.0f)];
    [toggleButton setTitle:@"Turn Anisotropic Images ON" forState:UIControlStateNormal];
    [toggleButton addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:toggleButton];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [DAAnisotropicImage stopAnisotropicUpdates];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
