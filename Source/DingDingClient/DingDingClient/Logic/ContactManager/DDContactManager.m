//
//  DDContactManager.m
//  DingDingClient
//
//  Created by phoenix on 14-11-6.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import "DDContactManager.h"

static DDContactManager *_sharedContactManager = nil;

@implementation DDContactManager

+ (DDContactManager*)getInstance
{
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        
        _sharedContactManager = [[DDContactManager alloc] init];
    });
    
    return _sharedContactManager;
}

- (id)init
{
    self = [super init];
    
    if(self)
    {
        // Todo...
    }
    return self;
}

- (void)getContectByUserId:(NSString *)userId
{
    // 根据uid去服务器拉取用户信息并且存数据库
//    [YY_CORE.userService getUserInfo:userId smallWidth:PORTRAIT_VIEW_SIZE smallHeight:PORTRAIT_VIEW_SIZE bigWidth:PORTRAIT_VIEW_BIG_SIZE bigHeight:PORTRAIT_VIEW_BIG_SIZE resopnse:^(NSInteger result, NSDictionary *dict, YYError *error) {
//        
//        if(result == EYYResponseResultSucceed)
//        {
//            /*
//             "userView":用户对象,
//             "notesCount":动态数量
//             "userQACount":用户回答QA问答数量
//             */
//            // 更新用户对象并且存数据库
//            NSDictionary* item = [dict objectForKey:@"userView"];
//            YYUser* user = [[YYContactManager getInstance] parseUserObject:item];
//            YYContactData* contact = [[YYContactManager getInstance] convertUserObject:user];
//            contact.qaCount = [[dict objectForKey:@"userQACount"] intValue];
//            contact.notesCount = [[dict objectForKey:@"notesCount"] intValue];
//            [contact saveContact];
//        }
//        else if (result == EYYResponseResultFailed)
//        {
//            //[DDHUDVIEW showTips:error.errorMsg autoHideTime:1];
//        }
//    }];
}

@end
