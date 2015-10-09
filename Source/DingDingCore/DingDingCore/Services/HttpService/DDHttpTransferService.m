//
//  DDHttpTransferService.m
//  DingDingCore
//
//  Created by phoenix on 14-10-10.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import "DDHttpTransferService.h"
#import "MKNetworkKit.h"
#import "SIBreakpointsDownload.h"
#import "SIDownloadManager.h"

@interface DDHttpUploadRequest: NSObject

@property (nonatomic, copy) UploadSucceedBlock succeedHandler;
@property (nonatomic, copy) UploadFailedBlock failedHandler;
@property (nonatomic, copy) Progress progressHandler;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSString *uniqueId;
@property (nonatomic, strong) NSMutableDictionary *params;
@end

@implementation DDHttpUploadRequest

- (id)init
{
    self = [super init];
    if (self)
    {
        self.uniqueId = [NSString uniqueString];
    }
    return self;
}
@end

@interface DDHttpUploadQueue : NSObject

@property (strong, nonatomic) NSMutableArray *queue;

- (NSUInteger)count;
- (void)addRequest:(DDHttpUploadRequest*)request;
- (void)removeRequest:(DDHttpUploadRequest*)request;
- (void)removeRequestWithUniqueId:(NSString*)uniqueId;
- (void)removeAllRequest;
- (DDHttpUploadRequest*)findRequestWithUniqueId:(NSString*)uniqueId;
- (DDHttpUploadRequest*)uploadRequestAtIndex:(NSUInteger)index;

@end

@implementation DDHttpUploadQueue

- (id)init
{
    self = [super init];
    if (self)
    {
        self.queue = [[NSMutableArray alloc] init];
    }
    return self;
}

- (DDHttpUploadRequest*)uploadRequestAtIndex:(NSUInteger)index
{
    if(index > [self count])
        return nil;
    
    return (DDHttpUploadRequest*)[self.queue objectAtIndex:index];
}

- (NSUInteger)count
{
    return [self.queue count];
}

- (void)addRequest:(DDHttpUploadRequest*)request
{
    if(request == nil)
        return;
    
    [self.queue addObject:request];
}

- (void)removeRequest:(DDHttpUploadRequest*)request
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
    DDHttpUploadRequest* request = [self findRequestWithUniqueId:uniqueId];
    if(request != nil)
    {
        [self removeRequest:request];
    }
}

- (DDHttpUploadRequest*)findRequestWithUniqueId:(NSString*)uniqueId
{
    for(DDHttpUploadRequest *request in self.queue)
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

@interface DDNetworkEngine : MKNetworkEngine

@end

@implementation DDNetworkEngine

- (NSString*)cacheDirectoryName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:@"DDImages"];
    return cacheDirectoryName;
}
@end

@interface DDImageUpload : MKNetworkOperation
{
}

@property (strong, nonatomic) NSData *imageData;
@property (strong, nonatomic) NSMutableDictionary *params;
@property (nonatomic, assign) BOOL multipart;

- (id)initWithURLString:(NSString *)aURLString
                 params:(NSMutableDictionary *)params image:(UIImage *)image;

@end

@implementation DDImageUpload

- (id)initWithURLString:(NSString *)aURLString
                 params:(NSMutableDictionary *)params image:(UIImage *)image
{
    
    self = [self initWithURLString:aURLString
                            params:params
                              data:UIImageJPEGRepresentation(image, 0.8)];
    return self;
}

- (id)initWithURLString:(NSString *)aURLString
                 params:(NSMutableDictionary *)params data:(NSData *)data
{
    self = [super initWithURLString:aURLString params:params httpMethod:@"POST"];
    if (self)
    {
        if(nil != data)
        {
            self.imageData = data;
        }
        self.params = [NSMutableDictionary dictionaryWithCapacity:10];
        if(params != nil)
        {
            [self.params setDictionary:params];
        }
    }
    return self;
}

- (NSData*)bodyData
{
	NSString *boundary = @"FlPm4LpSXsE";//Multipart 分割字段
	if (self.params != nil)
    {
        NSString* theKey;
		NSMutableString *stringBuffer = [[NSMutableString alloc] initWithCapacity:0];
		NSEnumerator *e = [self.params keyEnumerator];
        //加入参数对信息
		while (theKey = [e nextObject])
        {
			[stringBuffer appendFormat:@"--"];
			[stringBuffer appendString:boundary];
			[stringBuffer appendFormat:@"Content-Disposition: form-data; name=\"" ];
			[stringBuffer appendString:theKey];
			[stringBuffer appendFormat:@"\"\r\n\r\n"];
            NSObject *value = [self.params objectForKey:theKey];
            [stringBuffer appendFormat:@"%@", value];
			[stringBuffer appendFormat:@"\r\n"];
        }
        if (self.multipart)
        {
            [stringBuffer appendFormat:@"--"];
            [stringBuffer appendString:boundary];
            [stringBuffer appendFormat:@"\r\n"];
            [stringBuffer appendFormat:@"Content-Disposition: form-data; name=\"data\";filename=\""];
            [stringBuffer appendFormat:@"tmp_filename"];
            [stringBuffer appendFormat:@".jpg\"\r\n"];
            [stringBuffer appendFormat:@"Content-Type: image/jpg\r\n\r\n"];
        }
		
		NSMutableData *tempData=[NSMutableData dataWithLength:0];
		[tempData appendData: [stringBuffer dataUsingEncoding:NSUTF8StringEncoding]];
		
		if (_imageData)
        {
		    [tempData appendData: _imageData];//加入照片数据
            
		}
		
		NSMutableString *mutString=[[NSMutableString alloc]initWithCapacity:0];
		[mutString appendString:@"\r\n--"];//加入multipart结束符
		[mutString appendString:boundary];
		[mutString appendString:@"--\r\n"];
		[tempData appendData:[mutString dataUsingEncoding:NSUTF8StringEncoding]];
		
		//设置发送请求的头部信息
		[self setValue:@"multipart/form-data; charset=UTF-8; boundary=FlPm4LpSXsE" forHTTPHeaderField:@"Content-Type"];
		NSString *reqStr = [NSString stringWithFormat:@"%ld", (unsigned long)[tempData length]];
		[self setValue:reqStr forHTTPHeaderField:@"Content-Length"];
		
		return  tempData;
	}
	
	return  nil;
}

@end

@interface DDMultiImagesUpload : MKNetworkOperation
{
}

@property (strong, nonatomic) NSArray *imageDataArray;
@property (strong, nonatomic) NSMutableDictionary *params;

- (id)initWithURLString:(NSString *)aURLString
                 params:(NSMutableDictionary *)params imageArray:(NSArray *)imageArray;

@end

@implementation DDMultiImagesUpload

- (id)initWithURLString:(NSString *)aURLString
                 params:(NSMutableDictionary *)params imageArray:(NSArray *)imageArray
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:imageArray.count];
    
    for(UIImage* item in imageArray)
    {
        [array addObject:UIImageJPEGRepresentation(item, 0.7)];
    }
    self = [self initWithURLString:aURLString
                            params:params
                         dataArray:array];
    return self;
}

- (id)initWithURLString:(NSString *)aURLString
                 params:(NSMutableDictionary *)params dataArray:(NSArray *)array
{
    self = [super initWithURLString:aURLString params:params httpMethod:@"POST"];
    if (self)
    {
        if(nil != array)
        {
            self.imageDataArray = array;
        }
        self.params = [NSMutableDictionary dictionaryWithCapacity:10];
        if(params != nil)
        {
            [self.params setDictionary:params];
        }
    }
    return self;
}

- (NSData*)bodyData
{
    NSString *boundary = @"FlPm4LpSXsE";//Multipart 分割字段
    if (self.params != nil)
    {
        NSString* theKey;
        NSMutableString *stringBuffer = [[NSMutableString alloc] initWithCapacity:0];
        NSEnumerator *e = [self.params keyEnumerator];
        //加入参数对信息
        while (theKey = [e nextObject])
        {
            [stringBuffer appendFormat:@"--"];
            [stringBuffer appendString:boundary];
            [stringBuffer appendFormat:@"Content-Disposition: form-data; name=\"" ];
            [stringBuffer appendString:theKey];
            [stringBuffer appendFormat:@"\"\r\n\r\n"];
            NSObject *value = [self.params objectForKey:theKey];
            [stringBuffer appendFormat:@"%@", value];
            [stringBuffer appendFormat:@"\r\n"];
        }
        
        NSMutableData *tempData = [NSMutableData dataWithLength:0];
        [tempData appendData: [stringBuffer dataUsingEncoding:NSUTF8StringEncoding]];
        
        int index = 0;
        for(NSData* imageData in self.imageDataArray)
        {
            NSMutableString *tempStr = [[NSMutableString alloc] initWithCapacity:0];
            
            [tempStr appendFormat:@"--"];
            [tempStr appendString:boundary];
            [tempStr appendFormat:@"\r\n"];
            [tempStr appendFormat:@"Content-Disposition: form-data; name=\"data_%d\";filename=\"", index];
            [tempStr appendFormat:@"tmp_filename%d", index];
            [tempStr appendFormat:@".jpg\"\r\n"];
            [tempStr appendFormat:@"Content-Type: image/jpg\r\n\r\n"];
            
            [tempData appendData: [tempStr dataUsingEncoding:NSUTF8StringEncoding]];
            
            if (imageData)
            {
                [tempData appendData: imageData];//加入照片数据
                
            }
            
            NSMutableString *mutString=[[NSMutableString alloc]initWithCapacity:0];
            [mutString appendString:@"\r\n--"];//加入multipart结束符
            [mutString appendString:boundary];
            [mutString appendString:@"--\r\n"];
            [tempData appendData:[mutString dataUsingEncoding:NSUTF8StringEncoding]];
            
            index++;
        }
        
        //设置发送请求的头部信息
        [self setValue:@"multipart/form-data; charset=UTF-8; boundary=FlPm4LpSXsE" forHTTPHeaderField:@"Content-Type"];
        NSString *reqStr = [NSString stringWithFormat:@"%ld", (unsigned long)[tempData length]];
        [self setValue:reqStr forHTTPHeaderField:@"Content-Length"];
        
        return  tempData;
    }
    
    return  nil;
}

@end


@interface DDVoiceUpload : MKNetworkOperation
{
}

@property (strong, nonatomic) NSData *voiceData;
@property (strong, nonatomic) NSMutableDictionary *params;
@property (nonatomic, assign) BOOL multipart;

- (id)initWithURLString:(NSString *)aURLString
                 params:(NSMutableDictionary *)params voicePath:(NSString*)filePath;

@end

@implementation DDVoiceUpload

- (id)initWithURLString:(NSString *)aURLString
                 params:(NSMutableDictionary *)params voicePath:(NSString*)filePath
{
    
    NSData* data = [NSData dataWithContentsOfFile:filePath];

    self = [self initWithURLString:aURLString
                            params:params
                              data:data];
    return self;
}

- (id)initWithURLString:(NSString *)aURLString
                 params:(NSMutableDictionary *)params data:(NSData *)data
{
    self = [super initWithURLString:aURLString params:params httpMethod:@"POST"];
    if (self)
    {
        if(nil != data)
        {
            self.voiceData = data;
        }
        self.params = [NSMutableDictionary dictionaryWithCapacity:10];
        if(params != nil)
        {
            [self.params setDictionary:params];
        }
    }
    return self;
}

- (NSData*)bodyData
{
    NSString *boundary = @"FlPm4LpSXsE";//Multipart 分割字段
    if (self.params != nil)
    {
        NSString* theKey;
        NSMutableString *stringBuffer = [[NSMutableString alloc] initWithCapacity:0];
        NSEnumerator *e = [self.params keyEnumerator];
        //加入参数对信息
        while (theKey = [e nextObject])
        {
            [stringBuffer appendFormat:@"--"];
            [stringBuffer appendString:boundary];
            [stringBuffer appendFormat:@"Content-Disposition: form-data; name=\"" ];
            [stringBuffer appendString:theKey];
            [stringBuffer appendFormat:@"\"\r\n\r\n"];
            NSObject *value = [self.params objectForKey:theKey];
            [stringBuffer appendFormat:@"%@", value];
            [stringBuffer appendFormat:@"\r\n"];
        }
        if (self.multipart)
        {
            [stringBuffer appendFormat:@"--"];
            [stringBuffer appendString:boundary];
            [stringBuffer appendFormat:@"\r\n"];
            [stringBuffer appendFormat:@"Content-Disposition: form-data; name=\"file\";filename=\""];
            NSTimeInterval fileName = [[NSDate date] timeIntervalSince1970];
            [stringBuffer appendFormat:@"%llu",(long long)(fileName * 1000)];
            [stringBuffer appendFormat:@".aac\"\r\n"];
            [stringBuffer appendFormat:@"Content-Type: audio/x-mei-aac\r\n\r\n"];
        }
        
        NSMutableData *tempData=[NSMutableData dataWithLength:0];
        [tempData appendData: [stringBuffer dataUsingEncoding:NSUTF8StringEncoding]];
        
        if (_voiceData)
        {
            [tempData appendData: _voiceData];//加入语音数据
            
        }
        
        NSMutableString *mutString=[[NSMutableString alloc]initWithCapacity:0];
        [mutString appendString:@"\r\n--"];//加入multipart结束符
        [mutString appendString:boundary];
        [mutString appendString:@"--\r\n"];
        [tempData appendData:[mutString dataUsingEncoding:NSUTF8StringEncoding]];
        
        //设置发送请求的头部信息
        [self setValue:@"multipart/form-data; charset=UTF-8; boundary=FlPm4LpSXsE" forHTTPHeaderField:@"Content-Type"];
        NSString *reqStr = [NSString stringWithFormat:@"%ld", (unsigned long)[tempData length]];
        [self setValue:reqStr forHTTPHeaderField:@"Content-Length"];
        
        return  tempData;
    }
    
    return  nil;
}

@end

static DDHttpTransferService * instance = nil;

@interface DDHttpTransferService()<SIDownloadManagerDelegate>

@property (strong, nonatomic) MKNetworkEngine *engine;
@property (strong, nonatomic) NSMutableArray *opValues;
@property (strong, nonatomic) NSMutableArray *opKeys;
@property (strong, nonatomic) DDHttpUploadQueue *requestQueue;
@property (nonatomic) int uploadingImageCount;
@property (nonatomic) int uploadingVoiceCount;

-(void)handleCheckUploadQueue:(NSTimer*)timer;

@end

@implementation DDHttpTransferService

+ (DDHttpTransferService*)getInstance
{
    @synchronized(self) {
        if (instance == nil)
        {
            instance = [[DDHttpTransferService alloc] initWithHeaders:nil];
        }
    }
    return instance;
}


- (void)dealloc
{
    [_opValues removeAllObjects];
    [_opKeys removeAllObjects];
}

- (id)initWithHeaders:(NSDictionary*)headerDic
{
    self = [self init];
    if (self)
    {
        NSMutableDictionary *newHeadersDict = nil;
        if(nil == headerDic)
        {
            newHeadersDict = [[NSMutableDictionary alloc] init];
        }
        else
        {
            newHeadersDict = [headerDic mutableCopy];
        }
        [newHeadersDict setObject:@"IOS" forKey:@"x-client-identifier"];
        self.engine = [[MKNetworkEngine alloc] initWithHostName:nil customHeaderFields:newHeadersDict];
        
        self.opValues = [[NSMutableArray alloc] init];
        self.opKeys = [[NSMutableArray alloc] init];
        
        [self.engine useCache];
        
        self.requestQueue = [[DDHttpUploadQueue alloc] init];
        self.uploadingImageCount = 0;
        self.uploadingVoiceCount = 0;
        
    }
    return self;
}

- (NSString*)addOperation:(MKNetworkOperation*)op
{
    NSString *uniqueId = [NSString uniqueString];
    [self.opValues addObject:op];
    [self.opKeys addObject:uniqueId];
    
    return uniqueId.copy;
}

- (BOOL)removeOperation:(MKNetworkOperation*)op
{
    NSUInteger index = [self.opValues indexOfObject:op];
    if(index != NSNotFound)
    {
        [self.opValues removeObjectAtIndex:index];
        [self.opKeys removeObjectAtIndex:index];
        return YES;
    }
    return NO;
}

- (BOOL)cancelWithUniqueId:(NSString*)uniqueId
{
    DDHttpUploadRequest* request = [self.requestQueue findRequestWithUniqueId:uniqueId];
    if(request)
    {
        [self.requestQueue removeRequest:request];
    }
    
    NSUInteger index = [self.opKeys indexOfObject:uniqueId];
    MKNetworkOperation* op = [self.opValues objectAtIndex:index];
    if(nil != op)
    {
        [op cancel];
        return YES;
    }
    return NO;
}

// 取消某个断点下载
- (void)pauseTaskWithUrl:(NSString*) url
{
    SIDownloadManager * downLoadFile = [SIDownloadManager sharedSIDownloadManager];
    [downLoadFile cancelDownloadFileTaskInQueue:url];
}

- (void)cancelAllBreakpointDownLoad
{
    SIDownloadManager * downLoadFile = [SIDownloadManager sharedSIDownloadManager];
    [downLoadFile cancelAllDonloads];
}

- (BOOL)cancelDownLoadUniqueId:(NSString*) uniqueUrl
{
    SIDownloadManager * downLoadManager = [SIDownloadManager sharedSIDownloadManager];
    [downLoadManager cancelDownloadFileTaskInQueue:uniqueUrl];
    return YES;
}

-(BOOL)cancelAll
{
    for(MKNetworkOperation* op in self.opValues)
    {
        [op cancel];
        return YES;
    }
    return NO;
}

- (NSString*)uploadFormFileWithURL:(NSString*)url
                            params:(NSMutableDictionary*) params
                              file:(NSString*)file
                          fileType:(NSString*)fileType
                      onCompletion:(UploadSucceedBlock)completionBlock
                           onError:(UploadFailedBlock)errorBlock
                        onProgress:(Progress)progressBlock
{
    NSString *encodeURL = url;
    MKNetworkOperation *op = [self.engine operationWithURLString:encodeURL
                                                          params:params
                                                      httpMethod:@"POST"];
    [self initICEHeader:op];
    [op addFile:file forKey:@"file" mimeType:fileType];   //audio/mp3
    //  [op addFile:file forKey:@"audio/mp3"];
    // setFreezable uploads your images after connection is restored!
    [op setFreezable:YES];
    [op onCompletion:^(MKNetworkOperation* completedOperation) {
        
        [self removeOperation:op];
        
//        SBJsonParser *parser = [[SBJsonParser alloc] init];
//        id objectParsedFromJson = [parser objectWithData:[completedOperation responseData]];
//        
//        if([objectParsedFromJson isKindOfClass:[NSDictionary class]]){
//            NSDictionary *responseDict = (NSDictionary *)objectParsedFromJson;
//            completionBlock(responseDict);
//        }
        
        // completionBlock(nil);
        
    }onError:^(NSError* error) {
        [self removeOperation:op];
        errorBlock(error);
    }];
    
    [op onUploadProgressChanged:^(double progress) {
       // RR_LOG(LOG_LEVEL_INFO ,@"uploadFormFile progress %.2f", progress*100.0);
        progressBlock(progress*100.0);
    }];
    
    //    [self.opValues addObject:op];
    NSString* uniqueId = [self addOperation:op];
    [self.engine enqueueOperation:op];
    return uniqueId;
}


- (NSString*)uploadImageWithURLToQueue:(NSString *)url
                             imagePath:(NSString *)imagePath
                                params:(NSMutableDictionary*) params
                          onCompletion:(UploadSucceedBlock) completionBlock
                               onError:(UploadFailedBlock) errorBlock
                            onProgress:(Progress) progressBlock  {
    
    NSString *encodeURL = url;
    DDHttpUploadRequest* request = [[DDHttpUploadRequest alloc] init];
    request.url = encodeURL;
    request.imagePath= imagePath;
    request.params = params;
    request.succeedHandler = completionBlock;
    request.failedHandler = errorBlock;
    request.progressHandler = progressBlock;
    
    [self.requestQueue addRequest:request];
    [self checkUploadQueue];
    
    return request.uniqueId;
    
}

-(void)checkUploadQueue
{
    [[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(handleCheckUploadQueue:) userInfo:nil repeats:NO] fire];
}

-(void)handleCheckUploadQueue:(NSTimer*)timer
{
    if(self.uploadingImageCount > 0 || self.uploadingVoiceCount > 0)
        return;
    
    if([self.requestQueue count] > 0)
    {
        
        DDHttpUploadRequest* uploadRequest = [self.requestQueue uploadRequestAtIndex:0];
        if(nil == uploadRequest)
            return;
        
        NSData* data = [NSData dataWithContentsOfFile:uploadRequest.imagePath];
        if(data)
        {
            [self uploadImageWithURL:uploadRequest.url imageData:data params:uploadRequest.params headers:nil multipart:YES onCompletion:uploadRequest.succeedHandler onError:uploadRequest.failedHandler onProgress:uploadRequest.progressHandler];
        }
        
        [self.requestQueue removeRequest:uploadRequest];
    }
}

- (NSString*)uploadImageWithURL:(NSString*)url
                      imageData:(NSData*)data
                         params:(NSMutableDictionary*)params
                        headers:(NSDictionary*)headers
                      multipart:(BOOL)multipart
                   onCompletion:(UploadSucceedBlock)completionBlock
                        onError:(UploadFailedBlock)errorBlock
                     onProgress:(Progress) progressBlock
{
    //-----------------------------------------------------------------------------
    // 如果session id存在的话需要替换(unknown)
//    NSString* sessionID = DD_CONFIG.sessionId;
//    if(sessionID && sessionID.length > 0)
//    {
//        NSMutableString* tempUrl = [NSMutableString stringWithString:url];
//        url = [tempUrl stringByReplacingOccurrencesOfString:@"unknown" withString:sessionID];
//    }
//
//    // 所有请求都要在url后面带上auth
//    url = [NSString stringWithFormat:@"%@&oh=%@", url, [DD_CONFIG getAuthCode]];
//    // 所有请求都要在url后面带上token
//    if(DD_CONFIG.token && DD_CONFIG.token.length > 0)
//    {
//        url = [NSString stringWithFormat:@"%@&token=%@", url, DD_CONFIG.token];
//    }
//    
//    NSDictionary* platformInfoDict = [DD_CONFIG getPlatformInfo];
//    // 版本号
//    url = [NSString stringWithFormat:@"%@&version=%@", url, [platformInfoDict objectForKey:@"version"]];
//    // 渠道号
//    url = [NSString stringWithFormat:@"%@&fid=%@", url, [platformInfoDict objectForKey:@"fid"]];
//    // 平台(Android,ios,symbian,kjava)
//    url = [NSString stringWithFormat:@"%@&platform=%@", url, [platformInfoDict objectForKey:@"platform"]];
//    // 产品号
//    url = [NSString stringWithFormat:@"%@&product=%@", url, [platformInfoDict objectForKey:@"product"]];
//    // 手机型号
//    NSString* phoneType = [[platformInfoDict objectForKey:@"phonetype"] stringByReplacingOccurrencesOfString:@" " withString:@""];
//    url = [NSString stringWithFormat:@"%@&phoneType=%@", url, phoneType];
    //-----------------------------------------------------------------------------
    
    NSString *encodeURL = url;
    DDImageUpload* upload = [[DDImageUpload alloc] initWithURLString:encodeURL params:params data:data];
    upload.multipart = multipart;
    upload.shouldUseMAXTimeOut = YES;

    if (headers)
    {
        [upload addHeaders:headers];
    }
    
    __weak typeof(self) weakSelf = self;
    
    [upload onCompletion:^(MKNetworkOperation* completedOperation) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        [strongSelf removeOperation:upload];
        completionBlock([completedOperation responseJSON]);
        strongSelf.uploadingImageCount--;
        [strongSelf checkUploadQueue];
        
    }onError:^(NSError* error) {
        
        if ([self removeOperation:upload])
        {
            self.uploadingImageCount--;
        }
        errorBlock(error);
        [self checkUploadQueue];
    }];
    
    [upload onUploadProgressChanged:^(double progress) {
        
        progressBlock(progress * 100.0);
    }];
    
    self.uploadingImageCount++;
    NSString* uniqueId = [self addOperation:upload];
    [self.engine enqueueOperation:upload];
    return uniqueId;
}

- (NSString*)uploadImagesWithURL:(NSString *)url
                          params:(NSMutableDictionary*)params
                         headers:(NSDictionary*)headers
                          images:(NSArray*)images
                    onCompletion:(UploadSucceedBlock)completionBlock
                         onError:(UploadFailedBlock)errorBlock
                      onProgress:(Progress)progressBlock
{
    //-----------------------------------------------------------------------------
    // 如果session id存在的话需要替换(unknown)
//    NSString* sessionID = DD_CONFIG.sessionId;
//    if(sessionID && sessionID.length > 0)
//    {
//        NSMutableString* tempUrl = [NSMutableString stringWithString:url];
//        url = [tempUrl stringByReplacingOccurrencesOfString:@"unknown" withString:sessionID];
//    }
//    
//    // 所有请求都要在url后面带上auth
//    url = [NSString stringWithFormat:@"%@&oh=%@", url, [DD_CONFIG getAuthCode]];
//    // 所有请求都要在url后面带上token
//    if(DD_CONFIG.token && DD_CONFIG.token.length > 0)
//    {
//        url = [NSString stringWithFormat:@"%@&token=%@", url, DD_CONFIG.token];
//    }
//    
//    NSDictionary* platformInfoDict = [DD_CONFIG getPlatformInfo];
//    // 版本号
//    url = [NSString stringWithFormat:@"%@&version=%@", url, [platformInfoDict objectForKey:@"version"]];
//    // 渠道号
//    url = [NSString stringWithFormat:@"%@&fid=%@", url, [platformInfoDict objectForKey:@"fid"]];
//    // 平台(Android,ios,symbian,kjava)
//    url = [NSString stringWithFormat:@"%@&platform=%@", url, [platformInfoDict objectForKey:@"platform"]];
//    // 产品号
//    url = [NSString stringWithFormat:@"%@&product=%@", url, [platformInfoDict objectForKey:@"product"]];
//    // 手机型号
//    NSString* phoneType = [[platformInfoDict objectForKey:@"phonetype"] stringByReplacingOccurrencesOfString:@" " withString:@""];
//    url = [NSString stringWithFormat:@"%@&phoneType=%@", url, phoneType];
    //-----------------------------------------------------------------------------
    
    NSString *encodeURL = url;
    DDMultiImagesUpload* upload = [[DDMultiImagesUpload alloc] initWithURLString:encodeURL params:params dataArray:images];
    upload.shouldUseMAXTimeOut = YES;
    
    if (headers)
    {
        [upload addHeaders:headers];
    }
    
    __weak typeof(self) weakSelf = self;
    
    [upload onCompletion:^(MKNetworkOperation* completedOperation) {
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        [strongSelf removeOperation:upload];
        completionBlock([completedOperation responseJSON]);
        strongSelf.uploadingImageCount--;
        [strongSelf checkUploadQueue];
        
    }onError:^(NSError* error) {
        
        if ([self removeOperation:upload])
        {
            self.uploadingImageCount--;
        }
        errorBlock(error);
        [self checkUploadQueue];
    }];
    
    [upload onUploadProgressChanged:^(double progress) {
        
        progressBlock(progress * 100.0);
    }];
    
    self.uploadingImageCount++;
    NSString* uniqueId = [self addOperation:upload];
    [self.engine enqueueOperation:upload];
    return uniqueId;
}

- (NSString*)uploadAudioWithURL:(NSString*)url
                      audioData:(NSData*)data
                         params:(NSMutableDictionary*)params
                        headers:(NSDictionary*)headers
                      multipart:(BOOL)multipart
                   onCompletion:(UploadSucceedBlock)completionBlock
                        onError:(UploadFailedBlock)errorBlock
                     onProgress:(Progress) progressBlock
{
    //-----------------------------------------------------------------------------
    // 如果session id存在的话需要替换(unknown)
//    NSString* sessionID = DD_CONFIG.sessionId;
//    if(sessionID && sessionID.length > 0)
//    {
//        NSMutableString* tempUrl = [NSMutableString stringWithString:url];
//        url = [tempUrl stringByReplacingOccurrencesOfString:@"unknown" withString:sessionID];
//    }
//
//    // 所有请求都要在url后面带上auth
//    url = [NSString stringWithFormat:@"%@&oh=%@", url, [DD_CONFIG getAuthCode]];
//    // 所有请求都要在url后面带上token
//    if(DD_CONFIG.token && DD_CONFIG.token.length > 0)
//    {
//        url = [NSString stringWithFormat:@"%@&token=%@", url, DD_CONFIG.token];
//    }
//    
//    NSDictionary* platformInfoDict = [DD_CONFIG getPlatformInfo];
//    // 版本号
//    url = [NSString stringWithFormat:@"%@&version=%@", url, [platformInfoDict objectForKey:@"version"]];
//    // 渠道号
//    url = [NSString stringWithFormat:@"%@&fid=%@", url, [platformInfoDict objectForKey:@"fid"]];
//    // 平台(Android,ios,symbian,kjava)
//    url = [NSString stringWithFormat:@"%@&platform=%@", url, [platformInfoDict objectForKey:@"platform"]];
//    // 产品号
//    url = [NSString stringWithFormat:@"%@&product=%@", url, [platformInfoDict objectForKey:@"product"]];
    //-----------------------------------------------------------------------------
    
    NSString *encodeURL = url;
    DDVoiceUpload* upload = [[DDVoiceUpload alloc] initWithURLString:encodeURL params:params data:data];
    upload.multipart = multipart;
    upload.shouldUseMAXTimeOut = YES;
    if (headers)
    {
        [upload addHeaders:headers];
    }
    
    __weak typeof(self) weakSelf = self;
    
    [upload onCompletion:^(MKNetworkOperation* completedOperation) {
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        [strongSelf removeOperation:upload];
        completionBlock([completedOperation responseJSON]);
        strongSelf.uploadingVoiceCount--;
        [strongSelf checkUploadQueue];
        
    }onError:^(NSError* error) {
        
        if ([self removeOperation:upload])
        {
            self.uploadingVoiceCount--;
        }
        errorBlock(error);
        [self checkUploadQueue];
    }];
    
    [upload onUploadProgressChanged:^(double progress) {
        
        progressBlock(progress * 100.0);
    }];
    
    self.uploadingVoiceCount++;
    NSString* uniqueId = [self addOperation:upload];
    [self.engine enqueueOperation:upload];
    return uniqueId;
}


- (NSString*)downloadAudioWithURL:(NSString*)url
                     onCompletion:(DownloadSucceedBlock)completionBlock
                          onError:(DownloadFailedBlock)errorBlock
                       onProgress:(Progress) progressBlock
{
    
    NSString *encodeURL = url;
    MKNetworkOperation *op = [self.engine operationWithURLString:encodeURL
                                                          params:nil
                                                      httpMethod:@"GET"];
    // 已经有缓存
    if([self audioPathAtUrl:url])
        return nil;
    
    // 音频缓存目录
    NSString *audioCacheDir = [self getAudioCachePath];
    // 最终音频路径 = 音频缓存目录/[url md5]
    NSString *audioCachePath = [audioCacheDir stringByAppendingPathComponent:[url md5]];
    
    [op addDownloadStream:[NSOutputStream outputStreamToFileAtPath:audioCachePath
                                                            append:YES]];
    
    [op onCompletion:^(MKNetworkOperation* completedOperation) {
        
        completionBlock(audioCachePath);
        
    }onError:^(NSError* error) {
        
        errorBlock(error);
    }];
    
    [op onDownloadProgressChanged:^(double progress) {
        
        progressBlock(progress*100.0);
    }];
    
    NSString* uniqueId = [self addOperation:op];
    [self.engine enqueueOperation:op];
    return uniqueId;
}

- (NSString*)downloadImageAtURL:(NSString *)url
                   onCompletion:(DownloadImageBlock)imageFetchedBlock
                     onProgress:(Progress) progressBlock
                       useCache:(BOOL)bCache
                     storagePNG:(BOOL)isPNG
{
    if (!url || [url length] == 0)
    {
        return nil;
    }
    
    NSString *encodeURL = [self urlEncode:url encoding:NSUTF8StringEncoding];
    //CORE_LOG(@"downloadImageAtURL %@",encodeURL);
    // 首先监测缓存中是否存在
    UIImage *image = nil;
    NSString *requestUrl = encodeURL;
    if (bCache)
    {
        image = [self readPhotoFromLocalCache:requestUrl];
    }
    if (image)
    {
        imageFetchedBlock(image,[NSURL URLWithString:requestUrl],nil,nil);
        progressBlock(100);
        return nil;
    }
    
    MKNetworkOperation* op  = [self imageAtURL:[NSURL URLWithString:encodeURL] onProgressChanged:^(double progress) {
        
        progressBlock(progress * 100);
    }
                                  onCompletion:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache, NSDictionary * headerDict) {
                                      //                   imageFetchedBlock(fetchedImage , url);
                                      imageFetchedBlock (fetchedImage,url, headerDict, nil);
                                      // 使用缓存时,保存。
                                      if (bCache) {
                                          [self writePhotosToLocalCacheAsPNG:fetchedImage url:requestUrl];

//                                          if (isPNG) {
//                                          }else {
//                                              [self writePhotosToLocalCache:fetchedImage url:requestUrl];
//                                          }
                                      }
                                  } onError:^(NSError *error) {
                                      imageFetchedBlock(nil,[NSURL URLWithString:url], nil,nil);
                                  }];
    
    NSString* uniqueId = [self addOperation:op];
    return uniqueId;
}

- (NSString*)downloadImageAtURL:(NSString *)url
              onCompletion:(DownloadImageBlock)imageFetchedBlock
                onProgress:(Progress) progressBlock
                  useCache:(BOOL)bCache
{
    if (!url || [url length] == 0) {
        return nil;
    }
    
    NSString *encodeURL = [self urlEncode:url encoding:NSUTF8StringEncoding];
    //CORE_LOG(@"downloadImageAtURL %@",encodeURL);
    // 首先监测缓存中是否存在
    UIImage *image = nil;
    NSString *requestUrl = encodeURL;
    if (bCache)
    {
        image = [self readPhotoFromLocalCache:requestUrl];
    }
    if (image)
    {
        imageFetchedBlock(image,[NSURL URLWithString:requestUrl],nil,nil);
        progressBlock(100);
        return nil;
    }
    
    MKNetworkOperation* op  = [self imageAtURL:[NSURL URLWithString:encodeURL] onProgressChanged:^(double progress) {
        progressBlock(progress * 100);
    }
                                  onCompletion:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache, NSDictionary * headerDict) {

                                      imageFetchedBlock (fetchedImage,url, headerDict, nil);
                                      // 使用缓存时,保存。
                                      if (bCache) {
                                        [self writePhotosToLocalCache:fetchedImage url:requestUrl];
                                      }
                                  } onError:^(NSError *error) {
                                      imageFetchedBlock(nil,[NSURL URLWithString:url], nil,nil);
                                  }];
    
    NSString* uniqueId = [self addOperation:op];
    return uniqueId;
}

- (NSString*)downloadImageWithURL:(NSString *)url
                         withPath:(NSString *)path
                   onCompletion:(DownloadSucceedBlock)fetchedBlock
                     onProgress:(Progress) progressBlock
                       useCache:(BOOL) bCache
{
    if (!url || [url length] == 0)
    {
        return nil;
    }
    
    NSString *encodeURL = [self urlEncode:url encoding:NSUTF8StringEncoding];
    SIDownloadManager * downLoadFile = [SIDownloadManager sharedSIDownloadManager];
    downLoadFile.delegate = self;
    
    [downLoadFile addDownloadFileTaskInQueue:encodeURL toFilePath:path breakpointResume:YES rewriteFile:NO imageDownLoadComplish:^(MKNetworkOperation *operation,NSString * path)
    {
        fetchedBlock (path);
        
    } imageDownLoadProgress:^(double progress) {
        progressBlock (progress);
        
    } error:^(NSString *url, NSError *error) {
        
    }];
    
    return encodeURL;

    
}

-(NSString*) downloadImageAtURL:(NSString *)url
                    withHeaders:(NSDictionary *) headers
                   onCompletion:(DownloadImageBlock)imageFetchedBlock
                     onProgress:(Progress)progressBlock
                       useCache:(BOOL) bCache
                     isGifImage:(BOOL) isGifImage
{
    if (!url || [url length] == 0) {
        return nil;
    }
    
    NSString *encodeURL = [self urlEncode:url encoding:NSUTF8StringEncoding];
    //CORE_LOG(@"downloadImageAtURL %@",encodeURL);
    // 首先监测缓存中是否存在
    UIImage *image = nil;
    NSString *requestUrl = encodeURL;
    if (!isGifImage)
    {
        if (bCache)
        {
            image = [self readPhotoFromLocalCache:requestUrl];
        }
        if (image)
        {
            imageFetchedBlock(image,[NSURL URLWithString:requestUrl],nil,[self getDownLoadImagePath:requestUrl]);
            progressBlock(100);
            return nil;
        }
    }

    NSString * path = [self getDownLoadImagePath:encodeURL];
    SIDownloadManager * downLoadImage = [SIDownloadManager sharedSIDownloadManager];
    downLoadImage.delegate = self;
    [downLoadImage addDownloadFileTaskInQueue:encodeURL toFilePath:path breakpointResume:YES rewriteFile:NO imageDownLoadComplish:^(MKNetworkOperation *operation,NSString * path) {
        
        if (isGifImage)
        {
            NSString * relativePath = [self getRelativeDownLoadImagePath:url];
           imageFetchedBlock(nil,nil,nil,relativePath);
            NSLog(path);
        }
        else
        {
            UIImage * image =  [UIImage imageWithData:[NSData dataWithContentsOfFile:path]];
            imageFetchedBlock(image,[NSURL URLWithString:[operation url]],[[operation readonlyResponse] allHeaderFields],path);
        }
        
        
    } imageDownLoadProgress:^(double progress) {
        
        progressBlock (progress);
        
        
    } error:^(NSString *url, NSError *error) {
        
    }];
  
    return encodeURL;

}



-(NSString*) downloadImageAtURL:(NSString *)url
             onCompletion:(DownloadImageBlock)imageFetchedBlock
                 useCache:(BOOL)bCache
{
    if (!url || [url length] == 0) {
        return nil;
    }
    
    NSString *encodeURL = url;
    
    // 首先监测缓存中是否存在
    
    UIImage *image = nil;
    NSString *requestUrl = encodeURL;
    if (bCache) {
        image = [self readPhotoFromLocalCache:requestUrl];
    }
    if (image) {
        imageFetchedBlock(image,[NSURL URLWithString:requestUrl],nil,nil);
        return nil;
    }
    
    // 缓存中不存在 网络请求下载
    MKNetworkOperation* op = [self imageAtURL:[NSURL URLWithString:url] onProgressChanged:^(double progress) {
    }
               onCompletion:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache, NSDictionary * headerDict) {
                   imageFetchedBlock(fetchedImage , url,headerDict,nil);
                   
                   // 使用缓存时,保存。
                   if (bCache) {
                       [self writePhotosToLocalCache:fetchedImage url:requestUrl];
                   }
               } onError:^(NSError *error) {
                   imageFetchedBlock(nil,[NSURL URLWithString:url],nil,nil);
               }];
    NSString* uniqueId = [self addOperation:op];
    return uniqueId;
}

- (void)clearCache
{
    [self.engine emptyCache];
}

-(UIImage *)imageAtUrl:(NSString *)url
{
    if (!url || url.length == 0)
    {
        return nil;
    }
    
    NSString *encodeURL = [self urlEncode:url encoding:NSUTF8StringEncoding];
    
    NSString *str = [NSMutableString stringWithFormat:@"%@ %@", @"GET", encodeURL];;
    NSData *data = [self.engine cacheDataForKey:[str md5]];
    //先判断mk内存缓存
    if (data)
    {
        UIImage *image = [UIImage imageWithData:data];
        return image;
    }
    else
    {
        //判断我们自己有没有写沙盒
        UIImage *image = [self readPhotoFromLocalCache:encodeURL];
        if (image)
        {
            return image;
        }
        else
        {
            return nil;
        }
    }
}

- (MKNetworkOperation*)imageAtURL:(NSURL *)url withHeader:(NSDictionary *)header onProgressChanged:(MKNKProgressBlock) changedProgressBlock onCompletion:(MKNKImageBlock) imageFetchedBlock  onError:(MKNKErrorBlock) errorBlock
{
    if (url == nil)
    {
        return nil;
    }
    
    MKNetworkOperation *op = [self.engine operationWithURLString:[url absoluteString]];

    [self initICEHeader:op];
    if (header)
    {
        [op addHeaders:header];
    }
    
    [op onDownloadProgressChanged:^(double progress) {
        changedProgressBlock(progress);
    }];
    
    [op  onCompletion:^(MKNetworkOperation *completedOperation)
     {
         imageFetchedBlock([completedOperation responseImage],
                           url,
                           [completedOperation isCachedResponse],
                           [[completedOperation readonlyResponse] allHeaderFields]);
         
     }
     onError:^(NSError* error) {
         
         errorBlock(error);
     }];
    
    [self.engine enqueueOperation:op forceReload:YES];
    return op;
  
    
}

- (MKNetworkOperation*)imageAtURL:(NSURL *)url onProgressChanged:(MKNKProgressBlock) changedProgressBlock onCompletion:(MKNKImageBlock) imageFetchedBlock  onError:(MKNKErrorBlock) errorBlock
{
    if (url == nil)
    {
        return nil;
    }
    
    MKNetworkOperation *op = [self.engine operationWithURLString:[url absoluteString]];
    
    [self initICEHeader:op];
    
    [op onDownloadProgressChanged:^(double progress) {
        changedProgressBlock(progress);
    }];
    
    [op
     onCompletion:^(MKNetworkOperation *completedOperation)
     {
         imageFetchedBlock([completedOperation responseImage],
                           url,
                           [completedOperation isCachedResponse],[[completedOperation readonlyResponse] allHeaderFields]);
         
     }
     onError:^(NSError* error) {
         errorBlock(error);
         DLog(@"%@", error);
     }];
   
    [self.engine enqueueOperation:op];
    return op;
}

#pragma mark -Audios Cache-

- (NSString*)getAudioCachePath
{
    //获取引擎音频cache目录
    NSString *audioCachePath = [[self getCachePath] stringByAppendingPathComponent:@"audio/ddAudioDownloadCache"];
    //创建目录
    if (![[NSFileManager defaultManager] fileExistsAtPath:audioCachePath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:audioCachePath withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
    return audioCachePath;
}

- (NSString*)audioPathAtUrl:(NSString*)url
{
    if (!url || url.length == 0)
    {
        return nil;
    }
    
    // 音频cache目录
    NSString *audioCacheDir = [self getAudioCachePath];
    // 最终音频路径 = 音频cache目录/[url md5]
    NSString *audioCachePath = [audioCacheDir stringByAppendingPathComponent:[url md5]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:audioCachePath])
    {
        return audioCachePath;
    }
    else
    {
        return nil;
    }
}

#pragma mark -Photos Cache-

- (NSString*)getCachePath
{
    //获取程序cache目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

- (NSString*)getImageCachePath
{
    //获取引擎图片cache目录
    NSString *imageCachePath = [[self getCachePath] stringByAppendingPathComponent:@"image/ddImageDownloadCache"];
    return imageCachePath;
}

- (BOOL)writePhotosToLocalCacheAsPNG:(UIImage*)image url:(NSString*)url
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *imageCacheMgrDir = [self getImageCachePath];
    // 创建目录
    if (![[NSFileManager defaultManager] fileExistsAtPath:imageCacheMgrDir])
    {
        [fileManager createDirectoryAtPath:imageCacheMgrDir withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
    return [UIImagePNGRepresentation(image) writeToFile:[imageCacheMgrDir stringByAppendingPathComponent:[url md5]] atomically:YES];
}

- (BOOL)writePhotosToLocalCache:(UIImage *) image url:(NSString *) url
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *imageCacheMgrDir = [self getImageCachePath];
    // 创建目录
    if (![[NSFileManager defaultManager] fileExistsAtPath:imageCacheMgrDir])
    {
        [fileManager createDirectoryAtPath:imageCacheMgrDir withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
    return [UIImageJPEGRepresentation(image, 0.6) writeToFile:[imageCacheMgrDir stringByAppendingPathComponent:[url md5]]atomically:YES];
}

- (UIImage*)readPhotoFromLocalCache:(NSString *)url;
{
    // 图片缓存目录
    NSString *imageCacheMgrDir = [self getImageCachePath];
    // 最终图片路径 = 图片缓存目录/[url md5]
    NSString *imageCacheMgrPath = [imageCacheMgrDir stringByAppendingPathComponent:[url md5]];
    
    NSData *reader = [NSData dataWithContentsOfFile:imageCacheMgrPath];
    
    return [UIImage imageWithData:reader];
}

- (NSString*)getDownLoadImagePath:(NSString *)url
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSString *imageCacheMgrDir = [self getImageCachePath];

    if (![[NSFileManager defaultManager] fileExistsAtPath:imageCacheMgrDir])
    {
        [fileManager createDirectoryAtPath:imageCacheMgrDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *imageCacheMgrPath = [imageCacheMgrDir stringByAppendingPathComponent:[url md5]];
    return imageCacheMgrPath;
}

- (NSString *)getRelativeDownLoadImagePath:(NSString *)url
{
    NSString * path = @"image/ddImageDownloadCache" ;
    path = [path stringByAppendingPathComponent:[url md5]];
    return path;
}

- (BOOL)removePhotosFromLocalCache:(NSString *)url
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *imageCacheMgrDir = [self getImageCachePath];
    [fileManager changeCurrentDirectoryPath:imageCacheMgrDir];
    return [fileManager removeItemAtPath:[url md5] error:nil];
    
}

-(void)removeAllPhotosFromLocalCache
{
    //删除目录,再重建目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *imageCacheMgrDir = [self getImageCachePath];
    [fileManager removeItemAtPath:imageCacheMgrDir error:nil];
    [fileManager createDirectoryAtPath:imageCacheMgrDir
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];
}

- (void)initICEHeader:(MKNetworkOperation *)op
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

- (NSString*)urlEncode:(NSString*)url encoding:(NSStringEncoding)stringEncoding
{
	NSArray *escapeChars = [NSArray arrayWithObjects:/*@";", @"/", @"?", @":",*/
							/*@"@", @"&", @"=", */@"+", /*@"$", @",", @"!",
                                                         @"'", @"(", @")", @"*", @"-",*/ nil];
	
	NSArray *replaceChars = [NSArray arrayWithObjects:/*@"%3B", @"%2F", @"%3F", @"%3A",*/
							 /*@"%40", @"%26", @"%3D",*/@"%2B", /*@"%24", @"%2C", @"%21",
                                                                 @"%27", @"%28", @"%29", @"%2A", @"%2D",*/ nil];
	int len = (int)[escapeChars count];
	NSString *tempStr = [url stringByAddingPercentEscapesUsingEncoding:stringEncoding];
	if (tempStr == nil)
    {
		return nil;
	}
	NSMutableString *temp = [tempStr mutableCopy];
	int i;
	for (i = 0; i < len; i++)
    {
		
		[temp replaceOccurrencesOfString:[escapeChars objectAtIndex:i]
							  withString:[replaceChars objectAtIndex:i]
								 options:NSLiteralSearch
								   range:NSMakeRange(0, [temp length])];
	}
	NSString *outStr = [NSString stringWithString: temp];
	return outStr;
}

@end
