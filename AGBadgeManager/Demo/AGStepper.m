//
//  AGStepper.m
//  AGBadgeManager
//
//  Created by JohnnyB0Y on 2018/11/30.
//  Copyright © 2018 JohnnyB0Y. All rights reserved.
//

#import "AGStepper.h"


@interface AGStepper ()

/** left */
@property (nonatomic, strong, readwrite) UIButton *leftBtn;

/** right */
@property (nonatomic, strong, readwrite) UIButton *rightBtn;

@end

@implementation AGStepper

- (void)addLeftBtnTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self disabledUIStepperButton];
    [self.leftBtn addTarget:target action:action forControlEvents:controlEvents];
}

- (void)addRightBtnTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self disabledUIStepperButton];
    [self.rightBtn addTarget:target action:action forControlEvents:controlEvents];
}

- (void) disabledUIStepperButton
{
    for ( UIView *view in self.subviews ) {
        if ( [view isKindOfClass:NSClassFromString(@"_UIStepperButton")] ) {
            view.userInteractionEnabled = NO;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat btnW = self.bounds.size.width * 0.5;
    CGFloat btnH = self.bounds.size.height;
    
    self.leftBtn.frame = CGRectMake(0, 0, btnW, btnH);
    self.rightBtn.frame = CGRectMake(btnW, 0, btnW, btnH);
}

#pragma mark - ----------- Getter Methods ----------
- (UIButton *)leftBtn
{
    if (_leftBtn == nil) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_leftBtn];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn
{
    if (_rightBtn == nil) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_rightBtn];
    }
    return _rightBtn;
}

@end
