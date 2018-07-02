//
//  Mrs_LandinghamTests.m
//  Mrs LandinghamTests
//
//  Created by Joseph Reddington on 15/08/2017.
//  Copyright © 2017 Joseph Reddington. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FlowModel.h"

@interface Mrs_LandinghamTests : XCTestCase

@end

@implementation Mrs_LandinghamTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testFlowModelCreated {
    FlowModel * model=[FlowModel coreBrain];
    NSString * result = [model getMessage];
    //compare with @"Smile"
    XCTAssertTrue([result caseInsensitiveCompare:@"Smile"] == NSOrderedSame);
    
}




@end
