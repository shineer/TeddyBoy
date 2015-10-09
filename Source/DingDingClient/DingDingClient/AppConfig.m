//
//  AppConfig.m
//  DingDingClient
//
//  Created by phoenix on 14-10-10.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import "AppConfig.h"
#import "UIDevice+Ext.h"

static AppConfig * instance = nil;

@implementation AppConfig

#pragma mark - instance method
+ (AppConfig*)getInstance
{
	@synchronized(self) {
		if (instance == nil)
        {
			instance = [[AppConfig alloc] init];
		}
	}
	return instance;
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        [self initConfig];
        [self initDictionary];
    }
    return self;
}

-(void)initConfig
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    // 应用id
    self.appId = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    
    // 应用appStore的id
    self.appStoreId = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    
    // 客户端名称
    self.clientName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    
    // 客户端版本号
    self.version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    // 客户端编译日期和次数
    self.buildVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    // 数据库版本
    self.dataVersion = @"0.1";
    
    // 设备型号
    self.deviceModel = [UIDevice getCurrentDeviceName];
    
    // 设备类型编号
    self.clientType = [UIDevice getCurrentDeviceModel];

    // 渠道号
    self.fid = @"888888888";
}

- (void)initDictionary
{
    self.houseTagDict = @{@1: @"家电全",
                          @2: @"随时看",
                          @3: @"高清",
                          @4: @"有房本"};
}

@end