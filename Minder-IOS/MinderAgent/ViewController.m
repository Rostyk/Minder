//
//  ViewController.m
//  MinderAgent
//
//  Created by Garnik Ghazaryan on 5/21/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import "ViewController.h"
#import "ConnectedViewController.h"
#import "Utils.h"
#import "SVProgressHUD.h"
#import "LocationManager.h"
#import "SecureUDID.h"
#import "LocationShareModel.h"
#import <AudioToolbox/AudioToolbox.h>

#define iOSVersion7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)?TRUE:FALSE
#define iosVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#define topOffset (iOSVersion7) ? 64 : 0
#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE

@interface ViewController ()

@end

@implementation ViewController{

    SignUpViewController *signUpViewController;
    ConnectedViewController *connectedViewController;
    DataCommunicator *dataCommunicator;
    UIAlertView *connectFailed;
    UIAlertView *successAlert;
    

    UIScrollView *signUpScrollView;
    
    NSString *minderId;
    NSUserDefaults *defs;
    BOOL isConnected;
}
@synthesize minderImageView,idField,connectButton,signupButton,orLabel;

- (void) createUI {
    minderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 77, 285, 100)];
    minderImageView.image = [UIImage imageNamed:@"headerImage.png"];
    [self.view addSubview:minderImageView];
    idField = [self createTextFieldWithRect:CGRectMake(20, 199, 280, 30) title:@"" placeHolderText:@"Enter your MinderWeb ID"];
    connectButton = [self createButtonInRect:CGRectMake(70, 269, 180, 40) title:nil action:@selector(connectButtonAction) backGroundImage:[UIImage imageNamed:@"connect.png"] selectedImage:nil highlightImage:nil];
    connectButton.enabled = NO;
    [connectButton setTitle:@"Connect" forState:UIControlStateNormal];

    orLabel = [[UILabel alloc] initWithFrame:CGRectMake(136, 322, 48, 30)];
    orLabel.text = @"- OR -";
    [self.view addSubview:orLabel];
    signupButton = [self createButtonInRect:CGRectMake(70, 360, 180, 40) title:nil action:@selector(signupButtonAction) backGroundImage:[UIImage imageNamed:@"signupgray.png"] selectedImage:nil highlightImage:nil];
    [signupButton setTitle:@"Sign Up" forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    UILabel *navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 40)];
    navTitleLabel.text = @"Minder Native";
    navTitleLabel.font = [UIFont systemFontOfSize:20];
    navTitleLabel.textAlignment = NSTextAlignmentCenter;
    navTitleLabel.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = navTitleLabel;

    connectedViewController = [[ConnectedViewController alloc] initWithNibName:@"ConnectedViewController" bundle:nil];
    dataCommunicator = [[DataCommunicator alloc] initWithURL:@"http://minderweb.com/login"];
    dataCommunicator.delegate = self;
    
    
    [self createUI];
    idField.returnKeyType = UIReturnKeyDone;
    idField.delegate = self;
    NSLog(@"ios :%f", iosVersion);
    if (iosVersion < 7.0) {
        CGRect tmpRect = self.view.bounds;
        tmpRect.origin.y += 60;
        tmpRect.size.height = tmpRect.size.height - 60 ;
        self.view.bounds = tmpRect;
        
    }

	// Do any additional setup after loading the view, typically from a nib.
}
- (void)viewWillAppear:(BOOL)animated {
    
    signUpViewController = nil;
    
    signUpViewController = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
    signUpViewController.delegate = self;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        defs = [NSUserDefaults standardUserDefaults];
        isConnected = [[defs objectForKey:@"connected"] boolValue];
        if (isConnected) {
            [self presentViewController:connectedViewController animated:NO completion:nil];
        }

    });

}
-(void)viewDidDisappear:(BOOL)animated{

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Other functions


- (NSDictionary*) createJSON {
    
    NSString *deviceModel = [Utils deviceModelName];
    NSString *osVersion = [[UIDevice currentDevice] systemVersion];
    NSString *UUID = [Utils getUUIDString];//[SecureUDID UDIDForDomain:@"com.parttwoconsulting.minderWebId" usingKey:@"parttwominderwebapp"];
    
    NSNumber *latitude = [defs objectForKey:@"latitude"];
    NSNumber *longitude = [defs objectForKey:@"longitude"];

    NSString *mindID = @"";
    
    if ([idField.text isEqualToString:@""]) {
        mindID = minderId;
    }else {
        mindID = idField.text;
    }
    
    NSDictionary *dict = @{ @"minder_id" : mindID,
                            @"device_name" : deviceModel,
                            @"os_version" : osVersion,
                            @"udid" : UUID,
                            @"device_type" : @"iOS",
                            @"last_location" : [NSString stringWithFormat:@"%f, %f",[latitude doubleValue], [longitude doubleValue]]
                            };

    return dict;
    
}
- (void)connectButtonAction{
    if ([LocationManager locationServicesEnabled]) {
        if ([dataCommunicator networkIsReachable]) {
            [self connectToServer];
        }else {
            UIAlertView *nonetworkAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please check device network connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [nonetworkAlert show];
        }
    }else {
        UIAlertView *noLocationAlert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please enable location services for this app from device settings" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noLocationAlert show];
    }
//cw5hp3Sg
//    [self presentViewController:connectedViewController animated:YES completion:nil];
}
 

- (void)signupButtonAction{
    [self.navigationController pushViewController:signUpViewController animated:YES];
}

- (void) connectToServer{
    [dataCommunicator sendJSONDict:[self createJSON] withURL:@"http://minderweb.com/login"];
}
- (void) failedWithAlert:(NSString*)message andTitle:(NSString*) title andButtons:(NSArray *)buttons{
//    NSString *messageString = [NSString stringWithFormat:@"MinderWeb ID %@ does not exist. Do you want to signup now?",idField.text];
    connectFailed = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:buttons[0] otherButtonTitles:[buttons count] > 1 ? buttons[1] : nil , nil];
    [connectFailed show];
}

#pragma mark signup delegate

-(void)didSignUpSuccess:(id)responseObject{

    
    NSDictionary *dict = responseObject;
    NSString *message = [dict objectForKey:@"message"];
    NSString *statusCode = [dict objectForKey:@"status_code"];
    if ([statusCode intValue] == 200) {
        minderId = [dict objectForKey:@"minderId"];
        NSString *messageString = [NSString stringWithFormat:@"%@",message];
        successAlert = [[UIAlertView alloc] initWithTitle:@"Sign Up Success" message:messageString delegate:self cancelButtonTitle:@"Not Now" otherButtonTitles:@"Connect", nil];
        [successAlert show];
    }


}
#pragma mark datacommunicator delegates

-(void)requestWillStart{
    [SVProgressHUD show];
}

- (void)didFinishWithSuccess:(id)responseObject {
    
    NSDictionary *dict = responseObject;
    NSString *message = [dict objectForKey:@"message"];
    NSString *statusCode = [dict objectForKey:@"status_code"];
    NSString *deviceID = [dict objectForKey:@"device_id"];
    if ([message hasPrefix:@"MinderWeb ID"]) {
        [self failedWithAlert:message andTitle:@"Error" andButtons:@[@"Not Now", @"Sign Up"]];
    }else if ([message hasPrefix:@"Please activate"]){
        [self failedWithAlert:message andTitle:@"Warning" andButtons:@[@"OK"]];
    }else if ([statusCode intValue] == 200){
        [SVProgressHUD showSuccessWithStatus:message];
        [self presentViewController:connectedViewController animated:YES completion:^{
            isConnected = TRUE;
            
                [defs setObject:deviceID forKey:@"deviceID"];
                NSString *deviceToken = [defs objectForKey:@"deviceToken"];
                [self sendDeviceToken:deviceToken deviceId:[deviceID intValue]];
            [defs setObject:[NSNumber numberWithBool:isConnected] forKey:@"connected"];
            [defs synchronize];
        }];
    }
    [SVProgressHUD dismiss];
}

- (void)didFinishWithError:(id)responseObject {
    [SVProgressHUD showErrorWithStatus:@"Error"];
}

#pragma mark TextField Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@""]) {
//        textField.text = [textField.text substringToIndex:[textField.text length] - 1];
        if (![[textField.text substringToIndex:[textField.text length] - 1] isEqualToString:@""]) {
            connectButton.enabled = YES;
        }else{
            connectButton.enabled = NO;
            return YES;
        }
        
    }
    if (![[NSString stringWithFormat:@"%@%@",textField.text,string] isEqualToString:@""]){
            connectButton.enabled = YES;
    }
        
    return YES;
}
#pragma mark AlertView Delegates

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [SVProgressHUD dismiss];
    if (alertView == connectFailed) {
        if (buttonIndex == 1) {
            [self.navigationController pushViewController:signUpViewController animated:YES];
        }
            
    }else if (alertView == successAlert){
        if (buttonIndex == 1) {
            [self connectToServer];
        }
    }

}

#pragma mark UI Creation
- (UITextField*) createTextFieldWithRect:(CGRect)rect title:(NSString*)title placeHolderText:(NSString*)placeHolderText{
    UITextField *textField = [[UITextField alloc] initWithFrame:rect];
    [self.view addSubview:textField];
    textField.text = title;
    textField.placeholder = placeHolderText;   //for place holder
    [textField setBorderStyle:UITextBorderStyleRoundedRect];
    //    textField.textAlignment = UITextAlignmentLeft;          //for text Alignment
    //    textField.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:14.0]; // text font
    //    textField.adjustsFontSizeToFitWidth = YES;     //adjust the font size to fit width.
    //
    //    textField.textColor = [UIColor greenColor];             //text color
    //    textField.keyboardType = UIKeyboardTypeAlphabet;        //keyboard type of ur choice
    //    textField.returnKeyType = UIReturnKeyDone;              //returnKey type for keyboard
    //    textField.clearButtonMode = UITextFieldViewModeWhileEditing;//for clear button on right side
    //
    textField.delegate = self;
    
    return textField;
}

- (UIButton*)createButtonInRect:(CGRect)rect title:(NSString*)title action:(SEL)action backGroundImage:(UIImage*)backgroundImage selectedImage:(UIImage*)selectedImage highlightImage:(UIImage*)highlightImage{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:action
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = rect;
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [button setBackgroundImage:selectedImage forState:UIControlStateSelected];
    // Pressed state background
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    [self.view addSubview:button]; //invisible is a selector see below
    
    return button;
}

-(void)sendDeviceToken:(NSString*)deviceToken deviceId:(int)deviceID{
    
    NSString *tokenNoSpace = [NSString stringWithFormat:@"%@",deviceToken];
    
    tokenNoSpace = [tokenNoSpace stringByReplacingOccurrencesOfString:@" " withString:@""];
    tokenNoSpace = [tokenNoSpace stringByReplacingOccurrencesOfString:@"<" withString:@""];
    tokenNoSpace = [tokenNoSpace stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    NSString *tokenString = [NSString stringWithFormat:@"device_token=%@",tokenNoSpace]; //@"aass651378cfa2510b1a6d217fbe795c7cfb307b6cb058b6184aede661092c149"

    NSString *urlString=[NSString stringWithFormat:@"http://minderweb.com/device/%d",deviceID];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSData *fileData = [tokenString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:fileData];  // I tried with and
    
    NSData *respData;
    NSURLResponse *response;
    NSError *error;
    respData = [NSURLConnection sendSynchronousRequest:request
                                     returningResponse:&response
                                                 error:&error];
    
    NSLog(@"response: %@ error: %@",[[NSString alloc] initWithData:respData encoding:NSUTF8StringEncoding],[error localizedDescription]);
}

@end
