//
//  CodingChallengeTests.m
//  CodingChallengeTests
//
//  Created by Vaibhav N Laghane on 1/12/17.
//  Copyright © 2017 VirtusaPolaris. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SearchTableViewController.h"
#import "ParseJSON.h"
#import "LyricsViewController.h"
#import "CommonMethods.h"

@interface CodingChallengeTests : XCTestCase{
    SearchTableViewController *svc;
    LyricsViewController *lvc;
    NSArray *tracksArray, *lyricsArray;
    NSURLSessionDataTask            *dataTask;
//    NSArray *tracksArray;
    NSString*downloadFolder;
}
@end

@implementation CodingChallengeTests

- (void)setUp {
    [super setUp];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    svc = [storyboard instantiateViewControllerWithIdentifier:@"SearchTableViewController"];
    lvc  = [storyboard instantiateViewControllerWithIdentifier:@"LyricsViewController"];
    downloadFolder = [[ CommonMethods shared] downloadFolder];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


-(void )testdownloadFolder{
    
    XCTAssertNotNil(downloadFolder, @" downloadFolder is nil ");
    
}

-(void )testSearchViewCLoads{
 
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        svc = [storyboard instantiateViewControllerWithIdentifier:@"SearchTableViewController"];
    XCTAssertNotNil(svc, @" SearchTableViewController is nil ");
    
}


-(void )testLyricsViewCLoads{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    lvc  = [storyboard instantiateViewControllerWithIdentifier:@"LyricsViewController"];
    XCTAssertNotNil(svc, @" LyricsViewController is nil ");
    
}

-(void )testParseNullJSON{
    
    NSString* urlJSON = [  @"https://itunes.apple.com/search?term=" stringByAppendingString:@"ba0000000" ];
    //call the API to search the entered track name
        NSURLSession *session = [NSURLSession sharedSession];
        NSURL *url = [NSURL URLWithString:urlJSON ];
        
        dataTask = [session dataTaskWithURL:url
                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                              // Executed when the response comes from server
                              // Handle Response here
                              NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                              //refresh and reload the track list objects
                             
                                  tracksArray = nil;
                                  tracksArray = [[ ParseJSON shared ] parseTracksJSON:json];
                                  if (tracksArray == nil || [tracksArray count] == 0){
                                      //alert the user with message
                                    //  [ self alertUser:userMessage ];
                                  }
                             
                              XCTAssertNil(tracksArray, @"json returned nil ");
                              
                          }];
        [dataTask resume];   // Executed First
   
    
}


-(void )testParseJSON{
    
    NSString* urlJSON = [  @"https://itunes.apple.com/search?term=" stringByAppendingString:@"ba" ];
    //call the API to search the entered track name
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlJSON ];
    
    dataTask = [session dataTaskWithURL:url
                      completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                          // Executed when the response comes from server
                          // Handle Response here
                          NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                          //refresh and reload the track list objects
                          
                          tracksArray = nil;
                          tracksArray = [[ ParseJSON shared ] parseTracksJSON:json];
                          if (tracksArray == nil || [tracksArray count] == 0){
                              //alert the user with message
                              //  [ self alertUser:userMessage ];
                          }
                          
                          XCTAssertNotNil(tracksArray, @"json returned nil ");
                          
                      }];
    [dataTask resume];   // Executed First
    
    
}


-(void )testFileDownload{
    
    
     //  tracksArray = [[ ParseJSON shared ] parseTracksJSON:json];
    
}




@end
