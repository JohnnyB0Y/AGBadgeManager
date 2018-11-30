//
//  AGBadgePersistent.h
//  AGBadgeManager
//
//  Created by JohnnyB0Y on 2018/11/29.
//  Copyright © 2018 JohnnyB0Y. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AGBadgePersistentDelegate <NSObject>

/** 获取对应类型的标记数 */
- (NSNumber *) ag_badgeForType:(NSString *)type;

/** 对某类型标记存入字典 */
- (NSNumber *) ag_setBadge:(NSNumber *)badge forType:(NSString *)type;

/** 持久化标记数量 */
- (void) ag_persistentAllBadge;

@optional
/** 区分用户标记数量的标识符 */
- (NSString *) ag_persistentIdentifier;
- (NSInteger) ag_badgeIntegerForType:(NSString *)type;
- (NSInteger) ag_setBadgeInteger:(NSInteger)badge forType:(NSString *)type;

@end


@interface AGBadgePersistent : NSObject <AGBadgePersistentDelegate>

+ (instancetype)newWithPersistentIdentifier:(NSString *)identifier;
- (instancetype)initWithPersistentIdentifier:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
