//
//  MurmurHash3_OC.h
//  gitTest
//
//  Created by liangguowei on 15/8/13.
//  Copyright (c) 2015年 liangguowei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MurmurHash3_OC : NSObject

+(NSString *)MurmurHash3_x86_32_OC:(NSString *)key andSeed:(int)seed;
+(NSString *)MurmurHash3_x86_128_OC:(NSString *)key andSeed:(int)seed;
+(NSString *)MurmurHash3_x64_128_OC:(NSString *)key andSeed:(int)seed;

@end
