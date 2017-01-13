//
//  CommonMethods.h
//  CodingChallenge
//
//  Created by Vaibhav N Laghane on 1/12/17.
//  Copyright © 2017 VirtusaPolaris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface CommonMethods : Singleton


+ (CommonMethods *) shared;
-(NSString*)downloadFolder;
@end
