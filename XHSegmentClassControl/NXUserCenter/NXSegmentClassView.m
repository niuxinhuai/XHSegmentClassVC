//
//  NXSegmentClassView.m
//  firstproject
//
//  Created by 牛新怀 on 2017/9/29.
//  Copyright © 2017年 牛新怀. All rights reserved.
//
#define TOP_BLANNER_HEIGHT 50

#import "NXSegmentClassView.h"
#import "NXSegmentTopScrollView.h"
@interface NXSegmentClassView()<UIScrollViewDelegate,NXSegmentDelegate>
{
    CGFloat _startOffsetX;
    NSInteger newIndex;
    NSInteger selectPageIndex;
}

@property (nonatomic, strong) NSMutableArray * controllerClassNameArray;
@property (nonatomic, strong) NSMutableArray *strongArray;
@property (nonatomic, strong) NSArray * topTitleArray;
@property (nonatomic, strong) UIViewController * parentVC;
@property (nonatomic, strong) NXSegmentTopScrollView * topScrollView;
@property (nonatomic, strong) UIScrollView * mainScrollView;

@end

static const NSInteger TAG           = 100;

@implementation NXSegmentClassView

- (instancetype)initWithFrame:(CGRect)frame
          withControllerNames:(NSArray *)controllerNames
                 withTopTItle:(NSArray *)topTitles
         withParentController:(UIViewController *)controller{
    self = [super initWithFrame:frame];
    if (self) {
        self.controllerClassNameArray = [NSMutableArray arrayWithArray:controllerNames];
        self.topTitleArray = topTitles;
        _parentVC = controller;
        self.topScrollView.dataSourceTitleArray = self.topTitleArray;
        self.mainScrollView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (NSMutableArray *)strongArray{
    if (!_strongArray){
        _strongArray = [[NSMutableArray alloc]init];
    }
    return _strongArray;
}
/*
 @parameter 选中的按钮标签
 
 */
- (void)setSelectSegmentTag:(NSInteger)selectSegmentTag{
    _selectSegmentTag = selectSegmentTag;
    if (!_selectSegmentTag) {
        _selectSegmentTag = 0;
    }
    
    self.topScrollView.defaultSelectRange = _selectSegmentTag;
    [self.mainScrollView setContentOffset:CGPointMake(_selectSegmentTag*self.width, 0)];
    [self setUpChildVCWithPage:_selectSegmentTag];
    
}
-(void)setUpChildVCWithPage:(NSInteger)page{
    NSString * pageStr = [NSString stringWithFormat:@"%ld",page];
    if ([self.strongArray containsObject:pageStr]) {//数组中如果存在，则不进行添加controller
        return;
    }
    [self.strongArray addObject:pageStr];
    UIViewController * viewController = [self getChildVCWithClassName:self.controllerClassNameArray[page]];
    viewController.view.frame = CGRectMake(self.width*page, 0, self.width, self.height);
    [self.mainScrollView addSubview:viewController.view];
    [_parentVC addChildViewController:viewController];
}

- (UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]init];
        _mainScrollView.frame = CGRectMake(0, TOP_BLANNER_HEIGHT, self.width, SCREEN_HEIGHT-TOP_BLANNER_HEIGHT);
        _mainScrollView.contentSize=CGSizeMake(self.width*self.controllerClassNameArray.count, 0);
        _mainScrollView.delegate=self;
        _mainScrollView.showsHorizontalScrollIndicator=NO;
        _mainScrollView.pagingEnabled=YES;
        _mainScrollView.bounces=NO;
        
        [self addSubview:_mainScrollView];
    }
    return _mainScrollView;
}

- (NXSegmentTopScrollView *)topScrollView{
    if (!_topScrollView) {
        _topScrollView = [[NXSegmentTopScrollView alloc]init];
        _topScrollView.frame = CGRectMake(0, 0, self.width, TOP_BLANNER_HEIGHT);
        _topScrollView.backgroundColor = [UIColor whiteColor];
        _topScrollView.xhDelegate = self;
        [self addSubview:_topScrollView];
    }
    return _topScrollView;
}
- (UIViewController *)findViewController:(UIView *)sourceView
{
    id target = sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}
-(UIViewController *)getChildVCWithClassName:(NSString *)className{
    Class class = NSClassFromString(className);
    
    UIViewController *viewController = [[class alloc]init];
    return viewController;
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat sourceIndex = 0 ;
    CGFloat targetIndex = 0 ;
    CGFloat process = 0 ;
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    if ([self.segmentDelegate respondsToSelector:@selector(scrollViewDidScrollWithContentOffSetX:)]) {
        [self.segmentDelegate scrollViewDidScrollWithContentOffSetX:contentOffsetX];
    }
    // -- round  -- ceil  -- floor 苹果官方定义函数，
    /**
     Example:如何值是3.4的话，则
     -- round 3.000000 round 如果参数是小数，则求本身的四舍五入.
     -- ceil 4.000000 ceil 如果参数是小数，则求最小的整数但不小于本身.
     -- floor 3.00000 floor 如果参数是小数，则求最大的整数但不大于本身
     */
    //左侧滑动
    if (_startOffsetX < contentOffsetX) {
        
        sourceIndex  =floor((contentOffsetX / self.mainScrollView.frame.size.width));
        targetIndex =  sourceIndex+1;
        
        process =(contentOffsetX / self.mainScrollView.frame.size.width) - floor((contentOffsetX / self.mainScrollView.frame.size.width));
        
        if ((contentOffsetX - _startOffsetX)==self.mainScrollView.frame.size.width) {
            process=1;
            targetIndex=sourceIndex;
        }
    }
    //右侧滑动
    else
    {
        targetIndex = floor((contentOffsetX / self.mainScrollView.frame.size.width));
        sourceIndex = targetIndex+1;
        process = 1- ((contentOffsetX / self.mainScrollView.frame.size.width) - floor((contentOffsetX / self.mainScrollView.frame.size.width)));
        
    }
    UIButton * btn1 = [self.topScrollView viewWithTag:sourceIndex+TAG];
    UIButton * btn2 = [self.topScrollView viewWithTag:targetIndex+TAG];
    CGFloat detailX = btn2.center.x - btn1.center.x;
    
    if (sourceIndex >self.topTitleArray.count-1||targetIndex>self.topTitleArray.count-1||targetIndex<0 ) {
        return;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.topScrollView.lineView.center = CGPointMake(btn1.center.x+detailX*process, self.topScrollView.lineView.center.y);
        
    }];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    if (scrollView == self.mainScrollView) {
        
        //所有按钮字体颜色统一调整
        for (id empty in self.topScrollView.subviews) {
            if ([empty isKindOfClass:[UIButton class]]) {
                UIButton * button = (UIButton *)empty;
                [button setTitleColor:[UIColor uiColorFromString:@"#7e7e7e"] forState:UIControlStateNormal];
                button.transform = CGAffineTransformIdentity;
            }
        }
        NSInteger targetIndex = floor(self.mainScrollView.contentOffset.x / self.mainScrollView.frame.size.width);
        
        UIButton * btn = [self.topScrollView viewWithTag:targetIndex +TAG];
        [btn setTitleColor:[UIColor uiColorFromString:@"#42CEFC"] forState:UIControlStateNormal];
        self.topScrollView.lineView.center = CGPointMake(btn.center.x, self.topScrollView.lineView.center.y);
        [self setUpChildVCWithPage:floor(self.mainScrollView.contentOffset.x / self.mainScrollView.frame.size.width)];
        
        if (targetIndex == newIndex) {
            return;
        }
    }
    newIndex = floor(self.mainScrollView.contentOffset.x / self.mainScrollView.frame.size.width);
    
    selectPageIndex = newIndex;
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _startOffsetX = scrollView.contentOffset.x;
}
#pragma mark - 用户点击标题代理
- (void)didSelectView:(NXSegmentTopScrollView *)view selectButtonTag:(NSInteger)tag{
    if ([self.segmentDelegate respondsToSelector:@selector(segmentViewDidSelectView:selectTag:)]) {
        [self.segmentDelegate segmentViewDidSelectView:self selectTag:tag];
    }
    [self setUpChildVCWithPage:tag];
    [self.mainScrollView setContentOffset:CGPointMake(tag*self.mainScrollView.width, 0) animated:YES];
    
}


@end
