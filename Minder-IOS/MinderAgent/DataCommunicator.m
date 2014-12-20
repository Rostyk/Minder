//
//  DataCommunicator.m
//  MinderAgent
//
//  Created by Garnik Ghazaryan on 5/28/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import "DataCommunicator.h"
#import <AFNetworking/AFNetworking.h>


#define SERVER_URL @"http://minderweb.com/user"

NSString *_urlString;
@implementation DataCommunicator {

}


@synthesize delegate;


- (id)initWithURL:(NSString *) urlString
{
    self = [super init];
    if (self) {
        _urlString = urlString;
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    return self;
}
- (BOOL) networkIsReachable{
    BOOL reachable = FALSE;
    reachable = [AFNetworkReachabilityManager sharedManager].reachable;
    return reachable;
}
+ (void) sendJSONDict:(NSDictionary*) jsonDict withURL:(NSString*) URLString{

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
   [manager POST:URLString parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (void) sendJSONDict:(NSDictionary*) jsonDict withURL:(NSString*) URLString{
    
    [delegate requestWillStart];
    
    if (URLString == nil || [@"" isEqualToString:URLString]) {
        URLString = _urlString;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:URLString parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [delegate didFinishWithSuccess:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [delegate didFinishWithError:error];
    }];
    
}
@end
