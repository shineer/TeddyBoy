//
//  DDButton.m
//  DingDingClient
//
//  Created by phoenix on 14-10-17.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import "DDButton.h"

@implementation DDButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (id)initWithType:(EDDBtnType)type
{
    self = [super init];
    if (self)
    {
        self.type = type;
    }
    return self;
}

- (void)setType:(EDDBtnType)type
{
    if(type == EDDBtnType_Default)
    {
        [self defaultStyle];
    }
    else if(type == EDDBtnType_Blue)
    {
        [self primaryStyle];
    }
    else if(type == EDDBtnType_LightBlue)
    {
        [self infoStyle];
    }
    else if(type == EDDBtnType_Green)
    {
        [self successStyle];
    }
    else if(type == EDDBtnType_Yellow)
    {
        [self warningStyle];
        self.backgroundColor = RGBCOLORV(0xfd982c);
    }
    else if(type == EDDBtnType_Red)
    {
        [self dangerStyle];
    }
    else
    {
        [self defaultStyle];
    }
    
    self.titleLabel.font = [UIFont systemFontOfSize:DD_THEME.fontSizeMiddle];
}

@end
