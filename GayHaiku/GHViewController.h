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
#import <Parse/Parse.h>
#import <Social/Social.h>


@interface GHViewController : UIViewController <UITextViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,UIWebViewDelegate>

@property (nonatomic, strong) NSMutableArray *gayHaiku;
@property (nonatomic, strong) NSString *selectedCategory;
@property (nonatomic, strong) UITextView *haiku_text;
@property (nonatomic, strong) NSMutableArray *theseAreDoneAll;
@property (nonatomic, strong) NSMutableArray *theseAreDoneU;
@property (nonatomic, strong) NSMutableArray *theseAreDoneD;
@property (nonatomic) int indxAll;
@property (nonatomic) int indxU;
@property (nonatomic) int indxD;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UINavigationItem *titulus;
@property (nonatomic, strong) UINavigationBar *bar;
@property (nonatomic, strong) UITextView *instructions;
@property (nonatomic, strong) NSString *textToSave;
@property (nonatomic, strong) UIToolbar *toolb;
@property (nonatomic) BOOL instructionsSeen;
//CHECK WHETHER THIS ONE NECESSARY:
@property (nonatomic) BOOL savedEdit;
@property (nonatomic) BOOL checkboxChecked;
@property (nonatomic, strong) NSString *meth;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segContrAsOutlet;
@property (nonatomic, weak) IBOutlet UITextField *userName;
@property (nonatomic, weak) IBOutlet UIButton *checkbox;
@property (nonatomic, strong) UIWebView *webV;
@property (nonatomic, strong) UIBarButtonItem *home;
@property (nonatomic, strong) UIBarButtonItem *compose;
@property (nonatomic, strong) UIBarButtonItem *action;
@property (nonatomic, strong) UIBarButtonItem *done;
@property (nonatomic, strong) UIBarButtonItem *delet;
@property (nonatomic, strong) UIBarButtonItem *flex;
@property (nonatomic, strong) UIBarButtonItem *more;
@property (nonatomic) BOOL controlVisible;
@property (nonatomic) BOOL textEntered;

-(IBAction)selectButton;
-(IBAction)valueChanged:(UISegmentedControl *)sender;
-(IBAction)chooseDatabase:(UISegmentedControl *)segment;
-(IBAction)nextHaiku;
-(IBAction)previousHaiku;
//- (IBAction)fadeInOut;

@end
