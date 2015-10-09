//
//  DDContactData+Oper.h
//  DingDingClient
//
//  Created by phoenix on 14-10-20.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import "DDContactData.h"

static NSString * const kDDContact = @"Contact";

@interface DDContactData (Oper)

+ (DDContactData*)newContact:(NSString*)uid;
+ (DDContactData*)contactByUid:(NSString*)uid;

+ (void)deleteContactById:(NSString*)uid;

+ (NSArray*)getAllContact;
+ (NSFetchRequest*)requestForAllContact;
+ (NSInteger)requestForContactOfCount;
+ (void)saveAllContact;

- (void)saveContact;
- (NSString*)displayName;
- (UIImage*)displayPortrait;
- (BOOL)isNeedDownloadPortrait;

@end
