//
//  LyricsDetails.h
//  CodingChallenge
//
//  Created by Vaibhav N Laghane on 1/12/17.
//  Copyright © 2017 VirtusaPolaris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricsDetails : NSObject

@property (atomic,readwrite) NSString* song;
@property (atomic,readwrite) NSString* artistName;
@property (atomic,readwrite) NSString* lyrics;
@property (atomic,readwrite) NSString* url;
 

@end
