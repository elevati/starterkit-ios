//
//  MemberObj.h
//  iOS-StarterKit
//
//  Created by Rakesh B on 15/10/14.
//  Copyright (c) 2014 Elevati. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface MemberObj : NSManagedObject

@property(nonatomic,strong) NSString *constituencyName;
@property(nonatomic,strong) NSString *memberName;
@property(nonatomic,strong) NSString *memberParty;

@end
