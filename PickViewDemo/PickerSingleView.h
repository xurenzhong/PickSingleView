//
//  PickerSingleView.h
//  Wish
//
//  Created by XuRenzhong on 2017/4/20.
//  Copyright © 2017年 U1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PickerSingleView;

/**
 回调函数，处理视图

 @param pickerSingleView 本身视图
 @param choseString 选择词条
 */
typedef void(^pickerSingleViewBlock)(PickerSingleView *pickerSingleView,NSString *choseString);
@interface PickerSingleView : UIView

/**
 回调
 */
@property (nonatomic,copy) pickerSingleViewBlock callBlock;

@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,strong) UIFont *textFont;
@property (nonatomic,strong) UIColor *cancelColor;
@property (nonatomic,strong) UIColor *sureColor;
@property (nonatomic,strong) UIFont *titleFont;

/**
 列表项

 @param titleArray 数据源
 @param headTitle 列表名
 @param callBack 回调
 @return picker视图
 */
+(instancetype)initWithTitles:(NSArray *)titleArray andHeadTitle:(NSString *)headTitle andCallBack:(pickerSingleViewBlock)callBack;

/**
 展示view
 */
-(void)show;

/**
 销毁view
 */
-(void)dismissPickerView;

@end
