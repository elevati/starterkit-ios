//
//  XCTestCase+DCTAsynchronousTesting.h
//  iOS-StarterKit
//
//  Created by Rakesh B on 28/05/14.
//  Copyright (c) 2014 Elevati. All rights reserved.
//

@import XCTest;
#import "DCTTestExpectation.h"

@interface XCTestCase (DCTAsynchronousTesting)

- (XCTestExpectation *)expectationWithDescription:(NSString *)description;

- (void)waitForExpectationsWithTimeout:(NSTimeInterval)timeout handler:(void(^)(NSError *error))handler;

@end
