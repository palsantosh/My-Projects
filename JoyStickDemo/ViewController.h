//
//  ViewController.h
//  JoyStickDemo
//
//  Created by Zhang Xiang on 13-4-26.
//  Copyright (c) 2013年 Zhang Xiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    IBOutlet UIView *player;
    IBOutlet UISlider *slider;
    IBOutlet UIView *viewBackground;
    IBOutlet UILabel *lblPercent;
    IBOutlet UIButton *btnConnected;
    IBOutlet UIButton *btnBack;
    
    CGPoint playerOrigin;

}

@end
