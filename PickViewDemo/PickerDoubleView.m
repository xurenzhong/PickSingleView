//
//  PickerDoubleView.m
//  Wish
//
//  Created by XuRenzhong on 2017/5/18.
//  Copyright © 2017年 U1. All rights reserved.
//

#import "PickerDoubleView.h"

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define kMainWidth  [[UIScreen mainScreen] bounds].size.width

@interface PickerDoubleView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak,nonatomic) UIView *bgView;    //屏幕下方看不到的view
@property (weak,nonatomic) UILabel *titleLabel; //中间显示的标题lab
@property (weak,nonatomic) UIPickerView *leftPickerView;
@property (weak,nonatomic) UIPickerView *rightPickerView;
@property (weak,nonatomic) UIButton *cancelButton;
@property (weak,nonatomic) UIButton *doneButton;
@property (strong,nonatomic) NSArray *leftDataArray;   // 用来记录传递过来的数组数据
@property (strong,nonatomic) NSArray *rightDataArray;
@property (strong,nonatomic) NSString *headTitle;  //传递过来的标题头字符串
@property (strong,nonatomic) NSString *leftBackString; //回调的字符串
@property (strong,nonatomic) NSString *rightBackString;
@property (nonatomic,assign) NSInteger leftIndex;     //回调数组位置
@property (nonatomic,assign) NSInteger rightIndex;

@end

@implementation PickerDoubleView

+(instancetype)initWithTitles:(NSArray *)lefttitleArray rightTitles:(NSArray *)rightTitleArray andHeadTitle:(NSString *)headTitle andCallBack:(PickerDoubleViewBlock)callBack {
    PickerDoubleView *pickView = [[PickerDoubleView alloc] initWithFrame:[UIScreen mainScreen].bounds headTitle:headTitle leftArray:lefttitleArray rightArray:rightTitleArray];
    pickView.callBackBlock = callBack;
    return pickView;
}

-(instancetype)initWithFrame:(CGRect)frame headTitle:(NSString *)headTitle leftArray:(NSArray *)leftArray rightArray:(NSArray *)rightArray {
    self = [super initWithFrame:frame];
    if (self) {
        self.leftDataArray = leftArray;
        self.rightDataArray = rightArray;
        self.headTitle = headTitle;
        self.leftIndex = 0;
        self.rightIndex = 0;
        if (leftArray.count > 0) {
            self.leftBackString = leftArray[0];
        }
        if (rightArray.count > 0) {
            self.rightBackString = rightArray[0];
        }
        [self makeUI];
    }
    return self;
}

-(void)makeUI {
    //背景view
    UIView *bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.45];
    bgView.alpha = 0.0f;
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen)];
    [bgView addGestureRecognizer:tapG];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:bgView];
    self.bgView = bgView;
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_SIZE.width/2 - 75, 5, 150, 20)];
    titleLabel.font = [UIFont systemFontOfSize:18];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:_headTitle];
    [titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    //取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(2, 5, kMainWidth*0.2, 20);
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"取消" attributes:
                                      @{ NSForegroundColorAttributeName: [UIColor grayColor],
                                         NSFontAttributeName :           [UIFont systemFontOfSize:15],
                                         NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone) }];
    [cancelButton setAttributedTitle:attrString forState:UIControlStateNormal];
    cancelButton.adjustsImageWhenHighlighted = NO;
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    self.cancelButton = cancelButton;
    
    //完成按钮
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(kMainWidth - kMainWidth * 0.2 - 2, 5, kMainWidth*0.2, 20);
    NSAttributedString *attrString2 = [[NSAttributedString alloc] initWithString:@"确定" attributes:
                                       @{ NSForegroundColorAttributeName: [UIColor grayColor],
                                          NSFontAttributeName :           [UIFont systemFontOfSize:15],
                                          NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone) }];
    [doneButton setAttributedTitle:attrString2 forState:UIControlStateNormal];
    doneButton.adjustsImageWhenHighlighted = NO;
    doneButton.backgroundColor = [UIColor clearColor];
    [doneButton addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:doneButton];
    self.doneButton = doneButton;
    
    //选择器
    UIPickerView *leftPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(5,22, (SCREEN_SIZE.width-10)/2, 230)];
    [leftPickerView setShowsSelectionIndicator:YES];
    [leftPickerView setDelegate:self];
    [leftPickerView setDataSource:self];
    [self addSubview:leftPickerView];
    self.leftPickerView = leftPickerView;
    self.leftPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UIPickerView *rightPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(5 + (SCREEN_SIZE.width-10)/2,22, (SCREEN_SIZE.width-10)/2, 230)];
    [rightPickerView setShowsSelectionIndicator:YES];
    [rightPickerView setDelegate:self];
    [rightPickerView setDataSource:self];
    [self addSubview:rightPickerView];
    self.rightPickerView = rightPickerView;
    self.rightPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    self.backgroundColor = [UIColor whiteColor];
    [self setFrame:CGRectMake(0, SCREEN_SIZE.height-300, SCREEN_SIZE.width , 300)];
    self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    [self setFrame: CGRectMake(0, SCREEN_SIZE.height,SCREEN_SIZE.width , 250)];
}

#pragma mark--PickViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.leftPickerView) {
        return self.leftDataArray.count;
    }else{
        return self.rightDataArray.count;
    }
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    //设置分割线颜色
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, -1, kMainWidth, 1)];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 45, kMainWidth, 1)];
    line1.backgroundColor = [UIColor lightGrayColor];
    line2.backgroundColor = [UIColor lightGrayColor];
    //设置文字的属性
    UILabel *genderLabel = [UILabel new];
    [genderLabel addSubview:line1];
    [genderLabel addSubview:line2];
    genderLabel.textAlignment = NSTextAlignmentCenter;
    if (pickerView == self.leftPickerView) {
        genderLabel.text = self.leftDataArray[row];
    }else{
        genderLabel.text = self.rightDataArray[row];
    }
    return genderLabel;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == self.leftPickerView) {
        _leftIndex = row;
        _leftBackString = self.leftDataArray[row];
    }else{
        _rightIndex = row;
        _rightBackString = self.rightDataArray[row];
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 45.0f;
}

#pragma mark--Events
- (void)clicked:(UIButton *)sender {
    if ([sender isEqual:self.cancelButton]) {
        [self dismissPickerView];
    }else{
        if (self.callBackBlock) {
            self.callBackBlock(self, _leftBackString, _rightBackString, _leftIndex, _rightIndex);
            [self dismissPickerView];
        }
    }
}

#pragma mark--Setter
-(void)setCancelColor:(UIColor *)cancelColor {
    _cancelColor = cancelColor;
    [self.cancelButton setTitleColor:_cancelColor forState:UIControlStateNormal];
}

-(void)setSureColor:(UIColor *)sureColor {
    _sureColor = sureColor;
    [self.doneButton setTitleColor:_sureColor forState:UIControlStateNormal];
}

-(void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.cancelButton.titleLabel.font = _titleFont;
    self.doneButton.titleLabel.font = _titleFont;
}

#pragma makr--ViewLife
-(void)tapScreen {
    [self dismissPickerView];
}

-(void)show {
    [UIView animateWithDuration:0.8f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews animations:^{
        
        [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
        self.bgView.alpha = 1.0;
        
        self.frame = CGRectMake(0, SCREEN_SIZE.height-250, SCREEN_SIZE.width, 250);
    } completion:NULL];
}

-(void)dismissPickerView {
    [UIView animateWithDuration:0.8f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews animations:^{
        self.bgView.alpha = 0.0;
        self.frame = CGRectMake(0, SCREEN_SIZE.height,SCREEN_SIZE.width , 250);
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [self removeFromSuperview];
    }];
}





@end
