//
//  NXTableView.h
//  firstproject
//
//  Created by 牛新怀 on 2017/9/29.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 考虑到底部tabview需要可以同时响应多个手势，所以自定义 YksTableView 以满足多个手势同时交互
 */
@interface NXTableView : UITableView<UIGestureRecognizerDelegate>

@end
