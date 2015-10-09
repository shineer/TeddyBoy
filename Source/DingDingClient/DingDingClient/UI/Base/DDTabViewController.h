//
//  DDTabViewController.h
//  DingDingClient
//
//  Created by phoenix on 14-10-14.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDVTabBar.h"
#import "DDBaseViewController.h"

@protocol DDTabViewControllerDelegate;

@interface DDTabViewController : DDBaseViewController<RDVTabBarDelegate>

/**
 * The tab bar controller’s delegate object.
 */
@property (nonatomic, weak) id<DDTabViewControllerDelegate> delegate;

/**
 * An array of the root view controllers displayed by the tab bar interface.
 */
@property (nonatomic, copy) IBOutletCollection(UIViewController) NSArray *viewControllers;

/**
 * The tab bar view associated with this controller. (read-only)
 */
@property (nonatomic, readonly) RDVTabBar *tabBar;

/**
 * The view controller associated with the currently selected tab item.
 */
@property (nonatomic, weak) UIViewController *selectedViewController;

/**
 * The index of the view controller associated with the currently selected tab item.
 */
@property (nonatomic) NSUInteger selectedIndex;

/**
 * Show animated effect between view controller switch.
 */
@property (nonatomic) BOOL animated;

/**
 * A Boolean value that determines whether the tab bar is hidden.
 */
@property (nonatomic, getter=isTabBarHidden) BOOL tabBarHidden;

/**
 * Changes the visibility of the tab bar.
 */
- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

-(void) justSetSelectedIndex:(NSInteger)index;

@end

@protocol DDTabViewControllerDelegate <NSObject>
@optional
/**
 * Asks the delegate whether the specified view controller should be made active.
 */
- (BOOL)tabBarController:(DDTabViewController*)tabBarController shouldSelectViewController:(UIViewController*)viewController;

/**
 * Tells the delegate that the user selected an item in the tab bar.
 */
- (void)tabBarController:(DDTabViewController*)tabBarController didSelectViewController:(UIViewController*)viewController;

@end

@interface UIViewController (DDTabBarControllerItem)

/**
 * The tab bar item that represents the view controller when added to a tab bar controller.
 */
@property(nonatomic, setter = dd_setTabBarItem:) RDVTabBarItem *dd_tabBarItem;

/**
 * The nearest ancestor in the view controller hierarchy that is a tab bar controller. (read-only)
 */
@property(nonatomic, readonly) DDTabViewController *dd_tabBarController;


@end

