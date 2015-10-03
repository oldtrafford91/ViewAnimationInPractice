//
//  SnowView.m
//  ViewAnimationInPractice
//
//  Created by Tran Tuan Hai on 10/3/15.
//  Copyright (c) 2015 Tran Tuan Hai. All rights reserved.
//

#import "SnowView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SnowView

- (instancetype)initWithFrame:(CGRect)frame{
  if(self == [super initWithFrame:frame]){
    CAEmitterLayer *emitterLayer = (CAEmitterLayer*)[self layer];
    emitterLayer.emitterPosition = CGPointMake(self.bounds.size.width / 2, 0);
    emitterLayer.emitterSize = self.bounds.size;
    emitterLayer.emitterShape = kCAEmitterLayerRectangle;
    
    CAEmitterCell *emitterCell = [CAEmitterCell new];
    emitterCell.contents = (__bridge id)([UIImage imageNamed:@"flake"].CGImage);
    emitterCell.birthRate = 200;
    emitterCell.lifetime = 3.5;
    emitterCell.color = [UIColor whiteColor].CGColor;
    emitterCell.redRange = 0.0;
    emitterCell.blueRange = 0.1;
    emitterCell.greenRange = 0.0;
    emitterCell.velocity = 10;
    emitterCell.velocityRange = 350;
    emitterCell.emissionRange = M_PI_2;
    emitterCell.emissionLongitude = -M_PI;
    emitterCell.yAcceleration = 70;
    emitterCell.xAcceleration = 0;
    emitterCell.scale = 0.33;
    emitterCell.scaleRange = 1.25;
    emitterCell.scaleSpeed = -0.25;
    emitterCell.alphaRange = 0.5;
    emitterCell.alphaSpeed = -0.15;
    
    emitterLayer.emitterCells = @[emitterCell];
    
  }
  return self;
}

+ (Class)layerClass{
  return [CAEmitterLayer class];
}

@end
