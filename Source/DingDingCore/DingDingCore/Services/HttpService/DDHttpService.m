//
//  DDHttpService.m
//  DingDingCore
//
//  Created by phoenix on 14-10-10.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import "DDHttpService.h"
#import "MKNetworkKit.h"
#import "MurmurHash3_OC.h"

@interface DDHttpRequest : NSObject
{
}

@property (strong, nonatomic) NSString *uniqueId;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString* httpMethod;
@property (strong, nonatomic) NSMutableDictionary *headers;
@property (strong, nonatomic) NSMutableDictionary *body;
@property (strong, nonatomic) MKNetworkOperation *op;
@property (nonatomic, copy) HttpReuqestSucceedBlock succeedBlock;
@property (nonatomic, copy) HttpRequestFailedBlock failedBlock;
@property (nonatomic) BOOL isRequesting;

@end

@implementation DDHttpRequest

- (id)init
{
    self = [super init];
    if (self)
    {
        self.uniqueId = [NSString uniqueString];
    }
    return self;
}

-(void)dealloc
{
    if(self.headers)
    {
        [self.headers removeAllObjects];
    }
    if(self.body)
    {
        [self.body removeAllObjects];
    }
}

-(void)cancel
{
    if(self.op)
    {
        [self.op cancel];
    }
    if(self.succeedBlock)
    {
        self.succeedBlock = nil;
    }
    if(self.failedBlock)
    {
        self.failedBlock = nil;
    }
    if(self.headers)
    {
        [self.headers removeAllObjects];
    }
    if(self.body)
    {
        [self.body removeAllObjects];
    }
}
@end

@interface DDHttpQueue : NSObject
{
    
}

@property (strong, nonatomic) NSMutableArray *queue;

- (void)addRequest:(DDHttpRequest*)request;
- (void)removeRequest:(DDHttpRequest*)request;
- (void)removeRequestWithUniqueId:(NSString*)uniqueId;
- (void)removeAllRequest;
- (DDHttpRequest*)findRequestWithUniqueId:(NSString*)uniqueId;

@end

@implementation DDHttpQueue

- (id)init
{
    self = [super init];
    if (self)
    {
        self.queue = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addRequest:(DDHttpRequest*)request
{
    if(request == nil)
        return;
    
    [self.queue addObject:request];
}

- (void)removeRequest:(DDHttpRequest*)request
{
    if(request == nil)
        return;
    
    [self.queue removeObject:request];
}

- (void)removeAllRequest
{
    [self.queue removeAllObjects];
}

- (void)removeRequestWithUniqueId:(NSString*)uniqueId
{
    DDHttpRequest* request = [self findRequestWithUniqueId:uniqueId];
    if(request != nil)
    {
        [self removeRequest:request];
    }
}

- (DDHttpRequest*)findRequestWithUniqueId:(NSString*)uniqueId
{
    for(DDHttpRequest *request in self.queue)
    {
        if([request.uniqueId isEqualToString:uniqueId])
        {
            return request;
        }
    }
    return nil;
}

- (void)dealloc
{
    [self.queue removeAllObjects];
}

@end

static DDHttpService * instance = nil;

@interface DDHttpService()
{
}

@property (strong, nonatomic) MKNetworkEngine *engine;
@property (strong, nonatomic) NSMutableDictionary *customHeaders;
@property (strong, nonatomic) MKNetworkOperation *op;
@property (strong, nonatomic) NSMutableArray *opValues;
@property (strong, nonatomic) NSMutableArray *opKeys;
@property (strong, nonatomic) DDHttpQueue *requestQueue;
@end

@implementation DDHttpService

+ (DDHttpService*)getInstance
{
	@synchronized(self) {
		if (instance == nil)
        {
			instance = [[DDHttpService alloc] init];
		}
	}
	return instance;
}

NSString* const GET = @"GET";
NSString* const POST = @"POST";

- (id)init
{
    self = [super init];
    if (self)
    {
    }
    self.engine = [[MKNetworkEngine alloc] init];
    self.customHeaders = [[NSMutableDictionary alloc] init];
    self.requestQueue = [[DDHttpQueue alloc]init];
    return self;
}

- (void)setHeaders:(NSDictionary*)headerDic
{
    if(nil == headerDic)
    {
        [self.customHeaders setDictionary:headerDic];
    }
}

- (void)removeAllHeaders
{
    [self.customHeaders removeAllObjects];
}

- (NSString*)sendGetWithURL:(NSString*)url httpHeader:(NSDictionary*)headerDic onCompletion:(HttpReuqestSucceedBlock)completionBlock onError:(HttpRequestFailedBlock)errorBlock
{
    
    MKNetworkOperation *op = [self.engine operationWithURLString:url
                                                          params:nil
                                                      httpMethod:GET];
    
    if(nil != headerDic)
    [op addHeaders:headerDic];
    
    DDHttpRequest* request = [[DDHttpRequest alloc] init];
    request.op = op;
    request.url = url;
    request.headers = self.customHeaders;
    request.httpMethod = GET;
    request.succeedBlock = completionBlock;
    request.failedBlock = errorBlock;
    CORE_LOG(@"%@", request);
    [self.requestQueue addRequest:request];
    __weak typeof(self) weakSelf = self;
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if([completedOperation responseData])
        {
            NSDictionary* dc = [completedOperation responseJSON];
            
            if([dc isKindOfClass:[NSDictionary class]])
            {
                completionBlock(request.uniqueId, dc);
            }
            else
            {
                completionBlock(request.uniqueId, nil);
            }
        }
        else
        {
            completionBlock(request.uniqueId, nil);
        }
        [strongSelf.requestQueue removeRequest:request];
        
    }onError:^(NSError* error) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        errorBlock(request.uniqueId, error);
        [strongSelf.requestQueue removeRequest:request];
    }];
    
    request.isRequesting = YES;
    [self.engine enqueueOperation:op];
    return request.uniqueId;
}

// 组装成base:param:结构
- (NSDictionary*)packageBaseComponent:(NSDictionary*)dic
{
    NSMutableDictionary *finalParam = [NSMutableDictionary dictionary];
    
    // ParamDictionary
    NSString *paramValue = nil;
    NSMutableDictionary *paramDic = nil;
    if(dic == nil)
    {
        paramDic = [NSMutableDictionary new];
    }
    else
    {
        paramDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    }
    if (![paramDic objectForKey:@"cityId"])
    {
        [paramDic setValue:[NSNumber numberWithInteger:DD_CONFIG.coreSetting.cityId] forKey:@"cityId"];
    }
    paramValue = [CommonUtils dictionaryToJsonString:paramDic];
    [finalParam setValue:paramValue forKey:@"param"];
    
    // BaseDictionary
    NSString *baseValue = nil;
    NSMutableDictionary* baseDic = [NSMutableDictionary dictionaryWithDictionary:[DD_CONFIG getBaseInfo]];
    // 计算sign参数
    {
        // 拼装base
        NSArray *keys = [baseDic allKeys];
        NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
        keys = [keys sortedArrayUsingDescriptors:@[sd]];
        
        NSString* orderBase = nil;
        for(NSString *akey in keys)
        {
            if(!orderBase)
            {
                orderBase = [NSString stringWithFormat:@"%@=%@", akey, baseDic[akey]];
            }
            else
            {
                orderBase = [orderBase stringByAppendingString:[NSString stringWithFormat:@"%@=%@", akey, baseDic[akey]]];
            }
        }
        NSString *orderParam = [orderBase stringByAppendingString:paramValue];
        
        NSString *keyMurmurHash3 = [MurmurHash3_OC MurmurHash3_x64_128_OC:orderParam andSeed:20150720];
        // 加密串
        [baseDic setObject:keyMurmurHash3 forKey:@"sign"];
    }
    
    baseValue = [CommonUtils dictionaryToJsonString:baseDic];
    [finalParam setValue:baseValue forKey:@"base"];

    return finalParam;
}

- (NSString*)sendPostWithURL:(NSString*)url body:(NSMutableDictionary*)body httpHeader:(NSDictionary*)headerDic onCompletion:(HttpReuqestSucceedBlock) completionBlock onError:(HttpRequestFailedBlock)errorBlock
{
    //-----------------------------------------------------------------------------
    // 组装成base:param:结构
    NSMutableDictionary *finalSendParams = [NSMutableDictionary dictionaryWithDictionary:[self packageBaseComponent:body]];
    //-----------------------------------------------------------------------------
    
    MKNetworkOperation *op = [self.engine operationWithURLString:url
                                                          params:finalSendParams
                                                      httpMethod:POST];
    op.postDataEncoding = MKNKPostDataEncodingTypeURL;

    if(nil != headerDic)
    [op addHeaders:headerDic];
    
    DDHttpRequest* request = [[DDHttpRequest alloc] init];
    request.op = op;
    request.url = url;
    request.headers = self.customHeaders;
    request.httpMethod = POST;
    request.body = body;
    request.succeedBlock = completionBlock;
    request.failedBlock = errorBlock;
    [self.requestQueue addRequest:request];
    __weak typeof(self) weakSelf = self;
    [op onCompletion:^(MKNetworkOperation *completedOperation) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if([completedOperation responseData])
        {
            NSDictionary* dc = [completedOperation responseJSON];

            if([dc isKindOfClass:[NSDictionary class]])
            {
                NSInteger code = [[dc objectForKey:@"code"] integerValue];
                if(code == 100000)
                {
                    completionBlock(request.uniqueId,dc);
                }
                else
                {
                    NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] initWithCapacity:2];
                    [userInfo setObject:[NSString stringWithFormat:@"%ld", (long)code] forKey:@"errorCode"];
                    NSString* errorMsg = [dc objectForKey:@"message"];
                    if (errorMsg)
                    {
                        [userInfo setObject:errorMsg forKey:@"errorMsg"];
                    }
                    NSError* error = [NSError errorWithDomain:@"DingDing" code:code userInfo:userInfo];
                    errorBlock(request.uniqueId,error);
                }
                // 打印请求
                [CommonUtils printLogUrl:[completedOperation readonlyRequest].URL parameters:request.body finalResponseObject:dc];
            }
            else
            {
                completionBlock(request.uniqueId,nil);
            }
        }
        else
        {
            completionBlock(request.uniqueId,nil);
        }
        [strongSelf.requestQueue removeRequest:request];

    }onError:^(NSError* error) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        errorBlock(request.uniqueId,error);
        [CommonUtils printLogUrl:[NSURL URLWithString:request.url] parameters:request.body];
        [strongSelf.requestQueue removeRequest:request];
    }];
    
    request.isRequesting = YES;
    [self.engine enqueueOperation:op];
    return request.uniqueId;
}

- (BOOL)cancelWithUniqueId:(NSString*)uniqueId
{
    DDHttpRequest* request = [self.requestQueue findRequestWithUniqueId:uniqueId];
    if(request != nil)
    {
        [request cancel];
        [self.requestQueue removeRequest:request];
        return YES;
    }
    return NO;
}

- (void)cancelAll
{
    for(DDHttpRequest* request  in self.requestQueue.queue)
    {
        [request cancel];
    }
    [self.requestQueue removeAllRequest];
}

@end
