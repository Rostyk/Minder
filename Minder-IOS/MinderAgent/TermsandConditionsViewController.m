//
//  TermsandConditionsViewController.m
//  MinderAgent
//
//  Created by Garnik Ghazaryan on 5/30/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import "TermsandConditionsViewController.h"

#define iOSVersion7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)?TRUE:FALSE
#define iosVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#define topOffset (iOSVersion7) ? 64 : 0
#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE
@interface TermsandConditionsViewController ()

@end

@implementation TermsandConditionsViewController {

    UIWebView *webView;
}

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
    webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:webView];
    self.title = @"Terms & Conditions";
    if (!isiPhone5 || !iOSVersion7) {
        CGRect tmpRect = self.view.bounds;
        tmpRect.origin.y += 20;
        tmpRect.size.height = tmpRect.size.height - 20;
        self.view.bounds = tmpRect;
    }
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://minderweb.com/app/index.html#/contact-us"]];
    [webView loadRequest:request];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
