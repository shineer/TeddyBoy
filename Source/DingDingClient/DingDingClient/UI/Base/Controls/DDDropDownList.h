//
//  DDDropDownList.h
//  DingDingClient
//
//  Created by phoenix on 15-1-5.
//  Copyright (c) 2015年 SEU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDDropDownList;

@protocol DDDropDownListDelegate<NSObject>

- (void)dropDownList:(DDDropDownList*)sender didSelectedIndex:(NSInteger)index;
- (void)dropDownList:(DDDropDownList*)sender didDeleteIndex:(NSInteger)index;
- (void)dropDownListDidCancel;

@end

@interface DDDropDownList : UIView <UITableViewDelegate, UITableViewDataSource>
{
    UIButton*       _maskView;
    UITableView*    _tableView;
    NSArray*        _contentArray;
}

@property (nonatomic, weak) id <DDDropDownListDelegate> delegate;

@property (nonatomic, strong) NSArray* contentArray;

@property (nonatomic, assign) BOOL isEnableDelete;

- (void)showInView:(UIView*)aView;

- (void)dismiss;

- (void)itemDeletedAtIndex:(NSInteger)index;

@end
