//
//  DDContactData+Oper.m
//  DingDingClient
//
//  Created by phoenix on 14-10-20.
//  Copyright (c) 2014年 SEU. All rights reserved.
//

#import "DDContactData+Oper.h"
#import "DDCoreDataMgr.h"
#import "NSManagedObject+Oper.h"

@implementation DDContactData (Oper)

+(DDContactData*)newContact:(NSString*)uid
{
    DDContactData* contact = [self contactByUid:uid];
    if(nil == contact)
    {
        contact = [self entityWithMOC:[[DDCoreDataMgr getInstance] managedObjectContext] entityName:kDDContact];
        contact.uid = uid;
    }
    //DD_LOG(@"newContact contact uid %@", uid);
    return contact;
}

+(DDContactData*)contactByUid:(NSString*)uid
{
    DDContactData* contact = (DDContactData *)[self fetchWithPredict:[NSPredicate predicateWithFormat:@"uid==%@", uid] withMOC:[[DDCoreDataMgr getInstance] managedObjectContext] entityName:kDDContact];
    
    return contact;
}

+(void)deleteContactById:(NSString*)uid
{
    DDContactData* contact = [self contactByUid:uid];
    if(contact)
    {
        [self deleteEntity:contact withMOC:[DDCoreDataMgr getInstance].managedObjectContext];
        [contact saveContact];
    }
}

+(NSArray*)getAllContact
{
    NSArray* array = [[[DDCoreDataMgr getInstance] managedObjectContext] executeFetchRequest:[self requestForAllContact] error:nil];
    return array;
}

+(NSFetchRequest*)requestForAllContact
{
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = [NSEntityDescription entityForName:kDDContact
                                      inManagedObjectContext:[DDCoreDataMgr getInstance].managedObjectContext];
    
    NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@"nickName" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    fetchRequest.sortDescriptors = @[sort];
    
    return fetchRequest;
}

+(NSInteger)requestForContactOfCount
{
    NSFetchRequest* fetchRequest = [self requestForAllContact];
    NSInteger count  = [[DDCoreDataMgr getInstance].managedObjectContext countForFetchRequest:fetchRequest error:nil];
    return count;
}

+(void)saveAllContact
{
    [[DDCoreDataMgr getInstance] saveContextMOC];
}

-(void)saveContact
{
    [self.managedObjectContext performBlockAndWait:^{
        
        [[DDCoreDataMgr getInstance] saveContextMOC];
    }];
}

-(NSString*)displayName
{
    NSString* displayName = nil;
    
    if(self.nickName && self.nickName.length)
    {
        displayName = self.nickName;
    }
    else
    {
        displayName = [NSString stringWithFormat:@"%@%@", APP_NAME, @"用户"];
    }
    
    return displayName;
}

-(UIImage*)displayPortrait
{
    UIImage* displayImage = nil;
    
    NSString* url = self.portraitUrl;
    if(url)
    {
        displayImage = [[DDHttpTransferService getInstance] imageAtUrl:url];
    }
    
    if(displayImage == nil)
    {
        displayImage = [UIImage imageNamed:@"common_default_portrait"];
    }
    
    return displayImage;
}

- (BOOL)isNeedDownloadPortrait
{
    BOOL result = NO;
    UIImage* portraitImage = nil;
    
    NSString* url = self.portraitUrl;
    portraitImage = [[DDHttpTransferService getInstance] imageAtUrl:url];
    
    if(portraitImage == nil)
    {
        result = YES;
    }
    
    return result;
}

@end
