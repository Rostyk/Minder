//
//  Config.h
//  MinderAgent
//
//  Created by Ross on 12/20/14.
//  Copyright (c) 2014 Garnik Ghazaryan. All rights reserved.
//

#ifndef MinderAgent_Config_h
#define MinderAgent_Config_h

/*  Numbef of seconds location manager will last to receive locations update from the device. So basically, its the time location Manager is turned on durin the LOCATION_TRACKING_SERVICE_CALL_TO_PREVENT_SUSPENSION_FREQUENCY period*/
#define OBTAIN_LOCATION_TIME                                            10


/* the frequency of location tracking calls to prevent the app (being in background) to get suspended */
#define LOCATION_TRACKING_SERVICE_CALL_TO_PREVENT_SUSPENSION_FREQUENCY  60

#endif
