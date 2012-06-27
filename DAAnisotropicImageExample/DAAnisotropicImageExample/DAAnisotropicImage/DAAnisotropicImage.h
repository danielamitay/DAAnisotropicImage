//
//  DAAnisotropicImage.h
//  DAAnisotropicImage
//
//  Created by Daniel Amitay on 6/26/12.
//  Copyright (c) 2012 Daniel Amitay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

typedef void (^DAAnisotropicBlock)(UIImage *image);

@interface DAAnisotropicImage : NSObject

+ (void)startAnisotropicUpdatesWithHandler:(DAAnisotropicBlock)block;
+ (void)stopAnisotropicUpdates;
+ (BOOL)anisotropicUpdatesActive;

+ (UIImage *)imageFromAccelerometerData:(CMAccelerometerData *)data;

@end
