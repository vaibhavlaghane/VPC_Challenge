//
//  AppDelegate.h
//  CodingChallenge
//
/*
Code Challenges

Coding Challenge: Music Search
Coding Challenge: Weather
1.   Coding Challenge: Music Search

Below are the details needed to construct a music search application based on a public Apple and wiki API.

Public APIs

https://itunes.apple.com/search?term=tom+waits
http://lyrics.wikia.com/api.php?func=getSong&artist=Tom+Waits&song=new+coat+of+paint&fmt=json
Requirements

These requirements are rather high-level and vague. If there are details I have omitted, it is because I will be happy with any of a wide variety of solutions. Don't worry about finding "the" solution.

Create a browser or native-app based application to server as a basic music search app.
Search Screen
Allow customer to enter a term to search on.
Call the apple API and display all the returned track names, artist name, album name, and image of album in a customer cell on a table,
Clicking a cell should navigate to the lyrics screen.
Lyrics screen
Display all the information from the previous cell plus the lyrics returned from the wikia service.
In order to prevent you from running down rabbit holes that are less important to us, I'll try to prioritize what we are looking for versus what is less meaningful.

What is Important

Proper function – requirements met.
Well constructed, easy-to-follow, commented code (especially comment hacks or workarounds made in the interest of expediency (i.e. // given more time I would prefer to wrap this in a blah blah blah pattern blah blah )).
                                                                                                                            Proper separation of concerns and best-practice coding patterns.
                                                                                                                              Defensive code that graciously handles unexpected edge cases.
                                                                                                                              What is Less Important
                                                                                                                              
                                                                                                                              UI design – generally, design is handled by a dedicated team in our group.
                                                                                                                              Demonstrating technologies or techniques you are not already familiar with (for example, if you aren't comfortable building a single-page app, please don't feel you need to learn how for this).
                                                                                                                              Showing off in-depth knowledge of JavaScript semicolon syntax requirements.
                                                                                                                              Bonus Points!
                                                                                                                              
                                                                                                                              Automated tests!
                                                                                                                              Good design (I know I said it was less important, but what I mean is I don't want a beautiful, poorly constructed app).
                                                                                                                                           Additional functionality – whatever you see fit.
                                                                                                                                           As I mentioned, you are not expected to function in a vacuum. Use all the online resources you can find, and please do contact me with questions or for interim feedback if you desire.
*/
 //  Created by Vaibhav N Laghane on 1/12/17.
//  Copyright © 2017 VirtusaPolaris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

