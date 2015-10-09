//
//  NSManagedObject.m
//  StoryClient
//
//  Created by LiuQi on 13-12-27.
//  Copyright (c) 2013年 LiuQi. All rights reserved.
//

#import "NSManagedObject+Oper.h"

@implementation NSManagedObject (Oper)

+ (NSManagedObject*)fetchWithPredict:(NSPredicate *)pre withMOC:(NSManagedObjectContext *)moc entityName:(NSString*)entityName;
{
    if (!moc)
        return nil;
    
    if (pre && entityName)
    {
        NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:entityName];
        req.predicate = pre;
        NSArray *arr = [moc executeFetchRequest:req error:nil];
        if (arr.count > 0)
            return [arr lastObject];
        else
            return nil;
    }
    return nil;
}

+ (id)entityWithMOC:(NSManagedObjectContext*)moc entityName:(NSString*)entityName
{
    if (!moc || !entityName)
        return nil;
    
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:moc];
}

+ (void)deleteEntity:(NSManagedObject*)entity withMOC:(NSManagedObjectContext*)moc
{
    NSManagedObjectContext *objectMOC = entity.managedObjectContext;
    [objectMOC performBlockAndWait:^{
        [objectMOC deleteObject:entity];
    }];
}

@end
