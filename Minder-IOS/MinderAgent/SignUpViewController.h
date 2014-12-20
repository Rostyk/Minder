//
//  SignUpViewController.h
//  MinderAgent
//
//  Created by Garnik Ghazaryan on 5/21/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataCommunicator.h"
#import "BSKeyboardControls.h"
@protocol SignUpViewControllerDelegate <NSObject>

@optional - (void) didSignUpSuccess:(id) responseObject;

@end

@interface SignUpViewController : UIViewController <UITextFieldDelegate,UIAlertViewDelegate,DataCommunicatorDelegate,BSKeyboardControlsDelegate>{
    
    DataCommunicator *dataCommunicator;

}


@property (strong, nonatomic) UITextField *firstNameField;
@property (strong, nonatomic) UITextField *lastNameField;
@property (strong, nonatomic) UITextField *emailField;
@property (strong, nonatomic) UITextField *passwordField;
@property (strong, nonatomic) UITextField *reEnterPasswordField;
@property (strong, nonatomic) UIButton *checkBoxButton;
@property (strong, nonatomic) UIButton *agreeButton;
@property (strong, nonatomic) UIButton *signUpButton;

@property (nonatomic) id delegate;


@end
