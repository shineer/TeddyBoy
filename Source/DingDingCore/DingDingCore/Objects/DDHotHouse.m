//
//  DDHotHouse.m
//  DingDingCore
//
//  Created by phoenix on 15/9/14.
//  Copyright (c) 2015年 SEU. All rights reserved.
//

#import "DDHotHouse.h"

@implementation DDHotHouse

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        self.productId = nil;//房源id
        self.bizcircleId = nil;//商圈id
        self.bizcircleName = nil;//商圈名:"广渠门"
        self.resblockId = nil;//小区id:"140256"
        self.resblockName = nil;//小区名:"光明西里"
        self.hallCount = 0;//客厅数量
        self.toiletCount = 0;//卫生间数量
        self.cookroomCount = 0;//厨房数量
        self.roomCount = 0;//卧室数量
        self.rentType = 0;//出租方式
        self.rent = 0;//租金
        self.coverUrl = nil;//封面图片
        self.publishDate = nil;//发布日期:"2015-09-12 03:19:55"
        self.publisherName = nil;//发布者名字
        self.publisherType = 0;//发布者类型
        self.buildingArea = 0;//面积
        self.cityId = nil;//所属城市id
        self.districtId = nil;//区id
        self.districtName = nil;//区名
        self.enterTime = nil;//录入日期:"2015-09-11 16:00:00"
        self.firstCanSeeDate = nil;//可看日期:"2015-09-11 16:00:00"
        self.fitmentType = 0;//装修程度
        self.houseType = 0;//房屋类型:一居、两居...
        self.lat = 0;//纬度
        self.lng = 0;//经度
        self.orientations = nil;//朝向
        self.theFloor = nil;//层数
        self.totalFloor = 0;//一共多少层
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
    
    [aCoder encodeObject:self.productId forKey:@"productId"];
    [aCoder encodeObject:self.bizcircleId forKey:@"bizcircleId"];
    [aCoder encodeObject:self.bizcircleName forKey:@"bizcircleName"];
    [aCoder encodeObject:self.resblockId forKey:@"resblockId"];
    [aCoder encodeObject:self.resblockName forKey:@"resblockName"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.hallCount] forKey:@"hallCount"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.toiletCount] forKey:@"toiletCount"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.cookroomCount] forKey:@"cookroomCount"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.roomCount] forKey:@"roomCount"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.rentType] forKey:@"rentType"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.rent] forKey:@"rent"];
    [aCoder encodeObject:self.houseTagList forKey:@"houseTagList"];
    [aCoder encodeObject:self.coverUrl forKey:@"coverUrl"];
    [aCoder encodeObject:self.publishDate forKey:@"publishDate"];
    [aCoder encodeObject:self.publisherName forKey:@"publisherName"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.publisherType] forKey:@"publisherType"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.buildingArea] forKey:@"buildingArea"];
    [aCoder encodeObject:self.cityId forKey:@"cityId"];
    [aCoder encodeObject:self.districtId forKey:@"districtId"];
    [aCoder encodeObject:self.districtName forKey:@"districtName"];
    [aCoder encodeObject:self.enterTime forKey:@"enterTime"];
    [aCoder encodeObject:self.firstCanSeeDate forKey:@"firstCanSeeDate"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.fitmentType] forKey:@"fitmentType"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.houseType] forKey:@"houseType"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.lat] forKey:@"lat"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.lng] forKey:@"lng"];
    [aCoder encodeObject:self.orientations forKey:@"orientations"];
    [aCoder encodeObject:self.theFloor forKey:@"theFloor"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.totalFloor] forKey:@"totalFloor"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [self init])
    {
        // 这里务必和encodeWithCoder方法里面的内容一致，不然会读不到数据
        
        self.productId = [aDecoder decodeObjectForKey:@"productId"];
        self.bizcircleId = [aDecoder decodeObjectForKey:@"bizcircleId"];
        self.bizcircleName = [aDecoder decodeObjectForKey:@"bizcircleName"];
        self.resblockId = [aDecoder decodeObjectForKey:@"resblockId"];
        self.resblockName = [aDecoder decodeObjectForKey:@"resblockName"];
        self.hallCount = [[aDecoder decodeObjectForKey:@"hallCount"] intValue];
        self.toiletCount = [[aDecoder decodeObjectForKey:@"toiletCount"] intValue];
        self.cookroomCount = [[aDecoder decodeObjectForKey:@"cookroomCount"] intValue];
        self.roomCount = [[aDecoder decodeObjectForKey:@"roomCount"] intValue];
        self.rentType = [[aDecoder decodeObjectForKey:@"rentType"] intValue];
        self.rent = [[aDecoder decodeObjectForKey:@"rent"] intValue];
        self.houseTagList = [aDecoder decodeObjectForKey:@"houseTagList"];
        self.coverUrl = [aDecoder decodeObjectForKey:@"coverUrl"];
        self.publishDate = [aDecoder decodeObjectForKey:@"publishDate"];
        self.publisherName = [aDecoder decodeObjectForKey:@"publisherName"];
        self.publisherType = [[aDecoder decodeObjectForKey:@"publisherType"] intValue];
        self.buildingArea = [[aDecoder decodeObjectForKey:@"buildingArea"] doubleValue];
        self.cityId = [aDecoder decodeObjectForKey:@"cityId"];
        self.districtId = [aDecoder decodeObjectForKey:@"districtId"];
        self.districtName = [aDecoder decodeObjectForKey:@"districtName"];
        self.enterTime = [aDecoder decodeObjectForKey:@"enterTime"];
        self.firstCanSeeDate = [aDecoder decodeObjectForKey:@"firstCanSeeDate"];
        self.fitmentType = [[aDecoder decodeObjectForKey:@"fitmentType"] intValue];
        self.houseType = [[aDecoder decodeObjectForKey:@"houseType"] intValue];
        self.lat = [[aDecoder decodeObjectForKey:@"lat"] doubleValue];
        self.lng = [[aDecoder decodeObjectForKey:@"lng"] doubleValue];
        self.orientations = [aDecoder decodeObjectForKey:@"orientations"];
        self.theFloor = [aDecoder decodeObjectForKey:@"theFloor"];
        self.totalFloor = [[aDecoder decodeObjectForKey:@"totalFloor"] intValue];
    }
    return self;
}


@end
