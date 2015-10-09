//
//  DDHttpTransferService.h
//  DingDingCore
//
//  Created by phoenix on 14-10-10.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^UploadSucceedBlock)(NSDictionary* dic);
typedef void (^UploadFailedBlock)(NSError* error);
typedef void (^DownloadSucceedBlock)(NSString* path);
typedef void (^DownloadFailedBlock)(NSError* error);
typedef void (^DownloadImageBlock) (UIImage* fetchedImage, NSURL* url, NSDictionary * headerDic, NSString * path);
typedef void (^Progress)(double progress);

@interface DDHttpTransferService : NSObject
{
    
}

/**
 * 单例
 */
+ (DDHttpTransferService *)getInstance;

/**
 * 初始化
 * @param headers 请求头
 */
- (id)initWithHeaders:(NSDictionary*)headerDic;

/**
 * 上传文件
 * @param url 地址
 * @param file 文件名
 * @param onCompletion 返回结果
 * @param onError 失败错误
 * @param Progress 进度
 * @return 返回Id
 */
- (NSString*)uploadFormFileWithURL:(NSString *)url
                            params:(NSDictionary*) params
                              file:(NSString*)file
                          fileType:(NSString*)fileType
                      onCompletion:(UploadSucceedBlock)completionBlock
                           onError:(UploadFailedBlock)errorBlock
                        onProgress:(Progress)progressBlock;

/**
 * 上传音频从数据
 * @param url 地址
 * @param data 数据
 * @param onCompletion 返回结果
 * @param onError 失败错误
 * @param Progress 进度
 * @return 返回Id
 */
- (NSString*)uploadAudioWithURL:(NSString*)url
                      audioData:(NSData*)data
                         params:(NSMutableDictionary*)params
                        headers:(NSDictionary*)headers
                      multipart:(BOOL)multipart
                   onCompletion:(UploadSucceedBlock)completionBlock
                        onError:(UploadFailedBlock)errorBlock
                     onProgress:(Progress)progressBlock;

/**
 * 上传图片从数据
 * @param url 地址
 * @param data 数据
 * @param onCompletion 返回结果
 * @param onError 失败错误
 * @param progress 进度
 * @return 返回Id
 */
- (NSString*)uploadImageWithURL:(NSString*)url
                      imageData:(NSData*)data
                         params:(NSMutableDictionary*)params
                        headers:(NSDictionary*)headers
                      multipart:(BOOL)multipart
                   onCompletion:(UploadSucceedBlock)completionBlock
                        onError:(UploadFailedBlock)errorBlock
                     onProgress:(Progress)progressBlock;

/**
 * 批量上传图片
 * @param url 地址
 * @param images 图片数组
 * @param onCompletion 返回结果
 * @param onError 失败错误
 * @param Progress 进度
 * @return 返回Id
 */
- (NSString*)uploadImagesWithURL:(NSString *)url
                          params:(NSMutableDictionary*)params
                         headers:(NSDictionary*)headers
                          images:(NSArray*)images
                    onCompletion:(UploadSucceedBlock)completionBlock
                         onError:(UploadFailedBlock)errorBlock
                      onProgress:(Progress)progressBlock;

/**
 * 上传图片到队列
 * @param url 地址
 * @param imagePath 图片本地地址
 * @param onCompletion 返回结果
 * @param onError 失败错误
 * @param progress 进度
 * @return 返回Id
 */
- (NSString*)uploadImageWithURLToQueue:(NSString*)url
                             imagePath:(NSString*)imagePath
                                params:(NSMutableDictionary*)params
                          onCompletion:(UploadSucceedBlock)completionBlock
                               onError:(UploadFailedBlock)errorBlock
                            onProgress:(Progress)progressBlock;

/**
 * 下载文件 支持断点下载
 * @param url 地址
 * @param onCompletion 返回结果
 * @param onError 失败错误
 * @param progress 进度
 * @return 返回Id
 */
- (NSString*)downloadAudioWithURL:(NSString*)url
                     onCompletion:(DownloadSucceedBlock)completionBlock
                          onError:(DownloadFailedBlock)errorBlock
                       onProgress:(Progress)progressBlock;

/**
 * 下载图片 支持断点下载
 * @param url 地址
 * @param onCompletion 返回结果
 * @param progress 进度
 * @param bCache   是否使用缓存
 * return 返回Id
 */
- (NSString*)downloadImageWithURL:(NSString*)url
                         withPath:(NSString*)path
                     onCompletion:(DownloadSucceedBlock)completionBlock
                       onProgress:(Progress)progressBlock
                         useCache:(BOOL)bCache;

/**
 * 下载图片(带进度)
 * @param url 地址
 * @param DownloadImageBlock 返回图片指针和文件名
 * @param progress 进度
 * @param bCache   是否使用缓存
 * return true 调用接口成功,否则失败。
 */
- (NSString*)downloadImageAtURL:(NSString*)url
                   onCompletion:(DownloadImageBlock)imageFetchedBlock
                     onProgress:(Progress)progressBlock
                       useCache:(BOOL)bCache;

/**
 * 下载图片(不带进度)
 * @param url 地址
 * @param DownloadImageBlock 返回图片指针和文件名
 * @param bCache   是否使用缓存
 * return true 调用接口成功,否则失败。
 */
- (NSString*)downloadImageAtURL:(NSString *)url
                   onCompletion:(DownloadImageBlock)imageFetchedBlock
                       useCache:(BOOL)bCache;

/**
 * 下载图片 缓存图片为未压缩的png格式
 * @param url 地址
 * @param DownloadImageBlock 返回图片指针和文件名
 * @param progress 进度
 * @param bCache   是否使用缓存
 * @param isJPG  缓存是否使用jpg
 * return true 调用接口成功,否则失败。
 */
- (NSString*)downloadImageAtURL:(NSString *)url
                   onCompletion:(DownloadImageBlock)imageFetchedBlock
                     onProgress:(Progress) progressBlock
                       useCache:(BOOL)bCache
                     storagePNG:(BOOL)isPNG;
/**
 * 下载图片 缓存图片为未压缩的gif格式
 * @param url 地址
 * @param DownloadImageBlock 返回图片指针和文件名
 * @param bCache   是否使用缓存
 * @param isGIf   是否是gif图片
 * return true 调用接口成功,否则失败。
 */
- (NSString*)downloadImageAtURL:(NSString *)url
                    withHeaders:(NSDictionary*)headers
                   onCompletion:(DownloadImageBlock)imageFetchedBlock
                     onProgress:(Progress) progressBlock
                       useCache:(BOOL)bCache
                     isGifImage:(BOOL)isGif;


/**
 * 暂停某个断点下载
 * @param url 下载的地址
 */
- (void)pauseTaskWithUrl:(NSString *) url;

/**
 * 取消
 * @param uniqueId
 */
- (BOOL)cancelWithUniqueId:(NSString*)uniqueId;

- (BOOL)cancelDownLoadUniqueId:(NSString *) uniqueId;


/**
 * 取消所有
 */
- (BOOL)cancelAll;

/**
 * 取消所有 断点续传进程
 */
- (void)cancelAllBreakpointDownLoad;

/**
 * 清除缓存
 */
- (void)clearCache;

/**
 * 查看图片是否缓存过
 */
- (UIImage*)imageAtUrl:(NSString *)url;

/**
 * 查看音频是否缓存过
 */
- (NSString*)audioPathAtUrl:(NSString*)url;

@end
