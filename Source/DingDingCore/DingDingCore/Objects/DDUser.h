//
//  DDUser.h
//  DingDingClient
//
//  Created by phoenix on 14-11-3.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Base/DDBaseObject.h"

@interface DDUser : DDBaseObject<NSCoding>
{
    NSString* _userId;                      //用户id
    NSString* _userIconUrl;                 //用户头像
    NSString* _nickName;                    //昵称
    int _age;                               //用户年龄
    int _sex;                               //用户性别
    NSArray* _userGEO;                      //用户坐标（double数组）
    NSString* _recommend;                   //用户推荐理由
    NSTimeInterval _activeTime;             //用户的最后活跃时间
    NSArray* _userTagViewList;              //["userTagView":用户标签展示对象 ...]
    NSString* _nation;                      //民族
    int  _nationId;                         //民族id
    NSTimeInterval _birthday;               //生日
    NSString* _figure;                      //体型
    int _figureId;                          //体型Id
    NSString* _industry;                    //行业
    int _industryId;                        //行业id
    NSString* _income;                      //收入
    int _incomeId;                          //收入id
    NSString* _education;                   //学历
    int _educationId;                       //学历id
    NSString* _purpose;                     //交友目的
    int _purposeId;                         //交友目的id
    NSString* _mobileType;                  //手机型号
    NSString* _loginTime;                   //登录时间
    NSString* _constellation;               //星座
    NSArray* _photoList;                    //["imageView":{图片展示对象},"imageView":{图片展示对象},...]
    int  _isScore;                          //是否评过分 0:是 1:不是
    int  _isCollect;                        //是否收藏 0:是 1:不是
    int  _isSayHi;                          //是否打过招呼 0:是 1:不是
    int  _level;                            //用户级别
    int  _height;                           //身高
    int  _weight;                           //体重
    NSString* _sign;                        //个性签名
}

@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NSString* userIconUrl;
@property (nonatomic, strong) NSString* nickName;
@property (nonatomic, assign) int age;
@property (nonatomic, assign) int sex;
@property (nonatomic, strong) NSArray* userGEO;
@property (nonatomic, strong) NSString* recommend;
@property (nonatomic, assign) NSTimeInterval activeTime;
@property (nonatomic, strong) NSArray* userTagViewList;
@property (nonatomic, strong) NSString* nation;
@property (nonatomic, assign) int nationId;
@property (nonatomic, assign) NSTimeInterval birthday;
@property (nonatomic, strong) NSString* figure;
@property (nonatomic, assign) int figureId;
@property (nonatomic, strong) NSString* industry;
@property (nonatomic, assign) int industryId;
@property (nonatomic, strong) NSString* income;
@property (nonatomic, assign) int incomeId;
@property (nonatomic, strong) NSString* education;
@property (nonatomic, assign) int educationId;
@property (nonatomic, strong) NSString* purpose;
@property (nonatomic, assign) int purposeId;
@property (nonatomic, strong) NSString* mobileType;
@property (nonatomic, strong) NSString* loginTime;
@property (nonatomic, strong) NSString* constellation;
@property (nonatomic, strong) NSArray* photoList;
@property (nonatomic, assign) int isScore;
@property (nonatomic, assign) int isCollect;
@property (nonatomic, assign) int isSayHi;
@property (nonatomic, assign) int level;
@property (nonatomic, assign) int height;
@property (nonatomic, assign) int weight;
@property (nonatomic, strong) NSString* sign;

@end
