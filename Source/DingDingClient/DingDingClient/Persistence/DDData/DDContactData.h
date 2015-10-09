//
//  DDContactData.h
//  DingDingClient
//
//  Created by phoenix on 15/9/16.
//  Copyright (c) 2015年 SEU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DDContactData : NSManagedObject

@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * portraitUrl;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic) int16_t age;
@property (nonatomic) int16_t gender;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic) int16_t industry;
@property (nonatomic) int16_t cityId;

@end
