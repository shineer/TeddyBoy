//
//  DDHouseService.m
//  DingDingCore
//
//  Created by phoenix on 15/9/9.
//  Copyright (c) 2015年 SEU. All rights reserved.
//

#import "DDHouseService.h"
#import "DDHttpService.h"

@implementation DDHouseService

- (id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

/*
 *  @brief  获取推荐房源
 *  @param  response 回调block
 *  @return N/A
 */
- (void)getRecommendHouse:(DDResponse)response
{
    NSMutableDictionary *bodyDict = [[NSMutableDictionary alloc] init];

    NSString* url = DD_CONFIG.hotHouseListByClientUrl;
    
    [[DDHttpService getInstance] sendPostWithURL:url body:bodyDict httpHeader:nil onCompletion:^(NSString *reqId, NSDictionary *dic) {
        
        CORE_LOG(@"---- getRecommendHouse success!!!! ----");
        
        if(response)
        {
            response(EDDResponseResultSucceed, dic, nil);
        }
        
    } onError:^(NSString *reqId, NSError *error) {
        
        CORE_LOG(@"---- getRecommendHouse fail!!!! error = %@ ----", error.description);
        
        if(response)
        {
            DDError *dderror = [DDError errorWithNSError:error];
            response(EDDResponseResultFailed, nil, dderror);
        }
    }];
}

@end
