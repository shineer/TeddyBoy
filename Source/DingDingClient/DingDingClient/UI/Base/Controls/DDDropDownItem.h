//
//  DDDropDownItem.h
//  DingDingClient
//
//  Created by phoenix on 15-1-6.
//  Copyright (c) 2015年 SEU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDDropDownList;
@class DDBaseViewController;

@interface DDDropDownItem : UITableViewCell
{
    UILabel* _titleLabel;
    UIButton* _deleteBtn;
    UIImageView* _seperateLine;
    
    NSIndexPath* _indexPath;
}

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIButton* deleteBtn;
@property (nonatomic, strong) UIImageView* seperateLine;

@property (nonatomic, weak) DDDropDownList* dropDownList;

- (void)updateContent:(NSDictionary*)contentDict withVC:(DDBaseViewController*)viewController;

@end
