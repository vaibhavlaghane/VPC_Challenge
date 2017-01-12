//
//  Singleton.h
//  MoviesSearch
//
//  Created by Vaibhav N Laghane on 1/12/17.
//  Copyright © 2017 VirtusaPolaris. All rights reserved.
//

#import <Foundation/Foundation.h>


#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
+ (classname *)shared {\
\
static dispatch_once_t pred;\
\
static classname *sharedInstance = nil;\
\
dispatch_once(&pred, ^{ sharedInstance = [[self alloc] init]; });\
return sharedInstance;\
}\


@interface Singleton : NSObject

@end
