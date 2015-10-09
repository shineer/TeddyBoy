//
//  DDCoreDataMgr.h
//  DingDingClient
//
//  Created by phoenix on 14-10-10.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface DDCoreDataMgr : NSObject

@property (nonatomic, strong) NSString *modelFileName;

@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;

+ (DDCoreDataMgr *)getInstance;

- (void)performBlock:(void (^)(NSManagedObjectContext *moc))block;
- (void)performBlock:(void (^)(NSManagedObjectContext *moc))block onComplete:(void(^)())complete;
- (BOOL)saveContext:(NSManagedObjectContext *)savedMoc ToPersistentStore:(NSError **)error;
- (void)safelySaveContextMOC;
- (void)unsafelySaveContextMOC;
- (BOOL)saveContextMOC;
- (void)cleanUp;

@end
