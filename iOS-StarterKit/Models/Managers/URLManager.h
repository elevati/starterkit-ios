//
//  URLManager.h
//  iOS-StarterKit
//
//  Created by Rakesh B on 21/05/14.
//  Copyright (c) 2014 Elevati. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLManager : NSObject

+(URLManager*)defaultManager;

-(NSString*) getBaseURL;
-(NSString*) getOAuth2APIURL;
-(NSString*) getMemberDetailsURL;

@end
