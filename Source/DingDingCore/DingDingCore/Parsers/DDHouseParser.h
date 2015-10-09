//
//  DDHouseParser.h
//  DingDingCore
//
//  Created by phoenix on 15/9/14.
//  Copyright (c) 2015年 SEU. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DDHotHouse;

@interface DDHouseParser : NSObject

+ (DDHouseParser*)getInstance;

- (DDHotHouse*)parseHotHouseObject:(NSDictionary*)dic;

@end
