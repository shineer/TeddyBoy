//
//  DDSystemService.m
//  DingDingCore
//
//  Created by phoenix on 15/9/9.
//  Copyright (c) 2015年 SEU. All rights reserved.
//

#import "DDSystemService.h"
#import "DDHttpService.h"
#import "DDHttpTransferService.h"

static DDSystemService *_sharedSystemnManager = nil;

@interface DDSystemService()
{
}

@property (nonatomic, assign) NSTimeInterval svrTime;
@property (nonatomic, assign) NSTimeInterval localTick;

@end

@implementation DDSystemService

+ (DDSystemService*)getInstance
{
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        
        _sharedSystemnManager = [[DDSystemService alloc] init];
    });
    
    return _sharedSystemnManager;
}

- (id)init
{
    if (self = [super init])
    {
        _svrTime = 0;
        _localTick = 0;
    }
    return self;
}

//同步服务器时间
- (void)syncTimeWithServer
{
    __weak typeof(self) weakSelf = self;
    [self getServerTime:^(NSInteger result, NSDictionary *dict, DDError *error) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if(result == EDDResponseResultSucceed)
        {
            NSDictionary* dataDic = [dict objectForKey:@"data"];
            NSString* dateStr = [dataDic objectForKey:@"dateTime"];
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate* date = [formatter dateFromString :dateStr];
            
            strongSelf.svrTime = [date timeIntervalSince1970];
            strongSelf.localTick = [CommonUtils getCurTick];
            
        }
        else if (result == EDDResponseResultFailed)
        {
            if(error)
            {
                CORE_LOG(@"---- syncTime fail!!!! error = %@ ----", error.description);
            }
        }
    }];
}

/*
 *  @brief  去服务器端获取唯一的AppId
 *  @return N/A
 */
- (void)getAppIdWithServer
{
    NSString* appId = DD_CONFIG.coreSetting.appId;

    // 如果appId已经存在那不需要重复取
    if(appId && appId.length > 0)
    {
        return;
    }
    
    [self getAppId:^(NSInteger result, NSDictionary *dict, DDError *error) {
        
        if(result == EDDResponseResultSucceed)
        {
            NSDictionary* dataDic = [dict objectForKey:@"data"];
            DD_CONFIG.coreSetting.appId = [dataDic objectForKey:@"appId"];
            // 保存core参数设置
            [DD_CONFIG saveCoreSetting];
        }
        else if (result == EDDResponseResultFailed)
        {
            if(error)
            {
                CORE_LOG(@"---- getAppId fail!!!! error = %@ ----", error.description);
            }
        }
    }];
}

/*
 *  @brief  获取当前时间(和服务器时间同步以后的)
 *  @return N/A
 */
- (NSTimeInterval)getCurrentTime
{
    NSTimeInterval currentTime;
    
    if (self.svrTime == 0)
    {
        NSDate *date = [NSDate date];
        currentTime = [date timeIntervalSince1970];
    }
    else
    {
        currentTime = [CommonUtils getCurTick] - self.localTick + self.svrTime;
    }
    
    return currentTime;
}

/*
 *  @brief  获取服务器时间
 *  @param  response 回调block
 *  @return N/A
 */
- (void)getServerTime:(DDResponse)response
{
    NSMutableDictionary *bodyDict = [[NSMutableDictionary alloc] init];
    
    NSString* url = DD_CONFIG.getSystemTimeUrl;
    
    [[DDHttpService getInstance] sendPostWithURL:url body:bodyDict httpHeader:nil onCompletion:^(NSString *reqId, NSDictionary *dic) {
        
        CORE_LOG(@"---- getSystemTime success!!!! ----");
        
        if(response)
        {
            response(EDDResponseResultSucceed, dic, nil);
        }
        
    } onError:^(NSString *reqId, NSError *error) {
        
        CORE_LOG(@"---- getSystemTime fail!!!! error = %@ ----", error.description);
        
        if(response)
        {
            DDError *dderror = [DDError errorWithNSError:error];
            response(EDDResponseResultFailed, nil, dderror);
        }
    }];
}

/*
 *  @brief  从服务端获取唯一appId
 *  @param  response 回调block
 *  @return N/A
 */
- (void)getAppId:(DDResponse)response
{
    NSMutableDictionary *bodyDict = [[NSMutableDictionary alloc] init];
    
    NSString* url = DD_CONFIG.getAppIdUrl;
    
    [[DDHttpService getInstance] sendPostWithURL:url body:bodyDict httpHeader:nil onCompletion:^(NSString *reqId, NSDictionary *dic) {
        
        CORE_LOG(@"---- getAppId success!!!! ----");
        
        if(response)
        {
            response(EDDResponseResultSucceed, dic, nil);
        }
        
    } onError:^(NSString *reqId, NSError *error) {
        
        CORE_LOG(@"---- getAppId fail!!!! error = %@ ----", error.description);
        
        if(response)
        {
            DDError *dderror = [DDError errorWithNSError:error];
            response(EDDResponseResultFailed, nil, dderror);
        }
    }];
}

@end
