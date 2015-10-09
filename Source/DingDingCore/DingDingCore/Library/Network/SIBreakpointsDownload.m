//
//  SIBreakpointsDownload.m
//  StoryCore
//
//  Created by 张艳娜 on 14-4-18.
//  Copyright (c) 2014年 LiuQi. All rights reserved.
//

#import "SIBreakpointsDownload.h"

@implementation SIBreakpointsDownload


+ (SIBreakpointsDownload *) operationWithURLString:(NSString *) urlString
                                            params:(NSMutableDictionary *) body
                                        httpMethod:(NSString *)method
                                      tempFilePath:(NSString *)tempFilePath
                                  downloadFilePath:(NSString *)downloadFilePath
                                       rewriteFile:(BOOL)rewrite;
{
    // 获得临时文件的路径
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *newHeadersDict = [[NSMutableDictionary alloc] init];
    
    // 如果是重新下载，就要删除之前下载过的文件
    if (rewrite && [fileManager fileExistsAtPath:tempFilePath]) {
        NSError *error = nil;
        [fileManager removeItemAtPath:tempFilePath error:&error];
        if (error) {
            CORE_LOG(@"%@ file remove failed!\nError:%@", tempFilePath, error);
        }
    }else if(rewrite && [fileManager fileExistsAtPath:downloadFilePath]){
        NSError *error = nil;
        [fileManager removeItemAtPath:downloadFilePath error:&error];
        if (error) {
            CORE_LOG(@"%@ file remove failed!\nError:%@", downloadFilePath, error);
        }
    }
    
    if ([fileManager fileExistsAtPath:downloadFilePath]) {
        return nil;
    }else {
        
        NSString *userAgentString = [NSString stringWithFormat:@"%@/%@",
                                     [[[NSBundle mainBundle] infoDictionary]
                                      objectForKey:(NSString *)kCFBundleNameKey],
                                     [[[NSBundle mainBundle] infoDictionary]
                                      objectForKey:(NSString *)kCFBundleVersionKey]];
        [newHeadersDict setObject:userAgentString forKey:@"User-Agent"];
        
        // 判断之前是否下载过 如果有下载重新构造Header
        if ([fileManager fileExistsAtPath:tempFilePath]) {
            NSError *error = nil;
            unsigned long long fileSize = [[fileManager attributesOfItemAtPath:tempFilePath
                                                                         error:&error]
                                           fileSize];
            if (error) {
                CORE_LOG(@"get %@ fileSize failed!\nError:%@", tempFilePath, error);
            }
            NSString *headerRange = [NSString stringWithFormat:@"bytes=%llu-", fileSize];
            CORE_LOG(@"fileSize%llu",fileSize);
            [newHeadersDict setObject:headerRange forKey:@"RANGE"];
            
        }
        
        // 初始化opertion
        SIBreakpointsDownload *operation = [[SIBreakpointsDownload alloc] initWithURLString:urlString
                                                                                     params:body
                                                                                 httpMethod:method];
        
        [SIBreakpointsDownload initICEHeader:operation];
        
        [operation addDownloadStream:[NSOutputStream outputStreamToFileAtPath:tempFilePath append:YES]];
        
        [operation addHeaders:newHeadersDict];
        
        return operation;
    }
}

+ (void)initICEHeader:(SIBreakpointsDownload *)op
{
#if 0
    STICEService* ice = [STICEService getInstance];
    NSMutableDictionary * newHeadersDict = [NSMutableDictionary dictionary];
    
    if(ice && ice.token)
        [newHeadersDict setObject:ice.token forKey:@"token"];
    if(ice && ice.userUID)
        [newHeadersDict setObject:ice.userUID forKey:@"uid"];
    
    [op addHeaders:newHeadersDict];
#endif
}


@end
