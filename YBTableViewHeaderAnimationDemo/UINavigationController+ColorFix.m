//
//  UINavigationController+ColorFix.m
//  YBTableViewHeaderAnimationDemo
//
//  Created by fengbang on 2018/7/11.
//  Copyright © 2018年 王颖博. All rights reserved.
//

#import "UINavigationController+ColorFix.h"

@implementation UINavigationController (ColorFix)
- (void)setNavigationBackgroundAlpha:(CGFloat)alpha {
    // 导航栏背景透明度设置
    UIView *barBackgroundView = [self.navigationBar valueForKey:@"_backgroundView"];// _UIBarBackground
    if (barBackgroundView.subviews.count>0) {
        
    }else{
        return;
    }
    UIImageView *backgroundImageView = [[barBackgroundView subviews] objectAtIndex:0];// UIImageView
    if (self.navigationBar.isTranslucent) {
        if (backgroundImageView != nil && backgroundImageView.image != nil) {
            barBackgroundView.alpha = alpha;
        } else {
            if (barBackgroundView.subviews.count>1) {
                
            }else{
                return;
            }
            UIView *backgroundEffectView = [[barBackgroundView subviews] objectAtIndex:1];// UIVisualEffectView
            if (backgroundEffectView != nil) {
                backgroundEffectView.alpha = alpha;
            }
        }
    } else {
        barBackgroundView.alpha = alpha;
    }
    
    self.navigationBar.clipsToBounds = alpha == 0.0;
}
@end
