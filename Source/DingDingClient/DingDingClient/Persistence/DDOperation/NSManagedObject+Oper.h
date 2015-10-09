//
//  NSManagedObject.h
//  StoryClient
//
//  Created by LiuQi on 13-12-27.
//  Copyright (c) 2013年 LiuQi. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Oper)

+ (NSManagedObject *)fetchWithPredict:(NSPredicate*)pre withMOC:(NSManagedObjectContext*)moc entityName:(NSString*)entityName;
+ (id)entityWithMOC:(NSManagedObjectContext*)moc entityName:(NSString*)entityName;
+ (void)deleteEntity:(NSManagedObject*)entity withMOC:(NSManagedObjectContext*)moc;

@end
