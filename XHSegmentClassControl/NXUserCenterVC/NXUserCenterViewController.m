//
//  NXUserCenterViewController.m
//  firstproject
//
//  Created by 牛新怀 on 2017/9/29.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "NXUserCenterViewController.h"
#import "NXTableView.h"
#import "NXSegmentClassView.h"
@interface TableHeaderView : UIView
@property (nonatomic, strong) UIImageView * imageView;
@end
@implementation TableHeaderView

- (void)drawRect:(CGRect)rect{
    [self addSubview:self.imageView];
  
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.center = CGPointMake(SCREEN_WIDTH/2, self.height/2);
        _imageView.bounds = CGRectMake(0, 0, 40, 40);
        _imageView.layer.cornerRadius = 20;
        _imageView.clipsToBounds = YES;
        _imageView.image = [UIImage imageNamed:@"m8.jpg"];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        _imageView.userInteractionEnabled = YES;
        
        
    }
    return _imageView;
}

@end

@interface NXUserCenterViewController ()<UITableViewDelegate, UITableViewDataSource,NXSegmentDelegate>

@property (nonatomic, strong)NXTableView * mainTableView;
@property (nonatomic, strong)NXSegmentClassView * classView;
@property (nonatomic, strong)TableHeaderView * headerView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;
@property (nonatomic, assign) BOOL canScroll;

@end
static const CGFloat tableHeight = 200;
static NSString *const cellID = @"cellIdentifier";

@implementation NXUserCenterViewController

- (instancetype)initWithUrl:(NSString *)url{
    self  = [super init];
    if (self) {

        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"SegmentClassVC";
    self.navigationController.navigationBar.backgroundColor = [UIColor brownColor];
    [self.view addSubview:self.mainTableView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"leaveTop" object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"leaveTop" object:nil];

}

- (NXTableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[NXTableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.tableHeaderView= self.headerView;
       
    }
    return _mainTableView;
}

- (NXSegmentClassView *)classView{
    if (!_classView) {
        NSArray * classNameArray =@[@"NXHottestPostsViewController",@"NXMemberListViewController",@"NXEssentialPostViewController"];
        NSArray * classTitle =@[@"最新帖子",@"成员列表",@"历史记录"];
        _classView = [[NXSegmentClassView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) withControllerNames:classNameArray withTopTItle:classTitle withParentController:self];
        [_classView setSegmentDelegate:self];
        _classView.selectSegmentTag = 0;
        _classView.backgroundColor = [UIColor whiteColor];
    }
    return _classView;
}

- (TableHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[TableHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, tableHeight)];
        _headerView.backgroundColor = [UIColor cyanColor];

    }
    return _headerView;
}

#pragma mark -UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell.contentView addSubview:self.classView];
    return cell;
}
//cell 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HEIGHT;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.mainTableView) {
        
        CGFloat tempContentOffsetY = scrollView.contentOffset.y;

        CGFloat tabOffsetY =  [self.mainTableView rectForSection:0].origin.y;
        if (tempContentOffsetY<0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showRefresh" object:nil];
            
            [scrollView setContentOffset:CGPointZero];
            
        }
        _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
        if (tempContentOffsetY>=tabOffsetY) {
            
            scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            _isTopIsCanNotMoveTabView = YES;
            
        }else {
            
            _isTopIsCanNotMoveTabView = NO;
        }
        
        if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre) {
            if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView) {
                //滑动到顶端
                [[NSNotificationCenter defaultCenter] postNotificationName:@"goTop" object:nil userInfo:@{@"canScroll":@"1"}];
                _canScroll = NO;
            }
            if(_isTopIsCanNotMoveTabViewPre && !_isTopIsCanNotMoveTabView){
                // 离开顶部
                if (!_canScroll) {
                    scrollView.contentOffset = CGPointMake(0, tabOffsetY);
                }
                
            }
        }
        
    }
}

#pragma notification
-(void)acceptMsg : (NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
}
@end
