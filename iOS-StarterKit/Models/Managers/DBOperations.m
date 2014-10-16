//
//  DBOperations.m
//  iOS-StarterKit
//
//  Created by Rakesh B on 19/05/14.
//  Copyright (c) 2014 Elevati. All rights reserved.
//


#import "DBOperations.h"

@implementation DBOperations
@synthesize database;

- (DBOperations*) init
{
    path = [[Global defaultGlobal] getDatabaseStoragePath];
    fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    
    if(fileExists)//Database exists.
    {
        database = [FMDatabase databaseWithPath:path];
    }
    [database open];
    return self;
}

-(BOOL) addArticle:(NSString*)articleServerId withDetails:(NSString *)strArticleDetails created:(NSString*)createdTimestamp  modified:(NSString*)modifiedTimestamp categoryIds:(NSString*)strCategoryIds postType:(NSString *)postType
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strCurrentTime = [dateFormatter stringFromDate:[NSDate date]];
    
   //refresh_timestamp
    BOOL result = [database executeUpdate:@"insert into Articles (article_details,article_is_active, article_order, article_created_timestamp, article_modified_timestamp, article_server_id,categories_ids,postType,isUpdated,refresh_timestamp) values(?,?,?,?,?,?,?,?,?,?)",strArticleDetails,@"1",@"1",createdTimestamp,modifiedTimestamp,articleServerId,strCategoryIds,postType,@"0",strCurrentTime];
    
    return result;
}

-(BOOL)updateArticle:(NSString*)articleServerId withDetails:(NSString *)strArticleDetails created:(NSString*)createdTimestamp  modified:(NSString*)modifiedTimestamp categoryIds:(NSString*)strCategoryIds  postType:(NSString *)postType
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strCurrentTime = [dateFormatter stringFromDate:[NSDate date]];
    
    BOOL result = [database executeUpdate:@"update Articles set article_details = ?, article_is_active = ?, article_order = ?, article_created_timestamp = ?, article_modified_timestamp = ?, categories_ids = ?, isUpdated = ?,refresh_timestamp = ?  where article_server_id = ? and postType = ?",strArticleDetails,@"1",@"1",createdTimestamp,modifiedTimestamp,strCategoryIds,@"1",strCurrentTime,articleServerId,postType];
   
    return result;
}

-(BOOL)updateArticleWithoutDetails:(NSString*)articleServerId created:(NSString*)createdTimestamp  modified:(NSString*)modifiedTimestamp categoryIds:(NSString*)strCategoryIds  postType:(NSString *)postType
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strCurrentTime = [dateFormatter stringFromDate:[NSDate date]];
    
    BOOL result = [database executeUpdate:@"update Articles set article_is_active = ?, article_order = ?, article_created_timestamp = ?, article_modified_timestamp = ?, categories_ids = ?, isUpdated = ?,refresh_timestamp = ?  where article_server_id = ? and postType = ?",@"1",@"1",createdTimestamp,modifiedTimestamp,strCategoryIds,@"1",strCurrentTime,articleServerId,postType];
    
    return result;
}

- (BOOL) checkArticleExists:(NSString*) articleId created:(NSString*)serverCreatedTimestamp modified:(NSString*)serverModifiedTimestamp  postType:(NSString *)postType
{
    //Check whether Recipe name already exist
    NSString *query = [NSString stringWithFormat:@"select article_server_id,article_created_timestamp,article_modified_timestamp,isUpdated from Articles where article_server_id = %@ and postType = '%@'",articleId,postType];
    FMResultSet *result = [database executeQuery:query];
    
    while ([result next])
    {
        return YES;
    }
    
    return NO;
}

-(BOOL)checkPostExistsLocally:(NSString *)postId
{
    //Check whether Recipe name already exist
    NSString *query = [NSString stringWithFormat:@"select article_server_id from Articles where article_server_id = %@",postId];
    FMResultSet *result = [database executeQuery:query];
    while ([result next])
         return YES;
    
    return NO;
}

-(BOOL)deleteCacheArticleFromLongDays
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strCurrentTime = [dateFormatter stringFromDate:[NSDate date]];
    
    //For testing purpose we have change it to 0 from 15
    BOOL result = [database executeUpdate:@"DELETE FROM Articles WHERE id in (SELECT id FROM Articles WHERE cast(strftime('%s',?) - (strftime('%s',refresh_timestamp)) AS real)/60/60/24 > 15)",strCurrentTime]; // 15
    
    return result;
}

@end