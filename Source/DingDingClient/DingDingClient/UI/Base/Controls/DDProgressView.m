//
//  DDProgressView.m
//  DingDingClient
//
//  Created by phoenix on 15-5-19.
//  Copyright (c) 2015年 SEU. All rights reserved.
//

#import "DDProgressView.h"

@interface DDProgressView ()

@property (nonatomic, strong) UIImage * originalImage;

- (void)commonInit;
- (void)updateDrawing;

@end

@implementation DDProgressView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self commonInit];
    }
    return self;
    
}

- (void)commonInit{
    
    _progress = 0.f;
    _hasGrayscaleBackground = YES;
    _verticalProgress = YES;
    _originalImage = self.image;
    
}

#pragma mark - Custom Accessor

- (void)setImage:(UIImage *)image
{
    [super setImage:image];
    
    if (!_internalUpdating)
    {
        self.originalImage = image;
        [self updateDrawing];
    }
    
    _internalUpdating = NO;
}

- (void)setProgress:(float)progress
{
    _progress = MIN(MAX(0.f, progress), 1.f);
    [self updateDrawing];
}

- (void)setHasGrayscaleBackground:(BOOL)hasGrayscaleBackground
{
    _hasGrayscaleBackground = hasGrayscaleBackground;
    [self updateDrawing];
}

- (void)setVerticalProgress:(BOOL)verticalProgress
{
    _verticalProgress = verticalProgress;
    [self updateDrawing];
}

#pragma mark - drawing

- (void)updateDrawing
{
    _internalUpdating = YES;
    self.image = [_originalImage partialImageWithPercentage:_progress vertical:_verticalProgress grayscaleRest:_hasGrayscaleBackground];
    
}

@end
