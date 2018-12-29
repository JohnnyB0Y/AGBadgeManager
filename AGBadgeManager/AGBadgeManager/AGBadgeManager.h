//
//  AGBadgeManager.h
//  AGBadgeManager
//
//  Created by JohnnyB0Y on 2017/5/26.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  提示标记管理者

#import <Foundation/Foundation.h>

@protocol AGBadgeManagerDelegate, AGBadgePersistentDelegate;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AGBadgeManagerChangeMode) {
    AGBadgeManagerChangeModeNone = 0,
    AGBadgeManagerChangeModePlus,
    AGBadgeManagerChangeModeMinus,
};

@interface AGBadgeManager : NSObject

#pragma mark - 获取数值
@property (nonatomic, assign, readonly) NSInteger badge;
@property (nonatomic, copy, readonly) NSNumber *numberBadge;
@property (nonatomic, copy, readonly) NSString *stringBadge;

#pragma mark - 对数值进行加减操作
/** 标记加一 */
- (NSInteger) ag_plus;

/** 标记减一 */
- (NSInteger) ag_minus;

/** 减去指定标记数 */
- (NSInteger) ag_minusBadge:(NSInteger)badge;

/** 标记清零 */
- (void) ag_clearAllBadge;


#pragma mark - 直接赋值或更新
/** 直接设置badge的值 */
- (void) ag_resetBadge:(NSInteger)badge;

/** 让Observer 再接收一次 badgeManagerDidChange:current:mode:forType: 通知。 */
- (void) ag_resendBadgeChangeNotification;

#pragma mark - 注册、移除观察者
/** 添加对应类型的观察者 */
- (void) ag_registerObserver:(id<AGBadgeManagerDelegate>)observer;

/** 移除对应类型的观察者 */
- (void) ag_removeObserver:(id<AGBadgeManagerDelegate>)observer;

#pragma mark - 可在子类重写
/** 返回标记类型字符串 */
- (NSString *) ag_typeOfBadge;

/** 是否本类型？ */
- (BOOL) ag_isEqualToType:(NSString *)type;

#pragma mark - 持久化配置操作
/** 配置个性存储器 */
+ (void) ag_configurationPersistent:(id<AGBadgePersistentDelegate>)persistent;

/** 持久化 badge，用户退出 app 的时候需要 */
+ (void) ag_persistentAll;

@end


@protocol AGBadgeManagerDelegate <NSObject>

/**
 标记的数值改变 ...
 
 @param changeBadge 改变的标记数值
 @param currentBadge 当前的标记数值
 @mode 改变的模式，（加、减、默认）
 @param type 标记对应类型
 */
- (void) badgeManagerDidChange:(NSInteger)changeBadge
                       current:(NSString *)currentBadge
                          mode:(AGBadgeManagerChangeMode)mode
                       forType:(NSString *)type;

@end

NS_ASSUME_NONNULL_END

