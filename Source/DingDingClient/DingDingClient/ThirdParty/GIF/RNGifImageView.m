//
//  OLImageView.m
//  OLImageViewDemo
//
//  Created by Diego Torres on 9/5/12.
//  Copyright (c) 2012 Onda Labs. All rights reserved.
//

#import "RNGifImageView.h"
#import "RNGifImage.h"
#import <QuartzCore/QuartzCore.h>

@interface RNGifImageView ()
{
    CADisplayLink *displayLink;
}
@property (nonatomic, strong) RNGifImage *animatedImage;
@property (nonatomic) NSTimeInterval previousTimeStamp;
@property (nonatomic) NSTimeInterval accumulator;
@property (nonatomic) NSUInteger currentFrameIndex;
@property (nonatomic) NSUInteger loopCountdown;

@end
@implementation RNGifImageView

const NSTimeInterval kMaxTimeStep = 1; // note: To avoid spiral-o-death

@synthesize runLoopMode = _runLoopMode;

- (id)init
{
    self = [super init];
    if (self) {
        self.currentFrameIndex = 0;
    }
    return self;
}

- (void)dealloc
{
    [displayLink invalidate];
}

- (NSString *)runLoopMode
{
    return _runLoopMode ?: NSDefaultRunLoopMode;
}

- (void)setRunLoopMode:(NSString *)runLoopMode
{
    if (runLoopMode != _runLoopMode) {
        _runLoopMode = runLoopMode;
        [self stopAnimating];
        [self startAnimating];
    }
}


- (CGImageRef)createCGImageWithCGImage:(CGImageRef)imageRef{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 CGImageGetWidth(imageRef),
                                                 CGImageGetHeight(imageRef),
                                                 8,
                                                 CGImageGetWidth(imageRef) * 4,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    CGColorSpaceRelease(colorSpace);

    CGRect rect = (CGRect){CGPointZero,{CGImageGetWidth(imageRef), CGImageGetHeight(imageRef)}};
    CGContextDrawImage(context, rect, imageRef);
    CGImageRef decompressedImageRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);

    return decompressedImageRef;
}

- (void)setImage:(UIImage *)image
{
    [self stopAnimating];
    self.animatedImage = nil;
    self.currentFrameIndex = 0;
    self.previousTimeStamp = 0;
    self.loopCountdown = 0;
    self.accumulator = 0;
    [super setImage:nil];
    if ([image isKindOfClass:[RNGifImage class]] && image.images) {
        self.animatedImage = (RNGifImage *)image;
//        RRLOG_debug(@"图片的大小为%@",NSStringFromCGSize(self.animatedImage.size));
        CGImageRef imageRef = [[self.animatedImage.images objectAtIndex:0] CGImage];
        CGImageRef decompressedImageRef = [self createCGImageWithCGImage:imageRef];
        self.layer.contents = (__bridge id)(decompressedImageRef);
        CGImageRelease(decompressedImageRef);

        self.loopCountdown = self.animatedImage.loopCount ?: NSUIntegerMax;

        [self startAnimating];
    } else {
        self.layer.contents = nil;
        [super setImage:image];
    }
}

- (BOOL)isAnimating
{
    return [super isAnimating] || (displayLink && !displayLink.isPaused);
}

- (void)stopAnimating
{
    if (!self.animatedImage) {
        [super stopAnimating];
        return;
    }
    
    self.loopCountdown = 0;
    
    @synchronized(displayLink) {
        displayLink.paused = YES;
        [displayLink invalidate];
        displayLink = nil;
    }
}

- (void)startAnimating
{
    if (!self.animatedImage) {
        [super startAnimating];
        return;
    }
    
    if (self.isAnimating) {
        return;
    }
    
    self.loopCountdown = self.animatedImage.loopCount ?: NSUIntegerMax;
    self.previousTimeStamp = 0;
    
    @synchronized(displayLink) {
        [displayLink invalidate];

        if (self.animatedImage.images.count > 1) {
            displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeKeyframe:)];
            [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:self.runLoopMode];
        }else if(self.animatedImage.images.count == 1) {
            CGImageRef imageRef = [[self.animatedImage.images objectAtIndex:0] CGImage];
            CGImageRef decompressedImageRef = [self createCGImageWithCGImage:imageRef];
            self.layer.contents = (__bridge id)(decompressedImageRef);
            CGImageRelease(decompressedImageRef);
        }
    }
}

- (void)changeKeyframe:(CADisplayLink *)caDisplayLink
{
    NSTimeInterval timestamp = caDisplayLink.timestamp;
    
    if (self.previousTimeStamp == 0) {
        self.previousTimeStamp = timestamp;
    }
    
    self.accumulator += fmin(timestamp - self.previousTimeStamp, kMaxTimeStep);

    while (self.accumulator >= [self.animatedImage frameDurationWithIndex:self.currentFrameIndex]) {
        self.accumulator -= [self.animatedImage frameDurationWithIndex:self.currentFrameIndex];
        if (++self.currentFrameIndex >= [self.animatedImage.images count]) {

            if (--self.loopCountdown == 0 || self.animatedImage == nil) {
                [self stopAnimating];
                return;
            }
            self.currentFrameIndex = 0;
        }
        [self.layer setNeedsDisplay];
    }
    self.previousTimeStamp = timestamp;
}


- (void)displayLayer:(CALayer *)layer
{
    @autoreleasepool {
        if (self.currentFrameIndex >= self.animatedImage.images.count) {
            return;
        }
        
        CGImageRef imageRef = [[self.animatedImage.images objectAtIndex:self.currentFrameIndex]
                               CGImage];
        CGImageRef decompressedImageRef = [self createCGImageWithCGImage:imageRef];
        //set contents to display current frame
        layer.contents = (__bridge id)(decompressedImageRef);
        CGImageRelease(decompressedImageRef);
    }
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    if (self.window) {
        [self startAnimating];
    } else {
        [self stopAnimating];
    }
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (!self.animatedImage) {
        [super setHighlighted:highlighted];
    }
}

- (UIImage *)image
{
    return self.animatedImage ?: [super image];
}

@end
