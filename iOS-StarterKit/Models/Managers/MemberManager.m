//
//  Member.m
//  iOS-StarterKit
//
//  Created by Rakesh B on 08/10/14.
//  Copyright (c) 2014 Elevati. All rights reserved.
//

#import "MemberManager.h"

@implementation MemberManager

+ (MemberManager*)defaultManager {
    static MemberManager *_sharedObject = nil;
    static dispatch_once_t onePredicate;
    dispatch_once(&onePredicate,^ {
        _sharedObject = [[MemberManager alloc]init];
    });
    return _sharedObject;
}

#pragma mark ------- Get User From Webservice --------

- (void) getMemberDetails {
    //Get the data from the server
    _tableData = [[NSMutableArray alloc] init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 
    [manager GET:[[URLManager defaultManager] getMemberDetailsURL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _tableData = [[responseObject objectForKey:@"results"] objectForKey:@"members"];
        
        if([_tableData count] == 0)
        {
            NSString *strNoContent = [[NSString alloc] initWithFormat:@"%@",No_More_Content_To_Display];
            _tableData = [[NSMutableArray alloc] initWithObjects:strNoContent, nil];
        }
        
        if ([self.delegate respondsToSelector:@selector(getMemberDetailsSuccessfullyWith:)])
            [self.delegate getMemberDetailsSuccessfullyWith:_tableData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if([self.delegate respondsToSelector:@selector(getMemberDetailsError:)])
            [self.delegate getMemberDetailsError:@""];
    }];
}
@end
