//
//  NSFetchedResultsController+Oper.h
//  StoryClient
//
//  Created by LiuQi on 14-1-9.
//  Copyright (c) 2014年 LiuQi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface NSFetchedResultsController (Oper)

+(NSFetchedResultsController*)fetchedResultsControllerWithFetch:(NSFetchRequest *)fetchRequest
                                             sectionNameKeyPath:(NSString *)sectionNameKeyPath
                                                      cacheName:(NSString *)name;

- (NSIndexPath*)performFetchPrevious:(NSInteger)fetchCount error:(NSError **) error;

@end
