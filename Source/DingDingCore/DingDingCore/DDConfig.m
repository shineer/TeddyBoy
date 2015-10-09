//
//  DDConfig.m
//  DingDingCore
//
//  Created by phoenix on 14-10-16.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import "DDConfig.h"
#import "DDSystemService.h"

#define DD_CORE_SETTING_KEY      @"dd_core_setting"

@implementation DDCoreSetting

- (id)init
{
    if (self = [super init])
    {
        self.appId = nil;
        self.token = nil;
        self.userId = nil;
        self.deviceToken = nil;
        self.cityId = 131000;//默认设置廊坊:131000
        self.appVersion = @"2.2.0";//默认版本号
        self.longitude = 0.0;
        self.latitude = 0.0;
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder;
{
    [aCoder encodeObject:self.appId forKey:@"appId"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.deviceToken forKey:@"deviceToken"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.cityId] forKey:@"cityId"];
    [aCoder encodeObject:self.appVersion forKey:@"appVersion"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.longitude] forKey:@"longitude"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.latitude] forKey:@"latitude"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self init])
    {
        self.appId = [aDecoder decodeObjectForKey:@"appId"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.deviceToken = [aDecoder decodeObjectForKey:@"deviceToken"];
        self.cityId = [[aDecoder decodeObjectForKey:@"cityId"] integerValue];
        self.appVersion = [aDecoder decodeObjectForKey:@"appVersion"];
        self.longitude = [[aDecoder decodeObjectForKey:@"longitude"] doubleValue];
        self.latitude = [[aDecoder decodeObjectForKey:@"latitude"] doubleValue];
    }
    return self;
}

@end

static DDConfig *instance = nil;

@implementation DDConfig

#pragma mark - instance method
+ (DDConfig*)getInstance
{
    @synchronized(self)
    {
        if (instance == nil)
        {
            instance = [[DDConfig alloc] init];
        }
    }
    return instance;
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        [self initConfig];
    }
    return self;
}

-(void)initConfig
{
    // 默认是生产环境
    //----------------------------------------------------------------------------------------------------
    self.hostUrl = @"http://mobile.zufangzi.com";
    self.hostImageUrl = @"http://static.zufangzi.com";
    //----------------------------------------------------------------------------------------------------
    // 当前core参数设置(会持久化)
    self.coreSetting = (DDCoreSetting*)[DDConfig objectForKey:DD_CORE_SETTING_KEY];
    if (nil == self.coreSetting)
    {
        self.coreSetting = [[DDCoreSetting alloc] init];
    }
    //----------------------------------------------------------------------------------------------------

    // 更新server接口地址
    [self updateServerInterface];
}

#pragma mark - private method

// 更新server接口地址(每次host环境切换都必须调用该函数重新生成一遍新的接口地址)
- (void)updateServerInterface
{
    // 获取服务器时间
    self.getSystemTimeUrl = [NSString stringWithFormat:@"%@%@", self.hostUrl, kGetSystemTimeUrl];
    // 获取AppId
    self.getAppIdUrl= [NSString stringWithFormat:@"%@%@", self.hostUrl, kGetAppIdUrl];
    // 获取验证码
    self.loginIdentityCodeUrl = [NSString stringWithFormat:@"%@%@", self.hostUrl, kLoginIdentityCodeUrl];
    // 用户登录
    self.userLoginUrl= [NSString stringWithFormat:@"%@%@", self.hostUrl, kUserLoginUrl];
    // 获取推荐房源
    self.hotHouseListByClientUrl = [NSString stringWithFormat:@"%@%@", self.hostUrl, kHotHouseListByClientUrl];
}

+ (NSObject *)objectForKey:(NSString *)key
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self dataFilePathForKey:key]];
}

+ (BOOL)setObject:(NSObject *)value forKey:(NSString *)key
{
    return [NSKeyedArchiver archiveRootObject:value toFile:[self dataFilePathForKey:key]];
}

+ (NSString *)dataFilePathForKey:(NSString *)key
{
    NSArray *userPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [userPaths objectAtIndex:0];
    NSString *dir = [documentPath stringByAppendingPathComponent:@"core"];
    
    NSError *error = nil;
    
    if (![[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&error])
    {
        return nil;
    }
    NSString *path = [NSString stringWithFormat:@"%@/%@", dir, key];
    return path;
}

#pragma mark - public method

// 保存core设置
- (void)saveCoreSetting
{
    [DDConfig setObject:self.coreSetting forKey:DD_CORE_SETTING_KEY];
}

// 切换core环境
- (void)switchHostWithType:(EDDHostType)type
{
    if(type == EDDHostType_Development)
    {
        // 测试环境
        self.hostUrl = @"http://192.168.1.224:8080";
        self.hostImageUrl = @"http://192.168.1.233:8888/dd-file-gw";
    }
    else if(type == EDDHostType_Production)
    {
        // 生产环境
        self.hostUrl = @"http://mobile.zufangzi.com";
        self.hostImageUrl = @"http://static.zufangzi.com";
    }
    else
    {
        // 其他环境
        self.hostUrl = @"http://mobile.zufangzi.com";
        self.hostImageUrl = @"http://static.zufangzi.com";
    }
    
    // 更新server接口地址
    [self updateServerInterface];
}

// 注销core
- (void)coreLogout
{
    // 用户登出的时候需要清空Core下面这些变量
    self.coreSetting.token = nil;
    self.coreSetting.userId = nil;
    self.coreSetting.cityId = 131000;//默认设置廊坊:131000
    
    [self saveCoreSetting];
}

// 获取baseInfo
- (NSDictionary*)getBaseInfo
{
    /*
     "baseInfo":{
     "accountId":用户id
     "token":用户登录token
     "accountType":客户端类型,IOS没有管家端,都是传3
     "appId":appId用来唯一标示该应用
     "baseCityId":用户城市id
     "deviceId":用来唯一标示设备的deviceToken
     "deviceName":设备名称
     "from":来源产品渠道 1:web业务基础平台,2:web代理商平台,3:web400平台,4:web官网,5:ios客端,6:andorid助手,7:android客端,8:M站,9:微信
     "uuid":CFUUID(唯一标识符)
     "timestamp":获取系统时间(和服务器同步以后的)
     "appVersion":系统版本
     "location":经纬度信息
     }
     */
    NSMutableDictionary *baseInfo = [[NSMutableDictionary alloc] init];
    
    if (self.coreSetting.userId)
    {
        // 用户id
        [baseInfo setValue:self.coreSetting.userId forKey:@"accountId"];
    }
    
    if (self.coreSetting.token)
    {
        // 用户登录token
        [baseInfo setValue:self.coreSetting.token forKey:@"token"];
    }
    
    // 客户端类型,IOS没有管家端,都是传3
    [baseInfo setObject:[NSNumber numberWithInt:3] forKey:@"accountType"];
    
    if (self.coreSetting.appId)
    {
        // appId
        [baseInfo setValue:self.coreSetting.appId forKey:@"appId"];
    }
    
    // 经纬度信息
    [baseInfo setValue:[NSString stringWithFormat:@"%f,%f", self.coreSetting.longitude, self.coreSetting.latitude] forKey:@"location"];
    
    if(self.coreSetting.cityId == 0)
    {
        // 默认设置廊坊:131000
        [baseInfo setValue:[NSNumber numberWithInteger:131000] forKey:@"baseCityId"];
    }
    else
    {
        // cityId
        [baseInfo setValue:[NSNumber numberWithInteger:self.coreSetting.cityId] forKey:@"baseCityId"];
    }
    
    if (self.coreSetting.deviceToken)
    {
        // deviceToken
        [baseInfo setValue:self.coreSetting.deviceToken forKey:@"deviceId"];
    }

    // 设备名称
    NSString* deviceName = [CommonUtils getCurrentDeviceName];
    deviceName = [deviceName stringByReplacingOccurrencesOfString:@" " withString:@""];
    [baseInfo setValue:deviceName forKey:@"deviceName"];
    
    // 来源产品渠道 1:web业务基础平台,2:web代理商平台,3:web400平台,4:web官网,5:ios客端,6:andorid助手,7:android客端,8:M站,9:微信
    [baseInfo setValue:[NSNumber numberWithInt:5] forKey:@"from"];
    
    // UUID(OpenUDID)
    [baseInfo setValue:[CommonUtils uniqueStringOpenUDID] forKey:@"uuid"];
    
    // 获取系统时间(和服务器同步以后的)
    NSTimeInterval time = [[DDSystemService getInstance] getCurrentTime];
    [baseInfo setValue:@(time * 1000) forKey:@"timestamp"];
    
    // 系统版本
    [baseInfo setValue:self.coreSetting.appVersion forKey:@"appVersion"];
    
    return baseInfo;
}

@end
