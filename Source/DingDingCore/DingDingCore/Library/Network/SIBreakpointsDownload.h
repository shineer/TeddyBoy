//
//  SIBreakpointsDownload.h
//  StoryCore
//
//  Created by 张艳娜 on 14-4-18.
//  Copyright (c) 2014年 LiuQi. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "MKNetworkOperation.h"
@interface SIBreakpointsDownload : MKNetworkOperation

+ (SIBreakpointsDownload *) operationWithURLString:(NSString *) urlString
                                            params:(NSMutableDictionary *) body
                                        httpMethod:(NSString *)method
                                      tempFilePath:(NSString *)tempFilePath
                                  downloadFilePath:(NSString *)downloadFilePath
                                       rewriteFile:(BOOL)rewrite;

@end
