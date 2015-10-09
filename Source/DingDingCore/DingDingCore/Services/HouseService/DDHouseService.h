//
//  DDHouseService.h
//  DingDingCore
//
//  Created by phoenix on 15/9/9.
//  Copyright (c) 2015年 SEU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Base/DDBaseService.h"

@interface DDHouseService : DDBaseService
{
    
}

/*
 *  @brief  获取推荐房源
 *  @param  response 回调block
 *  @return N/A
 */
- (void)getRecommendHouse:(DDResponse)response;

@end
