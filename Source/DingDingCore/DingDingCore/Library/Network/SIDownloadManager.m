//
//  SIDownloadManager.m
//  StoryCore
//
//  Created by 张艳娜 on 14-4-18.
//  Copyright (c) 2014年 LiuQi. All rights reserved.
//

#import "SIDownloadManager.h"
#import "SIBreakpointsDownload.h"


@interface SIDownloadManager()

@property (strong, nonatomic) NSMutableArray *downloadArray;

@end

@implementation SIDownloadManager
@synthesize downloadArray = _downloadArray;
@synthesize delegate = _delegate;


+ (id)sharedSIDownloadManager
{
    static SIDownloadManager *siDownloadManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{ siDownloadManager = [[self alloc] init];});
    return siDownloadManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.downloadArray = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)addDownloadFileTaskInQueue:(NSString *)paramURL
                        toFilePath:(NSString *)paramFilePath
                  breakpointResume:(BOOL)paramResume
                       rewriteFile:(BOOL)paramRewrite
             imageDownLoadComplish:(SIDOWNComplishBlock)complishBlock
             imageDownLoadProgress:(SIDOWNProgressBlock)imageProgress
                             error:(SIDOWNErrorBlock)imageError
{
    
    // 获得临时文件的路径
    NSString  *tempDoucment = NSTemporaryDirectory();
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"/"];
    NSRange lastCharRange = [paramFilePath rangeOfCharacterFromSet:charSet options:NSBackwardsSearch];
    NSString *tempFilePath = [NSString stringWithFormat:@"%@%@.temp",
                              tempDoucment,
                              [paramFilePath substringFromIndex:lastCharRange.location + 1]];
    
    SIBreakpointsDownload *operation = [SIBreakpointsDownload operationWithURLString:paramURL
                                                                              params:nil
                                                                          httpMethod:@"GET"
                                                                        tempFilePath:tempFilePath
                                                                    downloadFilePath:paramFilePath
                                                                         rewriteFile:paramRewrite];
    // 如果已经存在下载文件 operation返回nil,否则把operation放入下载队列当中
    BOOL existDownload = NO;
    for (SIBreakpointsDownload *sibd in self.downloadArray) {
        if ([sibd.url isEqualToString:operation.url]) {
            existDownload = YES;
        }
    }
    
    if (existDownload)
    {
        // delegate
        
    } else if (operation == nil) {
       complishBlock (nil,paramFilePath);
    } else {
        [self enqueueOperation:operation];
        [self.downloadArray addObject:operation];
        
        [operation onDownloadProgressChanged:^(double progress){
//            [[self delegate] downloadManager:self withOperation:operation changeProgress:progress];
            imageProgress (progress * 100);
        }];
        
        [operation onCompletion:^(MKNetworkOperation *completedOperation) {
            
            NSFileManager *fileManager = [[NSFileManager alloc] init];
            NSError *error = nil;
            
            // 下载完成以后 先删除之前的文件 然后mv新的文件
            if ([fileManager fileExistsAtPath:paramFilePath]) {
                [fileManager removeItemAtPath:paramFilePath error:&error];
                if (error) {
                    CORE_LOG(@"remove %@ file failed!\nError:%@", paramFilePath, error);
                    exit(-1);
                }
            }
            
            [fileManager moveItemAtPath:tempFilePath toPath:paramFilePath error:&error];
            if (error) {
                CORE_LOG(@"move %@ file to %@ file is failed!\nError:%@", tempFilePath, paramFilePath, error);
                exit(-1);
            }
             complishBlock (completedOperation,paramFilePath);
//            [[self delegate] downloadManagerDidComplete:self withOperation:(SIBreakpointsDownload *)completedOperation];
           
            [self.downloadArray removeObject:operation];
            
        } onError:^(NSError *error) {
//            [[self delegate] downloadManagerError:self
//                                          withURL:paramURL
//                                        withError:error];
            imageError(paramURL, error);
            [self.downloadArray removeObject:operation];
        }];
    }
    
}

- (void)cancelDownloadFileTaskInQueue:(NSString *)paramURL
{
    SIBreakpointsDownload *deleteOperation = nil;
    for (SIBreakpointsDownload *sibd in self.downloadArray) {
        if ([sibd.url isEqualToString:paramURL]) {
            deleteOperation = sibd;
        }
    }
//    [[self delegate] downloadManagerPauseTask:self withURL:paramURL];
    [deleteOperation cancel];
    [self.downloadArray removeObject:deleteOperation];
}

- (void)cancelAllDonloads
{
    for (SIBreakpointsDownload *op in self.downloadArray) {
        [op cancel];
    }
    [self.downloadArray removeAllObjects];
}

- (NSArray *)allDownloads
{
    return self.downloadArray;
}


@end