//
//  URLManager.m
//  iOS-StarterKit
//
//  Created by Rakesh B on 21/05/14.
//  Copyright (c) 2014 Elevati. All rights reserved.
//

#import "URLManager.h"

@implementation URLManager

+ (URLManager*) defaultManager {
    static URLManager* _sharedObject = nil;
    static dispatch_once_t onePredicate;
    dispatch_once(&onePredicate,^ {
        _sharedObject = [[URLManager alloc]init];
    });
    return _sharedObject;
}

-(NSString*) getBaseURL
{
    return BASE_API_URL;
}

-(NSString*) getMemberDetailsURL
{
    return [NSString stringWithFormat:@"http://findyourmp.parliament.uk/api/search?q=bob&f=js"];
}

-(NSString*) getOAuth2APIURL
{
    return [NSString stringWithFormat:@"%@services/public/index.php/oauth2/token",[self getBaseURL]];
}

@end
