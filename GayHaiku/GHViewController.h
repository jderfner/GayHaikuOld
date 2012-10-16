//
//  GHViewController.h
//  Gay Haiku
//
//  Created by Joel Derfner on 7/22/12.
//  Copyright (c) 2012 Self. All rights reserved.
//
//  Note:  Layout is a dummy, standing in until I get a graphic that isn't under copyright.

#import <UIKit/UIKit.h>
#import "GHHaiku.h"
//should this be @class GHHaiku.h?


@interface GHViewController : UIViewController <UITextViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,UIWebViewDelegate>
{
    BOOL instructionsSeen;
    BOOL optOutSeen;
    UIBarButtonItem *home;
    UIBarButtonItem *compose;
    UIBarButtonItem *action;
    UIBarButtonItem *done;
    UIBarButtonItem *del;
    UIBarButtonItem *flex;
    UIBarButtonItem *more;
    UIBarButtonItem *edit;
    UIBarButtonItem *next;
    UIBarButtonItem *nextNext;
    UIBarButtonItem *back;
}

@property (nonatomic, strong) NSMutableArray *gayHaiku;
@property (nonatomic, strong) NSMutableArray *theseAreDoneAll;
@property (nonatomic, strong) NSMutableArray *theseAreDoneU;
@property (nonatomic, strong) NSMutableArray *theseAreDoneD;
@property (nonatomic, strong) UITextView *haiku_text;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITextView *instructions;
@property (nonatomic) int indxAll;
@property (nonatomic) int indxU;
@property (nonatomic) int indxD;
@property (nonatomic) int establishedSegment;
@property (nonatomic, strong) NSString *textToDelete;
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *textToSave;
@property (nonatomic, strong) NSString *selectedCategory;
@property (nonatomic, strong) NSString *serviceType;
@property (nonatomic) BOOL controlVisible; 
@property (nonatomic) BOOL textEntered;
@property (nonatomic) BOOL checkboxChecked;
@property (nonatomic) BOOL checkIfJustWrote;
@property (nonatomic) BOOL canFlipPage;
@property (nonatomic) BOOL userIsEditing;
@property (nonatomic, strong) UINavigationItem *titulus;
@property (nonatomic, strong) UINavigationBar *bar;
@property (nonatomic, strong) UIToolbar *toolb;
@property (nonatomic, strong) UIWebView *webV;
@property (nonatomic, strong) UIAlertView *alert;
@property (nonatomic, strong) GHHaiku *ghhaiku;
@property (weak, nonatomic) IBOutlet UIView *viewToFade;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segContrAsOutlet;
@property (nonatomic, weak) IBOutlet UITextField *userName;
@property (nonatomic, weak) IBOutlet UIButton *checkbox;

-(IBAction)selectButton;
-(IBAction)valueChanged:(UISegmentedControl *)sender;
-(IBAction)chooseDatabase:(UISegmentedControl *)segment;
-(IBAction)nextHaiku;
-(IBAction)previousHaiku;

-(void)clearScreen;
-(void)loadToolbar;
-(void)fadeView;

@end
