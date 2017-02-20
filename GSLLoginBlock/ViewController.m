//
//  ViewController.m
//  GSLLoginBlock
//
//  Created by 薛飞龙 on 2017/2/20.
//  Copyright © 2017年 薛飞龙. All rights reserved.
//

#import "ViewController.h"
#import "LoginView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor lightGrayColor];
    //调用方式
    LoginView * lv = [LoginView new];
    lv.makeCenter(self.view.center.x, self.view.center.y)
    .makeSize(250,220)
    .makeBtnColor([UIColor greenColor])
    .makeTitle(@"登录")
    .makeDescString(@"请输入您的手机号码")
    .showCodeBtn(NO)
    .setBtnTitle(@"下一步")
    .setTextMode(textPhoneField)
    .toView(self.view);
    
    lv.nextClick = ^{
        NSLog(@"下一步");
    };
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
