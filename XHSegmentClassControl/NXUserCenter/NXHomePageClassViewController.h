//
//  NXHomePageClassViewController.h
//  firstproject
//
//  Created by 牛新怀 on 2017/9/29.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXHomePageClassViewController : UIViewController

/**
 通过继承关系，统一管控子视图滚动问题
 */
@property(strong, nonatomic)UIScrollView *scrollView;

/**
 是否允许滑动
 */
@property (nonatomic, assign) BOOL canScroll;
@end
