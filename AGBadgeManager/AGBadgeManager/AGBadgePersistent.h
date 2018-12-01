//
//  AGBadgePersistent.h
//  AGBadgeManager
//
//  Created by JohnnyB0Y on 2018/11/29.
//  Copyright © 2018 JohnnyB0Y. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 用户可以根据<AGBadgePersistentDelegate>协议，自定义存储方式。
 
 1，默认使用的存储方式是 NSUserDefaults。
 
 2，遵守<AGBadgePersistentDelegate>协议的对象就能注入到 AGBadgeManager 作为内部存储对象。
 [AGBadgeManager ag_configurationPersistent:(id<AGBadgePersistentDelegate>)persistent];
 
 */

@protocol AGBadgePersistentDelegate <NSObject>

/** 获取对应类型标记数 */
- (NSInteger) badgeForType:(NSString *)type;

/** 保存对应类型标记 */
- (NSInteger) setBadge:(NSInteger)badge forType:(NSString *)type;

/** 持久化 */
- (void) persistentAll;

@end


@interface AGBadgePersistent : NSObject <AGBadgePersistentDelegate>

/**
 创建存储对象

 @param identifier 区分多账号下用户的标识
 @return 存储对象
 */
+ (instancetype)newWithIdentifier:(NSString *)identifier;

/**
 创建存储对象
 
 @param identifier 区分多账号下用户的标识
 @return 存储对象
 */
- (instancetype)initWithIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
