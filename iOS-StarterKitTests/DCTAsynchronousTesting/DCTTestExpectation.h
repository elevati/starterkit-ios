//
//  DCTTestExpectation.h
//  iOS-StarterKit
//
//  Created by Rakesh B on 28/05/14.
//  Copyright (c) 2014 Elevati. All rights reserved.
//

@import Foundation;

@interface DCTTestExpectation : NSObject

- (instancetype)initWithDescription:(NSString *)description;
@property (nonatomic, readonly) NSString *expectationDescription;
@property (nonatomic, copy) void (^completion)();

- (void)fulfill;

@end

@compatibility_alias XCTestExpectation DCTTestExpectation;
