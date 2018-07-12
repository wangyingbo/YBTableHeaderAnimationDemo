//
//  TableHeaderAnimationVC.m
//  YBTableViewHeaderAnimationDemo
//
//  Created by fengbang on 2018/7/11.
//  Copyright © 2018年 王颖博. All rights reserved.
//

#import "TableHeaderAnimationVC.h"
#import "UserInfoView.h"
#import "UINavigationController+ColorFix.h"

CGFloat kMaxScrollContentSizeY = 250;

@interface TableHeaderAnimationVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArray;
@property (assign, nonatomic) CGFloat headerViewHeight;
@property (nonatomic,strong) UserInfoView *userInfoView;

@end

@implementation TableHeaderAnimationVC


#pragma mark - lazy
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        if (@available(iOS 11.0, *)) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        tableView.estimatedRowHeight = 44;
        tableView.estimatedSectionHeaderHeight = 10.;
        tableView.estimatedSectionFooterHeight = 0.1;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.separatorInset = UIEdgeInsetsMake(0.5, 14, 0, 0);
        //占位用的view
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FULL_SCREEN_WIDTH, self.headerViewHeight)];
        view.backgroundColor = [UIColor clearColor];
        tableView.tableHeaderView = view;
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.01)];
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

#pragma mark - overwrite
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headerViewHeight = kUSER_INFO_HEADERVIEW_H;
    
    [self configUI];
    
    [self configData];
    
    [self configTopView];
    
    [self configBackButton];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBackgroundAlpha:0.0];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBackgroundAlpha:1.0];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];

    
}

#pragma amrk - private
- (void)configData {
    self.dataArray = @[@[@"修改密码",@"绑定手机号"],@[@"新消息通知",@"关于我们"]];
}

- (void)configUI {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)configBackButton {
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 30, 22, 22)];
    [backButton setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (void)backBarButtonItemAction {
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIView *)configTopView {
    _userInfoView = [[UserInfoView alloc]initWithFrame:CGRectMake(0, 0, FULL_SCREEN_WIDTH, self.headerViewHeight)];
    if (self.type == 0) {
        _userInfoView.animationType = FBUserInfoHeaderViewAnimationTypeNone;
    }else if (self.type == 1) {
        _userInfoView.animationType = FBUserInfoHeaderViewAnimationTypeScale;
    }else {
        _userInfoView.animationType = FBUserInfoHeaderViewAnimationTypeCircle;
    }
    [self.view addSubview:_userInfoView];
    [_userInfoView setInfoWithNoLoginData];
    return _userInfoView;
}

#pragma mark - dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.dataArray[section];
    return arr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellId];
    }
    
    NSArray *iconArray = @[@[@"mine_list_change_password",@"mine_list_binding"],@[@"mine_list_message_setting",@"mine_list_about"]];
    NSArray *arr = self.dataArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = arr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"section:%ld-row:%ld",indexPath.section,indexPath.row];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    NSArray *icons = iconArray[indexPath.section];
    cell.imageView.image = [UIImage imageNamed:icons[indexPath.row]];
    
    return cell;
}

#pragma mark - delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat width = self.view.frame.size.width;
    CGRect frame = self.userInfoView.frame;
    //FBLog(@"偏移量:%.2f",scrollView.contentOffset.y);
    
    if (self.userInfoView.animationType == FBUserInfoHeaderViewAnimationTypeCircle) {
        if (offsetY < 0) {
            frame.size.height = (self.headerViewHeight + ABS(offsetY))>kMaxScrollContentSizeY?kMaxScrollContentSizeY:(self.headerViewHeight + ABS(offsetY));
            frame.origin.y = 0;//及时归零
            if (self.headerViewHeight+ABS(offsetY)>kMaxScrollContentSizeY) {
                scrollView.contentOffset = CGPointMake(0, self.headerViewHeight-kMaxScrollContentSizeY);
            }
        } else {//向上滑
            //取消向上滑到顶的弹簧效果
            scrollView.contentOffset = CGPointZero;
            frame.size.height = self.headerViewHeight;
            frame.origin.y = 0;//-offsetY
        }
        self.userInfoView.frame = frame;
        
    }else if (self.userInfoView.animationType == FBUserInfoHeaderViewAnimationTypeScale) {
        
        if (offsetY < 0) {
            frame.size.height = (self.headerViewHeight + ABS(offsetY))>kMaxScrollContentSizeY?kMaxScrollContentSizeY:(self.headerViewHeight + ABS(offsetY));
            frame.origin.y = 0;//及时归零
            
            CGFloat f = (self.headerViewHeight + ABS(offsetY)) / self.headerViewHeight;//缩放比
            //拉伸后的图片的frame应该是同比例缩放。
            frame =  CGRectMake(- (width * f - width) / 2, 0, width * f, (self.headerViewHeight + ABS(offsetY)));
            
        } else {//向上滑
            //取消向上滑到顶的弹簧效果
            scrollView.contentOffset = CGPointZero;
            frame.size.height = self.headerViewHeight;
            frame.origin.y = 0;//-offsetY
        }
        self.userInfoView.frame = frame;
    }
    
}


// scrollViewWillEndDragging，这个方法内判断一下，contentOffset.y 值，如果超过多少值，那么自动回调一个 block，可实现下拉刷新
//松手时触发
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (-offsetY > 70) {
    }
}


@end
