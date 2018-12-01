//
//  AGHomeViewController.m
//  AGBadgeManager
//
//  Created by JohnnyB0Y on 2018/11/29.
//  Copyright © 2018 JohnnyB0Y. All rights reserved.
//

#import "AGHomeViewController.h"
#import "AGStepper.h"
#import "AGKobeBM.h"
#import "AGByneBM.h"
#import "AGMoseBM.h"

@interface AGHomeViewController () <AGBadgeManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelOne;
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelThree;

@property (weak, nonatomic) IBOutlet UIButton *btnOne;
@property (weak, nonatomic) IBOutlet UIButton *btnTwo;
@property (weak, nonatomic) IBOutlet UIButton *btnThree;

@property (weak, nonatomic) IBOutlet AGStepper *setpperOne;
@property (weak, nonatomic) IBOutlet AGStepper *setpperTwo;
@property (weak, nonatomic) IBOutlet AGStepper *setpperThree;

/** kobe */
@property (nonatomic, strong) AGKobeBM *kobe;
/** mose */
@property (nonatomic, strong) AGMoseBM *mose;
/** byne */
@property (nonatomic, strong) AGByneBM *byne;

@end

@implementation AGHomeViewController
#pragma mark - ----------- Life Cycle ----------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add observer
    [self.kobe ag_registerObserver:self];
    [self.mose ag_registerObserver:self];
    [self.byne ag_registerObserver:self];
    
    // Update UI
    [self.kobe ag_resendBadgeChangeNotification];
    [self.byne ag_resendBadgeChangeNotification];
    [self.mose ag_resendBadgeChangeNotification];
    
    // Add events
    [self.setpperOne addLeftBtnTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchDown];
    [self.setpperOne addRightBtnTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchDown];
    [self.setpperTwo addLeftBtnTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchDown];
    [self.setpperTwo addRightBtnTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchDown];
    [self.setpperThree addLeftBtnTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchDown];
    [self.setpperThree addRightBtnTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchDown];
}

- (void)dealloc
{
    // Remove observer
    [self.kobe ag_removeObserver:self];
    [self.byne ag_removeObserver:self];
    [self.mose ag_removeObserver:self];
}

#pragma mark - ---------- Event Methods ----------
- (void) leftBtnClick:(UIButton *)btn
{
    if ( btn == self.setpperOne.leftBtn ) {
        [self.kobe ag_minus];
        
    }
    else if ( btn == self.setpperTwo.leftBtn ) {
        [self.byne ag_minus];
        
    }
    else if ( btn == self.setpperThree.leftBtn ) {
        [self.mose ag_minus];
        
    }
}

- (void) rightBtnClick:(UIButton *)btn
{
    if ( btn == self.setpperOne.rightBtn ) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (NSInteger i = 0; i<10; i++) {
                [self.kobe ag_plus];
            }
        });
    }
    else if ( btn == self.setpperTwo.rightBtn ) {
        [self.byne ag_plus];
        
    }
    else if ( btn == self.setpperThree.rightBtn ) {
        [self.mose ag_plus];
    }
}

#pragma mark - ---------- Custom Delegate ----------
- (void)badgeManagerDidChange:(NSInteger)changeBadge
                      current:(NSString *)currentBadge
                         mode:(AGBadgeManagerChangeMode)mode
                      forType:(NSString *)type
{
    // ...
    if ( [self.kobe ag_isEqualToType:type] ) {
        [self.btnOne setTitle:currentBadge forState:UIControlStateNormal];
    }
    else if ( [self.byne ag_isEqualToType:type] ) {
        [self.btnTwo setTitle:currentBadge forState:UIControlStateNormal];
    }
    else if ( [self.mose ag_isEqualToType:type]) {
        [self.btnThree setTitle:currentBadge forState:UIControlStateNormal];
    }
    
    // ...
    NSString *oneStr = [NSString stringWithFormat:@"科比+拜恩=%@", @(self.kobe.badge + self.byne.badge)];
    [self.labelOne setText:oneStr];
    
    NSString *twoStr = [NSString stringWithFormat:@"科比+摩西=%@", @(self.kobe.badge + self.mose.badge)];
    [self.labelTwo setText:twoStr];
    
    NSString *threeStr = [NSString stringWithFormat:@"总票数=%@", @(self.kobe.badge + self.byne.badge + self.mose.badge)];
    [self.labelThree setText:threeStr];
    
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
