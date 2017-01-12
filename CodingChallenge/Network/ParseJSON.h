//
//  ParseJSON.h
//  MoviesSearch
//
//  Created by Vaibhav N Laghane on 1/12/17.
//  Copyright © 2017 VirtusaPolaris. All rights reserved.
//

#import <Foundation/Foundation.h> 
#import "TrackDetails.h"
#import "Singleton.h"
#import "LyricsDetails.h"

@interface ParseJSON : Singleton
+ (ParseJSON *) shared;
-(NSMutableArray*)parseTracksJSON:(NSDictionary *)jsonDict;
-(NSMutableArray*)parseLyricsJSON:(NSDictionary *)jsonDict;
@end
