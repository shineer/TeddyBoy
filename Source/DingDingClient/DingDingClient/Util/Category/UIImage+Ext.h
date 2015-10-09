//
//  UIImage+Ext.h
//  DingDingClient
//
//  Created by phoenix on 14-10-10.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (IdentifierAddition)

// 截取部分图像
- (UIImage*)getSubImage:(CGRect)rect;

// 等比例缩放
- (UIImage*)scaleToSize:(CGSize)size;

/**
 *  @brief  Create a partially displayed image
 *
 *  @param  percentage  This defines the part to be displayed as original
 *  @param  vertical    If YES, the image is displayed bottom to top; otherwise left to right
 *  @param  grayscaleRest   If YES, the non-displaye part are in grayscale; otherwise in transparent
 *
 *  @return A generated UIImage instance
 */
- (UIImage*)partialImageWithPercentage:(float)percentage
                              vertical:(BOOL)vertical
                         grayscaleRest:(BOOL)grayscaleRest;

@end
