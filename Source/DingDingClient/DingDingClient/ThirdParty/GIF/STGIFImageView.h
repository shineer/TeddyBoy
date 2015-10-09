//
//  STGIFImageView.h
//  StoryClient
//
//  Created by LiuQi on 14-5-19.
//  Copyright (c) 2013年 LiuQi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimatedGifQueueObject : NSObject
{
    UIImageView *uiv;
    NSURL *url;
}

@property (nonatomic, retain) UIImageView *uiv;
@property (nonatomic, retain) NSURL *url;

@end

@interface AnimatedGifFrame : NSObject
{
	NSData *data;
	NSData *header;
	double delay;
	int disposalMethod;
	CGRect area;
}

@property (nonatomic, copy) NSData *header;
@property (nonatomic, copy) NSData *data;
@property (nonatomic) double delay;
@property (nonatomic) int disposalMethod;
@property (nonatomic) CGRect area;

@end

@interface STGIFImageView : UIImageView {
	NSData *GIF_pointer;
	NSMutableData *GIF_buffer;
	NSMutableData *GIF_screen;
	NSMutableData *GIF_global;
	NSMutableArray *GIF_frames;
	
	int GIF_sorted;
	int GIF_colorS;
	int GIF_colorC;
	int GIF_colorF;
	int animatedGifDelay;
	
	int dataPointer;
}
@property (nonatomic, retain) NSMutableArray *GIF_frames;

- (id)initWithGIFName:(NSString*)imageName;
- (id)initWithGIFFile:(NSString*)gifFilePath;
- (id)initWithGIFData:(NSData*)gifImageData;

- (void)loadImageData;

+ (NSMutableArray*)getGifFrames:(NSData*)gifImageData;
+ (BOOL)isGifImage:(NSData*)imageData;
- (BOOL)loadGifImageData:(NSData*)gifImageData;
- (void) decodeGIF:(NSData *)GIFData;
- (void) GIFReadExtensions;
- (void) GIFReadDescriptor;
- (bool) GIFGetBytes:(int)length;
- (bool) GIFSkipBytes: (int) length;
- (NSData*) getFrameAsDataAtIndex:(int)index;
- (UIImage*) getFrameAsImageAtIndex:(int)index;

-(void)startGifAnimating;
-(void)stopGifAnimating;

+(STGIFImageView*)deQueueGifImageView:(NSString*)fileName;

+(NSMutableArray*)getGifImageFrameFromMem:(NSString*)fileName;
+(void)saveGifImageFrameToMem:(NSString*)fileName gif:(NSMutableArray*)gifFrames;
+(void)clearGifImageFrameMemStoreifOver:(NSInteger)maxSize;
@end
