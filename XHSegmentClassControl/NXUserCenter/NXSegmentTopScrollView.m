//
//  NXSegmentTopScrollView.m
//  firstproject
//
//  Created by 牛新怀 on 2017/9/29.
//  Copyright © 2017年 牛新怀. All rights reserved.
//

#define LEFT_SPACE 20
#define MIN_SPACING 20
#define RIGHT_SPACE 20

#import "NXSegmentTopScrollView.h"

@interface NXSegmentTopScrollView()
{
     NSInteger oldIndex;
}

@property (nonatomic,assign) CGFloat itemTabW;//tab宽度
@property (nonatomic,assign) CGFloat lrMargin;//左右间隔
@property (nonatomic,strong) UIView * bottomLineView;
@property (nonatomic,strong) UILabel * bottomScreenLabel;

@end

static const CGFloat buttonFont      = 17.0;
static const NSInteger TAG           = 100;
static const CGFloat lineViewHeight  = 4;

@implementation NXSegmentTopScrollView

- (void)drawRect:(CGRect)rect{
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton * btn = (UIButton *)view;
            [btn removeFromSuperview];
        }
    }
    
    [self createTopScrollButton];
}

- (void)setDataSourceTitleArray:(NSArray *)dataSourceTitleArray{
    _dataSourceTitleArray = dataSourceTitleArray;
    if (_dataSourceTitleArray ==nil) return;
    _leftSpace             = LEFT_SPACE;
    _font = _font?_font:[UIFont systemFontOfSize:16];
    _minSpace              = MIN_SPACING;
    _rightSpace            = RIGHT_SPACE;
    _selectedColor         = [UIColor uiColorFromString:@"#1997eb"];
    _unselectedColor       = [UIColor uiColorFromString:@"#7e7e7e"];
    _isAnimated            = NO;
    _lrMargin              = 20;
    [self addSubview:self.bottomScreenLabel];
    
}

-(void)createTopScrollButton{
    CGFloat totalW = 0;
    
    if(_dataSourceTitleArray.count<3){
        _itemTabW=100;

        _lrMargin=(SCREEN_WIDTH-_itemTabW*_dataSourceTitleArray.count)/2.0;
        
    }else{
        _itemTabW=SCREEN_WIDTH/_dataSourceTitleArray.count;
    }
    
    for (int idx =0; idx<_dataSourceTitleArray.count; idx++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat buttonWidth = [self titleWidthWithTitle:_dataSourceTitleArray[idx] withFont:[UIFont systemFontOfSize:buttonFont]];
        
        button.frame = CGRectMake(idx*_itemTabW + _lrMargin, 0, buttonWidth, self.height);
        button.titleLabel.font = [UIFont systemFontOfSize:buttonFont];
        [button setTitle:_dataSourceTitleArray[idx] forState:UIControlStateNormal];
        [button setTitleColor:_unselectedColor forState:UIControlStateNormal];
        button.tag = idx + TAG;
        if (idx ==_defaultSelectRange) {
            
            [button setTitleColor:_selectedColor forState:UIControlStateNormal];
            button.transform = CGAffineTransformMakeScale(1.1, 1.1);
            self.lineView.center = CGPointMake(button.center.x, self.height-lineViewHeight/2);
            self.lineView.bounds = CGRectMake(0, 0, 30, lineViewHeight);
        }
        [button addTarget:self action:@selector(changeSelectSenderClick:) forControlEvents:UIControlEventTouchUpInside];
        totalW = button.frame.origin.x + button.frame.size.width;
        [self addSubview:button];
        
    }
    
}
-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = _selectedColor;
        _lineView.layer.cornerRadius = 1;
        _lineView.clipsToBounds = YES;
        [self addSubview:_lineView];
    }
    return _lineView;
}
- (void)setDefaultSelectRange:(NSInteger)defaultSelectRange{
    _defaultSelectRange = defaultSelectRange;
    
}
- (void)changeSelectSenderClick:(UIButton *)sender{
    if (sender.tag == oldIndex) {
        return;
    }
    if ([self.xhDelegate respondsToSelector:@selector(didSelectView:selectButtonTag:)]) {
        [self.xhDelegate didSelectView:self selectButtonTag:sender.tag-TAG];
    }
    for (id empty in self.subviews) {
        if ([empty isKindOfClass:[UIButton class]]) {
            UIButton * button = (UIButton *)empty;
            [button setTitleColor:_unselectedColor forState:UIControlStateNormal];
            button.transform = CGAffineTransformIdentity;
        }
    }
    [sender setTitleColor:_selectedColor forState:UIControlStateNormal];
    
    oldIndex = sender.tag;
    
}
#pragma mark - Calculation Method

-(CGFloat)titleWidthWithTitle:(NSString *)title withFont:(UIFont *)font{
    CGFloat w = [title sizeWithAttributes:@{NSFontAttributeName:font}].width;
    
    return w;
}

- (UILabel *)bottomScreenLabel{
    if (!_bottomScreenLabel) {
        _bottomScreenLabel = [[UILabel alloc]init];
        _bottomScreenLabel.frame = CGRectMake(0, self.height-0.5, SCREEN_WIDTH, 0.5);
        _bottomScreenLabel.backgroundColor = _unselectedColor;
        
    }
    return _bottomScreenLabel;
}

@end
