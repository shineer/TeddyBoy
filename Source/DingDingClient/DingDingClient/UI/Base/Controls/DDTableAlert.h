//
//  DDTableAlert.h
//  DingDingClient
//
//  Created by phoenix on 15-5-23.
//  Copyright (c) 2015年 SEU. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DDTableAlert;

@protocol DDTableAlertDelegate <NSObject>

@optional

- (CGFloat)tableAlert:(DDTableAlert*)tableAlert heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableAlert:(DDTableAlert*)tableAlert didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableAlertConfirm:(DDTableAlert *)tableAlert withCurrentIndex:(NSInteger)index;

@end

@protocol DDTableAlertDataSource <NSObject>

@required

- (UITableViewCell *)tableAlert:(DDTableAlert*)tableAlert cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)tableAlert:(DDTableAlert*)tableAlert numberOfRowsInSection:(NSInteger)section;

@optional

- (NSInteger)numberOfSectionsInTableAlert:(DDTableAlert*)tableAlert; // default 1

@end


@interface DDTableAlert : UIView <UITableViewDelegate, UITableViewDataSource>
{
    UIView* _backgroundView;
    
    UILabel* _title;
    UIImageView* _seperaterLine;
    UITableView* _tableView;
    UIButton* _confirmBtn;
    
    NSInteger _currentIndex;
}

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) id <DDTableAlertDelegate> delegate;
@property (nonatomic, assign) id <DDTableAlertDataSource> dataSource;

- (id)initWithTitle:(NSString *)title confirmButtonTitle:(NSString *)confirmTitle;

- (void)show;

@end
