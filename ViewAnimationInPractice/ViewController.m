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
  if (animated) {
    AnimationDirection direction = data.isTakingOff ? Positive : Negative;
    
    [self fadeImageView:self.bgImageView toImage:[UIImage imageNamed:data.weatherImageName] showEffects:data.showWeatherEffects];
    
    [self cubeTransition:self.flightNr text:data.flightNr direction:direction];
    [self cubeTransition:self.gateNr text:data.gateNr direction:direction];
    
    CGPoint departingFromOffset = CGPointMake(direction * 80, 0.0);
    [self fadeAndBounce:self.departingFrom text:data.departingFrom offset:departingFromOffset];
    CGPoint arrivingToOffset = CGPointMake(0.0, direction * 50);
    [self fadeAndBounce:self.arrivingTo text:data.arrivingTo offset:arrivingToOffset];
    
    [self cubeTransition:self.flightStatus text:data.flightStatus direction:direction];
    [self planDepart];
    [self switchSummaryLabelTo:data.summary];
  }else{
    self.summaryLabel.text = data.summary;
    self.bgImageView.image = [UIImage imageNamed:data.weatherImageName];
    _snowView.hidden = !data.showWeatherEffects;
    self.flightNr.text = data.flightNr;
    self.gateNr.text = data.gateNr;
    self.departingFrom.text = data.departingFrom;
    self.arrivingTo.text = data.arrivingTo;
    self.flightStatus.text = data.flightStatus;
    self.summaryLabel.text = data.summary;
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
  
  // Animate label and auxLabel
  [UIView animateWithDuration:0.5f
                        delay:0.0f
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     auxLabel.transform = CGAffineTransformIdentity;
                     label.transform = CGAffineTransformConcat( CGAffineTransformMakeScale(1.0f, 0.1f),
                                                               CGAffineTransformMakeTranslation(0.0f, -auxLabelOffset));
                     
                   }
                   completion:^(BOOL finished) {
                     //Clean up
                     label.text = auxLabel.text;
                     label.transform = CGAffineTransformIdentity;
                     [auxLabel removeFromSuperview];
                   }];

}

- (void)fadeAndBounce:(UILabel*)label
                 text:(NSString*)text
               offset:(CGPoint)offset{

  //Create auxlabel with new text and copy properties of existing label
  UILabel *auxLabel = [[UILabel alloc] initWithFrame:label.frame];
  auxLabel.text = text;
  auxLabel.font = label.font;
  auxLabel.textAlignment = label.textAlignment;
  auxLabel.textColor = label.textColor;
  auxLabel.backgroundColor = [UIColor clearColor];
  
  //Transform auxlabel and add it to same hireachy with existing label
  auxLabel.transform = CGAffineTransformMakeTranslation(offset.x, offset.y);
  auxLabel.alpha = 0;
  [label.superview addSubview:auxLabel];
  
  //Animate label and auxLabel
  [UIView animateWithDuration:0.5f
                        delay:0.0f
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     label.transform = CGAffineTransformMakeTranslation(offset.x, offset.y);
                     label.alpha = 0.0f;
                     }completion:nil];
  [UIView animateWithDuration:0.25f
                        delay:0.25f
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     auxLabel.alpha = 1.0f;
                     auxLabel.transform = CGAffineTransformIdentity;
                   }completion:^(BOOL isFinished){
                     //Clean up
                     [auxLabel removeFromSuperview];
                     label.text = text;
                     label.alpha = 1.0f;
                     label.transform = CGAffineTransformIdentity;
                   }];
}

- (void)planDepart{
  CGPoint originalPlanCenter = self.planImageView.center;
  [UIView animateKeyframesWithDuration:1.5f delay:0.0f options:0 animations:^{
    [UIView addKeyframeWithRelativeStartTime:0.0f
                            relativeDuration:0.25f
                                  animations:^{
                                    self.planImageView.center = ({
                                      CGPoint center = self.planImageView.center;
                                      center.x += 80.0f;
                                      center.y -= 10.0f;
                                      center;
                                    });
                                  }];
    [UIView addKeyframeWithRelativeStartTime:0.1f
                            relativeDuration:0.4f
                                  animations:^{
                                    self.planImageView.transform = CGAffineTransformMakeRotation(-M_PI_4/2);
                                  }];
    [UIView addKeyframeWithRelativeStartTime:0.25f
                            relativeDuration:0.25f
                                  animations:^{
                                    self.planImageView.center = ({
                                      CGPoint center = self.planImageView.center;
                                      center.x += 100.0f;
                                      center.y -= 50.0f;
                                      center;
                                    });
                                    self.planImageView.alpha = 0.0f;
                                  }];
    [UIView addKeyframeWithRelativeStartTime:0.51f
                            relativeDuration:0.01f
                                  animations:^{
                                    self.planImageView.transform = CGAffineTransformIdentity;
                                    self.planImageView.center = CGPointMake(0.0f, originalPlanCenter.y);
                                  }];
    [UIView addKeyframeWithRelativeStartTime:0.55f
                            relativeDuration:0.45f
                                  animations:^{
                                    self.planImageView.alpha = 1.0f;
                                    self.planImageView.center = originalPlanCenter;
                                  }];
    
  } completion:nil];
}

- (void)switchSummaryLabelTo:(NSString*)summaryText{
  [UIView animateKeyframesWithDuration:1.0f delay:0.0f options:0 animations:^{
    [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.45f animations:^{
      self.summaryLabel.center = ({
        CGPoint center = self.summaryLabel.center;
        center.y -= 100.0f;
        center;
      });
    }];
    [UIView addKeyframeWithRelativeStartTime:0.5f relativeDuration:0.45f animations:^{
      self.summaryLabel.center = ({
        CGPoint center = self.summaryLabel.center;
        center.y += 100.0f;
        center;
      });
    }];
  } completion:nil];
  
  delay(0.5f, ^{
    self.summaryLabel.text = summaryText;
  });
}

@end
