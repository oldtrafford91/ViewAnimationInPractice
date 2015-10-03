//
//  ViewController.m
//  ViewAnimationInPractice
//
//  Created by Tran Tuan Hai on 10/3/15.
//  Copyright (c) 2015 Tran Tuan Hai. All rights reserved.
//

#import "ViewController.h"
#import "SnowView.h"
#import "FlightData.h"

void delay(double seconds, dispatch_block_t completion) {
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC));
  
  dispatch_after(popTime, dispatch_get_main_queue(), ^{
    completion();
  });
}

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *summaryIcon;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

@property (weak, nonatomic) IBOutlet UILabel *flightNr;
@property (weak, nonatomic) IBOutlet UILabel *gateNr;
@property (weak, nonatomic) IBOutlet UILabel *departingFrom;
@property (weak, nonatomic) IBOutlet UILabel *arrivingTo;

@property (weak, nonatomic) IBOutlet UIImageView *planImageView;
@property (weak, nonatomic) IBOutlet UIImageView *statusBanner;
@property (weak, nonatomic) IBOutlet UILabel *flightStatus;

@end

@implementation ViewController{
  SnowView *_snowView;
  NSArray *_flightDatas;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _flightDatas = [self generateFlightDatas];
  
  //Adjust UI
  [self.summaryLabel addSubview:self.summaryIcon];
  self.summaryIcon.center = ({
    CGPoint center = self.summaryIcon.center;
    center.y = self.summaryLabel.bounds.size.height / 2;
    center;
  });
  
  //Add the snow effect layer
  _snowView = [[SnowView alloc] initWithFrame:CGRectMake(-150.0f, -100.0f, 300.0f, 50.0f)];
  UIView *snowClipView = [[UIView alloc] initWithFrame:CGRectOffset(self.view.frame, 0, 50)];
  snowClipView.clipsToBounds = YES;
  [snowClipView addSubview:_snowView];
  [self.view addSubview:snowClipView];
  
  [self changeFlightDataTo:_flightDatas[0]];
  
}

- (void)changeFlightDataTo:(FlightData*)data {
  
  // populate the UI with the next flight's data
  self.summaryLabel.text = data.summary;
  self.flightNr.text = data.flightNr;
  self.gateNr.text = data.gateNr;
  self.departingFrom.text = data.departingFrom;
  self.arrivingTo.text = data.arrivingTo;
  self.flightStatus.text = data.flightStatus;
  self.bgImageView.image = [UIImage imageNamed:data.weatherImageName];
  _snowView.hidden = !data.showWeatherEffects;
  
  // schedule next flight
  delay(3.0f, ^{
    [self changeFlightDataTo:data.isTakingOff? _flightDatas[1] : _flightDatas[0]];
  });
}

- (NSArray*)generateFlightDatas{
  
  FlightData *londonToParis = [[FlightData alloc] initWithSummary:@"01 Apr 2015 09:42"
                                                         flightNr:@"ZY 2014"
                                                           gateNr:@"T1 A33"
                                                    departingFrom:@"LGW"
                                                       arrivingTo:@"CDG"
                                                 weatherImageName:@"bg-snowy"
                                                     flightStatus:@"Boarding"
                                               showWeatherEffects:YES
                                                      isTakingOff:YES];
  FlightData *parisToRome = [[FlightData alloc] initWithSummary:@"01 Apr 2015 17:05"
                                                         flightNr:@"AE 1107"
                                                           gateNr:@"045"
                                                    departingFrom:@"CDG"
                                                       arrivingTo:@"FCO"
                                                 weatherImageName:@"bg-sunny"
                                                     flightStatus:@"Delayed"
                                               showWeatherEffects:NO
                                                      isTakingOff:NO];
  return @[londonToParis,parisToRome];
}


@end
