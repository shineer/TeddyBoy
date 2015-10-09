//
//  DDLoginViewController.m
//  DingDingClient
//
//  Created by phoenix on 14-10-14.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import "DDLoginViewController.h"
#import "DDDropDownList.h"

#define kMaxPhoneNumberLength   11
#define kMaxPasswordLength      6

@interface DDLoginViewController ()<UITextFieldDelegate, DDDropDownListDelegate>
{
    UIView* _backgroundView;
    UIView* _seperateLineView;
    UIImageView* _phoneNumberIcon;
    UIImageView* _verifyCodeIcon;
    UITextField* _account;
    UITextField* _password;
    UIButton* _dropDownListBtn;
    DDButton* _getVerifyCodeBtn;
    
    DDButton* _enviromentBtn;
    
    DDDropDownList* _accountList;
    DDDropDownList* _enviromentList;
    
    DDButton* _loginBtn;
    UIButton* _closeBtn;
}

@property (nonatomic, strong) NSDictionary* enviromentDic;

@end

@implementation DDLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        self.enviromentDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:EDDHostType_Production], @"生产环境",
                              [NSNumber numberWithInt:EDDHostType_Development], @"测试环境",
                              nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.blurStyle = UIBlurEffectStyleDark;
    
    // 初始化控件
    [self setup];
    // 自动布局
    [self layout];
}

- (void)setup
{
    _backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    _backgroundView.backgroundColor = DD_THEME.colorWhite;
    [self.view addSubview:_backgroundView];
    
    _seperateLineView = [[UIView alloc] initWithFrame:CGRectZero];
    _seperateLineView.backgroundColor = DD_THEME.colorSeperateLine;
    [self.view addSubview:_seperateLineView];
    
    _phoneNumberIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    _phoneNumberIcon.contentMode = UIViewContentModeCenter;
    _phoneNumberIcon.image = [UIImage imageNamed:@"login_icon_phone"];
    [self.view addSubview:_phoneNumberIcon];
    
    _verifyCodeIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    _verifyCodeIcon.contentMode = UIViewContentModeCenter;
    _verifyCodeIcon.image = [UIImage imageNamed:@"login_icon_lock"];
    [self.view addSubview:_verifyCodeIcon];
    
    _account = [[UITextField alloc] initWithFrame:CGRectZero];
    _account.delegate = self;
    _account.borderStyle = UITextBorderStyleNone;
    _account.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _account.textAlignment = NSTextAlignmentLeft;
    //_account.backgroundColor = [UIColor yellowColor];
    _account.textColor = DD_THEME.colorBlack;
    _account.font = [UIFont systemFontOfSize:DD_THEME.fontSizeMiddle];
    _account.text = @"";
    _account.keyboardType = UIKeyboardTypeNumberPad;
    _account.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:@{NSForegroundColorAttributeName:DD_THEME.colorLightGray, NSFontAttributeName: [UIFont systemFontOfSize:DD_THEME.fontSizeMiddle]}];
    [_account setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.view addSubview:_account];
    
    _dropDownListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_dropDownListBtn setImage:[UIImage imageNamed:@"drop_down_list_arrow_normal"] forState:UIControlStateNormal];
    [_dropDownListBtn setImage:[UIImage imageNamed:@"drop_down_list_arrow_press"] forState:UIControlStateHighlighted];
    [_dropDownListBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //_dropDownListBtn.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_dropDownListBtn];
    
    _password = [[UITextField alloc] initWithFrame:CGRectZero];
    _password.delegate = self;
    _password.secureTextEntry = YES;
    _password.borderStyle = UITextBorderStyleNone;
    _password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _password.textAlignment = NSTextAlignmentLeft;
    //_password.backgroundColor = [UIColor yellowColor];
    _password.textColor = DD_THEME.colorBlack;
    _password.font = [UIFont systemFontOfSize:DD_THEME.fontSizeSmall];
    _password.text = @"";
    _password.keyboardType = UIKeyboardTypeNumberPad;
    _password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"验证码" attributes:@{NSForegroundColorAttributeName: DD_THEME.colorLightGray, NSFontAttributeName: [UIFont systemFontOfSize:DD_THEME.fontSizeMiddle]}];
    [_password setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.view addSubview:_password];
    
    _getVerifyCodeBtn = [[DDButton alloc] init];
    _getVerifyCodeBtn.type = EDDBtnType_Default;
    [_getVerifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getVerifyCodeBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_getVerifyCodeBtn];
    
    _loginBtn = [[DDButton alloc] init];
    _loginBtn.type = EDDBtnType_Yellow;
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _loginBtn.enabled = NO;
    [self.view addSubview:_loginBtn];
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setImage:[UIImage imageNamed:@"login_icon_close"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //_closeBtn.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_closeBtn];
    
    // 判断当前是什么环境
    NSString* name = nil;
    EDDHostType hostType = APP_UTILITY.appSetting.hostType;
    if(hostType == EDDHostType_Production)
    {
        name = @"生产环境";
    }
    else if(hostType == EDDHostType_Development)
    {
        name = @"测试环境";
    }
    else
    {
        name = @"未知环境";
    }
    _enviromentBtn = [[DDButton alloc] init];
    _enviromentBtn.type = EDDBtnType_Green;
    [_enviromentBtn setTitle:[NSString stringWithFormat:@"选择环境(%@)", name] forState:UIControlStateNormal];
    [_enviromentBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_enviromentBtn];
}

- (void)layout
{
    UIView *superview = self.view;
    
    CGFloat height = DD_THEME.tableRowHeight * 2;
    CGFloat xOffset = DD_THEME.xMargin;
    CGFloat yOffset = DD_THEME.yMargin;
    CGFloat xMargin = 20.0;
    
    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.greaterThanOrEqualTo(superview.mas_top).offset(64 + 44);
        make.left.equalTo(superview.mas_left).offset(xMargin);
        make.right.equalTo(superview.mas_right).offset(-xMargin);
        
        make.height.equalTo(@(height));
    }];
    
    [_seperateLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(_backgroundView);

        make.width.equalTo(_backgroundView);
        make.height.equalTo(@0.5);
    }];
    
    UIImage* image = [UIImage imageNamed:@"login_icon_phone"];
    height = height / 2;
    yOffset = (height - image.size.height) / 2;
    [_phoneNumberIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_backgroundView.mas_top).offset(yOffset);
        make.left.equalTo(_backgroundView.mas_left).offset(xOffset);

        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    [_verifyCodeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(_backgroundView.mas_bottom).offset(-yOffset);
        make.left.equalTo(_backgroundView.mas_left).offset(xOffset);
        
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    yOffset = 4;
    [_dropDownListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_backgroundView.mas_right).offset(-xOffset);
        make.top.equalTo(_backgroundView.mas_top).offset(yOffset);
        
        make.width.equalTo(@40);
        make.height.equalTo(@(height - yOffset * 2));
    }];
    
    yOffset = DD_THEME.yMargin;
    [_account mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_backgroundView.mas_top).offset(yOffset);
        make.left.equalTo(_phoneNumberIcon.mas_right).offset(xOffset);
        make.right.equalTo(_dropDownListBtn.mas_left).offset(-xOffset);
        
        make.height.equalTo(@(height - yOffset * 2));
    }];
    
    yOffset = 4;
    [_getVerifyCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_backgroundView.mas_right).offset(-xOffset);
        make.bottom.equalTo(_backgroundView.mas_bottom).offset(-yOffset);
        
        make.width.equalTo(@100);
        make.height.equalTo(@(height - yOffset * 2));
    }];
    
    yOffset = DD_THEME.yMargin;
    [_password mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_verifyCodeIcon.mas_right).offset(xOffset);
        make.right.equalTo(_getVerifyCodeBtn.mas_left).offset(-xOffset);
        make.bottom.equalTo(_backgroundView.mas_bottom).offset(-yOffset);
        
        make.height.equalTo(@(height - yOffset * 2));
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_backgroundView);
        make.right.equalTo(_backgroundView);
        make.top.equalTo(_backgroundView.mas_bottom).offset(64);
        
        make.height.equalTo(@(DD_THEME.buttonHeight));
    }];

    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(superview);
        make.bottom.equalTo(superview.mas_bottom).offset(-44);

        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];
    
    [_enviromentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_backgroundView);
        make.right.equalTo(_backgroundView);
        make.top.equalTo(_loginBtn.mas_bottom).offset(DD_THEME.yMargin);
        
        make.height.equalTo(@(DD_THEME.buttonHeight));
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleLoginStateChanged)
                                                 name:kNotificationLoginStateChanged
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChanged)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    
    if([APP_UTILITY.currentUser.account isEqualToString:@"Guest"])
    {
        _account.text = @"";
        _password.text = @"";
    }
    else
    {
        _account.text = APP_UTILITY.currentUser.account;
        _password.text = @"";
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action

- (void)btnClicked:(id)sender
{
    if(sender == _getVerifyCodeBtn)
    {
        if(_account.text.length == 0 )
        {
            [DDHUDVIEW showTips:[NSString stringWithFormat:@"请输入手机号"] autoHideTime:2];
            return;
        }
        else if([CommonUtils isValidateMobileNumber:_account.text] == NO)
        {
            [DDHUDVIEW showTips:[NSString stringWithFormat:@"号码格式错误"] autoHideTime:2];
            return;
        }
        
        // 设置按钮不可点击
        [_getVerifyCodeBtn setEnabled:NO];
        
        // 开始倒计时
        [UtilFunc countDown:60 complete:^{
            
            [_getVerifyCodeBtn setEnabled:YES];
            [_getVerifyCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
            
        } progress:^(id time) {
            
            [_getVerifyCodeBtn setTitle:time forState:UIControlStateNormal];
        }];
        
        // 向服务器请求验证码: type 验证码类型 1:登录 2:签约 3:其他
        [DD_CORE.userService getVerificationCode:_account.text type:1 resopnse:^(NSInteger result, NSDictionary *dict, DDError *error) {
            
            if(result == EDDResponseResultSucceed)
            {
                UI_LOG(@"\n---- 获取验证码成功 ----");
                
            }// end of 登录成功
            else
            {
                UI_LOG(@"\n---- 获取验证码失败 %@ ----", error.errorMsg);
            }

        }];
    }
    else if(sender == _loginBtn)
    {
        if(_account.text.length == 0 || _password.text.length == 0)
        {
            [DDHUDVIEW showTips:[NSString stringWithFormat:@"请输入手机号或验证码"] autoHideTime:2];
            return;
        }
        else if([CommonUtils isValidateMobileNumber:_account.text] == NO)
        {
            [DDHUDVIEW showTips:[NSString stringWithFormat:@"号码格式错误"] autoHideTime:2];
            return;
        }
        
        [self hideKeyboard];
        
        [[DDLoginManager getInstance] startLogin:_account.text  password:_password.text type:0];
    }
    else if(sender == _closeBtn)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if(sender == _dropDownListBtn)
    {
        [_account resignFirstResponder];
        [_password resignFirstResponder];
        
        CGRect rect = _account.frame;
        rect = CGRectOffset(rect, 0, rect.size.height);
        rect.size.height = 4 * DD_THEME.tableRowHeight;
        
        if(_accountList == nil)
        {
            _accountList = [[DDDropDownList alloc] init];
            _accountList.delegate = self;
            NSMutableArray* array = [[NSMutableArray alloc] init];
            for(NSString* obj in [APP_UTILITY.appSetting.userAccountDic allKeys])
            {
                [array addObject:obj];
            }
            _accountList.contentArray = array;
        }
        
        _accountList.frame = rect;
        [_accountList showInView:self.view];
    }
    else if(sender == _enviromentBtn)
    {
        [_account resignFirstResponder];
        [_password resignFirstResponder];
        
        CGRect rect = _enviromentBtn.frame;
        rect = CGRectOffset(rect, 0, rect.size.height);
        rect.size.height = 2 * DD_THEME.tableRowHeight;
        
        if(_enviromentList == nil)
        {
            _enviromentList = [[DDDropDownList alloc] init];
            _enviromentList.isEnableDelete = NO;
            _enviromentList.delegate = self;
            NSMutableArray* array = [[NSMutableArray alloc] init];
            for(NSString* obj in [self.enviromentDic allKeys])
            {
                [array addObject:obj];
            }
            _enviromentList.contentArray = array;
        }
        
        _enviromentList.frame = rect;
        [_enviromentList showInView:self.view];
    }
}

-(void)backBtnClicked:(id)sennder
{
    [AppNavigator popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

// 当点触textField内部，开始编辑都会调用这个方法。textField将成为first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 先判断位数是否超出
    if(_account == textField)
    {
        if([textField.text length] >= kMaxPhoneNumberLength && range.length != 1)
            return NO; // return NO to not change text
    }
    else if(_password == textField)
    {
        if (range.location >= kMaxPasswordLength)
            return NO; // return NO to not change text
    }
    
    // 再判断是否是数字
    if(_account == textField || _password == textField)
    {
        NSCharacterSet *cs;
        // 去反字符，把所有的除了数字的字符都找出来
        cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        // 把输入框输入的字符string根据cs中字符一个一个去除，cs字符分割成单字符并转化为NSArray
        // 把NSArray的字符通过“”无间隔连接成一个NSString字符赋给filtered
        // 最后只剩数字
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        
        return basicTest;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    if(_account == textField)
    {
        if([textField.text length] > kMaxPhoneNumberLength)
        {
            NSString *tempText = textField.text;
            textField.text = [tempText substringToIndex:kMaxPhoneNumberLength];
        }
    }
    else if(_password == textField)
    {
        if ([textField.text length] > kMaxPasswordLength)
        {
            NSString *tempText = textField.text;
            textField.text = [tempText substringToIndex:kMaxPasswordLength];
        }
    }
}


#pragma mark - handle touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKeyboard];
}

- (void)hideKeyboard
{
    [self.view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        [((UIView*)obj) resignFirstResponder];
    }];
}

#pragma mark - DDDropDownListDelegate

- (void)dropDownList:(DDDropDownList*)sender didSelectedIndex:(NSInteger)index
{
    
    if(sender == _accountList)
    {
        NSString* account = [sender.contentArray objectAtIndex:index];
        NSString* password = @"";
        
        _account.text = account;
        _password.text = password;
    }
    else if(sender == _enviromentList)
    {
        /*  
            注意环境选项变化后系统会立马重置当前环境
            用户需要重新用对应该环境的账号登录
            然后退出应用
            最后重启
         */
        NSString* enviroment = [sender.contentArray objectAtIndex:index];
        [_enviromentBtn setTitle:[NSString stringWithFormat:@"选择环境(%@)", enviroment] forState:UIControlStateNormal];
        APP_UTILITY.appSetting.hostType = [[self.enviromentDic objectForKey:enviroment] intValue];
        [APP_UTILITY saveAppSetting];
        // 环境发生变化需要重置app上下文
        [APP_UTILITY resetAppEnvirement];
    }
}

- (void)dropDownList:(DDDropDownList*)sender didDeleteIndex:(NSInteger)index
{
    NSString* account = [sender.contentArray objectAtIndex:index];
    
    if(account && account.length > 0)
    {
        [APP_UTILITY.appSetting.userAccountDic removeObjectForKey:account];
        [APP_UTILITY saveAppSetting];
    }
    
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for(NSString* obj in [APP_UTILITY.appSetting.userAccountDic allKeys])
    {
        [array addObject:obj];
    }
    sender.contentArray = array;
    
}

- (void)dropDownListDidCancel
{
    // do nothing!
}

#pragma mark - Notification

- (void)handleLoginStateChanged
{
    if([DDLoginManager getInstance].loginState == EDDStatusLogined)
    {
        [DDHUDVIEW showTips:@"登录成功" autoHideTime:1];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if([DDLoginManager getInstance].loginState == EDDStatusNotLogin)
    {
        [DDHUDVIEW showTips:@"未登录" autoHideTime:1];
    }
}

- (void)textFieldDidChanged
{
    if(_account.text.length >= kMaxPhoneNumberLength && _password.text.length >= kMaxPasswordLength)
    {
        _loginBtn.enabled = YES;
    }
    else
    {
        _loginBtn.enabled = NO;
    }
}

@end
