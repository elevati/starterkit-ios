//
//  iOS_StarterKitTests.m
//  iOS-StarterKitTests
//
//  Created by Rakesh B on 15/09/14.
//  Copyright (c) 2014 Elevati. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "URLManager.h"
#import "XCTestCase+DCTAsynchronousTesting.h"
#import "../Pods/AFNetworking/AFNetworking/AFNetworking.h"

@interface iOS_StarterKitTests : XCTestCase

@property (nonatomic,strong) NSMutableArray *arrResponseObjects;
@property (nonatomic,assign) NSInteger timeout;

@end

@implementation iOS_StarterKitTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
     _timeout = 15;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/*
 Below method is to check the sample API works fine by checking the status code as 200 and returns the data properly
 */
- (void)testMembersAPI
{
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    
    //handle the data table
    //Get the data from the server
    _arrResponseObjects = [[NSMutableArray alloc] init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[[URLManager defaultManager] getMemberDetailsURL] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger statusCode = operation.response.statusCode;
        if(statusCode == 200)
        {
            if([_arrResponseObjects count] > 0)
                XCTAssertTrue(YES, @"Valid posts response");
            else
                XCTAssertTrue(NO, @"Invalid posts response");
        }
        else
        {
            XCTAssertTrue(NO, @"Invalid posts response");
        }
        
        [expectation fulfill];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Server error: %@", error);
        XCTAssertTrue(NO, @"Server error");
    }];
    
    [self waitForExpectationsWithTimeout:_timeout handler:nil];
}

@end
