//
//  NXSegmentDelegate.h
//  firstproject
//
//  Created by 牛新怀 on 2017/9/29.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 苹果官方推荐倒入文件方式，不会导入.m文件
 */

@class NXSegmentTopScrollView;
@class NXSegmentClassView;

@protocol NXSegmentDelegate <NSObject>

/*
 @parameter 标题title点击
 
 */
@optional
- (void) didSelectView:(NXSegmentTopScrollView *)view selectButtonTag:(NSInteger)tag;

/*
 @parameter 左右滑动的偏移量
 
 */
@optional
-(void) scrollViewDidScrollWithContentOffSetX:(CGFloat)x;
/*
 @parameter 主视图上tab点击
 
 */
@optional
- (void) segmentViewDidSelectView:(NXSegmentClassView *)view selectTag:(NSInteger)tag;



@end
