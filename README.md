# GSLLoginBlock
根据链式语法写的登录模块，具体的样式都可以自定制。
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
