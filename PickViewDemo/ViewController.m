//
//  ViewController.m
//  PickViewDemo
//
//  Created by XuRenzhong on 03/05/2017.
//  Copyright © 2017 Blan_Xu. All rights reserved.
//

#import "ViewController.h"
#import "PickerSingleView.h"

@interface ViewController ()

@property (nonatomic,strong) NSArray *array;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.array = @[@"test1",@"test2",@"test3",@"test4",@"test5"];
    
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


@end
