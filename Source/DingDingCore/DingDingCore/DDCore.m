//
//  DDCore.m
//  DingDingCore
//
//  Created by phoenix on 14-10-10.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import "DDCore.h"

static DDCore * instance = nil;

@implementation DDCore

#pragma mark - instance method

+ (DDCore*)getInstance
{
	@synchronized(self) {
		if (instance == nil)
        {
			instance = [[DDCore alloc] init];
		}
	}
	return instance;
}

- (id)init
{
    if (self = [super init])
    {
        [self initServices];
        [self initObjects];
    }
    return self;
}

- (void)initServices
{
    _fileService = [[DDFileService alloc] init];
    _userService = [[DDUserService alloc] init];
    _houseService = [[DDHouseService alloc] init];
}

- (void)initObjects
{
    
}

@end
