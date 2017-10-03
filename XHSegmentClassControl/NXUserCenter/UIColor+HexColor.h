//
//  UIColor+HexColor.h
//  firstproject
//
//  Created by 牛新怀 on 2017/5/18.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)
//根据16进制数生成颜色
+ (UIColor *)uiColorFromString:(NSString *) clrString;
+ (UIColor *)RandomColor; // 随机颜色生成
@end
