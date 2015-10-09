//
//  YYTabViewController.m
//  DingDingClient
//
//  Created by phoenix on 14-10-14.
//  Copyright (c) 2014年 SEU. All rights reserved.
//


#import "DDTabViewController.h"
#import "RDVTabBarItem.h"
#import <objc/runtime.h>

@interface UIViewController (DDTabBarControllerItemInternal)

- (void)dd_setTabBarController:(DDTabViewController*)tabBarController;

@end

@interface DDTabViewController ()
{
    UIView *_contentView;
}

@property (nonatomic, readwrite) RDVTabBar *tabBar;

@end

@implementation DDTabViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect rect = CGRectMake(0, DD_THEME.screenHeight - DD_THEME.tabBarHeight - DD_THEME.navigationBarHeight - DD_THEME.navigationBarHeight - 1, DD_THEME.screenWidth, 1);
    UIImageView* seperateLine = [[UIImageView alloc] initWithFrame:rect];
    seperateLine.backgroundColor = DD_THEME.colorTheme;
    
    [self.view addSubview:[self contentView]];
    //[self.view addSubview:seperateLine];
    [self.view addSubview:[self tabBar]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setSelectedIndex:[self selectedIndex]];
    
    [self setTabBarHidden:NO animated:NO];
}

- (NSUInteger)supportedInterfaceOrientations
{
    UIInterfaceOrientationMask orientationMask = UIInterfaceOrientationMaskAll;
    for (UIViewController *viewController in [self viewControllers]) {
        if (![viewController respondsToSelector:@selector(supportedInterfaceOrientations)]) {
            return UIInterfaceOrientationMaskPortrait;
        }
        
        UIInterfaceOrientationMask supportedOrientations = [viewController supportedInterfaceOrientations];
        
        if (orientationMask > supportedOrientations) {
            orientationMask = supportedOrientations;
        }
    }
    
    return orientationMask;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    for (UIViewController *viewCotroller in [self viewControllers])
    {
        if (![viewCotroller respondsToSelector:@selector(shouldAutorotateToInterfaceOrientation:)] ||
            ![viewCotroller shouldAutorotateToInterfaceOrientation:toInterfaceOrientation])
        {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Methods

- (UIViewController *)selectedViewController
{
    return [[self viewControllers] objectAtIndex:[self selectedIndex]];
}

-(void) justSetSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    
    if (selectedIndex >= self.viewControllers.count)
    {
        return;
    }
    
    if ([self selectedViewController])
    {
        DD_LOG(@"selectedIndex = %d",selectedIndex);
        [[self selectedViewController] willMoveToParentViewController:nil];
        [[[self selectedViewController] view] removeFromSuperview];
        [[self selectedViewController] removeFromParentViewController];
    }
    //首先设置选择值
    _selectedIndex = selectedIndex;
    
    [[self tabBar] setSelectedItem:[[self tabBar] items][selectedIndex]];
    DD_LOG(@"[[self tabBar] setSelectedItem:[[self tabBar] items][selectedIndex]]; %d",selectedIndex);
    
    // 如果不使用系统默认动画的话那么就使用自定义的淡入淡出动画
    if(_animated)
    {
        AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.3;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionFade;
        animation.subtype = kCATransitionFromRight;
        
        [delegate.window.layer addAnimation:animation forKey:@"animation"];
    }
    
    [self setSelectedViewController:[[self viewControllers] objectAtIndex:selectedIndex]];

    [self addChildViewController:[self selectedViewController]];
    [[[self selectedViewController] view] setFrame:[[self contentView] bounds]];
    [[self contentView] addSubview:[[self selectedViewController] view]];
    [[self selectedViewController] didMoveToParentViewController:self];
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    if (viewControllers && [viewControllers isKindOfClass:[NSArray class]])
    {
        _viewControllers = [viewControllers copy];
        
        NSMutableArray *tabBarItems = [[NSMutableArray alloc] init];
        
        for (UIViewController *viewController in viewControllers)
        {
            RDVTabBarItem *tabBarItem = [[RDVTabBarItem alloc] init];
            [tabBarItem setTitle:viewController.title];
            [tabBarItems addObject:tabBarItem];
            [viewController dd_setTabBarController:self];
        }
        
        [[self tabBar] setItems:tabBarItems];
    }
    else
    {
        for (UIViewController *viewController in _viewControllers)
        {
            [viewController dd_setTabBarController:nil];
        }
        
        _viewControllers = nil;
    }
}

- (NSInteger)indexForViewController:(UIViewController *)viewController
{
    UIViewController *searchedController = viewController;
    if ([searchedController navigationController])
    {
        searchedController = [searchedController navigationController];
    }
    return [[self viewControllers] indexOfObject:searchedController];
}

- (RDVTabBar *)tabBar
{
    if (!_tabBar)
    {
        _tabBar = [[RDVTabBar alloc] init];
        [_tabBar setBackgroundColor:[UIColor whiteColor]];
        [_tabBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth|
         UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|
         UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin];
        [_tabBar setDelegate:self];
    }
    return _tabBar;
}

- (UIView *)contentView
{
    if (!_contentView)
    {
        _contentView = [[UIView alloc] init];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [_contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|
         UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|
         UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin];
    }
    return _contentView;
}

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    _tabBarHidden = hidden;
    
    __weak DDTabViewController *weakSelf = self;
    
    void (^block)() = ^{
        CGSize viewSize = weakSelf.view.bounds.size;
        CGFloat tabBarStartingY = viewSize.height;
        CGFloat contentViewHeight = viewSize.height;
        CGFloat tabBarHeight = CGRectGetHeight([[weakSelf tabBar] frame]);
        
        NSLog(@"viewSize = %@", NSStringFromCGSize(viewSize));
        
        if (!tabBarHeight)
        {
            tabBarHeight = DD_THEME.tabBarHeight;
        }
        
        if (!hidden)
        {
            tabBarStartingY = viewSize.height - tabBarHeight;
            if (![[weakSelf tabBar] isTranslucent])
            {
                contentViewHeight -= ([[weakSelf tabBar] minimumContentHeight] ?: tabBarHeight);
            }
            [[weakSelf tabBar] setHidden:NO];
        }
        
        [[weakSelf tabBar] setFrame:CGRectMake(0, tabBarStartingY, viewSize.width, tabBarHeight)];
        [[weakSelf contentView] setFrame:CGRectMake(0, 0, viewSize.width, contentViewHeight)];
    };
    
    void (^completion)(BOOL) = ^(BOOL finished){
        
        if (hidden)
        {
            [[weakSelf tabBar] setHidden:YES];
        }
    };
    
    if (animated)
    {
        [UIView animateWithDuration:0.24 animations:block completion:completion];
    }
    else
    {
        block();
        completion(YES);
    }
}

- (void)setTabBarHidden:(BOOL)hidden
{
    [self setTabBarHidden:hidden animated:NO];
}

#pragma mark - RDVTabBarDelegate

- (BOOL)tabBar:(RDVTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index
{
    if ([[self delegate] respondsToSelector:@selector(tabBarController:shouldSelectViewController:)])
    {
        if (![[self delegate] tabBarController:self shouldSelectViewController:[self viewControllers][index]])
        {
            return NO;
        }
    }
    
    if ([self selectedViewController] == [self viewControllers][index])
    {
        if ([[self selectedViewController] isKindOfClass:[UINavigationController class]])
        {
            UINavigationController *selectedController = (UINavigationController *)[self selectedViewController];
            
            if ([selectedController topViewController] != [selectedController viewControllers][0])
            {
                [selectedController popToRootViewControllerAnimated:YES];
            }
        }
        
        return NO;
    }
    
    return YES;
}

- (void)tabBar:(RDVTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index
{
    if (index < 0 || index >= [[self viewControllers] count])
    {
        return;
    }
    
    [self setSelectedIndex:index];
    
    if ([[self delegate] respondsToSelector:@selector(tabBarController:didSelectViewController:)])
    {
        [[self delegate] tabBarController:self didSelectViewController:[self viewControllers][index]];
    }
}

@end

#pragma mark - UIViewController+RDVTabBarControllerItem

@implementation UIViewController (DDTabBarControllerItemInternal)

- (void)dd_setTabBarController:(DDTabViewController*)tabBarController
{
    objc_setAssociatedObject(self, @selector(dd_tabBarController), tabBarController, OBJC_ASSOCIATION_ASSIGN);
}

@end

@implementation UIViewController (DDTabBarControllerItem)

- (DDTabViewController*)dd_tabBarController
{
    DDTabViewController *tabBarController = objc_getAssociatedObject(self, @selector(dd_tabBarController));
    
    if (!tabBarController && self.parentViewController)
    {
        tabBarController = [self.parentViewController dd_tabBarController];
    }
    
    return tabBarController;
}

- (RDVTabBarItem *)dd_tabBarItem
{
    DDTabViewController *tabBarController = [self dd_tabBarController];
    NSInteger index = [tabBarController indexForViewController:self];
    return [[[tabBarController tabBar] items] objectAtIndex:index];
}

- (void)dd_setTabBarItem:(RDVTabBarItem *)tabBarItem
{
    DDTabViewController *tabBarController = [self dd_tabBarController];
    
    if (!tabBarController)
    {
        return;
    }
    
    RDVTabBar *tabBar = [tabBarController tabBar];
    NSInteger index = [tabBarController indexForViewController:self];
    
    NSMutableArray *tabBarItems = [[NSMutableArray alloc] initWithArray:[tabBar items]];
    [tabBarItems replaceObjectAtIndex:index withObject:tabBarItem];
    [tabBar setItems:tabBarItems];
}

@end

