//
//  PickerDoubleView.h
//  Wish
//
//  Created by XuRenzhong on 2017/5/18.
//  Copyright © 2017年 U1. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PickerDoubleView;


/**
 选择回调

 @param pickerView pickView
 @param choseLeftString 左列表选取
 @param choseRightString 右列表选取
 @param leftIndex 左列表位置
 @param rightIndex 右列表位置
 */
typedef void(^PickerDoubleViewBlock)(PickerDoubleView *pickerView,NSString *choseLeftString,NSString *choseRightString,NSInteger leftIndex,NSInteger rightIndex);

@interface PickerDoubleView : UIView

@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,strong) UIFont *textFont;
@property (nonatomic,strong) UIColor *cancelColor;
@property (nonatomic,strong) UIColor *sureColor;
@property (nonatomic,strong) UIFont *titleFont;

/**
 回调
 */
@property (nonatomic,copy) PickerDoubleViewBlock callBackBlock;

+(instancetype)initWithTitles:(NSArray *)lefttitleArray rightTitles:(NSArray *)rightTitleArray andHeadTitle:(NSString *)headTitle andCallBack:(PickerDoubleViewBlock)callBack;


/**
 展示view
 */
-(void)show;

/**
 销毁view
 */
-(void)dismissPickerView;


@end
