//
//  CommonMethods.m
//  CodingChallenge
//
//  Created by Vaibhav N Laghane on 1/12/17.
//  Copyright © 2017 VirtusaPolaris. All rights reserved.
//

#import "CommonMethods.h"

@implementation CommonMethods
SYNTHESIZE_SINGLETON_FOR_CLASS(CommonMethods)

-(NSString*)downloadFolder{

//create a background downdload folder for downloaded images
NSArray *pathA = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
NSString *folderPath = ([pathA count] > 0) ? [pathA objectAtIndex:0]: nil  ;;
NSLog(@"FolderPath: %@", folderPath);
folderPath = [folderPath stringByAppendingPathComponent:@"BackgroundDownloads"];
NSFileManager *fm = [NSFileManager defaultManager];

if (![fm fileExistsAtPath:folderPath]) { // create the folder if it does not exist
    [fm createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
}
return   folderPath;

}
@end
