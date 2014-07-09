//
//  SECameraView.h
//  ShopExpo
//
//  Created by Constantin on 8/19/13.
//  Copyright (c) 2013 Constantin CLAUZEL SAS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>

#import "CCCameraViewDelegate.h"

@interface CCCameraView : UIView<AVCaptureVideoDataOutputSampleBufferDelegate>

@property(nonatomic, weak)id<CCCameraViewDelegate> delegate;

@end
