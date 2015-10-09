//
//  ConsoleViewController.m
//  lezhuliEnterpriseEx
//
//  Created by born on 13-1-8.
//
//

#import "ConsoleViewController.h"
#import "Log.h"
#import "ConsoleConfigViewController.h"
#import <QuartzCore/QuartzCore.h>
#include "stdio.h"





////////////////////////////////////////////////////////////////////////
@interface ConsoleLogItem : NSObject
@property(nonatomic,retain)NSString* content;
@property(nonatomic,retain)NSDate* time;
@property(nonatomic,retain)NSString* method;
@property(nonatomic,assign)int line;
@end

@implementation ConsoleLogItem
@synthesize content = _content;
@synthesize time = _time;
@synthesize method = _method;
@synthesize line = _line;


@end
NSMutableDictionary * s_consoleLogArray;




////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////

static UINavigationController* s_consoleNav = NULL;
static NSMutableString* m_msg = NULL;
#define MAX_CONSOLE_TEXT_LENGTH 20*1024

@interface ConsoleViewController ()
{
    UITextView* _console;
    BOOL    _visiable;
}
-(void)appendMsg:(NSString*)msg;
@end

@implementation ConsoleViewController
+(UIViewController*)shareConsoleVC
{
    if ([[ConsoleViewController shareSingleton].viewControllers count]) {
        return [[ConsoleViewController shareSingleton].viewControllers objectAtIndex:0];
    }
    return NULL;
}

+(UINavigationController*)shareSingleton
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#ifdef RELEASE_APP//发布AppStore
#else
        ConsoleViewController*vc = [[ConsoleViewController alloc] init];
        s_consoleNav = [[UINavigationController alloc] initWithRootViewController:vc];
        [vc release];
#endif
    });
    
    return s_consoleNav;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    if (self = [super init]) {
        if (m_msg == NULL)
        {
            m_msg = [[NSMutableString alloc] init];
            [self appendMsg:@"-----log start-----\r"];
        }
    }
    return self;
}

- (void)dealloc
{
    s_consoleNav = NULL;
    
    [_console release];
    _console = NULL;
    [m_msg release];
    m_msg = NULL;
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
#define BUTTON_H 50
    self.view.backgroundColor = [UIColor blackColor];
    CGRect rect = [UIScreen mainScreen].bounds;
    rect.size.height -= (44+20+BUTTON_H);
    CGRect viewRect = rect;
    viewRect.size.width = 320;
    if (([[UIDevice currentDevice].systemVersion floatValue]) >=7.0) {
        rect.origin.y = (44+22);
        viewRect = rect;
    }
    
    _console = [[UITextView alloc] initWithFrame:viewRect];
    [self.view addSubview:_console];
    _console.textColor = [UIColor greenColor];
    _console.editable = NO;
    _console.contentSize = CGSizeMake(640,viewRect.size.height);
    _console.scrollEnabled = YES;
    _console.showsVerticalScrollIndicator = YES;
    _console.showsHorizontalScrollIndicator = YES;
    _console.layer.borderWidth = 1;
    _console.layer.borderColor = [UIColor greenColor].CGColor;
    _console.backgroundColor = [UIColor clearColor];
    
    rect.size.width = rect.size.width/2.f;
    rect.origin.y = rect.size.height;
    if (([[UIDevice currentDevice].systemVersion floatValue]) >=7.0) {
        rect.origin.y += (44+22);
    }

    rect.size.height = 50;
    UIButton* hideBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    hideBt.frame = rect;
    [hideBt setTitle:@"clear" forState:UIControlStateNormal];
    [hideBt addTarget:self action:@selector(clearConsole) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hideBt];
    
    rect.origin.x = [UIScreen mainScreen].bounds.size.width /2.f;
    UIButton* settingBT = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    settingBT.frame = rect;
    [settingBT setTitle:@"config" forState:UIControlStateNormal];
    [settingBT addTarget:self action:@selector(configConsole) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingBT];
    
    
    UIButton *hideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    hideButton.frame = CGRectMake(0, 0, 60, 34);
    [hideButton addTarget:self action:@selector(hideConsole) forControlEvents:UIControlEventTouchUpInside];
    [hideButton setTitle:@"close" forState:UIControlStateNormal];
    hideButton.titleLabel.textColor = [UIColor whiteColor];
    hideButton.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:hideButton];
    self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];

}

-(void)clearConsole
{
    [m_msg setString:@""];

    _console.text = m_msg;
    _console.contentOffset = CGPointMake(0, _console.contentSize.height - _console.frame.size.height);
}

-(void)configConsole
{
    ConsoleConfigViewController* ccvc = [[ConsoleConfigViewController alloc] init];
    [self.navigationController pushViewController:ccvc animated:YES];
    [ccvc release];
}

- (void)hideConsole
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        //
    }];
    //[self dismissModalViewControllerAnimated:YES];
}

-(void)appendOnMainThread:(NSString*)msg
{
    if (m_msg.length > MAX_CONSOLE_TEXT_LENGTH) {
        [self clearConsole];
        [m_msg appendString:@"clear log\t"];
    }
    
    [m_msg appendString:msg];
    if (self.navigationController.topViewController != self)
    {
        return;
    }
    _console.text = m_msg;
}

-(void)appendMsg:(NSString*)msg
{
    /**
     * fixed bug: crash while appendMsg in sub thread
     */
    if ([NSThread isMainThread]) {
        [self appendOnMainThread:msg];
        
    }else{
        __block typeof(self) _self = self;
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_self appendOnMainThread:msg];
        });
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"Console-Debug";
}

- (void)viewWillAppear:(BOOL)animated
{
    _visiable = true;
    if (m_msg) {
        _console.text = m_msg;
        _console.contentOffset = CGPointMake(0, _console.contentSize.height - _console.frame.size.height);
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    _visiable = false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end





