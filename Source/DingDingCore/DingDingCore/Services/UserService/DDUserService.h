//
//  DDUserService.h
//  DingDingCore
//
//  Created by phoenix on 14-10-10.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Base/DDBaseService.h"

@interface DDUserService : DDBaseService
{

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
                   resopnse:(DDResponse)response;

/*
 *  @brief  登录
 *  @param  mobileNo 手机号
 *  @param  password 验证码
 *  @param  response 回调block
 *  @return N/A
 */
- (void)userLogin:(NSString*)phone
         password:(NSString*)password
         resopnse:(DDResponse)response;


@end
