//
//  LyricsViewController.h
//  CodingChallenge
//
//  Created by Vaibhav N Laghane on 1/12/17.
//  Copyright © 2017 VirtusaPolaris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackDetails.h"

@interface LyricsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *LabelStringArtist;
@property (weak, nonatomic) IBOutlet UILabel *labelStringTrack;
@property (weak, nonatomic) IBOutlet UILabel *labelStringSong;
@property (weak, nonatomic) IBOutlet UILabel *labelStringUrl;
@property (weak, nonatomic) IBOutlet UILabel *labelStringLyrics;
@property (weak, nonatomic) IBOutlet UILabel *labelStringAlbum;

@property (nonatomic,readwrite) UIImage * trackImage;
@property (nonatomic,readwrite) NSURL * imageURL;
@property (nonatomic,readwrite) NSURL * imagefilePath;
@property (nonatomic,retain) TrackDetails * currTrack;

@property (nonatomic,retain) NSString * jsonURL;



@end
