//
//  NXSegmentClassView.h
//  firstproject
//
//  Created by 牛新怀 on 2017/9/29.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NXSegmentDelegate.h"
@interface NXSegmentClassView : UIView
/**
 NXSegmentClassView
 
 @param frame 视图frame
 @param controllerNames controller字符串数组
 @param topTitles 顶部tab按钮数组
 @param controller 主视图，
 @return nil
 */
- (instancetype)initWithFrame:(CGRect)frame
          withControllerNames:(NSArray *)controllerNames
                 withTopTItle:(NSArray *)topTitles
         withParentController:(UIViewController *)controller;
@property (assign, nonatomic) NSInteger selectSegmentTag;

/**
 NXSegmentDelegate 统一管控代理协议方法，便于维护
 */
@property (weak, nonatomic) id<NXSegmentDelegate>segmentDelegate;
@end
