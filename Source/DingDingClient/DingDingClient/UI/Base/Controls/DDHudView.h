//
//  DDHudView.h
//  DingDingClient
//
//  Created by phoenix on 14-10-16.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DDHUDVIEW [DDHudView getInstance]

#define HUD_DEFAULT_HIDE_TIME 2.0f

@interface DDHudView : NSObject

+ (DDHudView*)getInstance;

- (void)showTips:(NSString*)tips autoHideTime:(NSTimeInterval)autoHideTimeInterval;
- (void)showTips:(NSString*)tips;
- (void)startAnimatingWithTitle:(NSString*)tilte;
- (void)stopAnimating;
- (void)showcaption:(NSString*)caption image:(UIImage*)image withTime:(NSInteger)time;

@end
