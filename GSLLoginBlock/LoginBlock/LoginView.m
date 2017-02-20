//
//  LoginView.m
//  GSLLoginBlock
//
//  Created by 薛飞龙 on 2017/2/20.
//  Copyright © 2017年 薛飞龙. All rights reserved.
//

#import "LoginView.h"
#import "UIView+BMLine.h"
#import "SDAutoLayout.h"
#define MaxSeconds 30  //设置您需要倒计时的最大事件
#define CL(x) (x) * [UIScreen mainScreen].bounds.size.height / 667
//弱引用/强引用
#define XWeakSelf(type)  __weak typeof(type) weak##type = type;
#define XStrongSelf(type)  __strong typeof(type) type = weak##type;

// RGB颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]
// 字体大小(常规/粗体)
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]

@interface LoginView ()<UITextFieldDelegate>
/** 标题 */
@property (nonatomic, strong) NSString *titleString;
/** 描述 */
@property (nonatomic, strong) NSString *descString;
/** 验证码发送按钮是否显示 */
@property (nonatomic, assign) BOOL isShowCodeBtn;
/** 按钮的文字 */
@property (nonatomic, strong) NSString *btnTitle;
/** 按钮的背景颜色 */
@property (nonatomic, strong) UIColor *btnBackColor;
/** 位置 */
@property (nonatomic, assign) CGPoint position;
/** 大小 */
@property (nonatomic, assign) CGSize size;
/** 模式 */
@property (nonatomic, assign) LoginTextInputMode textMode;
/** UI输入框视图 */
@property (nonatomic, strong) UIView *inputView;
/** 输入框 */
@property (nonatomic, strong) UITextField *textFiled;


@end

@implementation LoginView
{
    
    UIView * textView;
    UIButton * nextBtn;
    UILabel * forgetLabel;
    UILabel * titleLabel;
    UILabel * descLabel;
    UIButton * timeBtn;
    NSTimer*  _timer;
    NSInteger _times;
    
    
    NSString    *_previousTextFieldContent;
    UITextRange *_previousSelection;
    
}
- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (LoginView *)with
{
    return self;
}

- (LoginView *(^)(NSString *))makeTitle
{
    XWeakSelf(self);
    
    return ^LoginView * (NSString * string){
        
        XStrongSelf(self);
        self.titleString = string;
        if (titleLabel) {
            titleLabel.text = self.titleString;
        }
        return self;
    };
    
}

- (LoginView *(^)(NSString *))makeDescString
{
    XWeakSelf(self);
    
    return ^LoginView * (NSString * string){
        XStrongSelf(self);
        self.descString = string;
        if (descLabel) {
            descLabel.text = self.descString;
        }
        return self;
    };
    
}
- (LoginView *(^)(NSString *))setBtnTitle
{
    XWeakSelf(self);
    return  ^LoginView * (NSString * string){
        XStrongSelf(self);
        self.btnTitle = string;
        if (nextBtn) {
            [nextBtn setTitle:self.btnTitle forState:UIControlStateNormal];
        }
        return self;
    };
}
- (LoginView *(^)(BOOL))showCodeBtn
{
    XWeakSelf(self);
    return  ^LoginView * (BOOL isOrNot){
        XStrongSelf(self);
        self.isShowCodeBtn = isOrNot;
        return self;
    };
}
- (LoginView *(^)(UIColor *))makeBtnColor
{
    XWeakSelf(self);
    return  ^LoginView * (UIColor * color){
        XStrongSelf(self);
        self.btnBackColor = color;
        if (nextBtn) {
            [nextBtn setBackgroundColor:self.btnBackColor];
        }
        return self;
    };
}
- (LoginView *(^)(CGFloat,CGFloat))makeCenter
{
    XWeakSelf(self);
    return ^LoginView * (CGFloat x, CGFloat y){
        XStrongSelf(self);
        self.position = CGPointMake(x, y);
        return self;
    };
}
- (LoginView *(^)(CGFloat,CGFloat))makeSize
{
    XWeakSelf(self);
    return ^LoginView * (CGFloat width, CGFloat height) {
        XStrongSelf(self);
        self.size = CGSizeMake(width, height);
        return self;
    };
}
- (LoginView *(^)(LoginTextInputMode))setTextMode
{
    XWeakSelf(self);
    return ^LoginView *(LoginTextInputMode mode) {
        XStrongSelf(self);
        self.textMode = mode;
        if (_inputView) {
            [_inputView removeFromSuperview];
            [timeBtn removeFromSuperview];
            switch (self.textMode) {
                case textPhoneField:
                {
                    
                    _inputView = [[UIView alloc] initWithFrame:CGRectMake(0, CL(85), CL(220), CL(45))];
                    _inputView.centerX = textView.center.x;
                    [_inputView addLineWithType:BMLineTypeCustomDefault color:UIColorFromRGB(0x6bd66a) position:BMLinePostionCustomAll];
                    {
                        UILabel * num = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CL(45), CL(45))];
                        num.text = @"+86";
                        num.textColor = UIColorFromRGB(0xffffff);
                        num.textAlignment = NSTextAlignmentCenter;
                        num.backgroundColor = UIColorFromRGB(0x6bd66a);
                        num.font = BOLDSYSTEMFONT(CL(18));
                        [_inputView addSubview:num];
                        
                        _textFiled = [[UITextField alloc] initWithFrame:CGRectMake(num.width + CL(15), 0, _inputView.width - num.width - CL(30), CL(45))];
                        _textFiled.delegate = self;
                        _textFiled.keyboardType = UIKeyboardTypePhonePad;
                        _textFiled.textColor = UIColorFromRGB(0x6bd66a);
                        _textFiled.font = BOLDSYSTEMFONT(CL(18));
                        [_textFiled addTarget:self action:@selector(phoneNum_tfChange:) forControlEvents:UIControlEventEditingChanged];
                        
                        [_inputView addSubview:_textFiled];
                        
                        
                    }
                    [textView addSubview:_inputView];
                    textView.frame = CGRectMake(0, 0, textView.width, CL(145));
                    nextBtn.frame = CGRectMake(0, textView.height + CL(5) , nextBtn.width, CL(45));
                }
                    break;
                case textCodeField:
                {
                    
                    timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    timeBtn.frame = CGRectMake(0, descLabel.height + descLabel.y + CL(10), CL(55), CL(20));
                    timeBtn.centerX = textView.center.x;
                    [timeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                    _times = MaxSeconds;
                    [timeBtn addLineWithType:BMLineTypeCustomDefault color:UIColorFromRGB(0xf2f2f2) position:BMLinePostionCustomAll];
                    [timeBtn addTarget:self action:@selector(startTimer) forControlEvents:UIControlEventTouchUpInside];
                    [textView addSubview:timeBtn];
                    
                    [self startTimer];
                    
                    _inputView = [[UIView alloc] initWithFrame:CGRectMake(0, CL(102), CL(220), CL(45))];
                    _inputView.centerX = textView.center.x;
                    [_inputView addLineWithType:BMLineTypeCustomDefault color:UIColorFromRGB(0x6bd66a) position:BMLinePostionCustomAll];
                    {
                        _textFiled = [[UITextField alloc] initWithFrame:CGRectMake(CL(15), 0, _inputView.width - CL(30), CL(45))];
                        _textFiled.delegate = self;
                        _textFiled.keyboardType = UIKeyboardTypeNumberPad;
                        _textFiled.textColor = UIColorFromRGB(0x6bd66a);
                        _textFiled.font = BOLDSYSTEMFONT(CL(18));
                        [_textFiled addTarget:self action:@selector(phoneCode_tfChange:) forControlEvents:UIControlEventEditingChanged];
                        
                        [_inputView addSubview:_textFiled];
                        
                        
                    }
                    [textView addSubview:_inputView];
                    textView.frame = CGRectMake(0, 0, textView.width, CL(162));
                    nextBtn.frame = CGRectMake(0, textView.height + CL(5) , nextBtn.width, CL(45));
                    
                }
                    break;
                case textPassField:
                {
                    _inputView = [[UIView alloc] initWithFrame:CGRectMake(0, CL(85), CL(220), CL(45))];
                    _inputView.centerX = textView.center.x;
                    [_inputView addLineWithType:BMLineTypeCustomDefault color:UIColorFromRGB(0x6bd66a) position:BMLinePostionCustomAll];
                    {
                        
                        _textFiled = [[UITextField alloc] initWithFrame:CGRectMake( CL(15), 0, _inputView.width - CL(30), CL(45))];
                        _textFiled.delegate = self;
                        _textFiled.keyboardType = UIKeyboardTypeASCIICapable;
                        _textFiled.textColor = UIColorFromRGB(0x6bd66a);
                        _textFiled.font = BOLDSYSTEMFONT(CL(18));
                        _textFiled.secureTextEntry = YES;
                        _textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
                        [_inputView addSubview:_textFiled];
                        
                        
                    }
                    [textView addSubview:_inputView];
                    textView.frame = CGRectMake(0, 0, textView.width, CL(145));
                    nextBtn.frame = CGRectMake(0, textView.height + CL(5) , nextBtn.width, CL(45));
                }
                    break;
                default:
                    break;
            }
            
        }
        
        return self;
        
    };
}


- (LoginView *(^)(UIView *))toView
{
    XWeakSelf(self);
    return ^LoginView * (UIView *superView) {
        XStrongSelf(self);
        CGRect rect = CGRectMake(0, 0,
                                 self.size.width, self.size.height);
        
        UIView *view = [[UIView alloc] initWithFrame:rect];
        view.center = CGPointMake(self.position.x, self.position.y);
        [view setBackgroundColor:[UIColor clearColor]];
        [self setUpSubViewsToView:view];
        
        [superView addSubview:view];
        return self;
    };
}





- (void)setUpSubViewsToView:(UIView *)view{
    
    textView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.width, CL(145))];
    if (self.textMode == textCodeField) {
        textView.frame = CGRectMake(0, 0, view.width, CL(162));
    }
    textView.backgroundColor = UIColorFromRGB(0xffffff);
    [view addSubview:textView];
    {
        titleLabel = [UILabel new];
        titleLabel.text = self.titleString;
        titleLabel.textColor = UIColorFromRGB(0x6bd66a);
        titleLabel.font = BOLDSYSTEMFONT(CL(18));
        titleLabel.size = CGSizeMake(textView.width - CL(84), CL(40));
        titleLabel.y = 0;
        titleLabel.centerX = textView.center.x;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [textView addSubview:titleLabel];
        
        descLabel = [UILabel new];
        descLabel.text = self.descString;
        descLabel.textColor = UIColorFromRGB(0xb2b2b2);
        descLabel.font = SYSTEMFONT(CL(14));
        CGSize sizl = [self sizeForTitle:descLabel.text withFont:descLabel.font];
        descLabel.size = CGSizeMake(titleLabel.width, sizl.height);
        descLabel.y = titleLabel.height;
        descLabel.centerX = textView.center.x;
        descLabel.textAlignment = NSTextAlignmentCenter;
        [textView addSubview:descLabel];
        
        
        switch (self.textMode) {
            case textPhoneField:
            {
                _inputView = [[UIView alloc] initWithFrame:CGRectMake(0, CL(85), CL(220), CL(45))];
                _inputView.centerX = textView.center.x;
                [_inputView addLineWithType:BMLineTypeCustomDefault color:UIColorFromRGB(0x6bd66a) position:BMLinePostionCustomAll];
                {
                    UILabel * num = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CL(45), CL(45))];
                    num.text = @"+86";
                    num.textColor = UIColorFromRGB(0xffffff);
                    num.textAlignment = NSTextAlignmentCenter;
                    num.backgroundColor = UIColorFromRGB(0x6bd66a);
                    num.font = BOLDSYSTEMFONT(CL(18));
                    [_inputView addSubview:num];
                    
                    _textFiled = [[UITextField alloc] initWithFrame:CGRectMake(num.width + CL(15), 0, _inputView.width - num.width - CL(30), CL(45))];
                    _textFiled.delegate = self;
                    _textFiled.keyboardType = UIKeyboardTypePhonePad;
                    _textFiled.textColor = UIColorFromRGB(0x6bd66a);
                    _textFiled.font = BOLDSYSTEMFONT(CL(18));
                    [_textFiled addTarget:self action:@selector(phoneNum_tfChange:) forControlEvents:UIControlEventEditingChanged];
                    
                    [_inputView addSubview:_textFiled];
                    
                    
                }
                [textView addSubview:_inputView];
            }
                break;
            case textCodeField:
            {
                
                timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                timeBtn.frame = CGRectMake(0, descLabel.height + descLabel.y + CL(10), CL(55), CL(20));
                [timeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                _times = MaxSeconds;
                [textView addSubview:timeBtn];
                
                
                _inputView = [[UIView alloc] initWithFrame:CGRectMake(0, CL(102), CL(220), CL(45))];
                _inputView.centerX = textView.center.x;
                [_inputView addLineWithType:BMLineTypeCustomDefault color:UIColorFromRGB(0x6bd66a) position:BMLinePostionCustomAll];
                {
                    _textFiled = [[UITextField alloc] initWithFrame:CGRectMake(CL(15), 0, _inputView.width - CL(30), CL(45))];
                    _textFiled.delegate = self;
                    _textFiled.keyboardType = UIKeyboardTypeNumberPad;
                    _textFiled.textColor = UIColorFromRGB(0x6bd66a);
                    _textFiled.font = BOLDSYSTEMFONT(CL(18));
                    [_textFiled addTarget:self action:@selector(phoneCode_tfChange:) forControlEvents:UIControlEventEditingChanged];
                    
                    [_inputView addSubview:_textFiled];
                    
                    
                }
                [textView addSubview:_inputView];
            }
                break;
            case textPassField:
            {
                _inputView = [[UIView alloc] initWithFrame:CGRectMake(0, CL(85), CL(220), CL(45))];
                _inputView.centerX = textView.center.x;
                [_inputView addLineWithType:BMLineTypeCustomDefault color:UIColorFromRGB(0x6bd66a) position:BMLinePostionCustomAll];
                {
                    
                    _textFiled = [[UITextField alloc] initWithFrame:CGRectMake( CL(15), 0, _inputView.width - CL(30), CL(45))];
                    _textFiled.delegate = self;
                    _textFiled.keyboardType = UIKeyboardTypeASCIICapable;
                    _textFiled.textColor = UIColorFromRGB(0x6bd66a);
                    _textFiled.font = BOLDSYSTEMFONT(CL(18));
                    _textFiled.secureTextEntry = YES;
                    _textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
                    [_inputView addSubview:_textFiled];
                    
                    
                }
                [textView addSubview:_inputView];
            }
                break;
            default:
                break;
        }
        
        
        
    }
    
    nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(0, textView.height + CL(5) , view.width, CL(45));
    [nextBtn setBackgroundColor:self.btnBackColor];
    [nextBtn setTitle:self.btnTitle forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:nextBtn];
}

- (void)nextBtnClick
{
    if (_nextClick) {
        _nextClick();
    }
    
}


#pragma mark - 方法
- (CGSize)sizeForTitle:(NSString *)title withFont:(UIFont *)font
{
    CGRect titleRect = [title boundingRectWithSize:CGSizeMake(FLT_MAX, FLT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName : font}
                                           context:nil];
    
    return CGSizeMake(titleRect.size.width,
                      titleRect.size.height);
}

#pragma mark - 实时更新输入框
- (void)phoneNum_tfChange:(UITextField *)textField
{
    /**
     *  判断正确的光标位置
     */
    NSUInteger targetCursorPostion = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
    NSString *phoneNumberWithoutSpaces = [self removeNonDigits:textField.text andPreserveCursorPosition:&targetCursorPostion];
    
    if([phoneNumberWithoutSpaces length]>11)
    {
        /**
         *  避免超过11位的输入
         */
        
        [textField setText:_previousTextFieldContent];
        textField.selectedTextRange = _previousSelection;
        
        return;
    }
    if ([phoneNumberWithoutSpaces length]>=11)
    {
        
        [textField resignFirstResponder];
        
        
        
    }
    //号码小于11位
    else
    {
        
    }
    
    if (_textFiled.text.length > 0)
    {
        //        if (SCREEN_W < 375)
        //        {
        //            phoneNum_tf.font = [UIFont systemFontOfSize:21];
        //        }
        //        else
        //        {
        //            phoneNum_tf.font = [UIFont systemFontOfSize:24];
        //        }
    }
    else
    {
        //        phoneNum_tf.font = [UIFont systemFontOfSize:19];
    }
    
    NSString *phoneNumberWithSpaces = [self insertSpacesPhoneEveryFourDigitsIntoString:phoneNumberWithoutSpaces andPreserveCursorPosition:&targetCursorPostion];
    
    textField.text = phoneNumberWithSpaces;
    UITextPosition *targetPostion = [textField positionFromPosition:textField.beginningOfDocument offset:targetCursorPostion];
    [textField setSelectedTextRange:[textField textRangeFromPosition:targetPostion toPosition:targetPostion]];
}

- (void)phoneCode_tfChange:(UITextField *)textField
{
    /**
     *  判断正确的光标位置
     */
    NSUInteger targetCursorPostion = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
    NSString *phoneNumberWithoutSpaces = [self removeNonDigits:textField.text andPreserveCursorPosition:&targetCursorPostion];
    
    if([phoneNumberWithoutSpaces length]>4)
    {
        /**
         *  避免超过11位的输入
         */
        
        [textField setText:_previousTextFieldContent];
        textField.selectedTextRange = _previousSelection;
        
        return;
    }
    if ([phoneNumberWithoutSpaces length]>=4)
    {
        
        [textField resignFirstResponder];
        
        
        
    }
    //号码小于11位
    else
    {
        
    }
    
    if (_textFiled.text.length > 0)
    {
        //        if (SCREEN_W < 375)
        //        {
        //            phoneNum_tf.font = [UIFont systemFontOfSize:21];
        //        }
        //        else
        //        {
        //            phoneNum_tf.font = [UIFont systemFontOfSize:24];
        //        }
    }
    else
    {
        //        phoneNum_tf.font = [UIFont systemFontOfSize:19];
    }
    
    //    NSString *phoneNumberWithSpaces = [self insertSpacesCodeEveryFourDigitsIntoString:phoneNumberWithoutSpaces andPreserveCursorPosition:&targetCursorPostion];
    
    textField.text = phoneNumberWithoutSpaces;
    UITextPosition *targetPostion = [textField positionFromPosition:textField.beginningOfDocument offset:targetCursorPostion];
    [textField setSelectedTextRange:[textField textRangeFromPosition:targetPostion toPosition:targetPostion]];
}

/**
 *  除去非数字字符，确定光标正确位置
 *
 *  @param string         当前的string
 *  @param cursorPosition 光标位置
 *
 *  @return 处理过后的string
 */
- (NSString *)removeNonDigits:(NSString *)string andPreserveCursorPosition:(NSUInteger *)cursorPosition {
    NSUInteger originalCursorPosition =*cursorPosition;
    NSMutableString *digitsOnlyString = [NSMutableString new];
    
    for (NSUInteger i=0; i<string.length; i++) {
        unichar characterToAdd = [string characterAtIndex:i];
        
        if(isdigit(characterToAdd)) {
            NSString *stringToAdd = [NSString stringWithCharacters:&characterToAdd length:1];
            [digitsOnlyString appendString:stringToAdd];
        }
        else {
            if(i<originalCursorPosition) {
                (*cursorPosition)--;
            }
        }
    }
    return digitsOnlyString;
}

/**
 *  将空格插入我们现在的string 中，并确定我们光标的正确位置，防止在空格中
 *
 *  @param string         当前的string
 *  @param cursorPosition 光标位置
 *
 *  @return 处理后有空格的string
 */
- (NSString *)insertSpacesPhoneEveryFourDigitsIntoString:(NSString *)string andPreserveCursorPosition:(NSUInteger *)cursorPosition{
    NSMutableString *stringWithAddedSpaces = [NSMutableString new];
    NSUInteger cursorPositionInSpacelessString = *cursorPosition;
    
    for (NSUInteger i=0; i<string.length; i++) {
        if(i>0)
        {
            if(i==3 || i==7) {
                [stringWithAddedSpaces appendString:@" "];
                
                if(i<cursorPositionInSpacelessString) {
                    (*cursorPosition)++;
                }
            }
        }
        
        unichar characterToAdd = [string characterAtIndex:i];
        NSString *stringToAdd = [NSString stringWithCharacters:&characterToAdd length:1];
        [stringWithAddedSpaces appendString:stringToAdd];
    }
    return stringWithAddedSpaces;
}

- (NSString *)insertSpacesCodeEveryFourDigitsIntoString:(NSString *)string andPreserveCursorPosition:(NSUInteger *)cursorPosition{
    NSMutableString *stringWithAddedSpaces = [NSMutableString new];
    NSUInteger cursorPositionInSpacelessString = *cursorPosition;
    
    for (NSUInteger i=0; i<string.length; i++) {
        if(i>0)
        {
            if(i==1 || i==2 || i==3) {
                [stringWithAddedSpaces appendString:@"      "];
                
                if(i<cursorPositionInSpacelessString) {
                    (*cursorPosition)++;
                }
            }
        }
        
        unichar characterToAdd = [string characterAtIndex:i];
        NSString *stringToAdd = [NSString stringWithCharacters:&characterToAdd length:1];
        [stringWithAddedSpaces appendString:stringToAdd];
    }
    return stringWithAddedSpaces;
}

#pragma mark - UITextFieldDelegate 判断输入框是否还可以编辑
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    _previousSelection = textField.selectedTextRange;
    _previousTextFieldContent = textField.text;
    
    if(range.location==0) {
        if(string.integerValue >1)
        {
            return NO;
        }
    }
    
    return YES;
}


#pragma mark - 定时器
- (void)startTimer {
    timeBtn.userInteractionEnabled = NO;
    _times = MaxSeconds;
    _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(showLastTime) userInfo:nil repeats:YES];
    _timer.fireDate = [NSDate distantPast];
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}
- (void)showLastTime {
    if (_times < 0) {
        [_timer invalidate];
        _timer = nil;
        timeBtn.userInteractionEnabled = YES;
        [timeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        return;
    }
    
    timeBtn.userInteractionEnabled = NO;
    NSString* str = [NSString stringWithFormat:@"%lds重发",_times];
    [timeBtn setTitle:str forState:UIControlStateNormal];
    timeBtn.titleLabel.font = SYSTEMFONT(CL(12));
    [timeBtn setTitleColor:UIColorFromRGB(0xb2b2b2) forState:UIControlStateNormal];
    
    _times--;
}

@end
