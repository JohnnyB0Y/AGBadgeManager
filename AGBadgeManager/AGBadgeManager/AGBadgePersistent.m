//
//  AGBadgePersistent.m
//  AGBadgeManager
//
//  Created by JohnnyB0Y on 2018/11/29.
//  Copyright © 2018 JohnnyB0Y. All rights reserved.
//

#import "AGBadgePersistent.h"

NSString * const kAGBadgePersistentDict = @"kAGBadgePersistentDict";

@interface AGBadgePersistent ()

@property (nonatomic, strong) NSMutableDictionary *badgeDictM;

@end

@implementation AGBadgePersistent {
    NSString *_identifier;
}

- (instancetype)initWithIdentifier:(NSString *)identifier
{
    self = [self init];
    
    if ( self ) {
        self->_identifier = identifier;
    }
    
    return self;
}

+ (instancetype)newWithIdentifier:(NSString *)identifier
{
    return [[self alloc] initWithIdentifier:identifier];
}

- (NSInteger) badgeForType:(NSString *)type
{
    return [[self.badgeDictM objectForKey:type] integerValue];
}

- (NSInteger) setBadge:(NSInteger)badge forType:(NSString *)type
{
    [[self badgeDictM] setObject:[NSNumber numberWithInteger:badge] forKey:type];
    return badge;
}

- (void)persistentAll
{
    NSMutableDictionary *baseBadgeDictM = [[NSUserDefaults standardUserDefaults] objectForKey:kAGBadgePersistentDict];
    baseBadgeDictM = baseBadgeDictM ? [baseBadgeDictM mutableCopy] : [NSMutableDictionary dictionaryWithCapacity:10];
    
    [baseBadgeDictM setObject:self.badgeDictM forKey:[self ag_persistentIdentifier]];
    [[NSUserDefaults standardUserDefaults] setObject:baseBadgeDictM forKey:kAGBadgePersistentDict];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)ag_persistentIdentifier
{
    return _identifier ?: @"__currentUserId__";
}

#pragma mark - ----------- Getter Methods ----------
- (NSMutableDictionary *)badgeDictM
{
    if (_badgeDictM == nil) {
        NSMutableDictionary *badgeDictM;
        NSDictionary *baseBadgeDict = [[NSUserDefaults standardUserDefaults] objectForKey:kAGBadgePersistentDict];
        badgeDictM = [baseBadgeDict objectForKey:[self ag_persistentIdentifier]];
        badgeDictM = badgeDictM ? [badgeDictM mutableCopy] : [NSMutableDictionary dictionaryWithCapacity:10];
        _badgeDictM = badgeDictM;
    }
    return _badgeDictM;
}

#pragma mark - ---------- Override Methods ----------
- (NSString *) debugDescription
{
    return [NSString stringWithFormat:@"%@-%@", self, [self badgeDictM]];
}

@end
