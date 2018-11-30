//
//  AGBadgeManager.m
//  AGBadgeManager
//
//  Created by JohnnyB0Y on 2017/5/26.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  提示标记管理者

#import "AGBadgeManager.h"


@interface __AGBadgeManager : NSObject

/** badge persistent */
@property (nonatomic, strong) id<AGBadgePersistentDelegate> persistent;
/** observer dict */
@property (nonatomic, strong) NSMutableDictionary *observerInfo;

/** 获取某类型标记 */
- (NSInteger) badgeForType:(NSString *)type;

/** 对某类型标记加一 return currentBadge */
- (NSInteger) addForType:(NSString *)type;
/** 对某类型标记减一 return currentBadge */
- (NSInteger) minusForType:(NSString *)type;
/** 对某类型标记减去 badge, return currentBadge */
- (NSInteger) minusBadge:(NSInteger)badge forType:(NSString *)type;
/** 对某类型标记清零 return 清除数量 */
- (NSInteger) clearForType:(NSString *)type;

- (void) setBadge:(NSInteger)badge forType:(NSString *)type;

/** 更新badge, 通知代理 */
- (void) updateForType:(NSString *)type;

/** 持久化 badge，用户退出 app 的时候需要 */
- (void) persistentAllBadge;


/** 添加对应类型的观察者 */
- (void) registerObserver:(id<AGBadgeManagerDelegate>)observer forType:(NSString *)type;
/** 移除对应类型的观察者 */
- (void) removeObserver:(id<AGBadgeManagerDelegate>)observer forType:(NSString *)type;


+ (instancetype) sharedInstance;

@end


@implementation __AGBadgeManager {
    dispatch_queue_t _serialQueue;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static __AGBadgeManager *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance->_serialQueue = dispatch_queue_create("com.badgeManager.serialQueue", DISPATCH_QUEUE_SERIAL);
    });
    return sharedInstance;
}

#pragma mark - ---------- Public Methods ----------
/** 获取某类型标记 */
- (NSInteger) badgeForType:(NSString *)type
{
    __block NSInteger badge = 0;
    dispatch_sync(_serialQueue, ^{
        badge = [self.persistent ag_badgeIntegerForType:type];
    });
    return badge;
}

/** 对某类型标记加一 */
- (NSInteger) addForType:(NSString *)type
{
    return [self addBadge:1 forType:type];
}

- (NSInteger) addBadge:(NSInteger)badge forType:(NSString *)type
{
    __block NSInteger currentBadge = 0;
    dispatch_sync(_serialQueue, ^{
        currentBadge = [self.persistent ag_badgeIntegerForType:type];
        if ( badge > 0 ) {
            currentBadge = [self.persistent ag_setBadgeInteger:currentBadge + badge  forType:type];
            // ...
            [self _didChangeBadge:badge currentBadge:currentBadge mode:AGBadgeManagerChangeModeAdd forType:type];
        }
    });
    
    return currentBadge;
}

/** 对某类型标记减一 */
- (NSInteger) minusForType:(NSString *)type
{
    return [self minusBadge:1 forType:type];
}

/** 对某类型标记减去 badge */
- (NSInteger) minusBadge:(NSInteger)badge forType:(NSString *)type
{
    __block NSInteger less = 0;
    dispatch_sync(_serialQueue, ^{
        less = ([self.persistent ag_badgeIntegerForType:type] - badge);
        NSInteger currentBadge = less > 0 ? less : 0;
        [self.persistent ag_setBadgeInteger:currentBadge forType:type];
        // ...
        if ( less >= 0 && badge > 0 ) {
            [self _didChangeBadge:badge currentBadge:currentBadge mode:AGBadgeManagerChangeModeMinus forType:type];
        }
    });
    
    return less;
}

/** 对某类型标记清零 return 清除数量 */
- (NSInteger) clearForType:(NSString *)type
{
    __block NSInteger badge = 0;
    dispatch_sync(_serialQueue, ^{
        badge = [self.persistent ag_badgeIntegerForType:type];
        if ( badge > 0 ) {
            [self.persistent ag_setBadgeInteger:0 forType:type];
            [self _didChangeBadge:badge currentBadge:0 mode:AGBadgeManagerChangeModeMinus forType:type];
        }
    });
    
    return badge;
}

- (void)updateForType:(NSString *)type
{
    dispatch_sync(_serialQueue, ^{
        NSInteger currentBadge = [self.persistent ag_badgeIntegerForType:type];
        [self _didChangeBadge:0 currentBadge:currentBadge mode:AGBadgeManagerChangeModeNormal forType:type];
    });
}

- (void)setBadge:(NSInteger)badge forType:(NSString *)type
{
    dispatch_sync(_serialQueue, ^{
        [self _didChangeBadge:badge currentBadge:badge mode:AGBadgeManagerChangeModeNormal forType:type];
    });
}

/** 持久化 badge，用户退出 app 的时候需要 */
- (void) persistentAllBadge
{
    dispatch_sync(_serialQueue, ^{
        [self.persistent ag_persistentAllBadge];
    });
}

- (void) registerObserver:(id<AGBadgeManagerDelegate>)observer forType:(NSString *)type
{
    if ( observer == nil || type == nil ) return;
    NSMapTable *mapTable = [self _observerMapTableWithType:type];
    [mapTable setObject:observer forKey:[observer description]];
}

/** 移除对应类型的观察者 */
- (void) removeObserver:(id<AGBadgeManagerDelegate>)observer forType:(NSString *)type
{
    if ( observer == nil || type == nil ) return;
    
    NSMapTable *mapTable = [self _observerMapTableWithType:type];
    [mapTable removeObjectForKey:[observer description]];
}

#pragma mark - ---------- Private Methods ----------
- (void) _didChangeBadge:(NSInteger)changeBadge
            currentBadge:(NSInteger)currentBadge
                    mode:(AGBadgeManagerChangeMode)mode
                 forType:(NSString *)type
{
    NSString *currentBadgeStr = [NSNumber numberWithInteger:currentBadge].stringValue;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSMapTable *mapTable = self.observerInfo[type];
        NSEnumerator *enumerator = [mapTable objectEnumerator];
        id<AGBadgeManagerDelegate> observer;
        
        while ( (observer = enumerator.nextObject) ) {
            // 通知消息接收者
            if ( [observer respondsToSelector:@selector(badgeManagerDidChange:current:mode:forType:)] ) {
                [observer badgeManagerDidChange:changeBadge current:currentBadgeStr mode:mode forType:type];
            }
        }
        
    });
}

- (NSMapTable *) _observerMapTableWithType:(NSString *)type
{
    NSMapTable *mapTable = self.observerInfo[type];
    if ( ! mapTable ) {
        mapTable = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory
                                         valueOptions:NSPointerFunctionsWeakMemory];
        self.observerInfo[type] = mapTable;
    }
    return mapTable;
}

#pragma mark - ----------- Getter Methods ----------
- (NSMutableDictionary *)observerInfo
{
    if (_observerInfo == nil) {
        _observerInfo = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return _observerInfo;
}

- (id<AGBadgePersistentDelegate>)persistent
{
    if (_persistent == nil) {
        _persistent = [[AGBadgePersistent alloc] init];
    }
    return _persistent;
}

#pragma mark - ---------- Override Methods ----------
- (NSString *) debugDescription
{
    return [NSString stringWithFormat:@"%@-%@", self,self.persistent];
}

@end



@interface AGBadgeManager ()

/** badge manager */
@property (nonatomic, strong) __AGBadgeManager *badgeManager;

@end

@implementation AGBadgeManager


- (NSInteger)ag_badge
{
    return [self.badgeManager badgeForType:self.ag_badgeType];
}

/** 获取标记数值对象 */
- (NSNumber *) ag_badgeNumber
{
    return [NSNumber numberWithInteger:[self ag_badge]];
}

/** 获取标记数值字符串 */
- (NSString *) ag_badgeString
{
    return [self ag_badgeNumber].stringValue;
}

- (void)ag_registerObserver:(id<AGBadgeManagerDelegate>)observer
{
    [self.badgeManager registerObserver:observer forType:[self ag_badgeType]];
}

- (void)ag_removeObserver:(id<AGBadgeManagerDelegate>)observer
{
    [self.badgeManager removeObserver:observer forType:[self ag_badgeType]];
}

- (NSString *)ag_badgeType
{
    return NSStringFromClass(self.class);
}

/** 是否本类型？ */
- (BOOL) ag_isEqualToType:(NSString *)type
{
    return [type isEqualToString:self.ag_badgeType];
}

- (void) ag_updateBadge
{
    [self.badgeManager updateForType:self.ag_badgeType];
}

/**
 标记加一
 
 @return 当前标记数量
 */
- (NSInteger) ag_add
{
    return [self.badgeManager addForType:self.ag_badgeType];
}

/**
 标记减一
 
 @return 当前标记数量
 */
- (NSInteger) ag_minus
{
    return [self.badgeManager minusForType:self.ag_badgeType];
}

/**
 减去标记数
 
 @param badge 待减去的标记数
 @return 当前标记数量
 */
- (NSInteger) ag_minusBadge:(NSInteger)badge
{
    return [self.badgeManager minusBadge:badge forType:self.ag_badgeType];
}

/** 对某类型标记清零 */
- (void) ag_clearAllBadge
{
    [self.badgeManager clearForType:self.ag_badgeType];
}

- (void)ag_setBadge:(NSInteger)badge
{
    [self.badgeManager setBadge:badge forType:self.ag_badgeType];
}

+ (void) ag_configurationWithPersistent:(id<AGBadgePersistentDelegate>)persistent
{
    __AGBadgeManager *badgeManager = [__AGBadgeManager sharedInstance];
    badgeManager.persistent = persistent;
}

/** 持久化 badge，用户退出 app 的时候需要 */
+ (void) ag_persistentAllBadge
{
    __AGBadgeManager *badgeManager = [__AGBadgeManager sharedInstance];
    [badgeManager persistentAllBadge];
}

#pragma mark - ----------- Getter Methods ----------
- (__AGBadgeManager *)badgeManager
{
    if (_badgeManager == nil) {
        _badgeManager = [__AGBadgeManager sharedInstance];
    }
    return _badgeManager;
}

@end
