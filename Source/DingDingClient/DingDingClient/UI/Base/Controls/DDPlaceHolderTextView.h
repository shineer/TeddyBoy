//
//  DDPlaceHolderTextView.h
//  DingDingClient
//
//  Created by phoenix on 15-4-17.
//  Copyright (c) 2015年 SEU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDPlaceHolderTextView : UITextView

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

- (void)textChanged:(NSNotification*)notification;

@end
