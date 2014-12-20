//
//  SignUpViewController.m
//  MinderAgent
//
//  Created by Garnik Ghazaryan on 5/21/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import "SignUpViewController.h"
#import "SVProgressHUD.h"
#import "TermsandConditionsViewController.h"


#define SERVER_URL @"http://minderweb.com/user"

#define iOSVersion7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)?TRUE:FALSE
#define iosVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#define topOffset (iOSVersion7) ? 64 : 0
#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE

@interface SignUpViewController ()
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@end

@implementation SignUpViewController {

    int topOffsetHeight;
    BOOL passwordVerified;
    BOOL reenteredRight;
    BOOL isAccepted;
    UITextField *toClose;
    int validCounter;
    int movedBy;
   

}

@synthesize checkBoxButton,emailField,firstNameField,lastNameField,passwordField,reEnterPasswordField,agreeButton,signUpButton;
@synthesize delegate,keyboardControls;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void) createUI{
    topOffsetHeight = topOffset;
    
    firstNameField = [self createTextFieldWithRect:CGRectMake(20, 30, 280, 30) title:@"" placeHolderText:@"*First Name"];
    lastNameField = [self createTextFieldWithRect:CGRectMake(20, 75, 280, 30) title:@"" placeHolderText:@"*Last Name"];
    emailField = [self createTextFieldWithRect:CGRectMake(20, 120, 280, 30) title:@"" placeHolderText:@"*Email"];
    passwordField = [self createTextFieldWithRect:CGRectMake(20, 165, 280, 30) title:@"" placeHolderText:@"*Password"];
    reEnterPasswordField = [self createTextFieldWithRect:CGRectMake(20, 210, 280, 30) title:@"" placeHolderText:@"*Re-Enter password"];
    
    checkBoxButton = [self createButtonInRect:CGRectMake( 14, 253, 40, 40) title:@"" action:@selector(checkBoxPressed) backGroundImage:[UIImage imageNamed:@"box.png"] selectedImage:[UIImage imageNamed:@"checkbox.png"]  highlightImage:nil];
    agreeButton = [self createButtonInRect:CGRectMake( 54, 257, 246, 30) title:@"" action:@selector(termsAndCondsPressed) backGroundImage:nil selectedImage:nil  highlightImage:nil];
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:14.0];
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName : font, NSForegroundColorAttributeName : [UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:1]};
    NSAttributedString * attributedText = [[NSAttributedString alloc] initWithString:@"I Accept the Terms and Conditions"
                                                             attributes:underlineAttribute];
    [agreeButton setAttributedTitle:attributedText forState:UIControlStateNormal];
    
    signUpButton = [self createButtonInRect:CGRectMake( 70, 328, 180, 40) title:@"" action:@selector(signUpPressed) backGroundImage:[UIImage imageNamed:@"signup.png"] selectedImage:nil  highlightImage:nil];
    [signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    signUpButton.enabled = NO;
    
    firstNameField.returnKeyType=UIReturnKeyNext;
    lastNameField.returnKeyType=UIReturnKeyNext;
    emailField.returnKeyType=UIReturnKeyNext;
    passwordField.returnKeyType=UIReturnKeyNext;
    reEnterPasswordField.returnKeyType=UIReturnKeyNext;
    emailField.keyboardType = UIKeyboardTypeEmailAddress;
    
    passwordField.secureTextEntry = TRUE;
    reEnterPasswordField.secureTextEntry = TRUE;
    
    
    NSArray *fields = @[firstNameField,lastNameField,emailField,passwordField,reEnterPasswordField];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
    UILabel *navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 40)];
    navTitleLabel.text = @"Sign Up";
    navTitleLabel.font = [UIFont systemFontOfSize:20];
    navTitleLabel.textAlignment = NSTextAlignmentCenter;
    navTitleLabel.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = navTitleLabel;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;

    dataCommunicator = [[DataCommunicator alloc] initWithURL:SERVER_URL];
    dataCommunicator.delegate = self;
    
    
    passwordField.delegate = self;
    reEnterPasswordField.delegate = self;
    firstNameField.delegate = self;
    lastNameField.delegate = self;
    emailField.delegate = self;
    passwordField.delegate = self;

    
    if (!isiPhone5 || !iOSVersion7) {
        CGRect tmpRect = self.view.bounds;
        tmpRect.origin.y += 20;
        tmpRect.size.height = tmpRect.size.height - 20;
        self.view.bounds = tmpRect;
        [signUpButton setFrame:CGRectMake(signUpButton.frame.origin.x, signUpButton.frame.origin.y - 30, signUpButton.frame.size.width, signUpButton.frame.size.height)];
        
    }

    
    

    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{


}
-(void)viewDidDisappear:(BOOL)animated{

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControlss
{
//    [self animateTextField:self.view up:NO];
    [keyboardControlss.activeField resignFirstResponder];
}
- (void)keyboardControls:(BSKeyboardControls *)keyboardControlss selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
//    UIView *view = keyboardControlss.activeField.superview.superview;
//    [self animateTextField:field up:direction];
    
}
- (void)termsAndCondsPressed{
    TermsandConditionsViewController *termsnCond = [[TermsandConditionsViewController alloc] init];
    [self.navigationController pushViewController:termsnCond animated:YES];
    
}

- (void)checkBoxPressed {
    checkBoxButton.selected = !checkBoxButton.selected;
    isAccepted = !isAccepted;
    [self verifying];
    [toClose resignFirstResponder];
}

- (void)signUpPressed {
    
    if ([dataCommunicator networkIsReachable]) {
        if ([self verifying]) {
            //SEND SIGN UP
            [dataCommunicator sendJSONDict:[self createJSON] withURL:nil];
        }
    }else {
        UIAlertView *nonetworkAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please check device network connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [nonetworkAlert show];
    }
}



- (NSDictionary*) createJSON{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:firstNameField.text,@"first_name",lastNameField.text,@"last_name",emailField.text, @"email",passwordField.text, @"password",reEnterPasswordField.text, @"confirm_password",[NSNumber numberWithBool:isAccepted] ,@"agreeterms", nil];
    
//    NSDictionary *jsonDict = @{@"\"first_name\"": [NSString stringWithFormat:@"'%@'",firstNameField.text],@"\"last_name\"":[NSString stringWithFormat:@"'%@'",lastNameField.text],@"\"email\"":[NSString stringWithFormat:@"'%@'",emailField.text], @"\"password\"" : [NSString stringWithFormat:@"'%@'",passwordField.text], @"\"confirm_password\"" : [NSString stringWithFormat:@"'%@'",reEnterPasswordField.text] };
//    NSLog(@"DIct :%@",dict);
    return dict;
    
}

- (BOOL) verifying {

    BOOL passed = FALSE;
    NSMutableString *alertString = [NSMutableString string];
    validCounter = 0;
    
    if ([firstNameField.text isEqualToString:@""]) {
//        [alertString appendFormat:@"\u2022 %@\n",@"First Name should not be empty."];
        validCounter++;
    }
    if ([lastNameField.text isEqualToString:@""]) {
//        [alertString appendFormat:@"\u2022 %@\n",@"Last Name should not be empty."];
        validCounter++;
    }
    if (![self checkEmailValidity:emailField.text] || [emailField.text isEqualToString:@""]) {
        [alertString appendFormat:@"\u2022 %@\n",@"Email is empty or wrong format."];
        validCounter++;
    }
    if (!passwordVerified || [passwordField.text isEqualToString:@""]) {
//        [alertString appendFormat:@"\u2022 %@\n",@"Wrong password format."];
        validCounter++;
    } 
    if (!reenteredRight || [reEnterPasswordField.text isEqualToString:@""]) {
//        [alertString appendFormat:@"\u2022 %@\n",@"Password re-entered wrong."];
        validCounter++;
    }if (!isAccepted) {
//        [alertString appendFormat:@"\u2022 %@\n",@"Terms and conditions are not accepted."];
        validCounter++;
    }
    if (validCounter == 0) {
        passed = TRUE;
        signUpButton.enabled = YES;
    }else{
        UIAlertView *notPassedAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:alertString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [notPassedAlert show];
        signUpButton.enabled = NO;
    }
    
    
    return passed;
}


- (BOOL) checkPasswordValidity:(UITextField*) textField lastChar: (NSString*) lastChar{
    BOOL passed = FALSE;
    NSString *resText = textField.text;
    if (textField == passwordField) {
        passwordField.layer.borderColor = [UIColor redColor].CGColor;
        passwordField.layer.borderWidth = 2.0f;
        passwordField.layer.cornerRadius = 5.0f;
        if ([lastChar isEqualToString:@""]) {
            textField.text = [textField.text substringToIndex:[textField.text length] - 1];
            passwordVerified = passed;
        }
        if ([[NSString stringWithFormat:@"%@%@",passwordField.text,lastChar] length] > 4 && [[NSString stringWithFormat:@"%@%@",passwordField.text,lastChar] length] < 20) {
            passwordField.layer.borderColor = [UIColor greenColor].CGColor;
            passwordField.layer.borderWidth = 2.0f;
            passwordField.layer.cornerRadius = 5.0f;
            passed = TRUE;
        }
        textField.text = resText;
        passwordVerified = passed;
        return passed;
    }else if (textField != nil) {
        passwordVerified = passed;
        return passed;
    }
    return passed;
}

- (BOOL) checkPasswordEquality:(UITextField*)textField lastChar:(NSString*)lastChar{
    BOOL checkPassed = FALSE;
    NSString *resText = textField.text;
    if (textField == reEnterPasswordField) {
        reEnterPasswordField.layer.borderColor = [UIColor redColor].CGColor;
        reEnterPasswordField.layer.borderWidth = 2.0f;
        reEnterPasswordField.layer.cornerRadius = 5.0f;
        if ([lastChar isEqualToString:@""]) {
            textField.text = [textField.text substringToIndex:[textField.text length] - 1];
            reenteredRight = checkPassed;
        }
        if ([passwordField.text isEqualToString:[NSString stringWithFormat:@"%@%@",reEnterPasswordField.text,lastChar]] && [[NSString stringWithFormat:@"%@%@",reEnterPasswordField.text,lastChar] length] > 4 && [[NSString stringWithFormat:@"%@%@",reEnterPasswordField.text,lastChar] length] < 20) {
            reEnterPasswordField.layer.borderColor = [UIColor greenColor].CGColor;
            reEnterPasswordField.layer.borderWidth = 2.0f;
            reEnterPasswordField.layer.cornerRadius = 5.0f;
            checkPassed = TRUE;
            reenteredRight = checkPassed;
        }
        textField.text = resText;
        reenteredRight = checkPassed;
        return checkPassed;
    }else if (textField != nil) {
        reenteredRight = checkPassed;
        return checkPassed;
    }
    
    
//    if (![passwordField.text isEqualToString:reEnterPasswordField.text]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Password re-entered wrong." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    }else if ([passwordField.text isEqualToString:@""] || [reEnterPasswordField.text isEqualToString:@""]){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Empty password not allowed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    }
    return checkPassed;
    
}

-(BOOL) checkEmailValidity:(NSString *)checkString
{
    BOOL stricterFilter = YES; 
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    stricterFilter = [emailTest evaluateWithObject:checkString];
    return stricterFilter;
}
#pragma data communicator delegates 

- (void) requestWillStart {
    [SVProgressHUD show];
}

- (void)didFinishWithSuccess:(id)responseObject{
    [SVProgressHUD dismiss];
    
    NSDictionary *dict = responseObject;
    NSString *message = [dict objectForKey:@"message"];
    NSString *emailHave = [dict objectForKey:@"emailAleardyHave"];
    NSString *statusCode = [dict objectForKey:@"status_code"];

    if ([statusCode intValue] == 200 ) {
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@",message]];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [delegate didSignUpSuccess:responseObject];
    }else if ([statusCode intValue] == 202) {
        if (emailHave != nil) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",emailHave]];
        }else if (message != nil){
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",message]];
        }

    }

}

- (void)didFinishWithError:(id)responseObject{
    [SVProgressHUD showErrorWithStatus:@"Error"];
}


#pragma mark textField delegates

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    if (textField == passwordField) {
        passwordField.text = @"";
        passwordField.layer.borderColor = [UIColor redColor].CGColor;
        passwordField.layer.borderWidth = 2.0f;
        passwordField.layer.cornerRadius = 5.0f;
        
    }
    if (textField == reEnterPasswordField) {
        reEnterPasswordField.text = @"";
        reEnterPasswordField.layer.borderColor = [UIColor redColor].CGColor;
        reEnterPasswordField.layer.borderWidth = 2.0f;
        reEnterPasswordField.layer.cornerRadius = 5.0f;
    }
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == passwordField) {
        [self checkPasswordValidity:textField lastChar:string];
    }
    if (textField == reEnterPasswordField) {
        [self checkPasswordEquality:textField lastChar:string];
    }
//    [self verifying];
    toClose = textField;
    
    return YES;

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self verifying];
    
    if (textField == firstNameField) {
        [lastNameField becomeFirstResponder];
    }else if (textField == lastNameField) {
        [emailField becomeFirstResponder];
    }else if (textField == emailField) {
        [passwordField becomeFirstResponder];
    }else if (textField == passwordField){
        [reEnterPasswordField becomeFirstResponder];
    }else if (textField == reEnterPasswordField) {
        [textField resignFirstResponder];
    }
    
    return YES;
}
//Text view
- (void)textFieldDidBeginEditing:(UITextView *)textView{
    [self.keyboardControls setActiveField:textView];
    [self animateTextField: textView up: YES];
}
- (void)textFieldDidEndEditing:(UITextView *)textView{
    [self animateTextField: textView up: NO];
}
- (void) animateTextField: (UIView*) view up: (BOOL) up
{
    
    int movementDistance = 0;//keyboardSize.width; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    if (view.frame.origin.y >= self.view.frame.size.height - 280 ) {
        movementDistance = view.frame.origin.y - (self.view.frame.size.height - 216) + view.frame.size.height + 40;
    }
    int movement = (up ? movementDistance  : - movedBy);
    if (up) {
        movedBy = movement;
    }
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    
    CGRect tmpRect = self.view.frame;
    tmpRect.origin.y -= movement;
    tmpRect.size.height = tmpRect.size.height + movement;
    self.view.frame = tmpRect;
    

    [UIView commitAnimations];

}



#pragma mark UI Creation methods

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

@end
