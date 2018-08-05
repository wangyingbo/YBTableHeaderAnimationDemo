//
//  UserInfoView.h
//  YBTableViewHeaderAnimationDemo
//
//  Created by fengbang on 2018/7/11.
//  Copyright © 2018年 王颖博. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kUSER_INFO_HEADERVIEW_H 220


#define FULL_SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define FULL_SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height

typedef enum {
    /**无效果*/
    FBUserInfoHeaderViewAnimationTypeNone = 0,
    /**下拉放大*/
    FBUserInfoHeaderViewAnimationTypeScale,
    /**下拉圆弧*/
    FBUserInfoHeaderViewAnimationTypeCircle,
} FBUserInfoHeaderViewAnimationType;


@interface UserInfoView : UIView
@property (nonatomic,strong) UIImageView *backGroundView;
@property (nonatomic,strong) UIImageView *userLogoImageView;
@property (nonatomic, strong) UIImageView *subLogoImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *subTitleLabel;
@property (nonatomic, assign) FBUserInfoHeaderViewAnimationType animationType;

//-(void)setInfoWithDefaultModel:(UserInfoDataModel*)userInfoModel;
-(void)setInfoWithNoLoginData;
@end
