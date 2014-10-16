//
//  DCTTestExpectation.m
//  iOS-StarterKit
//
//  Created by Rakesh B on 28/05/14.
//  Copyright (c) 2014 Elevati. All rights reserved.
//

#import "DCTTestExpectation.h"

@implementation DCTTestExpectation

- (instancetype)initWithDescription:(NSString *)description {
	self = [super init];
	if (!self) return nil;
	_expectationDescription = [description copy];
	return self;
}

- (void)fulfill {
	if (self.completion) self.completion();
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p; %@>",
			NSStringFromClass([self class]),
			self,
			self.expectationDescription];
}

@end
