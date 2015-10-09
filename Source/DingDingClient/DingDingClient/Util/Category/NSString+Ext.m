//
//  NSString+Ext.m
//  DingDingClient
//
//  Created by phoenix on 14-10-10.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import "NSString+Ext.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (IdentifierAddition)

+ (BOOL)isBlankString:(NSString *)string{
    BOOL result = NO;
    
    if (NULL == string || [string isEqual:nil] || [string isEqual:Nil])
    {
        result = YES;
    }
    else if ([string isEqual:[NSNull null]])
    {
        result = YES;
    }
    else if (0 == [string length] || 0 == [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length])
    {
        result = YES;
    }
    else if([string isEqualToString:@"(null)"])
    {
        result = YES;
    }
    
    return result;
}

// 普通字符串转换为十六进制
+ (NSString *)hexStringFromString:(NSString *)string
{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i = 0; i < [myD length]; i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x", bytes[i]&0xff];//16进制数
        
        if([newHexStr length]==1)
        {
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        }
        else
        {
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }
    }
    return hexStr;
}

// 出现类似这样格式的字段"\\U6df1\\U5733\\U56fd\\U5f00\\U884c01\\U673a\\U623",通常为Unicode码,转换函数为
+ (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

@end
