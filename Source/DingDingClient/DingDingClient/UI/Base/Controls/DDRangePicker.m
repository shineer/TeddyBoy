//
//  DDAgePicker.m
//  DingDingClient
//
//  Created by phoenix on 15/7/13.
//  Copyright (c) 2015年 dingding. All rights reserved.
//

#import "DDRangePicker.h"

@implementation DDRangePicker
{
    NSMutableArray *_smallList;
    NSMutableArray *_bigList;
    
    DDRangeSelected _selected;
}

-(instancetype)initWithRangeFrom:(int)min to:(int)max unit:(NSString*)unit done:(DDRangeSelected)selected
{
    if (self = [super init])
    {
        NSAssert(min < max, @"输入区间不正确，min应该比max小");
        _minNumber = min;
        _maxNumber = max;
        
        _smallIndex = 0;
        _bigIndex = 0;
        
        _unit = unit;
        _selected = selected;
        
        _smallList = [[NSMutableArray alloc] initWithCapacity:max - min];
        _bigList = [[NSMutableArray alloc] initWithCapacity:max - min];
        for (int i = _minNumber; i <= _maxNumber; i++) {
            [_smallList addObject:[NSString stringWithFormat:@"%d%@",i,_unit]];
            [_bigList addObject:[NSString stringWithFormat:@"%d%@",i,_unit]];
        }
    }
    return self;
}

-(void)setSmallIndex:(int)smallIndex
{
    _smallIndex = smallIndex;
    [_bigList removeAllObjects];
    for (int i = _minNumber + _smallIndex; i <= _maxNumber; i++) {
        [_bigList addObject:[NSString stringWithFormat:@"%d%@",i,_unit]];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // Returns
    switch (component) {
        case 0: return _smallList.count;
        case 1:return _bigList.count;
        default:break;
    }
    return 0;
}

//选择确认后的处理
- (void)actionSheetPickerDidSucceed:(AbstractActionSheetPicker *)actionSheetPicker origin:(id)origin
{
    _selected(_smallIndex + _minNumber,_smallIndex + _minNumber + _bigIndex, origin);
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return HALF_SCREEN_WIDTH;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //每列展示什么
    switch (component) {
        case 0: return _smallList[row];
        case 1: return _bigList[row];
        default:break;
    }
    return nil;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    if (0 == component) {
        CGFloat width = HALF_SCREEN_WIDTH;
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, width, 30)];
        
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.text = [_smallList objectAtIndex:row];
        
        myView.font = [UIFont systemFontOfSize:kPickerTitleSize];         //用label来设置字体大小
        
        myView.backgroundColor = [UIColor clearColor];
        
    }
    else if(1 == component)
    {
        CGFloat width = 160;
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, width, 30)];
        
        myView.textAlignment = NSTextAlignmentCenter;
        
        myView.text = [_bigList objectAtIndex:row];
        
        myView.font = [UIFont systemFontOfSize:kPickerTitleSize];         //用label来设置字体大小
        
        myView.backgroundColor = [UIColor clearColor];
        
    }
    
    return myView;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (0 == component) {
        //选择省
        self.smallIndex = (int)row;
        self.bigIndex = 0;
        //更新第二个轮子
        [pickerView reloadComponent:1];
        //更新第2个轮子的时候，现在默认就是第一个吧
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
    }else if (1 == component)
    {
        //选择市
        self.bigIndex = (int)row;
    }
}




@end
