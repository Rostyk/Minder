//
//  ConnectedViewController.h
//  MinderAgent
//
//  Created by Garnik Ghazaryan on 5/22/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectedViewController : UIViewController <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *webID;
- (IBAction)disconnectPressed:(id)sender;

@end
