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

typedef NS_ENUM(NSInteger, AnimationDirection) {
  Positive = 1,
  Negative = -1
};

//Delay utility
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

#pragma mark - Generate Data

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

#pragma mark - View Life Cycle

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
  
  [self changeFlightDataTo:_flightDatas[0] animated:NO];
  
}

- (void)changeFlightDataTo:(FlightData*)data animated:(BOOL)animated{
  
  // populate the UI with the next flight's data
  self.summaryLabel.text = data.summary;
  
  AnimationDirection direction = data.isTakingOff ? Positive : Negative;
  [self cubeTransition:self.flightNr text:data.flightNr direction:direction];
  [self cubeTransition:self.gateNr text:data.gateNr direction:direction];
  
  self.departingFrom.text = data.departingFrom;
  self.arrivingTo.text = data.arrivingTo;
  self.flightStatus.text = data.flightStatus;
  if (animated) {
    [self fadeImageView:self.bgImageView toImage:[UIImage imageNamed:data.weatherImageName] showEffects:data.showWeatherEffects];
  }else{
    self.bgImageView.image = [UIImage imageNamed:data.weatherImageName];
    _snowView.hidden = !data.showWeatherEffects;
    self.flightNr.text = data.flightNr;
    self.gateNr.text = data.gateNr;
  }

  // schedule next flight
  delay(3.0f, ^{
    [self changeFlightDataTo:data.isTakingOff ? _flightDatas[1] : _flightDatas[0] animated:YES];
  });
}

#pragma mark - Animation

- (void)fadeImageView:(UIImageView*)imageView
              toImage:(UIImage*)toImage
          showEffects:(BOOL)showEffects{
  [UIView transitionWithView:imageView
                    duration:1.0f
                     options:UIViewAnimationOptionTransitionCrossDissolve
                  animations:^{
                    imageView.image = toImage;
                  } completion:nil];
  [UIView animateWithDuration:1.0f
                        delay:0.0f
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     _snowView.alpha = showEffects ? 1.0f : 0.0f;
                   } completion:nil];
}

- (void)cubeTransition:(UILabel*)label
                  text:(NSString*)text
             direction:(AnimationDirection)direction{
  //Create auxlabel with new text and copy properties of existing label
  UILabel *auxLabel = [[UILabel alloc] initWithFrame:label.frame];
  auxLabel.text = text;
  auxLabel.font = label.font;
  auxLabel.textAlignment = label.textAlignment;
  auxLabel.textColor = label.textColor;
  auxLabel.backgroundColor = [UIColor clearColor];
  
  //Transform auxlabel and add it to same hireachy with existing label
  CGFloat auxLabelOffset = direction * label.frame.size.height / 2.0f;
  auxLabel.transform = CGAffineTransformConcat( CGAffineTransformMakeScale(1.0f, 0.1f),
                                               CGAffineTransformMakeTranslation(0.0f, auxLabelOffset));
  [label.superview addSubview:auxLabel];
  
  
  [UIView animateWithDuration:0.5f
                        delay:0.0f
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     auxLabel.transform = CGAffineTransformIdentity;
                     label.transform = CGAffineTransformConcat( CGAffineTransformMakeScale(1.0f, 0.1f),
                                                               CGAffineTransformMakeTranslation(0.0f, -auxLabelOffset));
                     
                   }
                   completion:^(BOOL finished) {
                     label.text = auxLabel.text;
                     label.transform = CGAffineTransformIdentity;
                     [auxLabel removeFromSuperview];
                   }];

}

@end
