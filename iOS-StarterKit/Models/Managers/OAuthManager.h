//
//  OAuthManager.h
//  iOS-StarterKit
//
//  Created by Rakesh B on 02/09/14.
//  Copyright (c) 2014 Elevati. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@protocol OAuthManagerDelegate <NSObject>
@optional

- (void) getTokenDetailsSuccessfullyWith:(NSString*)strOAuthToken;
- (void) getTokenDetailsError:(NSString*)error;

@end

@interface OAuthManager : NSObject

@property (nonatomic, weak) id<OAuthManagerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *tableData;

+ (OAuthManager*)defaultManager;
- (void) getOAuthSecretToken;

@end
