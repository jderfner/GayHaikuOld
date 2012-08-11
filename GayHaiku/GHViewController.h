//
//  GHViewController.h
//  Gay Haiku
//
//  Created by Joel Derfner on 7/22/12.
//  Copyright (c) 2012 Self. All rights reserved.
//
//  Note:  Layout is provisional until I get a graphic that isn't under copyright.  The new graphic is expected to run along the bottom of the screen, leaving more room for the haiku themselves (and allowing them to appear in a larger font).

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GHViewController : UIViewController <UITextViewDelegate,UIAlertViewDelegate>
{
    IBOutlet UINavigationBar *navBarForDone;
    IBOutlet UITextView *haiku_text;
    IBOutlet UINavigationBar *navBarForAmazon;
}


@property (nonatomic, retain) UIWebView *wView;
@property (nonatomic, retain) NSMutableArray *gayHaiku;
@property (nonatomic, retain) NSString *selectedCategory;
@property (nonatomic, retain) UITextView *haiku_text;
@property (nonatomic, retain) NSMutableArray *theseAreDone;
@property (nonatomic) int indx;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UIWebView *webV;

-(IBAction)chooseDatabase:(UISegmentedControl *)sender;
-(IBAction)nextHaiku;
-(IBAction)previousHaiku;
-(IBAction)showMessage:(int)sender;
-(IBAction)loadAmazon;
-(IBAction)userWritesHaiku;
-(IBAction)userFinishedWritingHaiku;
-(IBAction)webBack;
-(IBAction)doneWithAmazon;
-(IBAction)haikuInstructions;


@end
