//
//  DDError.h
//  DingDingCore
//
//  Created by phoenix on 14-10-10.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDError : NSError
{
	
}

/**
 * @brief 构造Error
 *
 * @param error NSError 对象
 * @return 返回错误对象.
 */
+ (DDError*)errorWithNSError:(NSError*)error;

/**
 * @brief 构造Error
 *
 * @param code 错误代码
 * @param errorMessage 错误信息
 *
 * @return 返回错误对象.
 */
+ (DDError*)errorWithCode:(NSInteger)code errorMessage:(NSString*)errorMsg;

/**
 * @brief 返回相关错误码
 * @return 错误码
 */
- (NSInteger)errorCode;

/**
 * @brief 错误信息
 * @return 错误信息
 */
- (NSString*)errorMsg;

@end