//
//  SECameraView.m
//  ShopExpo
//
//  Created by Constantin on 8/19/13.
//  Copyright (c) 2013 Constantin CLAUZEL SAS. All rights reserved.
//

#import "CCCameraView.h"

#import <QuartzCore/QuartzCore.h>

#import <ImageIO/ImageIO.h>

@interface CCCameraView() {
    
    AVCaptureStillImageOutput *_stillImageOutput;
    AVCaptureVideoPreviewLayer *_videoLayer;
    
}

@end

@implementation CCCameraView

- (id)init
{
    self = [super init];
    if (self) {
        NSError *error;
        
        self.backgroundColor = [UIColor whiteColor];
        
        AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
        AVCaptureDeviceInput *input = nil;
        NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        
        if (cameras == nil)
            return nil;
        
        for (AVCaptureDevice *device in cameras) {
            if (device.position == AVCaptureDevicePositionBack) {
                input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
                break;
            }
        }
        if (input == nil)
            return nil;
        if ([captureSession canAddInput:input] == NO)
            return nil;
        [captureSession addInput:input];
        
        AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc] init];
        //[videoOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
        
        if ([captureSession canAddOutput:videoOutput] == NO)
            return nil;
        
        [captureSession addOutput:videoOutput];
        
        _videoLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
        _videoLayer.frame = self.bounds;
        [self.layer addSublayer:_videoLayer];
        
        _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, AVVideoScalingModeResizeAspectFill, AVVideoScalingModeKey, nil];
        [_stillImageOutput setOutputSettings:outputSettings];
        if ([captureSession canAddOutput:_stillImageOutput] == NO)
            return nil;
        
        [captureSession addOutput:_stillImageOutput];
        
        [captureSession startRunning];
        
        CGRect cancelButtonFrame = CGRectMake(0, 0, 40, 40);
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = cancelButtonFrame;
        cancelButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        cancelButton.layer.cornerRadius = 5.0f;
        cancelButton.clipsToBounds = YES;
        [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        [cancelButton setTitle:@"X" forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont fontWithName:@"Courier-Bold" size:50];
        [self addSubview:cancelButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _videoLayer.frame = self.bounds;
}

- (void)cancel:(id)target {
    [_delegate cancelled];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self showLoadingView];
    
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _stillImageOutput.connections) {
        for (AVCaptureInputPort *inputPort in connection.inputPorts) {
            if ([[inputPort mediaType] isEqualToString:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection != nil)
            break;
    }
    
    if (videoConnection == nil)
        return; // :(
    
    if ([videoConnection isVideoOrientationSupported] == YES) {
        AVCaptureVideoOrientation videoOrientation;
        switch ([UIDevice currentDevice].orientation) {
            case UIDeviceOrientationLandscapeLeft:
                videoOrientation = AVCaptureVideoOrientationLandscapeRight;
                break;
            case UIDeviceOrientationLandscapeRight:
                videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
                break;
            case UIDeviceOrientationPortraitUpsideDown:
                videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
                break;
            default:
                videoOrientation = AVCaptureVideoOrientationPortrait;
                break;
        }
        videoConnection.videoOrientation = videoOrientation;
    }
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        CFDictionaryRef exifAttachments = CMGetAttachment(imageDataSampleBuffer, kCGImagePropertyExifDictionary, NULL);
        if (exifAttachments) {
            NSLog(@"attachements: %@", exifAttachments);
        } else {
            NSLog(@"no attachments");
        }
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        
        if (_delegate != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate imageCaptured:image];
            });
        }
    }];
}

- (void)showLoadingView {
    UIView *loadingView = [[UIView alloc] initWithFrame:self.bounds];
    loadingView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    loadingView.alpha = 0;
    [self addSubview:loadingView];
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicatorView.center = loadingView.center;
    [loadingView addSubview:indicatorView];
    [indicatorView startAnimating];
    
    [UIView animateWithDuration:0.2 animations:^{
        loadingView.alpha = 1;
    }];
}

@end
