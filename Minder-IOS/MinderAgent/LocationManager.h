//
//  LocationManager.h
//  MinderAgent
//
//  Created by Garnik Ghazaryan on 5/22/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@protocol LocationManagerDelegate <NSObject>

@optional - (void) locationDidUpdateToLocation:(float)latitude longitude:(float)longitude;
@optional - (void) locationDidFailToUpdateWithError:(NSError*)error;

@end

@interface LocationManager : NSObject <CLLocationManagerDelegate>{

    CLLocationManager *clLocationManager;
}
+ (BOOL) locationServicesEnabled;
- (void) updateLocation;
- (void) stopUptadingLocation;
+ (LocationManager *) sharedManager;

@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic, assign) id  delegate;

@end
