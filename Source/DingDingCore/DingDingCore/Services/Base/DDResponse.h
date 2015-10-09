//
//  DDResponse.h
//  DingDingCore
//
//  Created by phoenix on 14-10-10.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import "DDError.h"

typedef enum
{
    EDDResponseResultSucceed        =   0,
    EDDResponseResultFailed         =   1,
    
}EDDResponseResult;

typedef enum
{
    EDDUnknowError = -1000,              //未知错误
    EDDTimeOutError = -999,              //连接超时
    EDDNetWorkError = -998,              //网络错误
    EDDTokenError = -99,                 //从token中获取用户失败
    EDDServerAbnormal = -500,            //服务器异常
    EDDServerError = -995,               //服务器错误
    EDDContentViolate = -994             //内容包含违禁词
    
}EDDErrorCode;

/*
 *  @brief 通用的请求响应
 *  @param result 返回结果
 *  @param dict 返回具体内容 Value Key
 */
typedef void (^DDResponse)(NSInteger result, NSDictionary *dict, DDError* error);

/*
 *  @brief 下载静态图片的请求响应
 *  @param result 返回结果
 *  @param image 返回图片
 *  @param url 返回图片地址
 */
typedef void (^DDResponseImage)(NSInteger result, id image, NSString* url, DDError* error);

/*
 *  @brief 下载文件的的请求响应
 *  @param result 返回结果
 *  @param path 返回文件路径
 */
typedef void (^DDResponseFile)(NSInteger result, NSString* path, DDError* error);

/*
 *  @brief 上传下载进度响应
 *  @param progress 请求进度
 */
typedef void (^DDProgress)(double progress);


