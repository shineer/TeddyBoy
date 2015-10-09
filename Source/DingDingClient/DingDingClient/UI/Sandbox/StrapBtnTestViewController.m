//
//  StrapBtnTestViewController.m
//  DingDingClient
//
//  Created by phoenix on 14-10-15.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import "StrapBtnTestViewController.h"
#import "UIButton+Bootstrap.h"

@implementation StrapBtnTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.defaultButton defaultStyle];
    [self.primaryButton primaryStyle];
    [self.successButton successStyle];
    [self.infoButton infoStyle];
    [self.warningButton warningStyle];
    [self.dangerButton dangerStyle];
    
    [self.bookmarkButton primaryStyle];
    [self.bookmarkButton addAwesomeIcon:FAIconBookmark beforeTitle:YES];
    
    [self.doneButton successStyle];
    [self.doneButton addAwesomeIcon:FAIconCheck beforeTitle:NO];
    
    [self.deleteButton dangerStyle];
    [self.deleteButton addAwesomeIcon:FAIconRemove beforeTitle:YES];
    
    [self.downloadButton defaultStyle];
    [self.downloadButton addAwesomeIcon:FAIconDownloadAlt beforeTitle:NO];
    
    [self.calendarButton infoStyle];
    [self.calendarButton addAwesomeIcon:FAIconCalendar beforeTitle:NO];
    
    [self.favoriteButton warningStyle];
    [self.favoriteButton addAwesomeIcon:FAIconStar beforeTitle:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
