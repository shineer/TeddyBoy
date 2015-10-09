//
//  STGIFImageView.m
//  StoryClient
//
//  Created by LiuQi on 14-5-19.
//  Copyright (c) 2013年 LiuQi. All rights reserved.
//
#import "STGIFImageView.h"

@implementation AnimatedGifQueueObject

@synthesize uiv;
@synthesize url;

@end

@implementation AnimatedGifFrame

@synthesize data, delay, disposalMethod, area, header;

@end

@implementation STGIFImageView
@synthesize GIF_frames;

static NSMutableDictionary * ChatGifFrameCacheMemStore = nil;

+ (BOOL)isGifImage:(NSData*)imageData {
	const char* buf = (const char*)[imageData bytes];
	if (buf[0] == 0x47 && buf[1] == 0x49 && buf[2] == 0x46 && buf[3] == 0x38) {
		return YES;
	}
	return NO;
}

+ (NSMutableArray*)getGifFrames:(NSData*)gifImageData {
	STGIFImageView* gifImageView = [[STGIFImageView alloc] initWithGIFData:gifImageData];
	if (!gifImageView) {
		return nil;
	}
	
	NSMutableArray* gifFrames = gifImageView.GIF_frames;
//	[[gifFrames retain] autorelease];
	return gifFrames;
}

- (id)initWithGIFName:(NSString*)imageName {
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
    return [self initWithGIFFile:imagePath];
}

- (id)initWithGIFFile:(NSString*)gifFilePath {
    @autoreleasepool {
        NSData* imageData = [NSData dataWithContentsOfFile:gifFilePath];
        return [self initWithGIFData:imageData];
    }
	
}

- (id)initWithGIFData:(NSData*)gifImageData {
	if (gifImageData.length < 4) {
		return nil;
	}
	
	if (![STGIFImageView isGifImage:gifImageData]) {
		UIImage* image = [UIImage imageWithData:gifImageData];
		return [super initWithImage:image];
	}
	
	self = [super init];
	if (self) {
		//[self loadImageData];
        @autoreleasepool {
            [self decodeGIF:gifImageData];
        }
        @autoreleasepool {
            [NSThread detachNewThreadSelector:@selector(loadImageData) toTarget:self withObject:nil];
        }
        
	}
	
	return self;
}

- (void)setGIF_frames:(NSMutableArray *)gifFrames {
//	[gifFrames retain];

	if (GIF_frames) {
		GIF_frames = nil;
	}
	GIF_frames = gifFrames;
	//DDLogInfo(@"!!!!!!start time :%@",[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]);
	[self loadImageData];
    //DDLogInfo(@"!!!!!!end time :%@",[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]);
}

- (void)loadImageData {
    @autoreleasepool {

	// Add all subframes to the animation
	NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray *overlayArray = [[NSMutableArray alloc] init];
	for (NSUInteger i = 0; i < [GIF_frames count]; i++)
	{		
		[array addObject: [self getFrameAsImageAtIndex:i]];
	}
	
    if ([array count] > 0)
    {
        UIImage *firstImage = [array objectAtIndex:0];
        CGSize size = firstImage.size;
        CGRect rect = CGRectZero;
        rect.size = size;
        
        UIGraphicsBeginImageContext(size);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        int i = 0;
        AnimatedGifFrame *lastFrame = nil;
        for (UIImage *image in array)
        {
            // Get Frame
            AnimatedGifFrame *frame = [GIF_frames objectAtIndex:i];
            
            // Initialize Flag
            UIImage *previousCanvas = nil;
            
            // Save Context
            CGContextSaveGState(ctx);
            // Change CTM
            CGContextScaleCTM(ctx, 1.0, -1.0);
            CGContextTranslateCTM(ctx, 0.0, -size.height);
            
            // Check if lastFrame exists
            CGRect clipRect;
            
            // Disposal Method (Operations before draw frame)
            switch (frame.disposalMethod)
            {
                case 1: // Do not dispose (draw over context)
                    // Create Rect (y inverted) to clipping
                    clipRect = CGRectMake(frame.area.origin.x, size.height - frame.area.size.height - frame.area.origin.y, frame.area.size.width, frame.area.size.height);
                    // Clip Context
                    CGContextClipToRect(ctx, clipRect);
                    break;
                case 2: // Restore to background the rect when the actual frame will go to be drawed
                    // Create Rect (y inverted) to clipping
                    clipRect = CGRectMake(frame.area.origin.x, size.height - frame.area.size.height - frame.area.origin.y, frame.area.size.width, frame.area.size.height);
                    // Clip Context
                    CGContextClipToRect(ctx, clipRect);
                    break;
                case 3: // Restore to Previous
                    // Get Canvas
                    previousCanvas = UIGraphicsGetImageFromCurrentImageContext();
                    
                    // Create Rect (y inverted) to clipping
                    clipRect = CGRectMake(frame.area.origin.x, size.height - frame.area.size.height - frame.area.origin.y, frame.area.size.width, frame.area.size.height);
                    // Clip Context
                    CGContextClipToRect(ctx, clipRect);
                    break;
            }
            
            // Draw Actual Frame
            CGContextDrawImage(ctx, rect, image.CGImage);
            // Restore State
            CGContextRestoreGState(ctx);
            
            //delay must larger than 0, the minimum delay in firefox is 10.
            if (frame.delay <= 0) {
                frame.delay = 10;
            }
            [overlayArray addObject:UIGraphicsGetImageFromCurrentImageContext()];
            
            // Set Last Frame
            lastFrame = frame;
            
            // Disposal Method (Operations afte draw frame)
            switch (frame.disposalMethod)
            {
                case 2: // Restore to background color the zone of the actual frame
                    // Save Context
                    CGContextSaveGState(ctx);
                    // Change CTM
                    CGContextScaleCTM(ctx, 1.0, -1.0);
                    CGContextTranslateCTM(ctx, 0.0, -size.height);
                    // Clear Context
                    CGContextClearRect(ctx, clipRect);
                    // Restore Context
                    CGContextRestoreGState(ctx);
                    break;
                case 3: // Restore to Previous Canvas
                    // Save Context
                    CGContextSaveGState(ctx);
                    // Change CTM
                    CGContextScaleCTM(ctx, 1.0, -1.0);
                    CGContextTranslateCTM(ctx, 0.0, -size.height);
                    // Clear Context
                    CGContextClearRect(ctx, lastFrame.area);
                    // Draw previous frame
                    CGContextDrawImage(ctx, rect, previousCanvas.CGImage);
                    // Restore State
                    CGContextRestoreGState(ctx);
                    break;
            }
            
            // Increment counter
            i++;
        }
        UIGraphicsEndImageContext();
    }
        
    [self performSelectorOnMainThread:@selector(updateGif:) withObject:overlayArray waitUntilDone:NO];
    }
}

-(BOOL)loadGifImageData:(NSData*)gifImageData{
    
    if (gifImageData.length < 4 || ![STGIFImageView isGifImage:gifImageData]) {
        //add by chenxuefang 2013/12/05 处理![SCGIFImageView isGifImage:gifImageData]的gif图片
        if (gifImageData.length>4) {
            UIImage* image = [UIImage imageWithData:gifImageData];
            self.image = image;
        }
        //add end
		return NO;
	}
	
	[self decodeGIF:gifImageData];
	
	if (GIF_frames.count <= 0) {
		return NO;
	}
	
    [self removeObservers];
	[self addObservers];
    
    [self loadImageData];
    return YES;
}

-(void)updateGif:(NSArray*)imageArr{
    if ([imageArr count] > 0)
    {
        [self setImage:[imageArr objectAtIndex:0]];
        [self setAnimationImages:imageArr];
        
        // Count up the total delay, since Cocoa doesn't do per frame delays.
        double total = 0;
        for (AnimatedGifFrame *frame in GIF_frames) {
            total += frame.delay;
        }
        
        // GIFs store the delays as 1/100th of a second,
        // UIImageViews want it in seconds.
        [self setAnimationDuration:total/100];
        
        // Repeat infinite
        [self setAnimationRepeatCount:0];
        
        [self startAnimating];
    }
}
- (void)dealloc {
    [self removeObservers];
    if (GIF_buffer != nil)
    {
	    GIF_buffer = nil;
    }
    
    if (GIF_screen != nil)
    {
		GIF_screen = nil;
    }
    
    if (GIF_global != nil)
    {
        GIF_global= nil;
    }
    
	GIF_frames = nil;
	
}
	 
- (void) decodeGIF:(NSData *)GIFData {
	GIF_pointer = GIFData;
    
    if (GIF_buffer != nil)
    {
        GIF_buffer = nil;
    }
    
    if (GIF_global != nil)
    {
        GIF_global= nil;
    }
    
    if (GIF_screen != nil)
    {
        GIF_screen = nil;
    }
    
	GIF_frames = nil;
	
    GIF_buffer = [[NSMutableData alloc] init];
	GIF_global = [[NSMutableData alloc] init];
	GIF_screen = [[NSMutableData alloc] init];
	GIF_frames = [[NSMutableArray alloc] init];
	
    // Reset file counters to 0
	dataPointer = 0;
	
	[self GIFSkipBytes: 6]; // GIF89a, throw away
	[self GIFGetBytes: 7]; // Logical Screen Descriptor
	
    // Deep copy
	[GIF_screen setData: GIF_buffer];
	
    // Copy the read bytes into a local buffer on the stack
    // For easy byte access in the following lines.
    int length = [GIF_buffer length];
	unsigned char aBuffer[length];
	[GIF_buffer getBytes:aBuffer length:length];
	
	if (aBuffer[4] & 0x80) GIF_colorF = 1; else GIF_colorF = 0; 
	if (aBuffer[4] & 0x08) GIF_sorted = 1; else GIF_sorted = 0;
	GIF_colorC = (aBuffer[4] & 0x07);
	GIF_colorS = 2 << GIF_colorC;
	
	if (GIF_colorF == 1)
    {
		[self GIFGetBytes: (3 * GIF_colorS)];
        
        // Deep copy
		[GIF_global setData:GIF_buffer];
	}
	
	unsigned char bBuffer[1];
	while ([self GIFGetBytes:1] == YES)
    {
        [GIF_buffer getBytes:bBuffer length:1];
        
        if (bBuffer[0] == 0x3B)
        { // This is the end
            break;
        }
        
        switch (bBuffer[0])
        {
            case 0x21:
                // Graphic Control Extension (#n of n)
                [self GIFReadExtensions];
                break;
            case 0x2C:
                // Image Descriptor (#n of n)
                [self GIFReadDescriptor];
                break;
        }
	}
	
	// clean up stuff
    GIF_buffer = nil;
    
    GIF_screen = nil;
    	
    GIF_global = nil;
}

- (void) GIFReadExtensions {
	// 21! But we still could have an Application Extension,
	// so we want to check for the full signature.
	unsigned char cur[1], prev[1];
    [self GIFGetBytes:1];
    [GIF_buffer getBytes:cur length:1];
    
	while (cur[0] != 0x00)
    {
		
		// TODO: Known bug, the sequence F9 04 could occur in the Application Extension, we
		//       should check whether this combo follows directly after the 21.
		if (cur[0] == 0x04 && prev[0] == 0xF9)
		{
			[self GIFGetBytes:5];
            
			AnimatedGifFrame *frame = [[AnimatedGifFrame alloc] init];
			
			unsigned char buffer[5];
			[GIF_buffer getBytes:buffer length:5];
			frame.disposalMethod = (buffer[0] & 0x1c) >> 2;
			//DDLogInfo(@"flags=%x, dm=%x", (int)(buffer[0]), frame.disposalMethod);
			
			// We save the delays for easy access.
			frame.delay = (buffer[1] | buffer[2] << 8);
			
			unsigned char board[8];
			board[0] = 0x21;
			board[1] = 0xF9;
			board[2] = 0x04;
			
			for(int i = 3, a = 0; a < 5; i++, a++)
			{
				board[i] = buffer[a];
			}
			
			frame.header = [NSData dataWithBytes:board length:8];
            
			[GIF_frames addObject:frame];
			break;
		}
		
		prev[0] = cur[0];
        [self GIFGetBytes:1];
		[GIF_buffer getBytes:cur length:1];
	}	
}

- (void) GIFReadDescriptor {
	[self GIFGetBytes:9];
    
    // Deep copy
	NSMutableData *GIF_screenTmp = [NSMutableData dataWithData:GIF_buffer];
	
	unsigned char aBuffer[9];
	[GIF_buffer getBytes:aBuffer length:9];
	
	CGRect rect;
	rect.origin.x = ((int)aBuffer[1] << 8) | aBuffer[0];
	rect.origin.y = ((int)aBuffer[3] << 8) | aBuffer[2];
	rect.size.width = ((int)aBuffer[5] << 8) | aBuffer[4];
	rect.size.height = ((int)aBuffer[7] << 8) | aBuffer[6];
    
	AnimatedGifFrame *frame = [GIF_frames lastObject];
	frame.area = rect;
	
	if (aBuffer[8] & 0x80) GIF_colorF = 1; else GIF_colorF = 0;
	
	unsigned char GIF_code = GIF_colorC, GIF_sort = GIF_sorted;
	
	if (GIF_colorF == 1)
    {
		GIF_code = (aBuffer[8] & 0x07);
        
		if (aBuffer[8] & 0x20)
        {
            GIF_sort = 1;
        }
        else
        {
        	GIF_sort = 0;
        }
	}
	
	int GIF_size = (2 << GIF_code);
	
	size_t blength = [GIF_screen length];
	unsigned char bBuffer[blength];
	[GIF_screen getBytes:bBuffer length:blength];
	
	bBuffer[4] = (bBuffer[4] & 0x70);
	bBuffer[4] = (bBuffer[4] | 0x80);
	bBuffer[4] = (bBuffer[4] | GIF_code);
	
	if (GIF_sort)
    {
		bBuffer[4] |= 0x08;
	}
	
    NSMutableData *GIF_string = [NSMutableData dataWithData:[@"GIF89a" dataUsingEncoding: NSUTF8StringEncoding]];
	[GIF_screen setData:[NSData dataWithBytes:bBuffer length:blength]];
    [GIF_string appendData: GIF_screen];
    
	if (GIF_colorF == 1)
    {
		[self GIFGetBytes:(3 * GIF_size)];
		[GIF_string appendData:GIF_buffer];
	}
    else
    {
		[GIF_string appendData:GIF_global];
	}
	
	// Add Graphic Control Extension Frame (for transparancy)
	[GIF_string appendData:frame.header];
	
	char endC = 0x2c;
	[GIF_string appendBytes:&endC length:sizeof(endC)];
	
	size_t clength = [GIF_screenTmp length];
	unsigned char cBuffer[clength];
	[GIF_screenTmp getBytes:cBuffer length:clength];
	
	cBuffer[8] &= 0x40;
	
	[GIF_screenTmp setData:[NSData dataWithBytes:cBuffer length:clength]];
	
	[GIF_string appendData: GIF_screenTmp];
	[self GIFGetBytes:1];
	[GIF_string appendData: GIF_buffer];
	
	while (true)
    {
		[self GIFGetBytes:1];
		[GIF_string appendData: GIF_buffer];
		
		unsigned char dBuffer[1];
		[GIF_buffer getBytes:dBuffer length:1];
		
		long u = (long) dBuffer[0];
        
		if (u != 0x00)
        {
			[self GIFGetBytes:u];
			[GIF_string appendData: GIF_buffer];
        }
        else
        {
            break;
        }
        
	}
	
	endC = 0x3b;
	[GIF_string appendBytes:&endC length:sizeof(endC)];
	
	// save the frame into the array of frames
	frame.data = GIF_string;
}

- (bool) GIFGetBytes:(int)length {
    if (GIF_buffer != nil)
    {
        GIF_buffer = nil;
    }
    
	if ((NSInteger)[GIF_pointer length] >= dataPointer + length) // Don't read across the edge of the file..
    {
        //消除警告替换
		//GIF_buffer = [[GIF_pointer subdataWithRange:NSMakeRange(dataPointer, length)] retain];
        GIF_buffer = [[NSMutableData alloc] init];
        [GIF_buffer setData:[GIF_pointer subdataWithRange:NSMakeRange(dataPointer, length)]];
        
        dataPointer += length;
		return YES;
	}
    else
    {
        return NO;
	}
}

- (bool) GIFSkipBytes: (int) length {
    if ((NSInteger)[GIF_pointer length] >= dataPointer + length)
    {
        dataPointer += length;
        return YES;
    }
    else
    {
    	return NO;
    }
}

- (NSData*) getFrameAsDataAtIndex:(int)index {
	if (index < (NSInteger)[GIF_frames count])
	{
		return ((AnimatedGifFrame *)[GIF_frames objectAtIndex:index]).data;
	}
	else
	{
		return nil;
	}
}

- (UIImage*) getFrameAsImageAtIndex:(int)index {
    NSData *frameData = [self getFrameAsDataAtIndex: index];
    UIImage *image = nil;
    
    if (frameData != nil)
    {
		image = [UIImage imageWithData:frameData];
    }
    
    return image;
}


-(void)startGifAnimating
{
    [self startAnimating];
}
-(void)stopGifAnimating
{
    [self stopAnimating];
}

+(STGIFImageView*)deQueueGifImageView:(NSString*)fileName
{
    NSMutableArray * gifFrames = [STGIFImageView getGifImageFrameFromMem:fileName];

    STGIFImageView * gifObjView = nil;

    
    if (gifFrames==nil) {
    
        NSString * path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
        
        gifObjView = [[STGIFImageView alloc] initWithGIFFile:path];
        
        [STGIFImageView saveGifImageFrameToMem:fileName gif:gifObjView.GIF_frames];

    }else
    {
        gifObjView = [[STGIFImageView alloc] init];
        
        [gifObjView setGIF_frames:gifFrames];

    }
    
    [gifObjView setFrame:CGRectMake(0, 0,  110,110)];
//    RL_RELEASE_SAFELY(gifFrames);

    return gifObjView;

}

+(NSMutableArray*)getGifImageFrameFromMem:(NSString*)fileName
{
    NSMutableArray * retGif = nil;
    
    if (ChatGifFrameCacheMemStore) {
        retGif = [ChatGifFrameCacheMemStore objectForKey:fileName];
    }
    
    return  retGif;
}


+(void)saveGifImageFrameToMem:(NSString*)fileName gif:(NSMutableArray*)gifFrames
{
    if (fileName == nil) {
        return;
    }
    
    if (ChatGifFrameCacheMemStore == nil) {
        ChatGifFrameCacheMemStore = [[NSMutableDictionary alloc] initWithCapacity:20];
    }
    
    [ChatGifFrameCacheMemStore setObject:gifFrames forKey:fileName];
    
}

+(void)clearGifImageFrameMemStoreifOver:(NSInteger)maxSize
{
    if (ChatGifFrameCacheMemStore) {
        
        if ([[ChatGifFrameCacheMemStore allKeys] count]>maxSize) {
            [ChatGifFrameCacheMemStore removeAllObjects];
        }
        if (maxSize == 0) {
            ChatGifFrameCacheMemStore = nil;
        }
    }
    
}

#pragma mark - Observer
- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goChange:) name:@"ChangeStart" object:nil];
}

- (void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChangeStart" object:nil];
}

- (void)goChange:(NSNotification *)notification
{
    if ([notification.object boolValue]) {
        [self startAnimating];
    }else{
        [self stopAnimating];
    }
}

@end
