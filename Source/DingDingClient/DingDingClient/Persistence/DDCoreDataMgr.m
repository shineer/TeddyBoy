//
//  DDCoreDataMgr.m
//  DingDingClient
//
//  Created by phoenix on 14-10-10.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "DDCoreDataMgr.h"

@interface DDCoreDataMgr()
{
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
    NSManagedObjectModel *_managedObjectModel;
    NSManagedObjectContext *_managedObjectContext;
    NSPersistentStore *_PersistentStore;
}
@end

@implementation DDCoreDataMgr

static DDCoreDataMgr *coredataManager = nil;

+ (DDCoreDataMgr *)getInstance
{
    if (!coredataManager)
    {
        coredataManager = [[DDCoreDataMgr alloc] init];
        coredataManager.modelFileName = @"DDDataModel";
    }
    
    [coredataManager initManagedObjectContext];
    
    return coredataManager;
}

+ (void)destroy
{
    if(coredataManager)
    {
        [coredataManager cleanUp];
    }
    coredataManager = nil;
}

- (void)cleanUp
{
    _managedObjectContext = nil;
    _managedObjectModel = nil;
    _persistentStoreCoordinator = nil;
    _PersistentStore = nil;
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (void)initManagedObjectContext
{
    if (!self.managedObjectModel)
        return;
    
    if (!self.persistentStoreCoordinator)
        return;
    
    if (!_managedObjectContext)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
        _managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
    }
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext)
    {
        [self initManagedObjectContext];
    }
    return _managedObjectContext;
}


// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (self.modelFileName.length == 0)
        return nil;
    
    if (_managedObjectModel != nil)
        return _managedObjectModel;
    
    NSRange rag = [self.modelFileName rangeOfString:@".momd"];
    NSString *modFileName = self.modelFileName;
    if (rag.location != NSNotFound)
        modFileName = [self.modelFileName substringToIndex:rag.location];
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:modFileName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (!self.managedObjectModel)
        return nil;
    
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    NSString *databasePath = [APP_UTILITY userDatabasePath];
    if (databasePath)
    {
        NSURL *storeURL = [NSURL fileURLWithPath:databasePath];
        DD_LOG(@"Store URL %@", storeURL);
        NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        _PersistentStore = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        if (!_PersistentStore)
        {
            DD_LOG(@"database unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    else
    {
        DD_LOG(@"database fatal error!!!!");
    }
    return _persistentStoreCoordinator;
}


- (void)performBlock:(void (^)(NSManagedObjectContext *moc))block{
    if (!block)
        return;
    
    NSManagedObjectContext *moc = self.managedObjectContext;
    
    [moc performBlock:^{
        block(moc);
    }];
}

- (void)performBlock:(void (^)(NSManagedObjectContext *moc))block onComplete:(void(^)())complete{
    if (!block)
        return;
    
    NSManagedObjectContext *moc = self.managedObjectContext;
    
    [moc performBlock:^{
        block(moc);
        if (complete)
            dispatch_async(dispatch_get_main_queue(), complete);
    }];
}

- (void)safelySaveContextMOC
{
    [self.managedObjectContext performBlockAndWait:^{
        [[DDCoreDataMgr getInstance] saveContextMOC];
    }];
}

- (void)unsafelySaveContextMOC
{
    [self.managedObjectContext performBlock:^{
        [[DDCoreDataMgr getInstance] saveContextMOC];
    }];
}

- (BOOL)saveContextMOC
{
    return [self saveContext:[DDCoreDataMgr getInstance].managedObjectContext ToPersistentStore:nil];
}

- (BOOL)saveContext:(NSManagedObjectContext *)savedMoc ToPersistentStore:(NSError **)error
{
    __block NSError *localError = nil;
    NSManagedObjectContext *contextToSave = savedMoc;
    while (contextToSave) {
        __block BOOL success;
        [contextToSave obtainPermanentIDsForObjects:[[contextToSave insertedObjects] allObjects] error:&localError];
        if (localError) {
            if (error) *error = localError;
            return NO;
        }
		
        if ([contextToSave hasChanges]) {
            success = [contextToSave save:&localError];
            if (! success && localError == nil) DD_LOG(@"Saving of managed object context failed");
        }else
            success = YES;
        
        if (! success) {
            if (error) *error = localError;
            return NO;
        }
        
        if (! contextToSave.parentContext && contextToSave.persistentStoreCoordinator == nil) {
            DD_LOG(@"Reached the end of the chain of nested managed object contexts without encountering a persistent store coordinator. Objects are not fully persisted.");
            return NO;
        }
        contextToSave = contextToSave.parentContext;
    }
    return YES;
}
@end
