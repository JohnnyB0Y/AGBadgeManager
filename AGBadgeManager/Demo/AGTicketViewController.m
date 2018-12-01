//
//  AGTicketViewController.m
//  AGBadgeManager
//
//  Created by JohnnyB0Y on 2018/11/29.
//  Copyright © 2018 JohnnyB0Y. All rights reserved.
//

#import "AGTicketViewController.h"
#import "AGKobeBM.h"
#import "AGByneBM.h"
#import "AGMoseBM.h"

@interface AGTicketViewController ()

/** kobe */
@property (nonatomic, strong) AGKobeBM *kobe;
/** mose */
@property (nonatomic, strong) AGMoseBM *mose;
/** byne */
@property (nonatomic, strong) AGByneBM *byne;

@end

@implementation AGTicketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

#pragma mark - ---------- Event Methods ----------
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // Clear all badge
    [self.kobe ag_clearAllBadge];
    [self.mose ag_clearAllBadge];
    [self.byne ag_clearAllBadge];
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
