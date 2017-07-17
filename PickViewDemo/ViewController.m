//
//  ViewController.m
//  PickViewDemo
//
//  Created by XuRenzhong on 03/05/2017.
//  Copyright © 2017 Blan_Xu. All rights reserved.
//

#import "ViewController.h"
#import "PickerSingleView.h"
#import "PickerDoubleView.h"

@interface ViewController ()

@property (nonatomic,strong) NSArray *array;

@property (nonatomic,strong) NSArray *array1;

@property (weak, nonatomic) IBOutlet UILabel *testLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.array = @[@"test1",@"test2",@"test3",@"test4",@"test5"];
    
    
    self.array1 = @[@"double0",@"double1",@"double2",@"double3"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)testClick:(id)sender {
    __weak typeof(self) weakSelf = self;
    PickerSingleView *pickView = [PickerSingleView initWithTitles:self.array andHeadTitle:@"test" andCallBack:^(PickerSingleView *pickerSingleView, NSString *choseString) {
        weakSelf.testLabel.text = choseString;
    }];
    [pickView show];
}

- (IBAction)testDouble:(id)sender {
    __weak typeof(self) weakSelf = self;
    PickerDoubleView *doubleView = [PickerDoubleView initWithTitles:self.array1 rightTitles:self.array andHeadTitle:@"TestDouble" andCallBack:^(PickerDoubleView *pickerView, NSString *choseLeftString, NSString *choseRightString, NSInteger leftIndex, NSInteger rightIndex) {
        weakSelf.testLabel.text = [NSString stringWithFormat:@"%@--%@",choseLeftString,choseRightString];
        
    }];
    [doubleView show];
}

@end
