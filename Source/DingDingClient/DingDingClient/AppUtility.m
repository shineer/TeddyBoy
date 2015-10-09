//
//  AppUtility.m
//  DingDingClient
//
//  Created by phoenix on 14-10-10.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import "AppUtility.h"
#import "FCIPAddressGeocoder.h"
#import "DDCoreDataMgr.h"

#define DD_CURRENT_USER_KEY     @"dd_current_user_info"
#define DD_APP_SETTING_KEY      @"dd_app_setting"

@implementation DDAppSetting

- (id)init
{
    if (self = [super init])
    {
        self.isActived = NO;
        self.isShowSplash = NO;
        self.splashImageUrl = nil;
        self.userAccountDic = [[NSMutableDictionary alloc] init];
        // 当前host环境(默认是生产环境)
        self.hostType = EDDHostType_Production;
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder;
{
    [aCoder encodeObject:[NSNumber numberWithBool:self.isActived] forKey:@"isActived"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isShowSplash] forKey:@"isShowSplash"];
    [aCoder encodeObject:self.splashImageUrl forKey:@"splashImageUrl"];
    [aCoder encodeObject:self.userAccountDic forKey:@"userAccountDic"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.hostType] forKey:@"hostType"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self init])
    {
        self.isActived = [[aDecoder decodeObjectForKey:@"isActived"] boolValue];
        self.isShowSplash = [[aDecoder decodeObjectForKey:@"isShowSplash"] boolValue];
        self.splashImageUrl = [aDecoder decodeObjectForKey:@"splashImageUrl"];
        self.userAccountDic = [aDecoder decodeObjectForKey:@"userAccountDic"];
        self.hostType = [[aDecoder decodeObjectForKey:@"hostType"] intValue];
    }
    return self;
}

@end


@implementation DDCurrentUser

- (id)init
{
    if (self = [super init])
    {
        // 默认是访客账号
        self.account = @"Guest";
        self.password = @"123456";
        self.userId = @"888888";
        self.nickName = @"访客";
        self.gender = 0;
        self.isFirstTimeLogin = 0;
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder;
{
    [aCoder encodeObject:self.account forKey:@"account"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.gender] forKey:@"gender"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.isFirstTimeLogin] forKey:@"isFirstTimeLogin"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [self init])
    {
        self.account = [aDecoder decodeObjectForKey:@"account"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.gender = [[aDecoder decodeObjectForKey:@"gender"] intValue];
        self.isFirstTimeLogin = [[aDecoder decodeObjectForKey:@"isFirstTimeLogin"] intValue];
	}
	return self;
}

@end

static AppUtility * utilityInstance = nil;

@implementation AppUtility

+ (AppUtility*)getInstance
{
	@synchronized(self)
    {
		if (utilityInstance == nil)
        {
            utilityInstance = [[AppUtility alloc] init];
		}
	}
	return utilityInstance;
}

- (id)init
{
    if (self = [super init])
    {
        // 当前用户缓存(会持久化)
        self.currentUser = (DDCurrentUser*)[AppUtility objectForKey:DD_CURRENT_USER_KEY];
        if (nil == self.currentUser)
        {
            self.currentUser = [[DDCurrentUser alloc] init];
        }

        // 当前应用程序设置(会持久化)
        self.appSetting = (DDAppSetting*)[AppUtility objectForKey:DD_APP_SETTING_KEY];
        if (nil == self.appSetting)
        {
            self.appSetting = [[DDAppSetting alloc] init];
        }
    }
    return self;
}

/*
 UIRemoteNotificationTypeNone                         ＝ 0，
 UIRemoteNotificationTypeBadge                        ＝ 1，
 UIRemoteNotificationTypeSound                        ＝ 2，
 UIRemoteNotificationTypeAlert                        ＝ 4，
 UIRemoteNotificationTypeNewsstandContentAvailability ＝ 8
 */
+ (UIRemoteNotificationType)getPushNotificationType
{
    UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    
    return type;
}

+ (void)regPushServive
{
    // IOS8新系统需要使用新的代码
    if([UIDevice isHigherIOS8])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound|UIUserNotificationTypeAlert|UIUserNotificationTypeBadge) categories:nil]];
        
        [[UIApplication sharedApplication]registerForRemoteNotifications];
        
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
    }
}

+ (void)unregPushService
{
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
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
    NSString *documentPath = [[FileUtil getFileUtil] getDocmentPath];
    NSString *dir = [documentPath stringByAppendingPathComponent:@"user"];
    
    NSError *error = nil;
    
    if (![[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&error])
    {
        return nil;
    }
    NSString *path = [NSString stringWithFormat:@"%@/%@", dir, key];
    return path;
}

// 保存应用程序设置
- (void)saveAppSetting
{
    [AppUtility setObject:self.appSetting forKey:DD_APP_SETTING_KEY];
}

- (BOOL)checkCurrentUser
{
    //有用户名和密码或者有token就可以登录
    if (self.currentUser.account)
    {
		return YES;
	}
    else
    {
        return NO;
    }
}

- (void)saveCurrentUser
{
    [AppUtility setObject:self.currentUser forKey:DD_CURRENT_USER_KEY];
}

- (void)clearCurrentUser
{
    // 清除当前用户的数据库引用
    [[DDCoreDataMgr getInstance] cleanUp];
    
    // 清空当前用户登录的token凭证,新注册或者登录后重新获取,设置成默认的访客账号
    self.currentUser.account = @"Guest";
    self.currentUser.password = @"123456";
    self.currentUser.userId = @"888888";
    self.currentUser.nickName = @"访客";
    self.currentUser.gender = 0;

    [self saveCurrentUser];
}

// 当前用户路径
- (NSString *)userDocumentPath
{
    if(nil == self.currentUser.account)
        return nil;
    
    NSString *path = [[[FileUtil getFileUtil] getDocmentPath] stringByAppendingPathComponent:self.currentUser.account];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    if (![fileMgr fileExistsAtPath:path])
    {
        NSError *error = nil;
        [fileMgr  createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error)
        {
            DD_LOG(@"\n---- Create userDocumentPath error %@ ----", error.description);
        }
    }
    
    return path;
}

// 当前用户数据库路径
- (NSString *)userDatabasePath
{
    NSString *path = [[self userDocumentPath] stringByAppendingPathComponent:@"sql"];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    if (![fileMgr fileExistsAtPath:path])
    {
        NSError *error = nil;
        [fileMgr  createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error)
        {
            DD_LOG(@"\n---- Create databasePath error %@ ----", error.description);
        }
    }
    
    return [path stringByAppendingPathComponent:@"dingding.sql"];
}

// 当前用户图片路径
- (NSString *)userImageFilePath
{
    NSString *path = [[self userDocumentPath] stringByAppendingPathComponent:@"image"];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    if (![fileMgr fileExistsAtPath:path])
    {
        NSError *error = nil;
        [fileMgr  createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error)
        {
            DD_LOG(@"\n---- Create imageFilePath error %@ ----", error.description);
        }
    }
    
    return path;
}

// 当前用户录音路径
- (NSString *)userVoiceFilePath
{
    NSString *path = [[self userDocumentPath] stringByAppendingPathComponent:@"voice"];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    if (![fileMgr fileExistsAtPath:path])
    {
        NSError *error = nil;
        [fileMgr  createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error)
        {
            DD_LOG(@"\n---- Create voiceFilePath error %@ ----", error.description);
        }
    }
    
    return path;
}

// 公共文件夹路径
- (NSString *)userCommonPath
{
    NSString *path = [[[FileUtil getFileUtil] getDocmentPath] stringByAppendingPathComponent:@"common"];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    if (![fileMgr fileExistsAtPath:path])
    {
        NSError *error = nil;
        [fileMgr  createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error)
        {
            DD_LOG(@"\n---- Create commonPath error %@ ----", error.description);
        }
    }
    return path;
}

// 重置app环境变量(初次运行或者切换host环境)
- (void)resetAppEnvirement
{
    // 首先需要切换host环境
    [DD_CONFIG switchHostWithType:self.appSetting.hostType];
    
    // 和服务器同步时间
    [[DDSystemService getInstance] syncTimeWithServer];
    
    // 从服务器端获取唯一AppId
    [[DDSystemService getInstance] getAppIdWithServer];
}

// 获取地理位置信息
- (void)getLoctaionInfo
{
    // 获取地理位置信息,基于IP位置地址编码器,这样就不会弹出需要授权的提示(精度会差一点)
    FCIPAddressGeocoder *geocoder = [FCIPAddressGeocoder sharedGeocoder];
    geocoder.canUseOtherServicesAsFallback = YES;
    [geocoder geocode:^(BOOL success) {
        
        if(success)
        {
            //you can access the location info-dictionary containing all informations using 'geocoder.locationInfo'
            //you can access the location using 'geocoder.location'
            //you can access the location city using 'geocoder.locationCity' (it could be nil)
            //you can access the location country using 'geocoder.locationCountry'
            //you can access the location country-code using 'geocoder.locationCountryCode'
            //UI_LOG(@"geocoder.locationInfo = %@", geocoder.locationInfo);
            // 经度
            DD_CONFIG.coreSetting.longitude = [[geocoder.locationInfo objectForKey:@"longitude"] floatValue];
            // 纬度
            DD_CONFIG.coreSetting.latitude = [[geocoder.locationInfo objectForKey:@"latitude"] floatValue];
            
            // 保存core参数设置
            [DD_CONFIG saveCoreSetting];
        }
        else
        {
            //you can debug what's going wrong using: 'geocoder.error'
        }
    }];
}

@end
