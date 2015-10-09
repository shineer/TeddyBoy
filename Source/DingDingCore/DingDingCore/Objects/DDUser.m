//
//  DDUser.m
//  DingDingClient
//
//  Created by phoenix on 14-11-3.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import "DDUser.h"

@implementation DDUser

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        _userId = nil;                      //用户id
        _userIconUrl = nil;                 //用户头像
        _nickName = nil;                    //昵称
        _age = 0;                           //用户年龄
        _sex = 0;                           //用户性别
        _userGEO = nil;                     //用户坐标（double数组）
        _recommend = nil;                   //用户推荐理由
        _activeTime = 0;                  //用户的最后活跃时间
        _userTagViewList = nil;             //["userTagView":用户标签展示对象 ...]
        _nation = nil;                      //民族
        _nationId = 0;                      //民族id
        _birthday = 0;                    //生日
        _figure = nil;                      //体型
        _figureId = 0;                      //体型Id
        _industry = nil;                    //行业
        _industryId = 0;                    //行业id
        _income = nil;                      //收入
        _incomeId = 0;                      //收入id
        _education = nil;                   //学历
        _educationId = 0;                   //学历id
        _purpose = nil;                     //交友目的
        _purposeId = 0;                     //交友目的id
        _mobileType = nil;                  //手机型号
        _loginTime = nil;                   //登录时间
        _constellation = nil;               //星座
        _photoList = nil;                   //["imageView":{图片展示对象},"imageView":{图片展示对象},...]
        _isScore = 0;                       //是否评过分 0:是 1:不是
        _isCollect = 0;                     //是否收藏 0:是 1:不是
        _isSayHi = 0;                       //是否打过招呼 0:是 1:不是
        _level = 0;                         //用户级别
        _height = 0;                        //身高
        _weight = 0;                        //体重
        _sign = nil;                        //个性签名
    }
    return self;
}

- (void)dealloc
{
    //CORE_LOG(@"%@释放了", [self class]);
}

- (void)encodeWithCoder:(NSCoder *)aCoder;
{
    // 这里放置需要持久化的属性
    
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.userIconUrl forKey:@"userIconUrl"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.age] forKey:@"age"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.sex] forKey:@"sex"];
    [aCoder encodeObject:self.userGEO forKey:@"userGEO"];
    [aCoder encodeObject:self.recommend forKey:@"recommend"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.activeTime] forKey:@"activeTime"];
    [aCoder encodeObject:self.userTagViewList forKey:@"userTagViewList"];
    [aCoder encodeObject:self.nation forKey:@"nation"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.nationId] forKey:@"nationId"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.birthday] forKey:@"birthday"];
    [aCoder encodeObject:self.figure forKey:@"figure"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.figureId] forKey:@"figureId"];
    [aCoder encodeObject:self.industry forKey:@"industry"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.industryId] forKey:@"industryId"];
    [aCoder encodeObject:self.income forKey:@"income"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.incomeId] forKey:@"incomeId"];
    [aCoder encodeObject:self.education forKey:@"education"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.educationId] forKey:@"educationId"];
    [aCoder encodeObject:self.purpose forKey:@"purpose"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.purposeId] forKey:@"purposeId"];
    [aCoder encodeObject:self.mobileType forKey:@"mobileType"];
    [aCoder encodeObject:self.loginTime forKey:@"loginTime"];
    [aCoder encodeObject:self.constellation forKey:@"constellation"];
    [aCoder encodeObject:self.photoList forKey:@"photoList"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.isScore] forKey:@"isScore"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.isCollect] forKey:@"isCollect"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.isSayHi] forKey:@"isSayHi"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.level] forKey:@"level"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.height] forKey:@"height"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.weight] forKey:@"weight"];
    [aCoder encodeObject:self.sign forKey:@"sign"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self init])
    {
        // 这里务必和encodeWithCoder方法里面的内容一致，不然会读不到数据
        
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.userIconUrl = [aDecoder decodeObjectForKey:@"userIconUrl"];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.age = [[aDecoder decodeObjectForKey:@"age"] intValue];
        self.sex = [[aDecoder decodeObjectForKey:@"sex"] intValue];
        self.userGEO = [aDecoder decodeObjectForKey:@"userGEO"];
        self.recommend = [aDecoder decodeObjectForKey:@"recommend"];
        self.activeTime = [[aDecoder decodeObjectForKey:@"activeTime"] doubleValue];
        self.userTagViewList = [aDecoder decodeObjectForKey:@"userTagViewList"];
        self.nation = [aDecoder decodeObjectForKey:@"nation"];
        self.nationId = [[aDecoder decodeObjectForKey:@"nationId"] intValue];
        self.birthday = [[aDecoder decodeObjectForKey:@"birthday"] doubleValue];
        self.figure = [aDecoder decodeObjectForKey:@"figure"];
        self.figureId = [[aDecoder decodeObjectForKey:@"figureId"] intValue];
        self.industry = [aDecoder decodeObjectForKey:@"industry"];
        self.industryId = [[aDecoder decodeObjectForKey:@"industryId"] intValue];
        self.income = [aDecoder decodeObjectForKey:@"income"];
        self.incomeId = [[aDecoder decodeObjectForKey:@"incomeId"] intValue];
        self.education = [aDecoder decodeObjectForKey:@"education"];
        self.educationId = [[aDecoder decodeObjectForKey:@"educationId"] intValue];
        self.purpose = [aDecoder decodeObjectForKey:@"purpose"];
        self.purposeId = [[aDecoder decodeObjectForKey:@"purposeId"] intValue];
        self.mobileType = [aDecoder decodeObjectForKey:@"mobileType"];
        self.loginTime = [aDecoder decodeObjectForKey:@"loginTime"];
        self.constellation = [aDecoder decodeObjectForKey:@"constellation"];
        self.photoList = [aDecoder decodeObjectForKey:@"photoList"];
        self.isScore = [[aDecoder decodeObjectForKey:@"isScore"] intValue];
        self.isCollect = [[aDecoder decodeObjectForKey:@"isCollect"] intValue];
        self.isSayHi = [[aDecoder decodeObjectForKey:@"isSayHi"] intValue];
        self.level = [[aDecoder decodeObjectForKey:@"level"] intValue];
        self.height = [[aDecoder decodeObjectForKey:@"height"] intValue];
        self.weight = [[aDecoder decodeObjectForKey:@"weight"] intValue];
        self.sign = [aDecoder decodeObjectForKey:@"sign"];
    }
    return self;
}

@end
