//
//  TrackDetails.h
//  CodingChallenge
//
//  Created by Vaibhav N Laghane on 1/12/17.
//  Copyright © 2017 VirtusaPolaris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface TrackDetails : NSObject
@property (atomic,readwrite) NSString* trackName;
@property (atomic,readwrite) NSString* artistName;
@property (atomic,readwrite) NSString* albumName;
@property (atomic,readwrite) NSString* info;
@property (atomic,readwrite) NSString* uniqueID;
@property (atomic,readwrite) UIImage * trackImage;
@property (atomic,readwrite) NSString * imageURL;
@property (atomic,readwrite) NSString * imagefilePath;
@end
