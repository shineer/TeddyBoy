//
//  DDSystemService.h
//  DingDingCore
//
//  Created by phoenix on 15/9/9.
//  Copyright (c) 2015年 SEU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Base/DDBaseService.h"

@interface DDSystemService : DDBaseService
{
    
}

+ (DDSystemService*)getInstance;

/*
 *  @brief  同步服务器时间
 *  @return N/A
 */
- (void)syncTimeWithServer;

/*
 *  @brief  去服务器端获取唯一的AppId
 *  @return N/A
 */
- (void)getAppIdWithServer;

/*
 *  @brief  获取当前时间(和服务器时间同步以后的)
 *  @return N/A
 */
- (NSTimeInterval)getCurrentTime;

/*
 *  @brief  获取服务器时间
 *  @param  response 回调block
 *  @return N/A
 */
- (void)getServerTime:(DDResponse)response;

/*
 *  @brief  从服务端获取唯一appId
 *  @param  response 回调block
 *  @return N/A
 */
- (void)getAppId:(DDResponse)response;


@end
