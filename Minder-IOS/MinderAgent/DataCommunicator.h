//
//  DataCommunicator.h
//  MinderAgent
//
//  Created by Garnik Ghazaryan on 5/28/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataCommunicatorDelegate <NSObject>

@optional - (void) didFinishWithSuccess:(id) responseObject;
@optional - (void) didFinishWithError:(id) responseObject;
@optional - (void) requestWillStart;

@end

@interface DataCommunicator : NSObject


- (BOOL) networkIsReachable;

+ (void) sendJSONDict:(NSDictionary*) jsonDict withURL:(NSString*) URLString;

- (void) sendJSONDict:(NSDictionary*) jsonDict withURL:(NSString*) URLString;

- (id)initWithURL:(NSString *) urlString;

@property (nonatomic, assign) id  delegate;
@end
