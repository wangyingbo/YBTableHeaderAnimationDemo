//
//  UserInfoView.m
//  YBTableViewHeaderAnimationDemo
//
//  Created by fengbang on 2018/7/11.
//  Copyright © 2018年 王颖博. All rights reserved.
//

#import "UserInfoView.h"
@interface UserInfoView()
@property (nonatomic, assign) CGFloat headerViewHeight;
@end
@implementation UserInfoView

-(instancetype)initWithFrame:(CGRect)frame {
    self= [super initWithFrame:frame];
    if (self) {
        self.headerViewHeight = kUSER_INFO_HEADERVIEW_H;
        
        [self configUI];
    }
    return self;
}

-(void)configUI{
    _backGroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, FULL_SCREEN_WIDTH, self.headerViewHeight)];
    [_backGroundView setImage:[UIImage imageNamed:@"user_backGround"]];
    [self addSubview:_backGroundView];
    
    _userLogoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(14, 67, 58, 58)];
    _userLogoImageView.backgroundColor = [UIColor whiteColor];
    _userLogoImageView.layer.cornerRadius = 29;
    _userLogoImageView.userInteractionEnabled = YES;
    [_backGroundView addSubview:_userLogoImageView];
    
    UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 8.5, 28, 41)];
    [logoImageView setImage:[UIImage imageNamed:@"user_logo"]];
    [_userLogoImageView addSubview:logoImageView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_userLogoImageView.frame)+11, CGRectGetMinY(_userLogoImageView.frame)+7, 200, 20)];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:14.f];
    [_backGroundView addSubview:_titleLabel];
    
    _subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame)+2, 80, 17)];
    _subTitleLabel.textAlignment = NSTextAlignmentLeft;
    _subTitleLabel.textColor = [UIColor whiteColor];
    _subTitleLabel.font = [UIFont systemFontOfSize:12.];
    [_backGroundView addSubview:_subTitleLabel];
}

//-(void)setInfoWithDefaultModel:(UserInfoDataModel*)userInfoModel{
//    [FBAccountTool account].userInfoModel = userInfoModel;
//    if (userInfoModel.alias.isAvailable) {
//        _titleLabel.text = userInfoModel.alias;
//    }else{
//        _titleLabel.text = @"昵称";
//    }
//
//    if (userInfoModel.mobile.isAvailable) {
//        _subTitleLabel.text = userInfoModel.mobile;
//    }
//
//    if ([userInfoModel.certificationFlag isEqualToString:@"01"]) {
//        _subTitleRightLabel.text = @"  已实名认证";
//    }else{
//        _subTitleRightLabel.text = @"  未实名认证";
//    }
//}

-(void)setInfoWithNoLoginData{
    _titleLabel.text = @"请登录";
    _subTitleLabel.text = @"***********";
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.animationType == FBUserInfoHeaderViewAnimationTypeCircle) {
        self.backgroundColor = [UIColor clearColor];
        self.backGroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        //加一个偏移值
        CGFloat overY = ((self.frame.size.height-(self.frame.size.height-self.headerViewHeight)/2)/2 - self.headerViewHeight*0.5);
        self.userLogoImageView.frame = CGRectMake(14, 67+overY, 58, 58);
        self.titleLabel.frame = CGRectMake(CGRectGetMaxX(_userLogoImageView.frame)+11, CGRectGetMinY(_userLogoImageView.frame)+7, 200, 20);
        self.subTitleLabel.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame)+2, 80, 17);
        
        [self setNeedsDisplay];     // 重绘
    }else if (self.animationType == FBUserInfoHeaderViewAnimationTypeScale) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.backGroundView.frame = self.bounds;
        self.userLogoImageView.frame = CGRectMake(self.frame.size.width/2-FULL_SCREEN_WIDTH/2 + 14, 67+(self.frame.size.height/2 - self.headerViewHeight/2), 58, 58);
        self.titleLabel.frame = CGRectMake(CGRectGetMaxX(_userLogoImageView.frame)+11, CGRectGetMinY(_userLogoImageView.frame)+7, 200, 20);
        self.subTitleLabel.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame)+2, 80, 17);
    }
}


// 绘制曲线
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGFloat h1 = self.headerViewHeight;
    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;
    CGPoint controlPoint = CGPointMake(w/2, h + (h - h1) * 0.5);
    
    if (self.animationType == FBUserInfoHeaderViewAnimationTypeCircle)
    {
        
        //    //获取上下文
        //    //CGContextRef 用来保存图形信息.输出目标
        //    CGContextRef context = UIGraphicsGetCurrentContext();
        //    //设置颜色
        //    CGContextSetRGBFillColor(context, 0.00392, 0.54117, 0.85098, 1.0);
        //    //CGContextSetRGBFillColor(context, 1., 1., 1., 1.0);
        //    //起点
        //    CGContextMoveToPoint(context, w, h1);
        //    //画线
        //    CGContextAddLineToPoint(context, w, 0);
        //    CGContextAddLineToPoint(context, 0, 0);
        //    CGContextAddLineToPoint(context, 0, h1);
        //    CGContextAddQuadCurveToPoint(context, controlPoint.x, controlPoint.y, w, h1);
        //    //闭合
        //    CGContextClosePath(context);
        //    CGContextDrawPath(context, kCGPathFill);
        
        
        // 0.加载图片
        UIImage *originImage = [UIImage imageNamed:@"user_backGround"];
        UIImage *image = originImage;
        // 1.开启位图上下文，跟图片尺寸一样大
        UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
        // 2.设置圆形裁剪区域，正切与图片
        // 2.1创建圆形的路径
        CGFloat scaleY = h1/(h/h1);
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(image.size.width, scaleY)];
        [path addLineToPoint:CGPointMake(image.size.width, 0)];
        [path addLineToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(0, scaleY)];
        [path addQuadCurveToPoint:CGPointMake(image.size.width, scaleY) controlPoint:CGPointMake(image.size.width/2, controlPoint.y/(h/h1))];
        [path closePath];
        //    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        
        // 2.2把路径设置为裁剪区域
        [path addClip];
        // 3.绘制图片
        [image drawAtPoint:CGPointZero];
        // 4.从上下文中获取图片
        UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
        // 5.关闭上下文
        UIGraphicsEndImageContext();
        _backGroundView.image = clipImage;
        
    }else if (self.animationType == FBUserInfoHeaderViewAnimationTypeScale) {
        
    }
    
}

//这个函数会被 hitTest 调用，返回 false 表示点击的不是自己，返回 true 表示点击的是自己
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    // 判断点击的点，在不在圆内
//    CGPoint center = self.userLogoImageView.center;
//    CGFloat r = self.userLogoImageView.frame.size.width * 0.5;
//    CGFloat newR = sqrt((center.x - point.x) * (center.x - point.x) + (center.y - point.y) * (center.y - point.y));
//
//    // 浮点数比较不推荐用等号，虽然 ios 底层已经处理了这种情况
//    if (newR > r) {
//        return false;
//    } else {
//        return true;
//    }
//}

@end
