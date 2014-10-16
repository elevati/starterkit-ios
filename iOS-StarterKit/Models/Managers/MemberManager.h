//
//  Member.h
//  iOS-StarterKit
//
//  Created by Rakesh B on 08/10/14.
//  Copyright (c) 2014 Elevati. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "URLManager.h"

@protocol MemberManagerDelegate <NSObject>
@optional

- (void)getMemberDetailsSuccessfullyWith:(NSArray*)arrMemberDetails;
- (void)getMemberDetailsError:(NSString*)error;

@end


@interface MemberManager : NSObject

@property (nonatomic, weak) id<MemberManagerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *tableData;

+ (MemberManager*) defaultManager;
- (void) getMemberDetails;

@end
