//
//  DDTempleteManager.m
//  DingDingClient
//
//  Created by phoenix on 14-9-19.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import "DDTempleteManager.h"

static DDTempleteManager *_sharedTempleteManager = nil;

@implementation DDTempleteManager

+ (DDTempleteManager*)getInstance
{
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        
        _sharedTempleteManager = [[DDTempleteManager alloc] init];
    });
    
	return _sharedTempleteManager;
}

- (id)init
{
    self = [super init];
    
    if(self)
    {
        // Todo...
    }
    return self;
}


@end
