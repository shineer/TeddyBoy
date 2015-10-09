//
//  DDContactManager.h
//  DingDingClient
//
//  Created by phoenix on 14-11-6.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDContactData+Oper.h"

@interface DDContactManager : NSObject
{
}

+ (DDContactManager*)getInstance;

- (void)getContectByUserId:(NSString*)userId;

@end
