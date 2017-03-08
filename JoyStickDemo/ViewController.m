//
//  ViewController.m
//  JoyStickDemo
//
//  Created by Zhang Xiang on 13-4-26.
//  Copyright (c) 2013年 Zhang Xiang. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    playerOrigin = player.frame.origin;
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver: self
                           selector: @selector (onStickChanged:)
                               name: @"StickChanged"
                             object: nil];
    
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * 1.5);
    slider.transform = trans;
    
    slider.value = 0.5;
    lblPercent.text = @"50%";
    btnConnected.selected = YES;
    
    [self startBlinkingLabel:btnConnected];
  //  [slider setThumbImage:[UIImage imageNamed:@"roller.png"] forState:UIControlStateNormal];

    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        AVCaptureSession *session = [[AVCaptureSession alloc] init];
        AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if (videoDevice)
        {
            NSError *error;
            AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
            if (!error)
            {
                if ([session canAddInput:videoInput])
                {
                    [session addInput:videoInput];
                    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
                    previewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
                    previewLayer.frame =viewBackground.layer.bounds;
                    [viewBackground.layer addSublayer:previewLayer];
                    [session startRunning];
                }
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) startBlinkingLabel:(UIButton *)label
{
    label.alpha =1.0f;
    [UIView animateWithDuration:0.32
                          delay:0.0
                        options: UIViewAnimationOptionAutoreverse |UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction |UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         label.alpha = 0.2f;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             
                         }
                     }];
}

-(void) stopBlinkingLabel:(UILabel *)label
{
    // REMOVE ANIMATION
    [label.layer removeAnimationForKey:@"opacity"];
    label.alpha = 1.0f;
}

-(IBAction)changeSlider:(id)sender
{
    lblPercent.text =[NSString stringWithFormat:@"%.0f%@",slider.value *100,@"%"];
    NSLog(@"slider == %f",slider.value);
}

-(IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onStickChanged:(id)notification
{
    NSDictionary *dict = [notification userInfo];
    NSValue *vdir = [dict valueForKey:@"dir"];
    CGPoint dir = [vdir CGPointValue];
    
    NSLog(@"dir.x === %.2f, dir.y === %.2f",dir.x, -1 * dir.y);

    CGPoint newpos = playerOrigin;
    newpos.x = 30.0 * dir.x + playerOrigin.x;
    newpos.y = 30.0 * dir.y + playerOrigin.y;
    CGRect fr = player.frame;
    fr.origin = newpos;
    player.frame = fr;
}

@end
