//
//  DDHttpService.h
//  DingDingCore
//
//  Created by phoenix on 14-10-10.
//  Copyright (c) 2014年 SEU. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef void (^HttpReuqestSucceedBlock)(NSString*reqId, NSDictionary* dic);
typedef void (^HttpRequestFailedBlock)(NSString*reqId, NSError* error);

@interface DDHttpService : NSObject

/**
 * 单例
 */
+ (DDHttpService*)getInstance;

/**
 * @brief 设置请求头
 * @param headerDic HTTP请求头字典
 * @return N/A
 */
- (void)setHeaders:(NSDictionary*)headerDic;

/**
 * @brief 删除所有HTTP请求头
 */
- (void)removeAllHeaders;

/**
 * @brief Get请求
 * @param path 请求页面
 * @param onCompletion 返回结果
 * @param onError 失败错误
 * @return uniqueId;
 */
- (NSString*)sendGetWithURL:(NSString*)url httpHeader:(NSDictionary*)headerDic onCompletion:(HttpReuqestSucceedBlock) completionBlock onError:(HttpRequestFailedBlock)errorBlock;

/**
 * @brief Post请求
 * @param path 请求页面
 * @param body 数据内容
 * @param onCompletion 返回结果
 * @param onError 失败错误
 * @return uniqueId;
 */
- (NSString*)sendPostWithURL:(NSString*)url body:(NSMutableDictionary*)body httpHeader:(NSDictionary*)headerDic onCompletion:(HttpReuqestSucceedBlock) completionBlock onError:(HttpRequestFailedBlock)errorBlock;

/**
 * @brief 取消
 * @param uniqueId
 * @return 成功或失败
 */
- (BOOL)cancelWithUniqueId:(NSString*)uniqueId;

/**
 * @brief 取消所有
 */
- (void)cancelAll;

@end