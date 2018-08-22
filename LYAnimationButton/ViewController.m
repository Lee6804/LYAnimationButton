//
//  ViewController.m
//  LYAnimationButton
//
//  Created by Lee on 2018/8/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "ViewController.h"
#import "LYAnimationBtn.h"

#define SWidth [UIScreen mainScreen].bounds.size.width
#define SHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property(nonatomic,strong)LYAnimationBtn *lyBtn;
@property(nonatomic,strong)UISwitch *nSwitch;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    self.navigationItem.title = @"AnimationButton";
    self.view.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    
    self.lyBtn = [LYAnimationBtn initWithFrame:CGRectMake(20, 100, SWidth - 40, 44) title:@"登录"];
    __weak typeof(self)weakSelf = self;
    self.lyBtn.btnClickBlock = ^{
        
        if (weakSelf.nSwitch.isOn) {
            [weakSelf.lyBtn dismissView];
            [weakSelf.lyBtn failAction];
        }else{
            [weakSelf.lyBtn dismissView];
        }
    };
    [self.view addSubview:self.lyBtn];
    
    self.nSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SWidth/2 - 30, 200, 60, 30)];
    [self.view addSubview:self.nSwitch];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
