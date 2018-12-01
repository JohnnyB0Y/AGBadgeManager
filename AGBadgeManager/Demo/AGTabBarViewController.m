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

@property (nonatomic, weak) AGHomeViewController *homeVC;

@property (nonatomic, weak) AGTicketViewController *ticketVC;

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
    
    // Add observer
    [self.allTicket ag_registerObserver:self];
    
    // Update UI
    [self.allTicket ag_resendBadgeChangeNotification];
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
