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

static UIImage *baseImage = nil;
static UIImage *darkImage = nil;
static UIImage *leftImage = nil;
static UIImage *rightImage = nil;

static CGFloat darkImageRotation = 0.0f;
static CGFloat leftImageRotation = 0.0f;
static CGFloat rightImageRotation = 0.0f;

+ (void)initialize
{
	if(self == [DAAnisotropicImage class])
	{
        motionManager = [[CMMotionManager alloc] init];
        motionManager.accelerometerUpdateInterval = 0.05f;
        accelerometerQueue = [[NSOperationQueue alloc] init];
        
        // These images will be accessed and drawn many times per second.
        // It is wise to allocate and retain them here to minimize future lag.
        // The difference is imperceptible, yet exists.
        
        baseImage = [UIImage imageNamed:@"DAAnisotropicImage.bundle/base"];
        darkImage = [UIImage imageNamed:@"DAAnisotropicImage.bundle/dark"];
        leftImage = [UIImage imageNamed:@"DAAnisotropicImage.bundle/left"];
        rightImage = [UIImage imageNamed:@"DAAnisotropicImage.bundle/right"];
    }
}

+ (void)startAnisotropicUpdatesWithHandler:(DAAnisotropicBlock)updateBlock
{
    [motionManager startAccelerometerUpdatesToQueue:accelerometerQueue 
                                         withHandler:^(CMAccelerometerData *data, NSError *error) {
                                             UIImage *anisotropicImage = [self imageFromAccelerometerData:data];
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 updateBlock(anisotropicImage);
                                             });
                                         }];
}

+ (void)stopAnisotropicUpdates
{
    [motionManager stopAccelerometerUpdates];
}

+ (BOOL)anisotropicUpdatesActive
{
    return motionManager.accelerometerActive;
}

+ (UIImage *)imageFromAccelerometerData:(CMAccelerometerData *)data
{
    CGSize baseImageSize = baseImage.size;
    CGPoint drawPoint = CGPointMake(-baseImageSize.width / 2.0f, -baseImageSize.height / 2.0f);
    
    if (UIGraphicsBeginImageContextWithOptions != NULL)
    {
        UIGraphicsBeginImageContextWithOptions(baseImageSize, NO, 0.0f);
    }
    else
    {
        UIGraphicsBeginImageContext(baseImageSize);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [baseImage drawAtPoint:CGPointZero];
    CGContextTranslateCTM(context, baseImageSize.width / 2.0f, baseImageSize.height / 2.0f);
    
    // The following numbers are made up
    // They look OK, but there is definitely improvement to be made
    
    darkImageRotation = (darkImageRotation * 0.6f) + (data.acceleration.x * M_PI_2) * 0.4f;
    CGContextRotateCTM(context, darkImageRotation);
    [darkImage drawAtPoint:drawPoint];
    
    leftImageRotation = (leftImageRotation * 0.6f) + (data.acceleration.y * M_PI_2 - darkImageRotation) * 0.4f;
    CGContextRotateCTM(context, leftImageRotation);
    [leftImage drawAtPoint:drawPoint];
    
    rightImageRotation = (rightImageRotation * 0.6f) + (data.acceleration.z * M_PI_2 - leftImageRotation) * 0.4f;
    CGContextRotateCTM(context, rightImageRotation);
    [rightImage drawAtPoint:drawPoint];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

@end
