//
//  DDCore.h
//  DingDingCore
//
//  Created by phoenix on 14-10-10.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import <Foundation/Foundation.h>

/* Library provided by SDK */
#import "Library/Network/MKNetworkKit.h"

/* Utilty provided by SDK */
#import "Utilty/CommonUtils.h"

/* Defines provided by SDK */
#import "DDCoreDefine.h"

/* Navigation provided by SDK */
#import "DDConfig.h"

/* Service provided by SDK */
#import "Services/HttpService/DDHttpService.h"
#import "Services/HttpService/DDHttpTransferService.h"
#import "Services/SystemService/DDSystemService.h"
#import "Services/FileService/DDFileService.h"
#import "Services/HouseService/DDHouseService.h"
#import "Services/UserService/DDUserService.h"

/* Object provided by SDK */
#import "Objects/DDUser.h"
#import "Objects/DDHotHouse.h"

/* Parser provided by SDK */
#import "Parsers/DDHouseParser.h"

/* Log provided by SDK */
#import "Log/inc/Log.h"

#define DD_CORE [DDCore getInstance]

@interface DDCore : NSObject

+ (DDCore*)getInstance;

// 协议接口
@property (nonatomic, strong, readonly) DDFileService *fileService;
@property (nonatomic, strong, readonly) DDUserService *userService;
@property (nonatomic, strong, readonly) DDHouseService *houseService;

@end