//
//  DDBaseViewController.h
//  DingDingClient
//
//  Created by phoenix on 14-10-10.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationBar+Awesome.h"

@interface DDBaseViewController : UIViewController

@property (nonatomic, strong) UILabel * navigationTitleLabel;

#pragma mark Navigation Text Button

- (void)setLeftBarButtonItem:(UIBarButtonItem *)barButtonItem;
- (void)setRightBarButtonItem:(UIBarButtonItem *)barButtonItem;

- (UIBarButtonItem *)leftBarButtonItem;
- (UIBarButtonItem *)rightBarButtonItem;

- (void)customlizeNavigationBarBackBtn;

- (BOOL)isCurrentViewControllerVisible;

- (IBAction)backAction;

@end
