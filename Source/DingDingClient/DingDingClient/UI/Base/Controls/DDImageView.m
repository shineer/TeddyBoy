//
//  DDImageView.m
//  DingDingClient
//
//  Created by phoenix on 14-11-25.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import "DDImageView.h"
#import "DDBaseViewController.h"
//#import "DDUserSpaceViewController.h"

@implementation DDImageView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Initialization code
    [self setup];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialization code
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)operationCornerRadius
{
    self.layer.cornerRadius = 0;
    self.clipsToBounds = YES;
}

- (void)setup
{
    // 默认占位图
    self.placeholder = [UIImage imageNamed:@"common_place_holder"];
    
    // 设置圆角
    [self operationCornerRadius];
}

// 设置图片地址
- (void)setImageUrl:(NSString*)url
{
    __weak __typeof(self)weakSelf = self;
    
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:self.placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        // 下载图片失败
        if(image == nil || error != nil)
        {
            DD_LOG(@"\n---- Download image error: %@ ----", error);
            return;
        }
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        /**
         * The image wasn't available the SDWebImage caches, but was downloaded from the web.
         */
        if(cacheType == SDImageCacheTypeNone)
        {
            strongSelf.image = image;
            
            // 渐变显现效果
            strongSelf.alpha = 0.2;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            [strongSelf setNeedsDisplay];
            strongSelf.alpha = 1;
            [UIView commitAnimations];
        }
    }];
}

// 设置图片地址&占位图
- (void)setImageUrl:(NSString*)url placeholderImage:(UIImage*)placeholder
{
    self.placeholder = placeholder;
    
    [self setImageUrl:url];
}


@end
