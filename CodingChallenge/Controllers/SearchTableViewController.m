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
    NSMutableArray                        *tracksArray, *tracksCopy;//current list of items in the array
    TrackDetails                               *currTrackObj;
    LyricsViewController                *lyricsVC;
    NSString                                    *sharedSessionID;
    NSURLSessionConfiguration    *sessionConfiguration;
    NSURLSession                           *backgroundSession;
    NSString                                    *downloadFolder;//download folder for files
    NSUInteger                               *downloadCount;
    NSMutableDictionary                *trackIDFilePaths, *lyricsData;//store downloaded images path mapped to trackID
}

@end

@implementation SearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDownloadInitializers];
    trackIDFilePaths = [[ NSMutableDictionary alloc] initWithCapacity:10];//aribtray size
    tracksArray = [[ NSMutableArray  alloc] initWithCapacity:10];;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
    @synchronized (tracksArray ) {
        
        if([tracksArray objectAtIndex:indexPath.row] != nil ){
            ///load cell with the track details
            TrackDetails *track = [ tracksArray objectAtIndex:(int )indexPath.row ];
            cell.labelStringTrack.text = track.trackName ;
            cell.labelStringInfo.text = track.info;
            cell.labelStringArtist.text = track.artistName;
            cell.labelStringAlbum.text = track.albumName ;
            cell.currTrackID = track.uniqueID ;
            cell.imageUrl = track.imageURL ;
            NSURL *filePath =   [trackIDFilePaths objectForKey:track.uniqueID];
            
                if (filePath != nil){
                    ///load the image frmo the image path
                    UIImage *downloadedImage = [UIImage imageWithData: [NSData dataWithContentsOfURL: filePath]];
                    if(downloadedImage == nil ){ downloadedImage = [UIImage imageWithData: [NSData dataWithContentsOfFile: [filePath absoluteString]]];
                    }
                    
                    if(downloadedImage){
                        [cell.imageView setImage:downloadedImage];
                                           }
                        
            }
                else if (track.imageURL !=nil ){
                            UIImage *downloadedImage = [UIImage imageWithData: [NSData dataWithContentsOfURL:  [ NSURL URLWithString:track.imageURL ]]];
                            [cell.imageView setImage:downloadedImage];
                        }
        }
            
         cell.imageView.contentMode = UIViewContentModeScaleAspectFit ;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    currTrackObj = [ tracksArray objectAtIndex:(int )indexPath.row ];
    [ self performSegueWithIdentifier:@"LyricsSegue" sender:self ];
    currTrackObj = nil ; 
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if(currTrackObj != nil ){
        
        lyricsVC = segue.destinationViewController;
        //Pass the currTrack details to the new view controller
        lyricsVC.currTrack = currTrackObj;
        NSURL *filePath =   [trackIDFilePaths objectForKey:currTrackObj.uniqueID];
        if (filePath != nil){
            lyricsVC.imageURL = filePath;
            }
        }
    
}

-(BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {

    if(currTrackObj != nil){
        return true;
    }
    return false;
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
        //@synchronized (tracksArray) {
            if(tracksArray){
                //Once json is download - we have retrieved the file details and url paths for images - download the images/posters
                [self downloadImages:tracksArray];
            }
        //}
    }
}

#pragma mark - delegate for session download task
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location{
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *locationPath = location.path;
    NSString *movedPath = [self relocatedDownloadPath:locationPath];
    NSString *desc = downloadTask.taskDescription;
    
    //using autorelease pool to release loaded image object variable sooner 
    @autoreleasepool {
      
        NSError *error = nil;
        BOOL flagMovedOK = [fm moveItemAtPath:locationPath toPath:movedPath error:&error];
        if(flagMovedOK){
        
            NSURL *dataURL = [NSURL fileURLWithPath:movedPath];
            if(dataURL != nil ){
            //fill the dictionary of filepath with the track ID for the cell
                @synchronized (trackIDFilePaths) {
                    if(desc != nil ){
                        [trackIDFilePaths setObject:dataURL forKey:desc];
                    }
                    dispatch_async( dispatch_get_main_queue()   , ^{
                     
                        [self.tableView reloadData];
                      
                    });
                }
            }
        }
        if (!flagMovedOK) {
            NSLog(@"errror occuredd while downloading file ");
        }
        
    }
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error{
    NSLog(@"errror occuredd while downloading file ");
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error{
    NSLog(@"errror occuredd while downloading file ");

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
 
                                [self.tableView reloadData];
                                self.tableView.contentOffset= CGPointZero ;;
                                //[self.view setNeedsLayout ];
                            });
                          
                      }];
    [dataTask resume];   // Executed First
}
//

///call download operation for each file
-(void)downloadFile:(NSString*)file withIndex:(int)ind andID:(NSString*)uniqID{
    
    if(file == nil ){ return;}
    NSURL *url = [NSURL URLWithString:file];
    NSURLSessionDownloadTask *downloadTask = [backgroundSession  downloadTaskWithURL:url  ];
    downloadTask.taskDescription = uniqID;//[ NSString stringWithFormat:@"%@", uniqID ]; ;
    [downloadTask resume];
}

//downlad images for all the cells of current list of tracks
-(void) downloadImages:(NSArray*)trackObjects{
    if(trackObjects == nil ){ return ;}
    for(int i = 0; i < [trackObjects count]; i++){
        TrackDetails *track = [ trackObjects objectAtIndex:i];
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

//initialize the download session
-(void )loadDownloadInitializers{
    // initializeDownloadSession
    downloadCount = 0;
    sharedSessionID = [[NSBundle mainBundle] bundleIdentifier];
    sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:sharedSessionID];
    sessionConfiguration.allowsCellularAccess = NO;
    sessionConfiguration.HTTPMaximumConnectionsPerHost = 1;
    backgroundSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:(id )self delegateQueue:nil];
    downloadFolder = [ [CommonMethods shared] downloadFolder];
}

#pragma methods - alert user
-(void)alertUser:(NSString*)message{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @"TrackUnavailable" message: userMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle: @"Ok"   style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:nil];
    
}




@end
