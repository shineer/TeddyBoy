//
//  DDHouseParser.m
//  DingDingCore
//
//  Created by phoenix on 15/9/14.
//  Copyright (c) 2015年 SEU. All rights reserved.
//

#import "DDHouseParser.h"
#import "DDHotHouse.h"

static DDHouseParser * _sharedHouseParser= nil;

@implementation DDHouseParser

+ (DDHouseParser*)getInstance
{
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        
        _sharedHouseParser = [[DDHouseParser alloc] init];
    });
    
    return _sharedHouseParser;
}

- (id)init
{
    self = [super init];
    
    if(self)
    {
        
    }
    return self;
}

- (DDHotHouse*)parseHotHouseObject:(NSDictionary*)dic
{
    // 解析协议的时候server有可能传过来类似于NSNull的对象,因此需要处理一下
    dic = [CommonUtils checkNull:dic];
    
    DDHotHouse* tempObject = [[DDHotHouse alloc] init];
    
    tempObject.productId = [dic objectForKey:@"productId"];//房源id
    tempObject.bizcircleId = [dic objectForKey:@"bizcircleId"];//商圈id
    tempObject.bizcircleName = [dic objectForKey:@"bizcircleName"];//商圈名:"广渠门"
    tempObject.resblockId = [dic objectForKey:@"resblockId"];//小区id:"140256"
    tempObject.resblockName = [dic objectForKey:@"resblockName"];//小区名:"光明西里"
    tempObject.hallCount = [[dic objectForKey:@"hallCount"] intValue];//客厅数量
    tempObject.toiletCount = [[dic objectForKey:@"toiletCount"] intValue];//卫生间数量
    tempObject.cookroomCount = [[dic objectForKey:@"cookroomCount"] intValue];//厨房数量
    tempObject.roomCount = [[dic objectForKey:@"roomCount"] intValue];//卧室数量
    tempObject.rentType = [[dic objectForKey:@"rentType"] intValue];//出租方式
    tempObject.rent = [[dic objectForKey:@"rent"] intValue];//租金
    tempObject.houseTagList = [dic objectForKey:@"houseTagList"];//标签
    
    // 标签
    NSArray* houseTagList = [dic objectForKey:@"houseTagList"];
    houseTagList = [CommonUtils checkNull:houseTagList];
    NSMutableArray* houseTagArray = [[NSMutableArray alloc] init];
    for(id item in houseTagList)
    {
        int i = [item intValue];
        [houseTagArray addObject:[NSNumber numberWithInt:i]];
    }
    tempObject.houseTagList = houseTagArray;
    
    tempObject.coverUrl = [dic objectForKey:@"coverUrl"];//显示图片
    tempObject.publishDate = [dic objectForKey:@"publishDate"];//发布日期:"2015-09-12 03:19:55"
    tempObject.publisherName = [dic objectForKey:@"publisherName"];//发布者名字
    tempObject.publisherType = [[dic objectForKey:@"publisherType"] intValue];//发布者类型
    tempObject.buildingArea = [[dic objectForKey:@"buildingArea"] doubleValue];//面积
    tempObject.cityId = [[dic objectForKey:@"cityId"] stringValue];//所属城市id
    tempObject.districtId = [dic objectForKey:@"districtId"];//区id
    tempObject.districtName = [dic objectForKey:@"districtName"];//区名
    tempObject.enterTime = [dic objectForKey:@"enterTime"];//录入日期:"2015-09-11 16:00:00"
    tempObject.firstCanSeeDate = [dic objectForKey:@"firstCanSeeDate"];//可看日期:"2015-09-11 16:00:00"
    tempObject.fitmentType = [[dic objectForKey:@"fitmentType"] intValue];//装修程度
    tempObject.houseType = [[dic objectForKey:@"houseType"] intValue];//房屋类型:一居、两居...
    tempObject.lat = [[dic objectForKey:@"lat"] doubleValue];//纬度
    tempObject.lng = [[dic objectForKey:@"lng"] doubleValue];//经度
    tempObject.orientations = [dic objectForKey:@"orientations"];//朝向
    tempObject.theFloor = [dic objectForKey:@"theFloor"];//层数
    tempObject.totalFloor = [[dic objectForKey:@"totalFloor"] intValue];//一共多少层
    
    return tempObject;
}

@end
