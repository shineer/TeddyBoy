//
//  DDImageView.h
//  DingDingClient
//
//  Created by phoenix on 14-11-25.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDImageView : UIImageView

@property (nonatomic, strong) UIImage* placeholder;//占位图

// 设置图片地址
- (void)setImageUrl:(NSString*)url;
// 设置图片地址&占位图
- (void)setImageUrl:(NSString*)url placeholderImage:(UIImage*)placeholder;

@end
