//
//  AGHomeViewController.h
//  AGBadgeManager
//
//  Created by JohnnyB0Y on 2018/11/29.
//  Copyright © 2018 JohnnyB0Y. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGKobeBM.h"
#import "AGByneBM.h"
#import "AGMoseBM.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGHomeViewController : UIViewController

/** kobe */
@property (nonatomic, strong, readonly) AGKobeBM *kobe;
/** mose */
@property (nonatomic, strong, readonly) AGMoseBM *mose;
/** byne */
@property (nonatomic, strong, readonly) AGByneBM *byne;

@end

NS_ASSUME_NONNULL_END
