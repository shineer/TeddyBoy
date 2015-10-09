//
//  UIView+Ext.m
//  DingDingClient
//
//  Created by phoenix on 14-10-10.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import "UIView+Ext.h"
#import <objc/runtime.h>

@implementation UIView (IdentifierAddition)

static char BlankPageViewKey;

#pragma mark BlankPageView

- (void)setBlankPageView:(EaseBlankPageView *)blankPageView
{
    [self willChangeValueForKey:@"BlankPageViewKey"];
    objc_setAssociatedObject(self, &BlankPageViewKey,
                             blankPageView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"BlankPageViewKey"];
}

- (EaseBlankPageView *)blankPageView
{
    return objc_getAssociatedObject(self, &BlankPageViewKey);
}

- (void)configBlankPage:(EDDEaseBlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void (^)(id))block
{
    if (hasData)
    {
        if (self.blankPageView)
        {
            self.blankPageView.hidden = YES;
            [self.blankPageView removeFromSuperview];
        }
    }
    else
    {
        if (!self.blankPageView)
        {
            self.blankPageView = [[EaseBlankPageView alloc] initWithFrame:self.bounds];
        }
        self.blankPageView.hidden = NO;
        [self.blankPageContainer addSubview:self.blankPageView];
        [self.blankPageView configWithType:blankPageType hasData:hasData hasError:hasError reloadButtonBlock:block];
    }
}

- (UIView *)blankPageContainer
{
    UIView *blankPageContainer = self;
    for (UIView *aView in [self subviews])
    {
        if ([aView isKindOfClass:[UITableView class]])
        {
            blankPageContainer = aView;
        }
    }
    return blankPageContainer;
}

@end


@implementation EaseBlankPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)configWithType:(EDDEaseBlankPageType)blankPageType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadButtonBlock:(void (^)(id))block
{
    if (hasData)
    {
        [self removeFromSuperview];
        return;
    }
    self.alpha = 1.0;
    // 图片
    if (!_iconView)
    {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconView.contentMode = UIViewContentModeCenter;
        [self addSubview:_iconView];
    }
    // 文字
    if (!_tipLabel)
    {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.numberOfLines = 0;
        _tipLabel.font = [UIFont systemFontOfSize:DD_THEME.fontSizeMiddle];
        _tipLabel.textColor = [UIColor lightGrayColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tipLabel];
    }
    
    // 布局
    CGRect rect = self.bounds;
    CGRect iconRect = [UtilFunc centerRect:rect width:140 height:140];
    iconRect.origin.y = rect.size.height / 6;
    _iconView.frame = iconRect;
    
    CGRect tipRect = CGRectOffset(iconRect, 0, iconRect.size.height);
    tipRect = [UtilFunc topRect:tipRect height:DD_THEME.fontSizeLarge * 2 offset:0];
    tipRect = [UtilFunc centerRect:tipRect width:DD_THEME.screenWidth height:tipRect.size.height];
    _tipLabel.frame = tipRect;
    
    _reloadButtonBlock = nil;
    if (hasError)
    {
        // 加载失败
        if (!_reloadButton)
        {
            _reloadButton = [[UIButton alloc] initWithFrame:CGRectZero];
            UIImage* image = [UIImage imageNamed:@"blankpage_button_reload"];
            [_reloadButton setImage:image forState:UIControlStateNormal];
            _reloadButton.adjustsImageWhenHighlighted = YES;
            [_reloadButton addTarget:self action:@selector(reloadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_reloadButton];
            
            CGRect reloadBtnRect = CGRectOffset(tipRect, 0, tipRect.size.height + 6);
            reloadBtnRect = [UtilFunc centerRect:reloadBtnRect width:image.size.width height:image.size.height];
            _reloadButton.frame = reloadBtnRect;
        }
        _reloadButton.hidden = NO;
        _reloadButtonBlock = block;
        [_iconView setImage:[UIImage imageNamed:@"blankpage_image_loadFail"]];
        _tipLabel.text = @"貌似出了点差错\n真忧伤呢";
    }
    else
    {
        // 空白数据
        if (_reloadButton)
        {
            _reloadButton.hidden = YES;
        }
        NSString *imageName, *tipStr;
        switch (blankPageType)
        {
            case EaseBlankPageTypeActivity:
            {
                imageName = @"blankpage_image_Sleep";
                tipStr = @"这里还什么都没有\n赶快起来弄出一点动静吧";
            }
                break;
            case EaseBlankPageTypeTask:
            {
                imageName = @"blankpage_image_Sleep";
                tipStr = @"这里还没有任务\n赶快起来为团队做点贡献吧";
            }
                break;
            case EaseBlankPageTypeTopic:
            {
                imageName = @"blankpage_image_Sleep";
                tipStr = @"这里怎么空空的\n发个讨论让它热闹点吧";
            }
                break;
            case EaseBlankPageTypeTweet:
            {
                imageName = @"blankpage_image_Hi";
                tipStr = @"无冒泡\n来，冒个泡吧～";
            }
                break;
            case EaseBlankPageTypeTweetOther:
            {
                imageName = @"blankpage_image_Sleep";
                tipStr = @"这个人很懒\n一个冒泡都木有～";
            }
                break;
            case EaseBlankPageTypeProject:
            {
                imageName = @"blankpage_image_Sleep";
                tipStr = @"这里还没有项目\n快去Coding网站创建吧";
            }
                break;
            case EaseBlankPageTypeFileDleted:
            {
                imageName = @"blankpage_image_loadFail";
                tipStr = @"晚了一步\n文件刚刚被人删除了～";
            }
                break;
            case EaseBlankPageTypeFolderDleted:
            {
                imageName = @"blankpage_image_loadFail";
                tipStr = @"晚了一步\n文件夹貌似被人删除了～";
            }
                break;
            case EaseBlankPageTypePrivateMsg:
            {
                imageName = @"blankpage_image_Hi";
                tipStr = @"无私信\n打个招呼吧～";
            }
                break;
            default:
            {
                imageName = @"blankpage_image_Sleep";
                tipStr = @"这里还什么都没有\n赶快起来弄出一点动静吧";
            }
                break;
        }
        [_iconView setImage:[UIImage imageNamed:imageName]];
        _tipLabel.text = tipStr;
    }
}

- (void)reloadButtonClicked:(id)sender
{
    self.hidden = YES;
    [self removeFromSuperview];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (_reloadButtonBlock)
        {
            _reloadButtonBlock(sender);
        }
    });
}

@end

