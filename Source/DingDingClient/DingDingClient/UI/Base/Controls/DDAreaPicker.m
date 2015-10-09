//
//  DDAreaPicker.m
//  DingDingClient
//
//  Created by phoenix on 15/7/9.
//  Copyright (c) 2015年 SEU. All rights reserved.
//

#import "DDAreaPicker.h"

@implementation DDAreaPicker
{
    NSArray* _area;                         //省市所有信息
    NSMutableArray* _cityList;              //当前省份下属城市
    
    NSMutableArray* _provinceNames;         //省份名称列表
    NSMutableArray* _cityNames;             //选中省份中城市名称列表
    
    DDAreaSelected _selected;
}

-(instancetype)initWithProvince:(int)provinceId andCity:(int)cityId done:(DDAreaSelected)selected
{
    if (self = [super init])
    {
        _area = APP_UTILITY.areaArray;
        
        _selected = selected;
        _provinceId = provinceId;
        _provinceIndex = _provinceId - 1; //因为省份是从0开始的  假如这里有“不限”需要另外处理
        _cityId = cityId;
        
        _provinceNames = [[NSMutableArray alloc] initWithCapacity:34];
        _cityNames = [[NSMutableArray alloc] initWithCapacity:20];
        
        NSAssert(_area, @"数组不能为空！");
        for (NSDictionary* item in _area)
        {
            [_provinceNames addObject:[item objectForKey:PROVINCE_NAME]];
        }
        
        NSDictionary* provinceInfo = [[NSDictionary alloc] initWithDictionary:_area[_provinceIndex]];
        _cityList = [provinceInfo objectForKey:CITYLIST];
        for (NSDictionary* item in _cityList)
        {
            [_cityNames addObject:[item objectForKey:CITY_NAME]];
        }
        _cityIndex = [self city:_cityList withCityId:_cityId];
        
        self.initialSelections = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:_provinceIndex],[NSNumber numberWithInt:_cityIndex], nil];
        
    }
    return self;
}

-(void)setProvinceIndex:(int)provinceIndex
{
    _provinceIndex = provinceIndex;
    _provinceId = _provinceIndex + 1;
    NSDictionary* provinceInfo = _area[_provinceIndex];
    _cityList = [provinceInfo objectForKey:CITYLIST];
    [_cityNames removeAllObjects];
    for (NSDictionary* item in _cityList)
    {
        [_cityNames addObject:[item objectForKey:CITY_NAME]];
    }
}

-(void)setCityIndex:(int)cityIndex
{
    _cityIndex = cityIndex;
    _cityId = [[_cityList[_cityIndex] objectForKey:CITY_ID] intValue];
}


-(int)city:(NSArray*)cityList withCityId:(int)cityId
{
    int index = 0;
    for (; index < cityList.count; index++)
    {
        if ([[cityList[index] objectForKey:CITY_ID] intValue] == cityId)
        {
            break;
        }
    }
    return index;
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // Returns
    switch (component)
    {
        case 0: return _area.count;
        case 1:return _cityList.count;
        default:break;
    }
    return 0;
}

//选择确认后的处理
- (void)actionSheetPickerDidSucceed:(AbstractActionSheetPicker *)actionSheetPicker origin:(id)origin
{
    _selected(_provinceId, _cityId, origin);
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return HALF_SCREEN_WIDTH;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //每列展示什么
    switch (component)
    {
        case 0: return _provinceNames[row];
        case 1: return _cityNames[row];
        default:break;
    }
    return nil;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    if (0 == component)
    {
        CGFloat width = HALF_SCREEN_WIDTH;
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, width, 30)];
        
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.text = [_provinceNames objectAtIndex:row];
        
        myView.font = [UIFont systemFontOfSize:kPickerTitleSize];         //用label来设置字体大小
        
        myView.backgroundColor = [UIColor clearColor];
        
    }
    else if(1 == component)
    {
        CGFloat width = 160;
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, width, 30)];
        
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.text = [_cityNames objectAtIndex:row];
        
        myView.font = [UIFont systemFontOfSize:kPickerTitleSize];         //用label来设置字体大小
        
        myView.backgroundColor = [UIColor clearColor];
        
    }
    
    return myView;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (0 == component) {
        //选择省
        self.provinceIndex = row;
        self.cityIndex = 0;
        //更新第二个轮子
        [pickerView reloadComponent:1];
        //更新第2个轮子的时候，现在默认就是第一个吧
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
    }else if (1 == component)
    {
        //选择市
        self.cityIndex = row;
    }
}

@end
