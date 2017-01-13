//
//  TrackDCell.h
//  CodingChallenge
//
//  Created by Vaibhav N Laghane on 1/12/17.
//  Copyright © 2017 VirtusaPolaris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackDCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UILabel *trackTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *trackInfo;
@property (nonatomic, retain) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@property (strong,nonatomic) NSString *currTrackID;
@property (strong,nonatomic) NSString *imageUrl;

@property (weak, nonatomic) IBOutlet UILabel *labelStringTrack;
@property (weak, nonatomic) IBOutlet UILabel *labelStringArtist;
@property (weak, nonatomic) IBOutlet UILabel *labelStringInfo;
@property (weak, nonatomic) IBOutlet UILabel *labelStringAlbum;


@end
