//
//  DDHotHouse.h
//  DingDingCore
//
//  Created by phoenix on 15/9/14.
//  Copyright (c) 2015年 SEU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Base/DDBaseObject.h"

@interface DDHotHouse : DDBaseObject
{
    
}

@property (nonatomic, strong) NSString* productId;//房源id
@property (nonatomic, strong) NSString* bizcircleId;//商圈id
@property (nonatomic, strong) NSString* bizcircleName;//商圈名:"广渠门"
@property (nonatomic, strong) NSString* resblockId;//小区id:"140256"
@property (nonatomic, strong) NSString* resblockName;//小区名:"光明西里"
@property (nonatomic, assign) int hallCount;//客厅数量
@property (nonatomic, assign) int toiletCount;//卫生间数量
@property (nonatomic, assign) int cookroomCount;//厨房数量
@property (nonatomic, assign) int roomCount;//卧室数量
@property (nonatomic, assign) int rentType;//出租方式
@property (nonatomic, assign) int rent;//租金
@property (nonatomic, strong) NSArray* houseTagList;//标签
@property (nonatomic, strong) NSString* coverUrl;//封面图片
@property (nonatomic, strong) NSString* publishDate;//发布日期:"2015-09-12 03:19:55"
@property (nonatomic, strong) NSString* publisherName;//发布者名字
@property (nonatomic, assign) int publisherType;//发布者类型
@property (nonatomic, assign) double buildingArea;//面积
@property (nonatomic, strong) NSString* cityId;//所属城市id
@property (nonatomic, strong) NSString* districtId;//区id
@property (nonatomic, strong) NSString* districtName;//区名
@property (nonatomic, strong) NSString* enterTime;//录入日期:"2015-09-11 16:00:00"
@property (nonatomic, strong) NSString* firstCanSeeDate;//可看日期:"2015-09-11 16:00:00"
@property (nonatomic, assign) int fitmentType;//装修程度
@property (nonatomic, assign) int houseType;//房屋类型:一居、两居...
@property (nonatomic, assign) double lat;//纬度
@property (nonatomic, assign) double lng;//经度
@property (nonatomic, strong) NSString* orientations;//朝向
@property (nonatomic, strong) NSString* theFloor;//层数
@property (nonatomic, assign) int totalFloor;//一共多少层


@end
