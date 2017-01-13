//
//  ParseJSON.m
//  MoviesSearch
//
//  Created by Vaibhav N Laghane on 1/12/17.
//  Copyright © 2017 VirtusaPolaris. All rights reserved.
//

#import "ParseJSON.h"

@implementation ParseJSON
 
SYNTHESIZE_SINGLETON_FOR_CLASS(ParseJSON)



-(NSMutableArray*)parseTracksJSON:(NSDictionary *)jsonDict{

    NSMutableArray *tracks = [[ NSMutableArray alloc] init];;
    if (jsonDict == nil ) {
        return  nil;
    }
    
    if([jsonDict valueForKey:@"resultCount" ] > 0 ){
        
        NSArray *trackList = [ jsonDict valueForKey:@"results"];
        //using NSSset to keep a check on duplicates 
        NSSet *tracksSet = [NSSet set];
        for(int i =0; i < [trackList count] ; i++){
            
            TrackDetails *track = [[ TrackDetails alloc] init];
            track.trackName = [[trackList objectAtIndex:i] valueForKey:@"trackName"];
            track.artistName = [[trackList objectAtIndex:i] valueForKey:@"artistName"];
            track.info = [[trackList objectAtIndex:i] valueForKey:@"longDescription"];
            track.albumName =  [[trackList objectAtIndex:i] valueForKey:@"collectionName"];
            track.imageURL = [[trackList objectAtIndex:i] valueForKey:@"artworkUrl30"];
            track.uniqueID = [[trackList objectAtIndex:i] valueForKey:@"trackId"];
            
            //check if current uniqID is already added - if yes donot repeat
            NSString* uniqID = track.uniqueID;
            if( uniqID != nil  ){
                [tracks  addObject:track];
                [tracksSet setByAddingObject:uniqID];
            }
        }
    }
    return tracks;
}

-(NSMutableArray*)parseLyricsJSON:(NSDictionary *)jsonDict{

    NSMutableArray *lyrics = [[ NSMutableArray alloc] init];;
    if (jsonDict == nil ) {
        return  nil;
    }
    if([jsonDict valueForKey:@"song" ] > 0 ){
        
        NSArray *lyricsList = [ jsonDict valueForKey:@"song"]; 
        for(int i =0; i < [lyricsList count] ; i++){
            LyricsDetails *lyric = [[ LyricsDetails alloc] init];
            lyric.artistName =  [[lyricsList objectAtIndex:i] valueForKey:@"artist"];
            lyric.lyrics = [[lyricsList objectAtIndex:i] valueForKey:@"lyrics"];
            lyric.url  = [[lyricsList objectAtIndex:i] valueForKey:@"url"];
            lyric.song  = [[lyricsList objectAtIndex:i] valueForKey:@"song"];
        }
    }
    
    return lyrics;
    
}






@end
