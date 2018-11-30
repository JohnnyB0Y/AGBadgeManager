//
//  AGBadgeManager.h
//  AGBadgeManager
//
//  Created by JohnnyB0Y on 2017/5/26.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  提示标记管理者

#import <Foundation/Foundation.h>
#import "AGBadgePersistent.h"
@class AGBadgeManager;

typedef NS_ENUM(NSUInteger, AGBadgeManagerChangeMode) {
    AGBadgeManagerChangeModeNormal = 0,
    AGBadgeManagerChangeModeAdd,
    AGBadgeManagerChangeModeMinus,
};

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


@interface AGBadgeManager : NSObject

#pragma mark - 获取数值
- (NSInteger) ag_badge;
- (NSNumber *) ag_badgeNumber;
- (NSString *) ag_badgeString;

#pragma mark - 对数值进行加减操作
/**
 标记加一
 
 @return 当前标记数量
 */
- (NSInteger) ag_add;

/**
 标记减一
 
 @return 当前标记数量
 */
- (NSInteger) ag_minus;

/**
 减去标记数
 
 @param badge 待减去的标记数
 @return 当前标记数量
 */
- (NSInteger) ag_minusBadge:(NSInteger)badge;

/** 对标记清零 */
- (void) ag_clearAllBadge;


#pragma mark - 直接赋值或更新
/**
 直接设值badge的值

 @param badge 新的badge值
 */
- (void) ag_setBadge:(NSInteger)badge;

/** 更新 Badge，其实就是通知代理刷新界面 */
- (void) ag_updateBadge;

#pragma mark - 注册、移除观察者
/** 添加对应类型的观察者 */
- (void) ag_registerObserver:(id<AGBadgeManagerDelegate>)observer;
/** 移除对应类型的观察者 */
- (void) ag_removeObserver:(id<AGBadgeManagerDelegate>)observer;

#pragma mark - 可在子类重写
/** 返回标记类型字符串 */
- (NSString *) ag_badgeType;

/** 是否本类型？ */
- (BOOL) ag_isEqualToType:(NSString *)type;


#pragma mark - 持久化配置操作
/** 配置个性存储器 */
+ (void) ag_configurationWithPersistent:(id<AGBadgePersistentDelegate>)persistent;

/** 持久化 badge，用户退出 app 的时候需要 */
+ (void) ag_persistentAllBadge;

@end

