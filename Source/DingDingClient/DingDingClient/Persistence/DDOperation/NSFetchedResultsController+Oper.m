//
//  NSFetchedResultsController+Oper.m
//  StoryClient
//
//  Created by LiuQi on 14-1-9.
//  Copyright (c) 2014年 LiuQi. All rights reserved.
//

#import "NSFetchedResultsController+Oper.h"
#import "DDCoreDataMgr.h"

@implementation NSFetchedResultsController (Oper)

+ (NSFetchedResultsController*)fetchedResultsControllerWithFetch:(NSFetchRequest *)fetchRequest
                                             sectionNameKeyPath:(NSString *)sectionNameKeyPath
                                                      cacheName:(NSString *)name
{
    NSFetchedResultsController* fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[DDCoreDataMgr getInstance].managedObjectContext sectionNameKeyPath:sectionNameKeyPath cacheName:name];
    
    return fetchedResultsController;
}

- (NSIndexPath*)performFetchPrevious:(NSInteger)fetchCount error:(NSError**) error
{
    self.fetchRequest.fetchLimit = 0;
    NSInteger fetchOffset = self.fetchRequest.fetchOffset;
    self.fetchRequest.fetchOffset = 0;
    NSInteger count  = [self.managedObjectContext countForFetchRequest:self.fetchRequest error:nil];
    fetchOffset = count - fetchCount;
    fetchOffset = fetchOffset < 0 ? 0: fetchOffset;
    self.fetchRequest.fetchOffset = fetchOffset;
    NSManagedObject * managedObject = self.fetchedObjects.count > 0 ? [self.fetchedObjects objectAtIndex:0] : nil;
    [self performFetch:error];
    NSIndexPath * indexPath = [self indexPathForObject:managedObject];
    return indexPath;
}

@end
