//
//  LyricsViewController.m
//  CodingChallenge
//
//  Created by Vaibhav N Laghane on 1/12/17.
//  Copyright © 2017 VirtusaPolaris. All rights reserved.
//

#import "LyricsViewController.h"

@interface LyricsViewController ()

@end

@implementation LyricsViewController
@synthesize imageView,LabelStringArtist,labelStringTrack,labelStringSong,labelStringUrl,labelStringLyrics,labelStringAlbum;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   
   self.labelStringTrack.text = _currTrack.trackName;
    self.labelStringAlbum.text = _currTrack.albumName;
    self.LabelStringArtist.text = _currTrack.artistName ;
    
   // lyricsVC.currTrack = currTrackObj;
    
    NSURL *filePath =   self.imagefilePath ;
   
    if (filePath != nil){
       // lyricsVC.imageURL = filePath;
        UIImage *downloadedImage = [UIImage imageWithData: [NSData dataWithContentsOfURL: filePath]];
        if(downloadedImage == nil ){ downloadedImage = [UIImage imageWithData: [NSData dataWithContentsOfFile: [filePath absoluteString]]];
           [self.imageView setImage:downloadedImage];
        }
    }
    
    if(!filePath){
        if(_currTrack.imageURL !=nil ){
            UIImage *downloadedImage = [UIImage imageWithData: [NSData dataWithContentsOfURL:  [ NSURL URLWithString:_currTrack.imageURL ]]];
                  [self.imageView setImage:downloadedImage];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
