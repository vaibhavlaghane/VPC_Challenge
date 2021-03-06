//
//  LyricsViewController.m
//  CodingChallenge
//
//  Created by Vaibhav N Laghane on 1/12/17.
//  Copyright © 2017 VirtusaPolaris. All rights reserved.
//

#import "LyricsViewController.h"

@interface LyricsViewController (){

    NSArray *lyricsArray;
    NSString *jsonURL;
    NSURLSessionDataTask            *dataTask;
}

@end

@implementation LyricsViewController

@synthesize imageView,LabelStringArtist,labelStringTrack,labelStringSong,labelStringUrl,labelStringLyrics,labelStringAlbum,jsonURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    jsonURL = [ self  formJSON];
    [self downloadJSONData:jsonURL];
    
    self.labelStringTrack.text = _currTrack.trackName;
    self.labelStringAlbum.text = _currTrack.albumName;
    self.LabelStringArtist.text = _currTrack.artistName ;
    
    NSURL *filePath =   self.imagefilePath ;
   
    if (filePath != nil){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *downloadedImage = [UIImage imageWithData: [NSData dataWithContentsOfURL: filePath]];
            if(downloadedImage == nil ){
                downloadedImage = [UIImage imageWithData: [NSData dataWithContentsOfFile: [filePath absoluteString]]];
                          }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(downloadedImage){
                        [self.imageView setImage:downloadedImage];
                    }
            });
        });
    }
    
    if(!filePath){
        if(_currTrack.imageURL !=nil ){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  UIImage *downloadedImage = [UIImage imageWithData: [NSData dataWithContentsOfURL:  [ NSURL URLWithString:_currTrack.imageURL ]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.imageView setImage:downloadedImage];
                });
            });
        }
    }
    
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSString*)formJSON{
    NSString *prefix= @"http://lyrics.wikia.com/api.php?func=getSong&artist=";
    NSString *prefix2 = @"&song=";
    NSString *prefix3 = @"&fmt=";
    NSString *artist = _currTrack.artistName;
    NSString *song = _currTrack.trackName;
    artist = [artist  stringByReplacingOccurrencesOfString:@" " withString: @"+"];;
    song = [ song stringByReplacingOccurrencesOfString:@" " withString: @"+"];
    NSString *json = [prefix  stringByAppendingString:artist];
    json = [ json stringByAppendingString:prefix2];
    json = [json stringByAppendingString:song];
    json = [json stringByAppendingString:prefix3];
    json = [json stringByAppendingString:@"json"];
    
    return json;

}



///data task to download the lyrics list json
-(void)downloadJSONData:(NSString*)urlJSON{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlJSON ];
    
    dataTask = [session dataTaskWithURL:url
                      completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                          // Executed when the response comes from server
                          // Handle Response here
                          NSDictionary * json = nil;
                          if(data != nil ){
                              json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                          }
                          //refresh and reload the track list objects
                          @synchronized (lyricsArray) {
                              lyricsArray = nil;
                              lyricsArray = [[ ParseJSON shared ] parseLyricsJSON:json];
                              if (lyricsArray == nil || [lyricsArray count] == 0){
                              
                              }else{
                                  LyricsDetails *lyrics = [lyricsArray objectAtIndex:0];
                              
                                  //once all the track names are read --- reload the table view
                                  dispatch_async( dispatch_get_main_queue()   , ^{
                                      self.labelStringLyrics.text = lyrics.lyrics;
                                      self.labelStringSong.text = lyrics.song;
                                      self.labelStringUrl.text = lyrics.url;
                                  });
                              }
                          }
                       
                          
                      }];
    [dataTask resume];   // Executed First
}
//

-(void)dealloc{

    [dataTask cancel];
}



//#pragma methods - alert user
//-(void)alertUser:(NSString*)message{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @"TrackUnavailable" message: userMessage preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction* ok = [UIAlertAction actionWithTitle: @"Ok"   style:UIAlertActionStyleDefault handler:nil];
//    [alertController addAction:ok];
//    [self presentViewController:alertController animated:YES completion:nil];
//    
//}


@end
