//
//  DDBaseViewController.m
//  DingDingClient
//
//  Created by phoenix on 14-10-10.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import "DDBaseViewController.h"

@implementation DDBaseViewController

- (void)dealloc
{
    NSLog(@"%@----界面释放了！", [self class]);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
   
    // 背景色
    self.view.backgroundColor = DD_THEME.colorBackground;
    
    // 导航条背景色
    [self.navigationController.navigationBar lt_setBackgroundColor:DD_THEME.colorNavigationBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 标题栏
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 176, 46)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font =[UIFont systemFontOfSize:DD_THEME.fontSizeLarge];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = DD_THEME.colorWhite;
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;;
    titleLabel.text = @"";
    self.navigationTitleLabel = titleLabel;
    self.navigationItem.titleView = titleLabel;
    
    // 导航栏
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    // 滑动返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    
    // 自定义状态栏style
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    // 开启log模式
    UITapGestureRecognizer* recognizer = NULL;
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleShowLogConsole:)];
    recognizer.numberOfTouchesRequired = 2;//手指数
    recognizer.numberOfTapsRequired = 3;//点击次数
    [self.view addGestureRecognizer:recognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)handleShowLogConsole:(UISwipeGestureRecognizer*)recognizer
{
    // 手势调出log界面
    ShowConsoleLogView(self);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 当前视图是否正在显示，假如显示返回为YES，假如不显示返回NO
- (BOOL)isCurrentViewControllerVisible
{
    return (self.isViewLoaded && self.view.window);
}

#pragma mark Navigation Text Button

- (void)setLeftBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    
    negativeSpacer.width = 0;
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, barButtonItem, nil];
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];

    negativeSpacer.width = 0;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, barButtonItem, nil];
}

- (UIBarButtonItem *)leftBarButtonItem
{
    if (self.navigationItem.leftBarButtonItems != nil && self.navigationItem.leftBarButtonItems.count == 0)
    {
        return nil;
    }
    
    return self.navigationItem.leftBarButtonItems.lastObject;
}

- (UIBarButtonItem *)rightBarButtonItem
{
    if (self.navigationItem.rightBarButtonItem != nil && self.navigationItem.rightBarButtonItems.count == 0)
    {
        return nil;
    }
    
    return self.navigationItem.rightBarButtonItems.lastObject;
}

- (void)customlizeNavigationBarBackBtn
{
    // 自定义返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0.0, 0.0, 50.0, 44.0);
    [backButton setImage:[UIImage imageNamed:@"nav_btn_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"nav_btn_back"] forState:UIControlStateHighlighted];
    //做偏移操作
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    //[backButton setBackgroundColor:[UIColor yellowColor]];
    UIBarButtonItem *backBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    backBarBtnItem.style = UIBarButtonItemStylePlain;
    
    [self setLeftBarButtonItem:backBarBtnItem];
}

#pragma mark Navigation leftBackBarItem action

- (IBAction)backAction
{
    [AppNavigator popViewControllerAnimated:YES];
}

@end
