//
//  DDFileService.m
//  DingDingCore
//
//  Created by phoenix on 15/9/15.
//  Copyright (c) 2015年 SEU. All rights reserved.
//

#import "DDFileService.h"
#import "DDHttpService.h"
#import "DDHttpTransferService.h"

@implementation DDFileService

- (id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

/*
 *  @brief  上传头像
 *  @param  file 图片源
 *  @param  response 回调block
 *  @return N/A
 */
- (void)uploadImage:(UIImage*)image
           resopnse:(DDResponse)response
{
    //    NSString* url = DD_CONFIG.uploadIconUrl;
    //
    //    NSData* data = UIImageJPEGRepresentation(file, 0.7);
    //
    //    [[DDHttpTransferService getInstance] uploadImageWithURL:url imageData:data params:nil headers:nil multipart:YES onCompletion:^(NSDictionary *dic) {
    //
    //        CORE_LOG(@"---- uploadIcon success!!!! ----");
    //
    //        if(response)
    //        {
    //            /*
    //             "icon_url":用户头像url
    //             */
    //            CORE_LOG(@"---- uploadIcon success!!!! ----");
    //            response(EDDResponseResultSucceed, dic, nil);
    //        }
    //
    //    } onError:^(NSError *error) {
    //
    //        CORE_LOG(@"---- uploadIcon fail!!!! error = %@ ----", error.description);
    //
    //        if(response)
    //        {
    //            DDError *ddError = [DDError errorWithNSError:error];
    //            response(EDDResponseResultFailed, nil, ddError);
    //        }
    //
    //    } onProgress:^(double progress) {
    //
    //    }];
}

/*
 *  @brief  下载图片
 *  @param  图片url地址
 *  @param  response 回调block
 *  @return N/A
 */
- (void)downloadImage:(NSString*)urlString
             response:(DDResponse)response
{
    [[DDHttpTransferService getInstance] downloadImageAtURL:urlString onCompletion:^(UIImage *fetchedImage, NSURL *url, NSDictionary *headerDict, NSString * path) {
        
        if(fetchedImage)
        {
            if(response)
            {
                NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      fetchedImage, DD_ATTR_R_PORTRAIT_IMAGE,
                                      urlString, DD_ATTR_R_PORTRAIT_URL,
                                      nil];
                
                response(EDDResponseResultSucceed, dict, nil);
            }
        }
        else
        {
            response(EDDResponseResultFailed, nil, nil);
        }
        
    } onProgress:^(double progress) {
        
    } useCache:YES];
}

@end
