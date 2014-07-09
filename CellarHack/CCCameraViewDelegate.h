//
//  CCCameraViewDelegate.h
//  AdRem
//
//  Created by stant on 27/01/14.
//  Copyright (c) 2014 CCSAS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CCCameraViewDelegate <NSObject>

- (void)imageCaptured:(UIImage *)image;
- (void)cancelled;

@end
