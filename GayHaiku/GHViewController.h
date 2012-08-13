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

@interface GHViewController : UIViewController <UITextViewDelegate,UIAlertViewDelegate>

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
@property (nonatomic, retain) UINavigationBar *bar;
@property (nonatomic, retain) UITextView *instructions;
@property (nonatomic, retain) NSString *textToSave;

-(IBAction)chooseDatabase:(UISegmentedControl *)sender;
-(IBAction)nextHaiku;
-(IBAction)previousHaiku;
-(IBAction)showMessage;
-(IBAction)loadAmazon;
-(IBAction)userWritesHaiku;

@end
