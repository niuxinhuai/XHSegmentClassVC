//
//  NXHottestPostsViewController.m
//  firstproject
//
//  Created by 牛新怀 on 2017/9/29.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "NXHottestPostsViewController.h"
@interface NXHottestPostsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView * classTableView;
@end

@implementation NXHottestPostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.classTableView];
    [self.classTableView.mj_header beginRefreshing];
}

- (UITableView *)classTableView{
    if (!_classTableView) {
        _classTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-30) style:UITableViewStylePlain];
        _classTableView.delegate = self;
        _classTableView.dataSource = self;
        _classTableView.backgroundColor = [UIColor whiteColor];
        _classTableView.showsHorizontalScrollIndicator = NO;
        //_classTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _classTableView.showsVerticalScrollIndicator = NO;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self refreshData];
        }];
        header.lastUpdatedTimeLabel.hidden = NO;
        header.stateLabel.hidden = NO;
        
        _classTableView.mj_header = header;
        
        _classTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
    }
    return _classTableView;
}
- (void)refreshData{
    [self performSelector:@selector(dissMissFooterView) withObject:nil afterDelay:2];
}
- (void)dissMissFooterView{
    [self.classTableView.mj_header endRefreshing];
    [self.classTableView.mj_footer endRefreshing];
}
- (void)loadMoreData{
    [self performSelector:@selector(dissMissFooterView) withObject:nil afterDelay:2];
}
#pragma mark -UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 12;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"我是第 %ld 个单元格",indexPath.row];
    return cell;
}
//cell 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

@end
