//
//  ViewController.h
//  MinderAgent
//
//  Created by Garnik Ghazaryan on 5/21/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUpViewController.h"
#import "DataCommunicator.h"
#import "AppDelegate.h"
@interface ViewController : UIViewController <UITextFieldDelegate,UIAlertViewDelegate,SignUpViewControllerDelegate,DataCommunicatorDelegate,UIApplicationDelegate>


@property (strong, nonatomic) UIImageView *minderImageView;
@property (strong, nonatomic) UIButton *connectButton;
@property (strong, nonatomic) UIButton *signupButton;
@property (strong, nonatomic) UILabel *orLabel;

@property (weak, nonatomic) UITextField *idField;

@end
