//
//  GHViewController.h
//  Gay Haiku
//
//  Created by Joel Derfner on 7/22/12.
//  Copyright (c) 2012 Self. All rights reserved.
//
//  Note:  Layout is a dummy, standing in until I get a graphic that isn't under copyright.

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import <Twitter/TWTweetComposeViewController.h>
#import <Twitter/Twitter.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <FacebookSDK/FacebookSDK.h>

@interface GHViewController : UIViewController <UITextViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>
{
        TWTweetComposeViewController *tweetView;
}

@property (nonatomic, retain) NSMutableArray *gayHaiku;
@property (nonatomic, retain) NSString *selectedCategory;
@property (nonatomic, retain) UITextView *haiku_text;
@property (nonatomic, retain) NSMutableArray *theseAreDoneAll;
@property (nonatomic, retain) NSMutableArray *theseAreDoneU;
@property (nonatomic, retain) NSMutableArray *theseAreDoneD;
@property (nonatomic) int indxAll;
@property (nonatomic) int indxU;
@property (nonatomic) int indxD;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) UIWebView *webV;
@property (nonatomic, retain) UINavigationItem *titulus;
@property (nonatomic, retain) UINavigationItem *tb;
@property (nonatomic, retain) UINavigationBar *bar;
@property (nonatomic, retain) UITextView *instructions;
@property (nonatomic, retain) NSString *textToSave;
@property (nonatomic, retain) TWTweetComposeViewController *tweetView;
@property (nonatomic, retain) UIToolbar *toolb;
@property (nonatomic) BOOL instructionsSeen;
@property (nonatomic) BOOL savedEdit;
@property (nonatomic) BOOL checkboxSelected;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segContrAsOutlet;
@property (nonatomic, retain) NSString *meth;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (nonatomic) BOOL boxSelected;
@property (nonatomic, weak) IBOutlet UIButton *checkbox;

-(IBAction)SelectButton;
-(IBAction)valueChanged:(UISegmentedControl *)sender;
-(IBAction)chooseDatabase:(UISegmentedControl *)segment;
-(IBAction)nextHaiku;
-(IBAction)previousHaiku;
-(IBAction)showMessage;
-(IBAction)loadAmazon;
-(IBAction)userWritesHaiku;

@end
