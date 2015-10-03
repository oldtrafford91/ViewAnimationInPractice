//
//  FlightData.h
//  ViewAnimationInPractice
//
//  Created by Tran Tuan Hai on 10/3/15.
//  Copyright (c) 2015 Tran Tuan Hai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlightData : NSObject

@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *flightNr;
@property (nonatomic, copy) NSString *gateNr;
@property (nonatomic, copy) NSString *departingFrom;
@property (nonatomic, copy) NSString *arrivingTo;
@property (nonatomic, copy) NSString *weatherImageName;
@property (nonatomic, copy) NSString *flightStatus;
@property (nonatomic, assign) BOOL showWeatherEffects;
@property (nonatomic, assign) BOOL isTakingOff;

- (instancetype)initWithSummary:(NSString*)summary
                       flightNr:(NSString*)flightNr
                         gateNr:(NSString*)gateNr
                  departingFrom:(NSString*)departingFrom
                     arrivingTo:(NSString*)arrivingTo
               weatherImageName:(NSString*)weatherImageName
                   flightStatus:(NSString*)flightStatus
             showWeatherEffects:(BOOL)showWeatherEffects
                    isTakingOff:(BOOL)isTakingOff;

@end
