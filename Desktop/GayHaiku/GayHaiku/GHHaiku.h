//
//  GHHaiku.h
//  GayHaikuReal
//
//  Created by Joel Derfner on 9/15/12.
//  Copyright (c) 2012 Joel Derfner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import <Twitter/TWTweetComposeViewController.h>
#import <Twitter/Twitter.h>
#import <MobileCoreServices/MobileCoreServices.h>
//#import <Parse/Parse.h>
#import <Social/Social.h>

@interface GHHaiku : NSObject

-(int)chooseNumber;
-(NSString *)haikuToShow;

@property (nonatomic) int index;
@property (nonatomic, strong) NSMutableArray *arrayOfSeen;
@property (nonatomic, strong) NSArray *arrayAfterFiltering;
@property (nonatomic, strong) NSString *selectedCategory;




@end
