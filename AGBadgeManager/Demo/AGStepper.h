//
//  AGStepper.h
//  AGBadgeManager
//
//  Created by JohnnyB0Y on 2018/11/30.
//  Copyright © 2018 JohnnyB0Y. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AGStepper : UIStepper

/** left */
@property (nonatomic, strong, readonly) UIButton *leftBtn;

/** right */
@property (nonatomic, strong, readonly) UIButton *rightBtn;

- (void)addLeftBtnTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)addRightBtnTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end

NS_ASSUME_NONNULL_END
