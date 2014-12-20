//
//  LocationManager.m
//  MinderAgent
//
//  Created by Garnik Ghazaryan on 5/22/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#import "LocationManager.h"

static dispatch_once_t predicate;
static LocationManager *locationManager;
#define iosVersion [[[UIDevice currentDevice] systemVersion] floatValue]
@implementation LocationManager {
    BOOL didFindLocation;
}

@synthesize latitude,longitude;
@synthesize delegate;

+ (LocationManager *) sharedManager{
    
    dispatch_once(&predicate, ^{
        
        locationManager = [[LocationManager alloc] init];
        
    });
    
    return locationManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        clLocationManager = [[CLLocationManager alloc] init];
        clLocationManager.delegate = self;
        clLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        clLocationManager.distanceFilter = kCLDistanceFilterNone;
        if (iosVersion > 8.0) {
            BOOL hasAlwaysKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"] != nil;
            BOOL hasWhenInUseKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"] != nil;
            if (hasAlwaysKey) {
                [clLocationManager requestAlwaysAuthorization];
            } else if (hasWhenInUseKey) {
                [clLocationManager requestWhenInUseAuthorization];
            } else {
                // At least one of the keys NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription MUST be present in the Info.plist file to use location services on iOS 8+.
                NSAssert(hasAlwaysKey || hasWhenInUseKey, @"To use location services in iOS 8+, your Info.plist must provide a value for either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription.");
            }
            if ([clLocationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [clLocationManager requestAlwaysAuthorization];
                [clLocationManager requestWhenInUseAuthorization];
            }
            
        }
        [clLocationManager startUpdatingLocation];
//        clLocationManager.pausesLocationUpdatesAutomatically = YES;
    }
    return self;
}
+ (BOOL) locationServicesEnabled{

    BOOL enabled = FALSE;
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied){
        enabled = TRUE;
    }
    return enabled;
}
- (void) updateLocation {
    [clLocationManager stopUpdatingLocation];
    sleep(0.2);
    didFindLocation = NO;
    [clLocationManager startUpdatingLocation];
}


- (void) stopUptadingLocation{
    [clLocationManager stopUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
//    NSLog(@"didFailWithError: %@", error);
    [delegate locationDidFailToUpdateWithError:error];
//    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [errorAlert show];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"didUpdateToLocation: %@", [locations lastObject]);
    CLLocation *currentLocation = [locations lastObject];
    
    if (currentLocation != nil) {
        longitude = currentLocation.coordinate.longitude;
        latitude = currentLocation.coordinate.latitude;
        [delegate locationDidUpdateToLocation:latitude longitude:longitude];
        [clLocationManager stopUpdatingLocation];
    }
}

@end
