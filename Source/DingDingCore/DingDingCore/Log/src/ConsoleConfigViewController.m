//
//  ConsoleConfigViewController.m
//  Fetion
//
//  Created by born on 13-12-6.
//  Copyright (c) 2013年 xinrui.com. All rights reserved.
//

#import "ConsoleConfigViewController.h"
#import "ConsoleLogInterface.h"
#import "../src/mongoose/MongooseDaemon.h"

int  getLogListSize();
bool GetConsoleLogEnable(ConsoleLogEnum type);
char* GetConsoleLogName(ConsoleLogEnum type);
void SetConsoleLogEnable(ConsoleLogEnum type,bool flag);

@interface ConsoleConfigViewController ()
{
    MongooseDaemon    *mongooseDaemon;
}
@end


@implementation ConsoleConfigViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    [mongooseDaemon stopMongooseDaemon];
    [mongooseDaemon release];
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor grayColor];
    
    int baseY = 20;
    int height = 40;
    int offsetY = 20;

    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    if (([[UIDevice currentDevice].systemVersion floatValue]) >=7.0) {
        CGRect rect = scrollView.frame;
        rect.origin.y += (44+22);
        rect.size.height -= (44+22);
        scrollView.frame = rect;
    }
    
    scrollView.contentSize = CGSizeMake(320,1800);
    [self.view addSubview:scrollView];
    [scrollView release];
    
    for(int i = 0; i < getLogListSize(); i++)
    {
        UILabel* descript = [[UILabel alloc] initWithFrame:CGRectMake(30, baseY + (i*(height+offsetY)), 100, 30)];
        descript.backgroundColor = [UIColor clearColor];
        descript.text = [NSString stringWithUTF8String:GetConsoleLogName(i)];
        descript.textColor = [UIColor blueColor];
        [scrollView addSubview:descript];
        [descript release];
        
        UISwitch* pswitch = [[UISwitch alloc] initWithFrame:CGRectMake(160, baseY + (i*(height+offsetY)), 80, height)];
        [pswitch addTarget:self action:@selector(switchLog:) forControlEvents:UIControlEventValueChanged];
        pswitch.tag = i;
        [pswitch setOn:GetConsoleLogEnable(i)];
        [scrollView addSubview:pswitch];
        [pswitch release];
    }
    
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 60, 34);
    [rightButton addTarget:self action:@selector(openhttpSvr) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"http" forState:UIControlStateNormal];
    rightButton.titleLabel.textColor = [UIColor whiteColor];
    rightButton.backgroundColor = [UIColor darkGrayColor];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    [rightBarButton release];
}

-(void)openhttpSvr
{
    mongooseDaemon = [[MongooseDaemon alloc] init];
    [mongooseDaemon startMongooseDaemon:@"8080"];
}

-(void)switchLog:(UISwitch*)sender
{
    if (sender.tag < 0 || sender.tag >= getLogListSize()) {
        return;
    }
    
    SetConsoleLogEnable(sender.tag, sender.on);
//    configList[sender.tag].openFlag = sender.on;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"Console-Config";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
