//
//  ViewController.m
//  YBTableViewHeaderAnimationDemo
//
//  Created by fengbang on 2018/7/11.
//  Copyright © 2018年 王颖博. All rights reserved.
//

#import "ViewController.h"
#import "TableHeaderAnimationVC.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArray;

@end

@implementation ViewController


#pragma mark - lazy
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        tableView.estimatedRowHeight = 44;
        tableView.estimatedSectionHeaderHeight = 10.;
        tableView.estimatedSectionFooterHeight = 0.1;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.separatorInset = UIEdgeInsetsMake(0.5, 14, 0, 0);
        tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.01)];
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.01)];
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

#pragma mark - overwrite
- (void)viewDidLoad {
    [super viewDidLoad];
        [self configUI];
    
    [self configData];
    
}

#pragma amrk - private
- (void)configData {
    self.dataArray = @[@"无效果",@"放大头部",@"拖拽圆弧"];
}

- (void)configUI {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellId];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.text = @"click here!";
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    return cell;
}

#pragma mark - delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TableHeaderAnimationVC *vc = [[TableHeaderAnimationVC alloc] init];
    vc.type = indexPath.row;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

@end
