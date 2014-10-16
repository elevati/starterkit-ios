//
//  OAuthManager.m
//  iOS-StarterKit
//
//  Created by Rakesh B on 02/09/14.
//  Copyright (c) 2014 Elevati. All rights reserved.
//

#import "OAuthManager.h"
#import "URLManager.h"

@implementation OAuthManager

+ (OAuthManager*)defaultManager
{
    static OAuthManager *_sharedObject = nil;
    static dispatch_once_t onePredicate;
    dispatch_once(&onePredicate,^ {
        _sharedObject = [[OAuthManager alloc]init];
    });
    
    return _sharedObject;
}

- (void) getOAuthSecretToken
{
    _tableData = [[NSMutableArray alloc] init];
    NSDictionary *parameters = @{@"grant_type":@"client_credentials"};
    
    NSURL *url = [NSURL URLWithString:[[URLManager defaultManager] getOAuth2APIURL]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
   
    // For auhorization token
    //
    // Step 1: Form a key
    //    <Consumer key>:<Consumer secret>
    //
    // Step 2: Encode string to base 64 string
    //    BASE64KEY
    
    [request setValue:@" Basic BASE64KEY" forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    
    // if we have params pull out the key/value and add to header
    if(parameters != nil)
    {
        NSMutableString *body = [[NSMutableString alloc] init];
        for (NSString *key in parameters.allKeys)
        {
            NSString *value = [parameters objectForKey:key];
            [body appendFormat:@"%@=%@&", key, value];
        }
        
        NSLog(@"request body : %@",body);
        [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // submit the request
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSError *error;
         if(data != nil && ![data isEqual:[NSNull null]] && data.length > 0 )
         {
             NSString *strResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"%@",strResponse);
             //{"access_token":"72b2c404c3165ba9b372e237810041cf048a0001","expires_in":3600,"token_type":"Bearer","scope":null}
            
             NSDictionary *dicResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
             NSLog(@"json parse error: %@",[error description]);
            
             NSString *strAccessToken = [dicResponse objectForKey:@"access_token"];
             if([strAccessToken length] > 0)
             {
                 if ([self.delegate respondsToSelector:@selector(getTokenDetailsSuccessfullyWith:)])
                     [self.delegate getTokenDetailsSuccessfullyWith:strAccessToken];
             }
             else
             {
                 if([self.delegate respondsToSelector:@selector(getTokenDetailsError:)])
                     [self.delegate getTokenDetailsError:[dicResponse valueForKey:@"error"]];
             }
         }
         else
         {
             NSLog(@"Error: %@", error);
             if([self.delegate respondsToSelector:@selector(getTokenDetailsError:)])
                 [self.delegate getTokenDetailsError:[error description]];
         }
     }];
}

@end
