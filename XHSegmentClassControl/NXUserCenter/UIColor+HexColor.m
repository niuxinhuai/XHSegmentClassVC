//
//  UIColor+HexColor.m
//  firstproject
//
//  Created by 牛新怀 on 2017/5/18.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#import "UIColor+HexColor.h"

@implementation UIColor (HexColor)
//根据@"#eef4f4"得到UIColor
+ (UIColor *)uiColorFromString:(NSString *) clrString
{
    return [self uiColorFromString:clrString alpha:1.0];
}
+ (UIColor *)uiColorFromString:(NSString *) clrString alpha:(double)alpha
{
    if ([clrString length] == 0) {
        return [UIColor clearColor];
    }
    
    if ( [clrString caseInsensitiveCompare:@"clear"] == NSOrderedSame) {
        return [UIColor clearColor];
    }
    
    if([clrString characterAtIndex:0] == 0x0023 && [clrString length]<8)
    {
        const char * strBuf= [clrString UTF8String];
        
        NSInteger iColor = strtol((strBuf+1), NULL, 16);
        typedef struct colorByte
        {
            unsigned char b;
            unsigned char g;
            unsigned char r;
        }CLRBYTE;
        CLRBYTE * pclr = (CLRBYTE *)&iColor;
        return [UIColor colorWithRed:((double)pclr->r/255.f) green:((double)pclr->g/255.f) blue:((double)pclr->b/255) alpha:alpha];
    }
    return [UIColor blackColor];
}

+(UIColor *)RandomColor{
    NSInteger aRedValue = arc4random() % 255;
    NSInteger aGreenValue = arc4random() % 255;
    NSInteger aBlueValue = arc4random() % 255;
    UIColor *randColor = [UIColor colorWithRed:aRedValue / 255.0f green:aGreenValue / 255.0f blue:aBlueValue / 255.0f alpha:1.0f];
    return randColor;
    
    
}

@end
