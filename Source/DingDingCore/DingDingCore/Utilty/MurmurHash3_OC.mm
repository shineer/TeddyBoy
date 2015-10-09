//
//  MurmurHash3_OC.m
//  gitTest
//
//  Created by liangguowei on 15/8/13.
//  Copyright (c) 2015年 liangguowei. All rights reserved.
//

#import "MurmurHash3_OC.h"
#import "MurmurHash3.h"

@implementation MurmurHash3_OC

+(NSString *)MurmurHash3_x86_32_OC:(NSString *)key andSeed:(int)seed
{
    uint32_t hash[4];
    const char *cStr= [key cStringUsingEncoding:NSUTF8StringEncoding];
    MurmurHash3_x86_32(cStr, (int)strlen(cStr), seed, hash);
    
    return [NSString stringWithFormat:@"%08x%08x%08x%08x",hash[1],hash[0],hash[3],hash[2]];

}
+(NSString *)MurmurHash3_x86_128_OC:(NSString *)key andSeed:(int)seed
{
    uint32_t hash[4];
    const char *cStr= [key cStringUsingEncoding:NSUTF8StringEncoding];
    MurmurHash3_x86_128(cStr, (int)strlen(cStr), seed, hash);
    
    return [NSString stringWithFormat:@"%08x%08x%08x%08x",hash[1],hash[0],hash[3],hash[2]];
}
+(NSString *)MurmurHash3_x64_128_OC:(NSString *)key andSeed:(int)seed
{
    uint32_t hash[4];
    const char *cStr= [key cStringUsingEncoding:NSUTF8StringEncoding];
    MurmurHash3_x64_128(cStr, (int)strlen(cStr), seed, hash);
    
    return [NSString stringWithFormat:@"%08x%08x%08x%08x",hash[1],hash[0],hash[3],hash[2]];
}

@end
