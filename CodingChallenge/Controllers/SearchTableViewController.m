//
//  SearchTableViewController.m
//  CodingChallenge
//
//  Created by Vaibhav N Laghane on 1/12/17.
//  Copyright © 2017 VirtusaPolaris. All rights reserved.
//

#import "SearchTableViewController.h"
static NSString *CellID = @"TrackDCell";
static NSString *userMessage = @"Track searched is not available. Please type different combinations of the text and search";

@interface SearchTableViewController ()
{
    NSURLSessionDataTask            *dataTask;
    NSMutableArray                        *tracksArray;
    LyricsViewController                *lyricsVC;
    NSString                                    *sharedSessionID;
    NSURLSessionConfiguration    *sessionConfiguration;
    NSURLSession                           *backgroundSession;
    NSString                                    *downloadFolder;
    NSUInteger                               *downloadCount;
}

@end

@implementation SearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem; 
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath;
{
    return 150;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return  [tracksArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier            =   @"TrackDCell";
    TrackDCell *cell               =   [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if(cell == nil){
        cell                            =   (TrackDCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.textColor                =   [ UIColor blackColor];
    cell.backgroundColor                    =   [ UIColor lightGrayColor];;
    //
    //    [cell.labelStringAlbum setText: NSLocalizedString(@"Year", nil)];
    //    [cell.labelStringTrack setText:NSLocalizedString(@"Brief Intro", nil) ];
    //    [cell.labelStringArtist setText:NSLocalizedString(@"Director", nil) ];
    //    [cell.labelStringInfo setText:NSLocalizedString(@"track", nil) ];
    //
    //
    @synchronized (tracksArray ) {
        
        if([tracksArray objectAtIndex:indexPath.row] != nil ){
            TrackDetails *track = [ tracksArray objectAtIndex:(int )indexPath.row ];
            cell.labelStringTrack.text = track.trackName ;
            cell.labelStringInfo.text = track.info;
            cell.labelStringArtist.text = track.artistName;
            cell.labelStringAlbum.text = track.albumName ;
            //            cell.ima = mv.posterURL ;
            //check if image availabble --- load image
            if(track.trackImage != nil){
                //  cell.imageView = [[ UIImageView alloc] initWithImage:track.trackImage];
                [cell.imageView setImage:track.trackImage];
            }
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"CURRENTCELL"];
    //    @synchronized (self ) {
    //
    //        if([trackObjects objectAtIndex:indexPath.row] != nil ){
    //            trackTrack *mv = [ trackObjects objectAtIndex:(int )indexPath.row ];
    //
    //            NSMutableDictionary *map = [[NSMutableDictionary alloc] init];
    //            [map setValue:mv.trackName forKey:@"trackName"];
    //            [map setValue:mv.directorName forKey:@"directorName"];
    //            [map setValue:mv.posterURL forKey:@"posterURL"];
    //            [map setValue:mv.year forKey:@"year"];
    //            [map setValue:mv.briefIntro forKey:@"briefIntro"];
    //
    //            [[NSUserDefaults standardUserDefaults] setObject:map forKey:@"CURRENTCELL"];
    //
    //        }
    
    
    //    }
    
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    //
    //load detail view controller from the present controller with the details of the cell selected
    //re-init
    //    detailVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    //    [ self presentViewController:detailVC animated:YES completion:nil];
    //
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //  Get the new view controller using [segue destinationViewController].
    //Pass the selected object to the new view controller.
    
   // LyricsViewController *myNewVC = [[LyricsViewController alloc] init];
       // lyricsVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"LyricsViewController"];
       // [ self    presentViewController:lyricsVC animated:YES completion:nil];
    
   // UINavigationController *navigationController = segue.destinationViewController;
    lyricsVC = segue.destinationViewController;
   // lyricsVC.delegate = self;
    
  //  [self presentModalViewController:myNewVC animated:YES];
}




#pragma mark - search field delegate methods

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return  YES  ;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //when enter is pressed in keyboarb --- start the data search operation
    [_searchBar resignFirstResponder ];
    if (searchBar.text != nil  ) {
        if (dataTask != nil) {
            [dataTask cancel];
        }
        NSCharacterSet * expectedCharSet = [NSCharacterSet  URLQueryAllowedCharacterSet];
        NSString* searchTerm = [searchBar.text stringByAddingPercentEncodingWithAllowedCharacters:expectedCharSet ];
        NSString* url = [  @"https://itunes.apple.com/search?term=" stringByAppendingString:searchTerm ];
        //call the API to search the entered track name
        [self downloadJSONData:url];
        @synchronized (self) {
            if(tracksArray){
                //Once json is download - we have retrieved the file details and url paths for images - download the images/posters
                [self downloadImages:tracksArray];
            }
        }
    }
}

#pragma mark - delegate for session download task
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location{
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *locationPath = location.path;
    NSString *movedPath = [self relocatedDownloadPath:locationPath];
    NSString *desc = downloadTask.taskDescription;
    
    NSError *error = nil;
    BOOL flagMovedOK = [fm moveItemAtPath:locationPath toPath:movedPath error:&error];
    if(flagMovedOK){
        
        NSURL *dataURL = [NSURL fileURLWithPath:movedPath];
        if(dataURL != nil ){
            UIImage *downloadedImage = [UIImage imageWithData: [NSData dataWithContentsOfURL: dataURL]];
            int index = (int )[desc integerValue];
            //from the current index---read the tracktrack object from the array. and refill the value for the poster image
            @synchronized (tracksArray) {
                if( [tracksArray count ]  >  index ){//the array has not been updated , then we can execute below
                    TrackDetails *tracks= [tracksArray objectAtIndex:index];
                    //                    if(tracks){
                    //                        tracks.posterImage = downloadedImage;
                    //                        tracks.posterURL = movedPath;
                    //                    }
                    if([tracksArray count] > index){
                        //inserting extra cells --- comment out
                        //[trackObjects replaceObjectAtIndex:index withObject:mv  ];
                    }
                }
                dispatch_async( dispatch_get_main_queue()   , ^{
                    [self.tracksTableView reloadData];
                });
            }
        }
    }
    if (!flagMovedOK) {
        NSLog(@"errror occrued while downloading file ");
    }
    
}

#pragma download operations
///data task to download the track list json
-(void)downloadJSONData:(NSString*)urlJSON{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlJSON ];
    
    dataTask = [session dataTaskWithURL:url
                      completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                          // Executed when the response comes from server
                          // Handle Response here
                          NSDictionary * json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                          //refresh and reload the track list objects
                          @synchronized (tracksArray) {
                              tracksArray = nil;
                              tracksArray = [[ ParseJSON shared ] parseTracksJSON:json];
                              if (tracksArray == nil || [tracksArray count] == 0){
                                  //alert the user with message
                                  [ self alertUser:userMessage ];
                              }
                          }
                          //once all the track names are read --- reload the table view
                          dispatch_async( dispatch_get_main_queue()   , ^{
                              [self.tracksTableView reloadData];
                              self.tracksTableView.contentOffset= CGPointZero ;;
                          });
                          
                      }];
    [dataTask resume];   // Executed First
}
//

///call download operation for each file
-(void)downloadFile:(NSString*)file withIndex:(int)ind andID:(NSString*)uniqID{
    
    if(file == nil ){ return;}
    //1
    NSURL *url = [NSURL URLWithString:file];
    // 2
    NSURLSessionDownloadTask *downloadTask = [backgroundSession  downloadTaskWithURL:url  ];
    downloadTask.taskDescription = [ NSString stringWithFormat:@"%d", ind ]; ;
    [downloadTask resume];
    
    
}

//downlad images for all the cells of current list of tracks
-(void) downloadImages:(NSArray*)imageObjects{
    
    if(imageObjects == nil ){ return ;}
    for(int i = 0; i < [imageObjects count]; i++){
        TrackDetails *track = [ imageObjects objectAtIndex:i];
        if(track != nil ){
            NSString *url = track.imageURL ;
            if(url != nil ){
                [self downloadFile:url withIndex:i andID:track.uniqueID];
            }
        }
    }
}

- (NSString *) relocatedDownloadPath:(NSString *) path {
    NSString *pathString = downloadFolder;
    pathString = [pathString stringByAppendingPathComponent:path.lastPathComponent];
    return pathString;
    
}

-(void )loadDownloadInitializers{
    // initializeDownloadSession
    downloadCount = 0;
    sharedSessionID = [[NSBundle mainBundle] bundleIdentifier];
    sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:sharedSessionID];
    sessionConfiguration.allowsCellularAccess = NO;
    sessionConfiguration.HTTPMaximumConnectionsPerHost = 1;
    backgroundSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:(id )self delegateQueue:nil];
    //create a background downdload folder for downloaded images
    NSArray *pathA = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *folderPath = ([pathA count] > 0) ? [pathA objectAtIndex:0]: nil  ;;
    NSLog(@"FolderPath: %@", folderPath);
    folderPath = [folderPath stringByAppendingPathComponent:@"BackgroundDownloads"];
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if (![fm fileExistsAtPath:folderPath]) { // create the folder if it does not exist
        [fm createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    downloadFolder = folderPath;
}


#pragma methods - alert user
-(void)alertUser:(NSString*)message{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @"TrackUnavailable" message: userMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle: @"Ok"   style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:nil];
    
}




@end
