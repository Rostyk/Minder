//
//  ConnectedViewController.m
//  MinderAgent
//
//  Created by Garnik Ghazaryan on 5/22/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import "ConnectedViewController.h"
#import "FTLocationManager.h"
#import "Utils.h"

#define iOSVersion7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)?TRUE:FALSE
#define iosVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#define topOffset (iOSVersion7) ? 64 : 0
#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE
@interface ConnectedViewController ()

@end

@implementation ConnectedViewController {

    UIAlertView *disconnectAlert;
}
@synthesize webID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Minder Native";

    int navBarHeight;
    if (iOSVersion7) {
        navBarHeight = 64;
    }else{
        navBarHeight = 44;
    }
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, navBarHeight)];
    UINavigationItem* item = [[UINavigationItem alloc] initWithTitle:@"Minder Native"];
    
    UILabel *navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 40)];
    navTitleLabel.text = @"Minder Native";
    navTitleLabel.font = [UIFont systemFontOfSize:20];
    navTitleLabel.textAlignment = NSTextAlignmentCenter;
    navTitleLabel.backgroundColor = [UIColor clearColor];
    item.titleView = navTitleLabel;
    
    [navBar pushNavigationItem:item animated:YES];
    [self.view addSubview:navBar];
    
    NSString *UUID = [Utils getUUIDString];//[SecureUDID UDIDForDomain:@"com.parttwoconsulting.minderWebId" usingKey:@"parttwominderwebapp"];
    webID.text = UUID;
//    webID.font = [UIFont systemFontOfSize:11];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)disconnectPressed:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
    disconnectAlert = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"Do you really want to disconnect?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [disconnectAlert show];
}

#pragma mark AlertView delegates

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (alertView == disconnectAlert) {
        if (buttonIndex == 1) {

            [self dismissViewControllerAnimated:YES completion:^{
                NSUserDefaults *userDefs = [NSUserDefaults standardUserDefaults];
                [userDefs removeObjectForKey:@"connected"];
                [userDefs synchronize];
            }];
        }
    }
}

@end
