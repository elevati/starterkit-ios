//
//  Article.m
//  iOS-StarterKit
//
//  Created by Rakesh B on 28/05/14.
//  Copyright (c) 2014 Elevati. All rights reserved.
//

#import "Member.h"

@implementation Member


- (NSMutableDictionary *)toNSDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:self.memberId forKey:@"memberId"];
    [dictionary setValue:self.constituencyName forKey:@"constituencyName"];
    [dictionary setValue:self.memberName forKey:@"memberName"];
    [dictionary setValue:self.memberParty forKey:@"memberParty"];
   
    return dictionary;
}

- (Member *)objectFromNSDictionary:(NSDictionary *)memberDictionary
{
    Member *objMember = [[Member alloc] init];
    objMember.memberId = [memberDictionary objectForKey:@"memberId"];
    objMember.constituencyName = [memberDictionary objectForKey:@"constituencyName"];
    objMember.memberName = [memberDictionary objectForKey:@"memberName"];
    objMember.memberParty = [memberDictionary objectForKey:@"memberParty"];
    
    return objMember;
}

@end
