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
#import <Parse/Parse.h>

@interface GHViewController : UIViewController <UITextViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,MFMessageComposeViewControllerDelegate,UIWebViewDelegate>

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
@property (nonatomic, retain) UINavigationItem *titulus;
@property (nonatomic, retain) UINavigationItem *tb;
@property (nonatomic, retain) UINavigationBar *bar;
@property (nonatomic, retain) UITextView *instructions;
@property (nonatomic, retain) NSString *textToSave;
@property (nonatomic, retain) TWTweetComposeViewController *tweetView;
@property (nonatomic, retain) UIToolbar *toolb;
@property (nonatomic) BOOL instructionsSeen;
@property (nonatomic) BOOL savedEdit;
@property (nonatomic) BOOL checkboxChecked;
@property (nonatomic) BOOL goneForward;
@property (nonatomic) BOOL goneBack;
@property (nonatomic, retain) NSString *meth;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segContrAsOutlet;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (nonatomic, weak) IBOutlet UIButton *checkbox;
@property (nonatomic, strong) NSURLRequest *requ;
@property (nonatomic, strong) NSURLConnection *conn;
@property (nonatomic, strong) NSData *urlData;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *baseURLString;
@property (nonatomic, strong) UIWebView *webV;
@property (nonatomic, strong) NSError *error;

-(IBAction)selectButton;
-(IBAction)valueChanged:(UISegmentedControl *)sender;
-(IBAction)chooseDatabase:(UISegmentedControl *)segment;
-(IBAction)nextHaiku;
-(IBAction)previousHaiku;

@end
