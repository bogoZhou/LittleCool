//
//  AlertView.m
//  AlertView
//
//  Created by 郝鹏飞 on 15/12/9.
//  Copyright © 2015年 郝鹏飞. All rights reserved.
//

#import "AlertView.h"
#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height
#define AUTOLAYTOU(a) ((a)*(kWidth/320))
#define WARN_WIDTH (self.frame.size.width-AUTOLAYTOU(120))

#define DEFAULT_SHOW_TIME 3
#define ONESEC_SHOW_TIME 1
#define TWOSEC_SHOW_TIME 2
@implementation AlertView {
    kAlertViewStyle style;
    UIView *_backView;
    UILabel *_titleLabel;
    NSTimer *_timer;
    NSInteger _showTime;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
   
    switch (style) {
        case kAlertViewStyleSuccess: {
            [self drawSuccessView];
            break;
        }
        case kAlertViewStyleFail: {
            [self drawFailView];
            break;
        }
        case kAlertViewStyleWarn: {
            [self drawWarnView];
            break;
        }
        default: {
            break;
        }
    }

}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.0f;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title target:(id<AlertViewDelegate>)delegate style:(kAlertViewStyle)kAlertViewStyle buttonsTitle:(NSArray *)titles {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(50, 50, kWidth - AUTOLAYTOU(100), kWidth - AUTOLAYTOU(140));
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.0f;
        self.clipsToBounds = YES;
        self.delegate = delegate;
        style = kAlertViewStyle;
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth ,kHeight)];
        _backView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:0.8];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, WARN_WIDTH + 16, self.frame.size.width-20, AUTOLAYTOU(20))];
        _titleLabel.textColor = [UIColor lightGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.text = title;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        for (int i = 0; i < titles.count; i ++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:titles[i] forState:UIControlStateNormal];
            button.frame = CGRectMake(i*self.frame.size.width/titles.count, WARN_WIDTH + 16 + AUTOLAYTOU(20) + 10, self.frame.size.width/titles.count, self.frame.size.height - (WARN_WIDTH + 16 + AUTOLAYTOU(20) + 10));
            button.tag = i + 1;
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
        
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, WARN_WIDTH + 16 + AUTOLAYTOU(20) + 9.5, self.frame.size.width, 0.5)];
        topLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:topLine];
        for (int i = 0; i < titles.count - 1 ; i ++) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake((i + 1)*self.frame.size.width/titles.count, WARN_WIDTH + 16 + AUTOLAYTOU(20) + 10, 0.5, self.frame.size.height - (WARN_WIDTH + 16 + AUTOLAYTOU(20) + 10))];
            line.backgroundColor = [UIColor lightGrayColor];
            [self addSubview:line];
        }
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title style:(kAlertViewStyle)kAlertViewStyle showTime:(kAlerViewShowTime)time {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(50, 50, kWidth - AUTOLAYTOU(100), kWidth - AUTOLAYTOU(180));
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.0f;
        self.clipsToBounds = YES;
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth ,kHeight)];
        _backView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:0.8];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, WARN_WIDTH + 16, self.frame.size.width-20, AUTOLAYTOU(20))];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.text = title;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        style = kAlertViewStyle;
        
        switch (time) {
            case kAlerViewShowTimeDefault: {
                _showTime = DEFAULT_SHOW_TIME;
                break;
            }
            case kAlerViewShowTimeOneSecond: {
                _showTime = ONESEC_SHOW_TIME;
                break;
            }
            case kAlerViewShowTimeTwoSeconds: {
                _showTime = TWOSEC_SHOW_TIME;
                break;
            }
            default: {
                break;
            }
        }
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
        [_timer fireDate];
    }
    return self;
}

- (void)timeChange {
    static int time = 0;
    if (time == _showTime) {
        [self removeFromSuperview];
        [_backView removeFromSuperview];
        _backView = nil;
        time = 0;
        [_timer invalidate];
        _timer = nil;
    }
    time ++;
}

- (void)drawSuccessView {
     UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake((self.frame.size.width-WARN_WIDTH)/2, 8, WARN_WIDTH, WARN_WIDTH) cornerRadius:WARN_WIDTH/2];
    [path moveToPoint:CGPointMake((self.frame.size.width-WARN_WIDTH)/2+10, WARN_WIDTH/2)];
    [path addLineToPoint:CGPointMake(self.frame.size.width/2.0-10, WARN_WIDTH-20)];
    [path addLineToPoint:CGPointMake(self.frame.size.width/2.0 + WARN_WIDTH/2-15, AUTOLAYTOU(35))];
    
    [self setDrawAnimationWithPath:path StrokeColor:[UIColor colorWithRed:13/255.0 green:150/255.0 blue:1/255.0 alpha:1]];
}

- (void)drawFailView {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake((self.frame.size.width-WARN_WIDTH)/2, 8, WARN_WIDTH, WARN_WIDTH) cornerRadius:WARN_WIDTH/2];
    [path moveToPoint:CGPointMake((self.frame.size.width-WARN_WIDTH)/2+AUTOLAYTOU(20), AUTOLAYTOU(25))];
    [path addLineToPoint:CGPointMake(self.frame.size.width/2.0 + WARN_WIDTH/2-AUTOLAYTOU(20), WARN_WIDTH-AUTOLAYTOU(15)+AUTOLAYTOU(3))];
    
    [path moveToPoint:CGPointMake(self.frame.size.width/2.0 + WARN_WIDTH/2-AUTOLAYTOU(20), AUTOLAYTOU(25))];
    [path addLineToPoint:CGPointMake((self.frame.size.width-WARN_WIDTH)/2+AUTOLAYTOU(20), WARN_WIDTH-AUTOLAYTOU(15)+AUTOLAYTOU(3))];
    
   [self setDrawAnimationWithPath:path StrokeColor:[UIColor redColor]];
}

- (void)drawWarnView {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake((self.frame.size.width-WARN_WIDTH)/2, 8, WARN_WIDTH, WARN_WIDTH) cornerRadius:WARN_WIDTH/2];
    [path moveToPoint:CGPointMake(self.frame.size.width/2.0, AUTOLAYTOU(15))];
    [path addLineToPoint:CGPointMake(self.frame.size.width/2.0, WARN_WIDTH-AUTOLAYTOU(20))];
    
    [path moveToPoint:CGPointMake(self.frame.size.width/2.0, WARN_WIDTH-AUTOLAYTOU(15))];
    [path addLineToPoint:CGPointMake(self.frame.size.width/2.0, WARN_WIDTH-AUTOLAYTOU(8))];
    [self setDrawAnimationWithPath:path StrokeColor:[UIColor colorWithRed:230/255.0 green:180/255.0 blue:1/255.0 alpha:1]];
    
}

- (void)setDrawAnimationWithPath:(UIBezierPath *)path StrokeColor:(UIColor *)strokeColor {
    CAShapeLayer *lineLayer = [ CAShapeLayer layer];
    
    lineLayer. frame = CGRectZero;
    
    lineLayer. fillColor = [ UIColor clearColor ]. CGColor ;
    
    lineLayer. path = path. CGPath ;
    
    lineLayer. strokeColor = strokeColor. CGColor ;
    lineLayer.lineWidth = 5;
    lineLayer.cornerRadius = 5;
    
    CABasicAnimation *ani = [ CABasicAnimation animationWithKeyPath : NSStringFromSelector ( @selector (strokeEnd))];
    
    ani. fromValue = @0 ;
    
    ani. toValue = @1 ;
    
    ani. duration = 0.5 ;
    
    
    [lineLayer addAnimation :ani forKey : NSStringFromSelector ( @selector (strokeEnd))];
    
    [self.layer addSublayer :lineLayer];
}

- (void)showInView:(UIView *)superView {
    
    [self setPopAnimation];
    [superView addSubview:_backView];
    [_backView addSubview:self];
    self.center = _backView.center;
}

- (void)buttonClicked:(UIButton *)sender {
    if (_delegate) {
        [_delegate alertView:self clickedButtonAtIndex:sender.tag - 1];
    }
    [self removeFromSuperview];
    [_backView removeFromSuperview];
    _backView = nil;
}

- (void)setPopAnimation {
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:
                                      kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.layer addAnimation:popAnimation forKey:nil];
}
@end
