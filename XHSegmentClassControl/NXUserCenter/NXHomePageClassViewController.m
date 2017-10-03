//
//  NXHomePageClassViewController.m
//  firstproject
//
//  Created by 牛新怀 on 2017/9/29.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "NXHomePageClassViewController.h"

@interface NXHomePageClassViewController ()<UIGestureRecognizerDelegate>
{
    BOOL is_span;// 为满足第一次进入界面直接下拉刷新准备
}
@end

@implementation NXHomePageClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"goTop" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"leaveTop" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(normalRefresh:) name:@"showRefresh" object:nil];
    is_span = YES;
}
- (void)normalRefresh:(NSNotification *)notification{
    NSString *notificationName = notification.name;
    
    if ([notificationName isEqualToString:@"showRefresh"]) {
        is_span = YES;
        self.scrollView.showsVerticalScrollIndicator = NO;
        // 底部滚动视图接受showRefresh通知
    }
}

-(void)acceptMsg : (NSNotification *)notification{
    
    NSString *notificationName = notification.name;
    
    if ([notificationName isEqualToString:@"goTop"]) {
        NSDictionary *userInfo = notification.userInfo;
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            is_span = NO;
            self.canScroll = YES;
            self.scrollView.showsVerticalScrollIndicator = NO;
            //  底部滚动视图接受goTop通知
        }
    }else if([notificationName isEqualToString:@"leaveTop"]){
        is_span = NO;
        self.scrollView.contentOffset = CGPointZero;
        self.canScroll = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        //   底部滚动视图接受leaveTop通知
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!_canScroll) {//不允许底部视图滑动
        if (scrollView.contentOffset.y>0) {
            is_span = NO;
        }
    }
    if (is_span) {// 保证第一次进入可以直接下啦刷新，以及后续的下啦刷新
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y)];
        return;
        
    }
    if (!self.canScroll) {
        
        [scrollView setContentOffset:CGPointZero];
        return;
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY<=0) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil userInfo:@{@"canScroll":@"1"}];
        // 底部滚动视图发起leaveTop通知
    }
    _scrollView = scrollView;
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // 首先判断otherGestureRecognizer是不是系统pop手势
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        // 再判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && self.scrollView.contentOffset.x == 0) {
            return YES;
        }
    }
    
    return NO;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"goTop" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"leaveTop" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showRefresh" object:nil];

    
}
@end
