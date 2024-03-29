//
//  OLImage.m
//  MMT
//
//  Created by Diego Torres on 9/1/12.
//  Copyright (c) 2012 Onda. All rights reserved.
//

#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "RNGifImage.h"

inline static NSTimeInterval CGImageSourceGetGifFrameDelay(CGImageSourceRef imageSource, NSUInteger index)
{
    NSTimeInterval frameDuration = 0;
    CFDictionaryRef theImageProperties;
    if ((theImageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, index, NULL))) {
        CFDictionaryRef gifProperties;
        if (CFDictionaryGetValueIfPresent(theImageProperties, kCGImagePropertyGIFDictionary, (const void **)&gifProperties)) {
            const void *frameDurationValue;
            if (CFDictionaryGetValueIfPresent(gifProperties, kCGImagePropertyGIFUnclampedDelayTime, &frameDurationValue)) {
                frameDuration = [(__bridge NSNumber *)frameDurationValue doubleValue];
                if (frameDuration <= 0) {
                    if (CFDictionaryGetValueIfPresent(gifProperties, kCGImagePropertyGIFDelayTime, &frameDurationValue)) {
                        frameDuration = [(__bridge NSNumber *)frameDurationValue doubleValue];
                    }
                }
            }
        }
        CFRelease(theImageProperties);
    }
    
#ifndef OLExactGIFRepresentation
    //Implement as Browsers do.
    //See:  http://nullsleep.tumblr.com/post/16524517190/animated-gif-minimum-frame-delay-browser-compatibility
    //Also: http://blogs.msdn.com/b/ieinternals/archive/2010/06/08/animated-gifs-slow-down-to-under-20-frames-per-second.aspx
    //设置最大最小频率
    if (frameDuration < 0.02 - FLT_EPSILON) {
        frameDuration = 0.1;
    }
    if (frameDuration > 0.3) {
        frameDuration = 0.3;
    }
#endif
    return frameDuration;
}

inline static NSTimeInterval CGImageSourceGetFramesAndDurations(NSTimeInterval *frameDurations, NSMutableArray *arrayToFill, CGImageSourceRef imageSource, NSUInteger numberOfFrames)
{
    NSTimeInterval finalDuration = 0;
    for (NSUInteger i = 0; i < numberOfFrames; ++i) {
        frameDurations[i] = CGImageSourceGetGifFrameDelay(imageSource, i);
        CGImageRef theImage = CGImageSourceCreateImageAtIndex(imageSource, i, NULL);
        if (theImage) {
            UIImage *image = [[UIImage alloc]initWithCGImage:theImage];
            [arrayToFill addObject:image];
            CFRelease(theImage);
            finalDuration += frameDurations[i];
        }
    }
    return finalDuration;
}


@interface RNGifImage ()

@property (nonatomic,strong,readwrite) NSMutableArray *images;
@property (nonatomic, readwrite) NSTimeInterval *frameDurations;
@property (nonatomic, readwrite) NSTimeInterval totalDuration;
@property (nonatomic, readwrite) NSUInteger loopCount;

@end

@implementation RNGifImage

@synthesize images;

+ (id)imageWithData:(NSData *)data
{
    return [[self alloc]initWithData:data];;
}

- (id)initWithData:(NSData *)data {
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)(data), NULL);
    if (!imageSource) {
        return nil;
    }
    if (!UTTypeConformsTo(CGImageSourceGetType(imageSource), kUTTypeGIF)) {
        CFRelease(imageSource);
        return [super initWithData:data];
    }
    self = [super init];
    NSUInteger numberOfFrames = CGImageSourceGetCount(imageSource);
    self.frameDurations = (NSTimeInterval *) malloc(numberOfFrames  * sizeof(NSTimeInterval));
    self.images = [NSMutableArray arrayWithCapacity:numberOfFrames];
    self.totalDuration = CGImageSourceGetFramesAndDurations(self.frameDurations, self.images, imageSource, numberOfFrames);

    NSDictionary *imageProperties = CFBridgingRelease(CGImageSourceCopyProperties(imageSource, NULL));
    NSDictionary *GIFProperties = [imageProperties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
    self.loopCount = [GIFProperties[(NSString *)kCGImagePropertyGIFLoopCount] unsignedIntegerValue];
    CFRelease(imageSource);
    return self;
}

+ (UIImage *)imageNamed:(NSString *)name
{
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:name];
    
    return ([[NSFileManager defaultManager] fileExistsAtPath:path]) ? [RNGifImage imageWithContentsOfFile:path] : nil;
}

+ (UIImage *)imageWithContentsOfFile:(NSString *)path
{
    return [RNGifImage imageWithData:[NSData dataWithContentsOfFile:path]];
}

- (CGSize)size
{
    if (self.images) {
        return [((UIImage *)[self.images objectAtIndex:0]) size];
    }
    return [super size];
}

- (NSTimeInterval)duration {
    return self.totalDuration;
}

- (void)dealloc {
    if (_frameDurations) {
        free(_frameDurations);
    }
}

- (NSTimeInterval)frameDurationWithIndex:(NSInteger)index
{
    return self.frameDurations[index];
}

@end
