//
//  ViewController.h
//  CodingChallenge
//
//  Created by Vaibhav N Laghane on 1/12/17.
//  Copyright © 2017 VirtusaPolaris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackCell.h"
#import "TrackDetails.h"
#import "LyricsViewController.h"
#import "ParseJSON.h"

@interface SearchViewController :UIViewController< UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tracksTableView;


@end

