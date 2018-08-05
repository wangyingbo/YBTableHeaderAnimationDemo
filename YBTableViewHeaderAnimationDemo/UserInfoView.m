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
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
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
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer new];
    shapeLayer.fillColor = [UIColor redColor].CGColor; //填充颜色
    [self.layer addSublayer:shapeLayer];
    self.shapeLayer = shapeLayer;
    
    _backGroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, FULL_SCREEN_WIDTH, self.headerViewHeight)];
    [_backGroundView setImage:[UIImage imageNamed:@"user_backGround"]];
    _backGroundView.clipsToBounds = YES;
    [self addSubview:_backGroundView];
    
    _userLogoImageView = [[UIImageView alloc]init];
    _userLogoImageView.backgroundColor = [UIColor whiteColor];
    _userLogoImageView.userInteractionEnabled = YES;
    [_backGroundView addSubview:_userLogoImageView];
    
    UIImageView *logoImageView = [[UIImageView alloc]init];
    [logoImageView setImage:[UIImage imageNamed:@"user_logo"]];
    [_userLogoImageView addSubview:logoImageView];
    self.subLogoImageView = logoImageView;
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:14.f];
    [_backGroundView addSubview:_titleLabel];
    
    _subTitleLabel = [[UILabel alloc]init];
    _subTitleLabel.textAlignment = NSTextAlignmentLeft;
    _subTitleLabel.textColor = [UIColor whiteColor];
    _subTitleLabel.font = [UIFont systemFontOfSize:12.];
    [_backGroundView addSubview:_subTitleLabel];
}

-(void)setInfoWithNoLoginData{
    _titleLabel.text = @"请登录";
    _subTitleLabel.text = @"***********";
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat logoImageView_h = 58.0;
    CGFloat titleLabel_h = 20.0;
    
    self.backGroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.backgroundColor = [UIColor clearColor];
    if (self.animationType == FBUserInfoHeaderViewAnimationTypeScale) {
        self.backGroundView.frame = self.bounds;
    }
    self.userLogoImageView.frame = CGRectMake(self.frame.size.width/2-FULL_SCREEN_WIDTH/2 + 14, self.frame.size.height/2 - logoImageView_h/2, logoImageView_h, logoImageView_h);
    self.userLogoImageView.layer.cornerRadius = 29;
    self.subLogoImageView.frame = CGRectMake(0, 0, 58*(29.0/40)*(2./3), 80*(29./40)*(2./3));
    self.subLogoImageView.center = CGPointMake(self.userLogoImageView.frame.size.width/2, self.userLogoImageView.frame.size.height/2);
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.userLogoImageView.frame)+5, CGRectGetMaxY(self.userLogoImageView.frame)-CGRectGetHeight(self.userLogoImageView.frame)/2 - titleLabel_h, 100, titleLabel_h);
    self.subTitleLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.titleLabel.frame), CGRectGetHeight(self.titleLabel.frame));
    if (self.animationType == FBUserInfoHeaderViewAnimationTypeCircle) {
        [self setNeedsDisplay];
    }
    
}


// 绘制曲线
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGFloat h1 = self.headerViewHeight;
    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;
    CGPoint controlPoint = CGPointMake(w/2, h + (h - h1));//(h - h1) * 0.5
    
    if (self.animationType == FBUserInfoHeaderViewAnimationTypeCircle)
    {
        UIBezierPath *bezierPath = [UIBezierPath new];
        [bezierPath moveToPoint:CGPointMake(w, h1)];
        [bezierPath addLineToPoint:CGPointMake(w, 0)];
        [bezierPath addLineToPoint:CGPointMake(0, 0)];
        [bezierPath addLineToPoint:CGPointMake(0, h1)];
        [bezierPath addQuadCurveToPoint:CGPointMake(w, h1) controlPoint:controlPoint];
        [bezierPath closePath];//将起点与结束点相连接
        self.shapeLayer.path = bezierPath.CGPath;
        self.backGroundView.layer.mask = self.shapeLayer;
        
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
