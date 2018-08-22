//
//  LYAnimationBtn.m
//  LYAnimationButton
//
//  Created by Lee on 2018/8/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LYAnimationBtn.h"

#define SWidth [UIScreen mainScreen].bounds.size.width
#define SHeight [UIScreen mainScreen].bounds.size.height

@interface LYAnimationBtn()

@property(nonatomic,strong)UIView *HView;//蒙板View
@property(nonatomic,strong)UIView *AmView;//动画View
@property (nonatomic,strong) CAShapeLayer *shapeLayer;//转圈白线layer

@end

@implementation LYAnimationBtn

+ (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title{
    
    return [[self alloc] initWithFrame:frame title:title];
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUIWithTitle:title];
    }
    return self;
}

- (void)setupUIWithTitle:(NSString *)title{
    
    self.backgroundColor = UIColor.redColor;
    self.layer.cornerRadius = 5;
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)btnClick{
    
    //HView，盖住view，以屏蔽掉点击事件
    self.HView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SWidth, SHeight)];
    [[UIApplication sharedApplication].keyWindow addSubview:self.HView];
    self.HView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    
    //执行登录按钮转圈动画的view
    self.AmView = [[UIView alloc] initWithFrame:self.frame];
    self.AmView.layer.cornerRadius = 5;
    self.AmView.layer.masksToBounds = YES;
    self.AmView.frame = self.frame;
    self.AmView.backgroundColor = self.backgroundColor;
    [self.superview addSubview:self.AmView];
    self.hidden = YES;
    
    //把view从宽的样子变圆
    CGPoint centerPoint = self.AmView.center;
    CGFloat radius = MIN(self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.AmView.frame = CGRectMake(0, 0, radius, radius);
        self.AmView.center = centerPoint;
        self.AmView.layer.cornerRadius = radius/2;
        self.AmView.layer.masksToBounds = YES;
        
    }completion:^(BOOL finished) {
        
        //不封闭的白色曲线
        UIBezierPath* path = [[UIBezierPath alloc] init];
        [path addArcWithCenter:CGPointMake(radius/2, radius/2) radius:(radius/2 - 5) startAngle:0 endAngle:M_PI_2 * 2 clockwise:YES];
        self.shapeLayer = [[CAShapeLayer alloc] init];
        self.shapeLayer.lineWidth = 1.5;
        self.shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        self.shapeLayer.fillColor = self.backgroundColor.CGColor;
        self.shapeLayer.frame = CGRectMake(0, 0, radius, radius);
        self.shapeLayer.path = path.CGPath;
        [self.AmView.layer addSublayer:self.shapeLayer];
        
        //转圈
        CABasicAnimation* baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        baseAnimation.duration = 0.4;
        baseAnimation.fromValue = @(0);
        baseAnimation.toValue = @(2 * M_PI);
        baseAnimation.repeatCount = MAXFLOAT;
        [self.AmView.layer addAnimation:baseAnimation forKey:nil];
        
        __weak typeof(self)weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            !weakSelf.btnClickBlock ? : weakSelf.btnClickBlock();
        });
    }];
}

-(void)dismissView{
    
    self.hidden = NO;
    [self.HView removeFromSuperview];
    [self.AmView removeFromSuperview];
    [self.AmView.layer removeAllAnimations];
}

-(void)failAction{
    
    //左右摇摆动画
    CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGPoint point = self.AmView.layer.position;
    keyFrame.values = @[[NSValue valueWithCGPoint:CGPointMake(point.x, point.y)],
                        [NSValue valueWithCGPoint:CGPointMake(point.x - 15, point.y)],
                        [NSValue valueWithCGPoint:CGPointMake(point.x + 15, point.y)],
                        [NSValue valueWithCGPoint:CGPointMake(point.x - 15, point.y)],
                        [NSValue valueWithCGPoint:CGPointMake(point.x + 15, point.y)],
                        [NSValue valueWithCGPoint:CGPointMake(point.x - 15, point.y)],
                        [NSValue valueWithCGPoint:CGPointMake(point.x + 15, point.y)],
                        [NSValue valueWithCGPoint:point]];
    keyFrame.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    keyFrame.duration = 0.5f;
    [self.layer addAnimation:keyFrame forKey:keyFrame.keyPath];
}


@end
