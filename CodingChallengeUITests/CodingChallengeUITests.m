//
//  CodingChallengeUITests.m
//  CodingChallengeUITests
//
//  Created by Vaibhav N Laghane on 1/12/17.
//  Copyright © 2017 VirtusaPolaris. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface CodingChallengeUITests : XCTestCase

@end

@implementation CodingChallengeUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

-(void)testSearchViewLaunch{

    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *emptyListTable = app.tables[@"Empty list"];
    XCTAssertNotNil(emptyListTable, @"Table doesnot exist");
    
}


-(void )testSearchBarLaunch{

    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *emptyListTable = app.tables[@"Empty list"];
    XCUIElement *searchField = [emptyListTable childrenMatchingType:XCUIElementTypeSearchField].element;
      XCTAssertNotNil(searchField, @"TabsearchFieldle doesnot exist");    
}

-(void)testIAlertBox{

    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *emptyListTable = app.tables[@"Empty list"];
    XCUIElement *searchField = [emptyListTable childrenMatchingType:XCUIElementTypeSearchField].element;
    XCTAssertNotNil(searchField, @"TabsearchFieldle doesnot exist");
    
    [searchField tap];
    [searchField tap];
    [searchField typeText:@"fdgdh"];
    [app typeText:@"\r"];
    
    sleep(2);
    XCUIElement *trackunavailableAlert = app.alerts[@"TrackUnavailable"];
    [trackunavailableAlert.staticTexts[@"Track searched is not available. Please type different combinations of the text and search"] tap];
    [trackunavailableAlert.buttons[@"Ok"] tap];
    XCTAssertNotNil(trackunavailableAlert, @"Alert not displayed");
    
}


-(void)testValidtextSearch{
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *emptyListTable = app.tables[@"Empty list"];
    XCUIElement *searchField = [emptyListTable childrenMatchingType:XCUIElementTypeSearchField].element;
    XCTAssertNotNil(searchField, @"TabsearchFieldle doesnot exist");
    
    [searchField tap];
    [searchField tap];
    [searchField typeText:@"tess"];
    [app typeText:@"\r"];
    
    
}
@end
