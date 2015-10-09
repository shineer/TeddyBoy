//
//  DDSearchBar.h
//  DingDingClient
//
//  Created by phoenix on 15/7/24.
//  Copyright (c) 2015年 SEU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDSearchBar : UISearchBar

/**
 *  自定义控件自带的取消按钮的文字（默认为“取消”/“Cancel”）
 *
 *  @param title 自定义文字
 */
- (void)setCancelButtonTitle:(NSString *)title;

@end
