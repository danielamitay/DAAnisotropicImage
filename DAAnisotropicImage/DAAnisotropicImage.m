//
//  DAAnisotropicImage.m
//  DAAnisotropicImage
//
//  Created by Daniel Amitay on 6/26/12.
//  Copyright (c) 2012 Daniel Amitay. All rights reserved.
//

#import "DAAnisotropicImage.h"

@implementation DAAnisotropicImage

static CMMotionManager *motionManager = nil;
static NSOperationQueue *accelerometerQueue = nil;

static UIImage *base = nil;
static UIImage *dark = nil;
static UIImage *left = nil;
static UIImage *right = nil;

static double darkImageRotation = 0.0;
static double leftImageRotation = 0.0;
static double rightImageRotation = 0.0;

+ (void)initialize
{
	if(self == [DAAnisotropicImage class])
	{
        motionManager = [[CMMotionManager alloc] init];
        motionManager.accelerometerUpdateInterval = 0.025f;
        accelerometerQueue = [[NSOperationQueue alloc] init];
        
        // These images will be accessed and drawn many times per second.
        // It is wise to allocate and retain them here to minimize future lag.
        // The difference is imperceptible, yet exists.
        
		base = [UIImage imageNamed:@"base"];
        dark = [UIImage imageNamed:@"dark"];
        left = [UIImage imageNamed:@"left"];
        right = [UIImage imageNamed:@"right"];
    }
}

+ (void)startAnisotropicUpdatesWithHandler:(DAAnisotropicBlock)block
{
    [motionManager startAccelerometerUpdatesToQueue:accelerometerQueue 
                                         withHandler:^(CMAccelerometerData *data, NSError *error) {
                                             UIImage *anisotropicImage = [self imageFromAccelerometerData:data];
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 block(anisotropicImage);
                                             });
                                         }];
}

+ (void)stopAnisotropicUpdates
{
    [motionManager stopAccelerometerUpdates];
}

+ (UIImage *)imageFromAccelerometerData:(CMAccelerometerData *)data
{
    CMAcceleration acceleration = [data acceleration];
    
    CGSize imageSize = base.size;
    CGPoint drawPoint = CGPointMake(-imageSize.width/2.0f,
                                    -imageSize.height/2.0f);
    
    if (UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    }
    else
    {
        UIGraphicsBeginImageContext(imageSize);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context,
                          imageSize.width/2.0f,
                          imageSize.height/2.0f);
    [base drawAtPoint:drawPoint];
    
    darkImageRotation = (darkImageRotation * 0.7f) + (acceleration.x) * 0.3f;
    CGContextRotateCTM(context, darkImageRotation);
    [dark drawAtPoint:drawPoint];
    
    leftImageRotation = (leftImageRotation * 0.7f) + (acceleration.y - darkImageRotation) * 0.3f;
    CGContextRotateCTM(context, leftImageRotation);
    [left drawAtPoint:drawPoint];
    
    rightImageRotation = (rightImageRotation * 0.7f) + (acceleration.z - leftImageRotation) * 0.3f;
    CGContextRotateCTM(context, rightImageRotation);
    [right drawAtPoint:drawPoint];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

@end
