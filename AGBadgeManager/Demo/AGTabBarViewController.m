//
//  AGTabBarViewController.m
//  AGBadgeManager
//
//  Created by JohnnyB0Y on 2018/11/29.
//  Copyright © 2018 JohnnyB0Y. All rights reserved.
//

#import "AGTabBarViewController.h"
#import "AGHomeViewController.h"
#import "AGTicketViewController.h"
#import "AGAllTicketBM.h"

@interface AGTabBarViewController ()
<AGBadgeManagerDelegate>

/** 主页面 */
@property (nonatomic, weak) AGHomeViewController *homeVC;

/** 好友页面 */
@property (nonatomic, weak) AGTicketViewController *ticketVC;

/** kobe */
@property (nonatomic, strong) AGAllTicketBM *allTicket;

@end

@implementation AGTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    for (UIViewController *vc in self.childViewControllers) {
        
        if ( [vc isKindOfClass:AGHomeViewController.class] ) {
            self.homeVC = (AGHomeViewController *)vc;
        }
        else if ( [vc isKindOfClass:AGTicketViewController.class] ) {
            self.ticketVC = (AGTicketViewController *)vc;
        }
    }
    
    // 注册标记观察者
    [self.allTicket ag_registerObserver:self];
    
    [self.allTicket ag_updateBadge];
    
}

#pragma mark - ---------- Custom Delegate ----------
- (void)badgeManagerDidChange:(NSInteger)changeBadge
                      current:(NSString *)currentBadge
                         mode:(AGBadgeManagerChangeMode)mode
                      forType:(NSString *)type
{
    
    if ( [self.allTicket ag_isEqualToType:type] ) {
        
        if ( currentBadge.integerValue > 0 ) {
            self.ticketVC.tabBarItem.badgeValue = currentBadge;
        }
        else {
            self.ticketVC.tabBarItem.badgeValue = nil;
        }
        
    }
    
}

#pragma mark - ----------- Getter Methods ----------
- (AGAllTicketBM *)allTicket
{
    if (_allTicket == nil) {
        _allTicket = [AGAllTicketBM new];
    }
    return _allTicket;
}

@end
