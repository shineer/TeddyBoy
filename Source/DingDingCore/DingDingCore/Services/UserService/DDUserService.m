//
//  DDUserService.m
//  DingDingCore
//
//  Created by phoenix on 14-10-10.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import "DDUserService.h"
#import "DDHttpService.h"
#import "DDHttpTransferService.h"

@implementation DDUserService

- (id)init
{
    if (self = [super init])
    {

    }
    return self;
}

/*
 *  @brief  获取验证码
 *  @param  mobileNo 手机号
 *  @param  type 验证码类型 1:登录 2:签约 3:其他
 *  @param  response 回调block
 *  @return N/A
 */
- (void)getVerificationCode:(NSString*)phone
                       type:(int)type
                   resopnse:(DDResponse)response
{
    NSMutableDictionary *bodyDict = [[NSMutableDictionary alloc] init];
    [bodyDict setValue:phone forKey:@"phone"];
    [bodyDict setValue:[NSNumber numberWithInt:type] forKey:@"type"];
    
    NSString* url = DD_CONFIG.loginIdentityCodeUrl;
    
    [[DDHttpService getInstance] sendPostWithURL:url body:bodyDict httpHeader:nil onCompletion:^(NSString *reqId, NSDictionary *dic) {
        
        CORE_LOG(@"---- getVerificationCode success!!!! ----");
        
        if(response)
        {
//            // 保存token
//            DD_CONFIG.token = [dic objectForKey:@"token"];
//            
//            NSDictionary* dataDic = [dic objectForKey:@"data"];
//            // 保存userId和cityId
//            DD_CONFIG.userId = [dataDic objectForKey:@"accountId"];
//            DD_CONFIG.cityId = [[dataDic objectForKey:@"cityId"] integerValue];
            response(EDDResponseResultSucceed, dic, nil);
        }
        
    } onError:^(NSString *reqId, NSError *error) {
        
        CORE_LOG(@"---- getVerificationCode fail!!!! error = %@ ----", error.description);
        
        if(response)
        {
            DDError *ddError = [DDError errorWithNSError:error];
            response(EDDResponseResultFailed, nil, ddError);
        }
    }];

}
/*
 *  @brief  登录
 *  @param  mobileNo 手机号
 *  @param  password 验证码
 *  @param  response 回调block
 *  @return N/A
 */
- (void)userLogin:(NSString*)phone
         password:(NSString*)password
         resopnse:(DDResponse)response
{
    NSMutableDictionary *bodyDict = [[NSMutableDictionary alloc] init];
    [bodyDict setValue:phone forKey:@"phone"];
    [bodyDict setValue:password forKey:@"identityCode"];

    NSString* url = DD_CONFIG.userLoginUrl;

    [[DDHttpService getInstance] sendPostWithURL:url body:bodyDict httpHeader:nil onCompletion:^(NSString *reqId, NSDictionary *dic) {

        CORE_LOG(@"---- login success!!!! ----");
        
        if(response)
        {
            // 保存token
            DD_CONFIG.coreSetting.token = [dic objectForKey:@"token"];
            
            NSDictionary* dataDic = [dic objectForKey:@"data"];
            // 保存userId和cityId
            DD_CONFIG.coreSetting.userId = [dataDic objectForKey:@"accountId"];
            NSInteger city = [[dataDic objectForKey:@"cityId"] integerValue];
            if(city != 0)
            {
                DD_CONFIG.coreSetting.cityId = [[dataDic objectForKey:@"cityId"] integerValue];
            }
            // 保存core参数设置
            [DD_CONFIG saveCoreSetting];
            
            response(EDDResponseResultSucceed, dic, nil);
        }

    } onError:^(NSString *reqId, NSError *error) {

        CORE_LOG(@"---- login fail!!!! error = %@ ----", error.description);

        if(response)
        {
            DDError *ddError = [DDError errorWithNSError:error];
            response(EDDResponseResultFailed, nil, ddError);
        }
    }];
}

@end
