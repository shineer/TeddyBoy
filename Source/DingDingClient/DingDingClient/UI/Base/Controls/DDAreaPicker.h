//
//  DDAreaPicker.h
//  DingDingClient
//
//  Created by phoenix on 15/7/9.
//  Copyright (c) 2015年 SEU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ActionSheetPicker.h"

#define PROVINCE_ID     @"id"
#define PROVINCE_NAME   @"name"
#define CITY_ID         @"id"
#define CITY_NAME       @"name"

#define CITYLIST        @"cityList"

#define HALF_SCREEN_WIDTH 160
#define kPickerTitleSize   16

typedef void (^DDAreaSelected)(int privinceId, int cityId, id origin);

@interface DDAreaPicker : NSObject<ActionSheetCustomPickerDelegate>

@property(nonatomic, assign) int provinceId;      //省份id
@property(nonatomic, assign) int cityId;          //城市id

@property(nonatomic, assign) int provinceIndex;   //省份索引
@property(nonatomic, assign) int cityIndex;       //城市索引

@property(nonatomic, strong) NSArray*  initialSelections;

/*
 *  @brief  初始化数组
 *  @param  privinceId  省份初始值
 *  @param  cityId      城市初始值
 *  @param  origin      操作cell对象
 *  @param  selected    选择后的回调
 *  @return 自定义地点选择pickerView
 */
-(instancetype)initWithProvince:(int)provinceId
                        andCity:(int)cityId
                           done:(DDAreaSelected)selected;

@end

