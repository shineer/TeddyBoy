//
//  DDFileService.h
//  DingDingCore
//
//  Created by phoenix on 15/9/15.
//  Copyright (c) 2015年 SEU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Base/DDBaseService.h"

@interface DDFileService : DDBaseService
{
    
}

/*
 *  @brief  上传头像
 *  @param  file 图片源
 *  @param  response 回调block
 *  @return N/A
 */
- (void)uploadImage:(UIImage*)image
           resopnse:(DDResponse)response;

/*
 *  @brief  下载图片
 *  @param  图片url地址
 *  @param  response 回调block
 *  @return N/A
 */
- (void)downloadImage:(NSString*)urlString
             response:(DDResponse)response;

@end
