//
//  GHViewController.h
//  Gay Haiku
//
//  Created by Joel Derfner on 7/22/12.
//  Copyright (c) 2012 Self. All rights reserved.
//
//  Note:  Layout is provisional until I get a graphic that isn't under copyright.  The new graphic is expected to run along the bottom of the screen, leaving more room for the haiku themselves (and allowing them to appear in a larger font).

#import <UIKit/UIKit.h>
#import "GHWebViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface GHViewController : UIViewController <UITextViewDelegate,UIAlertViewDelegate>
{
    IBOutlet UINavigationBar *navBarForDone;
    IBOutlet UITextView *haiku_text;
    IBOutlet UIWebView *wView;
}


@property (nonatomic, retain) UIWebView *wView;
@property (nonatomic, retain) NSMutableArray *gayHaiku;
@property (nonatomic, retain) NSString *selectedCategory;
@property (nonatomic, retain) UITextView *haiku_text;

-(IBAction)chooseDatabase:(UISegmentedControl *)sender;
-(IBAction)nextHaiku;
-(IBAction)showMessage:(int)sender;
- (IBAction)loadAmazon:(UIWebView *)webView;
-(IBAction)userWritesHaiku;

@end
