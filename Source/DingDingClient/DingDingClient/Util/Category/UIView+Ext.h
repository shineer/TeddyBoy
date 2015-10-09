//
//  UIView+Ext.h
//  DingDingClient
//
//  Created by phoenix on 14-10-10.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<QuartzCore/QuartzCore.h>

@class EaseBlankPageView;

// 通知类型
typedef enum
{
    EaseBlankPageTypeView = 0,
    EaseBlankPageTypeActivity,
    EaseBlankPageTypeTask,
    EaseBlankPageTypeTopic,
    EaseBlankPageTypeTweet,
    EaseBlankPageTypeTweetOther,
    EaseBlankPageTypeProject,
    EaseBlankPageTypeFileDleted,
    EaseBlankPageTypeFolderDleted,
    EaseBlankPageTypePrivateMsg
    
}EDDEaseBlankPageType;

@interface UIView (IdentifierAddition)

// EaseBlankPageView
@property (strong, nonatomic) EaseBlankPageView *blankPageView;
- (void)configBlankPage:(EDDEaseBlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void(^)(id sender))block;

@end

@interface EaseBlankPageView : UIView

@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *tipLabel;
@property (strong, nonatomic) UIButton *reloadButton;
@property (copy, nonatomic) void(^reloadButtonBlock)(id sender);
- (void)configWithType:(EDDEaseBlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void(^)(id sender))block;

@end