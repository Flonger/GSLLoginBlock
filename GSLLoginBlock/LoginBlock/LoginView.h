//
//  LoginView.h
//  GSLLoginBlock
//
//  Created by 薛飞龙 on 2017/2/20.
//  Copyright © 2017年 薛飞龙. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    textPhoneField = 1,
    textCodeField  = 2,
    textPassField = 3
}LoginTextInputMode;

typedef void (^NextClick)();
@interface LoginView : UIView
@property (nonatomic, strong) NextClick nextClick;


- (LoginView *(^)(NSString *))makeTitle;
- (LoginView *(^)(NSString *))makeDescString;
- (LoginView *(^)(NSString *))setBtnTitle;
- (LoginView *(^)(BOOL))showCodeBtn;
- (LoginView *(^)(UIColor *))makeBtnColor;
- (LoginView *(^)(CGFloat,CGFloat))makeCenter;
- (LoginView *(^)(CGFloat,CGFloat))makeSize;
- (LoginView *(^)(LoginTextInputMode))setTextMode;




- (LoginView *(^)(UIView *))toView;


@end
