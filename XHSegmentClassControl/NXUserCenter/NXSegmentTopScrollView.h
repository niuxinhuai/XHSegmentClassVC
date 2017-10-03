//
//  NXSegmentTopScrollView.h
//  firstproject
//
//  Created by 牛新怀 on 2017/9/29.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NXSegmentDelegate.h"
@interface NXSegmentTopScrollView : UIScrollView
@property (weak, nonatomic) id<NXSegmentDelegate>xhDelegate;


/**
 底部线条
 */
@property (strong, nonatomic) UIView * lineView;

/**
 默认选中项 default is 0
 */
@property (assign, nonatomic) NSInteger defaultSelectRange;

/**
 Title datasourse
 */
@property (strong, nonatomic) NSArray * dataSourceTitleArray;

/**
 左侧间距
 */
@property (nonatomic, assign) CGFloat leftSpace;

/**
 字体大小， 默认17
 */
@property (nonatomic, strong) UIFont *font;

/**
 最小间距
 */
@property (nonatomic, assign) CGFloat minSpace;

/**
 右侧间距
 */
@property (nonatomic, assign) CGFloat rightSpace;

/**
 选中字体颜色
 */
@property (nonatomic, strong) UIColor *selectedColor;

/**
 未被选中字体颜色
 */
@property (nonatomic, strong) UIColor *unselectedColor;
@property (nonatomic, assign) CGFloat contentOffSetX;
/**
 default NO.
 */
@property (nonatomic, assign) BOOL isAnimated;

@end
