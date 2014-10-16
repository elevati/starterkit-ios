//
//  Article.h
//  iOS-StarterKit
//
//  Created by Rakesh B on 28/05/14.
//  Copyright (c) 2014 Elevati. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Member : NSObject

@property(nonatomic,strong) NSString *memberId;
@property(nonatomic,strong) NSString *constituencyName;
@property(nonatomic,strong) NSString *memberName;
@property(nonatomic,strong) NSString *memberParty;

- (NSMutableDictionary *)toNSDictionary;
- (Member *)objectFromNSDictionary:(NSDictionary *)memberDictionary;

@end
