//
//  AGAllTicketBM.m
//  AGBadgeManager
//
//  Created by JohnnyB0Y on 2018/11/30.
//  Copyright © 2018 JohnnyB0Y. All rights reserved.
//

#import "AGAllTicketBM.h"
#import "AGKobeBM.h"
#import "AGByneBM.h"
#import "AGMoseBM.h"

@interface AGAllTicketBM ()
<AGBadgeManagerDelegate>

/** kobe */
@property (nonatomic, strong) AGKobeBM *kobe;
/** mose */
@property (nonatomic, strong) AGMoseBM *mose;
/** byne */
@property (nonatomic, strong) AGByneBM *byne;

@end

@implementation AGAllTicketBM
#pragma mark - ----------- Life Cycle ----------
- (instancetype)init
{
    self = [super init];
    
    if ( self ) {
        [self.kobe ag_registerObserver:self];
        [self.byne ag_registerObserver:self];
        [self.mose ag_registerObserver:self];
    }
    
    return self;
}

#pragma mark - ---------- Custom Delegate ----------
- (void)badgeManagerDidChange:(NSInteger)changeBadge
                      current:(NSString *)currentBadge
                         mode:(AGBadgeManagerChangeMode)mode
                      forType:(NSString *)type
{
    NSInteger badge = self.kobe.badge + self.byne.badge + self.mose.badge;
    [self ag_resetBadge:badge];
}

#pragma mark - ----------- Getter Methods ----------
- (AGKobeBM *)kobe
{
    if (_kobe == nil) {
        _kobe = [AGKobeBM new];
    }
    return _kobe;
}

- (AGMoseBM *)mose
{
    if (_mose == nil) {
        _mose = [AGMoseBM new];
    }
    return _mose;
}

- (AGByneBM *)byne
{
    if (_byne == nil) {
        _byne = [AGByneBM new];
    }
    return _byne;
}

@end
