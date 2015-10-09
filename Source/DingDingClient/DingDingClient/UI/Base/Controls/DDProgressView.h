//
//  DDProgressView.h
//  DingDingClient
//
//  Created by phoenix on 15-5-19.
//  Copyright (c) 2015年 SEU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDProgressView : UIImageView
{
    
    UIImage*  _originalImage;
    BOOL      _internalUpdating;
}

@property (nonatomic) float progress;
@property (nonatomic) BOOL  hasGrayscaleBackground;
@property (nonatomic, getter = isVerticalProgress) BOOL verticalProgress;

@end

