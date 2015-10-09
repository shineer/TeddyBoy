//
//  DDButton.h
//  DingDingClient
//
//  Created by phoenix on 14-10-17.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Bootstrap.h"

// 按钮类型
typedef enum
{
    EDDBtnType_Default = 0,                         //默认按钮
    EDDBtnType_Blue,                                //蓝色风格
    EDDBtnType_LightBlue,                           //天蓝风格
    EDDBtnType_Green,                               //绿色风格
    EDDBtnType_Yellow,                              //黄色风格
    EDDBtnType_Red                                  //红色风格
}EDDBtnType;

@interface DDButton : UIButton
{
    EDDBtnType      _type;
}

- (id)initWithType:(EDDBtnType)type;

@property (nonatomic) EDDBtnType type;

@end
