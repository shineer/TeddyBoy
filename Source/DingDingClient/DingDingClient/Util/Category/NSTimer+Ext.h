//
//  NSTimer+Ext.h
//  DingDingClient
//
//  Created by phoenix on 15-03-17.
//  Copyright (c) 2015年 SEU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Ext)

+ (id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;
+ (id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;

- (void)pauseTimer;
- (void)resumeTimer;
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
