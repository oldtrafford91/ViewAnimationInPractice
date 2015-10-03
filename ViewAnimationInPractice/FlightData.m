//
//  FlightData.m
//  ViewAnimationInPractice
//
//  Created by Tran Tuan Hai on 10/3/15.
//  Copyright (c) 2015 Tran Tuan Hai. All rights reserved.
//

#import "FlightData.h"

@implementation FlightData

-(instancetype)initWithSummary:(NSString *)summary
                      flightNr:(NSString *)flightNr
                        gateNr:(NSString *)gateNr
                 departingFrom:(NSString *)departingFrom
                    arrivingTo:(NSString *)arrivingTo
              weatherImageName:(NSString *)weatherImageName
                  flightStatus:(NSString *)flightStatus
            showWeatherEffects:(BOOL)showWeatherEffects
                   isTakingOff:(BOOL)isTakingOff
{
  if (self = [super init]) {
    _summary = summary;
    _flightNr = flightNr;
    _gateNr = gateNr;
    _departingFrom = departingFrom;
    _arrivingTo = arrivingTo;
    _weatherImageName = weatherImageName;
    _flightStatus = flightStatus;
    _showWeatherEffects = showWeatherEffects;
    _isTakingOff = isTakingOff;
  }
  return self;
}

@end
