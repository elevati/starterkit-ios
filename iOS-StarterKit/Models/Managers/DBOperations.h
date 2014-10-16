//
//  DBOperations.h
//  iOS-StarterKit
//
//  Created by Rakesh B on 19/05/14.
//  Copyright (c) 2014 Elevati. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "Global.h"


@interface DBOperations : NSObject
{
    NSString *path;
    BOOL fileExists;
}

@property (nonatomic, retain) FMDatabase *database;

- (DBOperations*) init;

- (BOOL) addArticle:(NSString*)articleServerId withDetails:(NSString *)strArticleDetails created:(NSString*)createdTimestamp  modified:(NSString*)modifiedTimestamp categoryIds:(NSString*)strCategoryIds postType:(NSString *)postType;

- (BOOL)updateArticle:(NSString*)articleServerId withDetails:(NSString *)strArticleDetails created:(NSString*)createdTimestamp  modified:(NSString*)modifiedTimestamp categoryIds:(NSString*)strCategoryIds postType:(NSString *)postType;

- (BOOL)updateArticleWithoutDetails:(NSString*)articleServerId created:(NSString*)createdTimestamp  modified:(NSString*)modifiedTimestamp categoryIds:(NSString*)strCategoryIds  postType:(NSString *)postType;

- (BOOL) checkArticleExists:(NSString*) articleId created:(NSString*)serverCreatedTimestamp modified:(NSString*)serverModifiedTimestamp postType:(NSString *)postType;

- (BOOL)checkPostExistsLocally:(NSString *)postId;

- (BOOL)deleteCacheArticleFromLongDays;
@end