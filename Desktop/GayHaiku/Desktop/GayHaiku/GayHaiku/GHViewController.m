//
//  GHViewController.m
//  Gay Haiku
//
//  Created by Joel Derfner on 7/22/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import "GHViewController.h"
#import <Twitter/Twitter.h>
#import <Twitter/TWTweetComposeViewController.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Parse/Parse.h>
#import <Social/Social.h>

@interface GHViewController ()<UITextViewDelegate,MFMailComposeViewControllerDelegate,UIAlertViewDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,UITextFieldDelegate>

@end

@implementation GHViewController

@synthesize userName = _userName;
@synthesize segContrAsOutlet = _segContrAsOutlet;
@synthesize checkbox = _checkbox;
@synthesize gayHaiku = _gayHaiku;
@synthesize textView = _textView;
@synthesize titulus = _titulus;
@synthesize bar = _bar;
@synthesize instructions = _instructions;
@synthesize textToSave = _textToSave;
@synthesize haiku_text = _haiku_text;
@synthesize selectedCategory = _selectedCategory;
@synthesize webV = _webV;
@synthesize theseAreDoneAll = _theseAreDoneAll;
@synthesize theseAreDoneD = _theseAreDoneD;
@synthesize theseAreDoneU = _theseAreDoneU;
@synthesize indxAll = _indxAll;
@synthesize indxD = _indxD;
@synthesize indxU = _indxU;
@synthesize toolb = _toolb;
@synthesize instructionsSeen = _instructionsSeen;
@synthesize checkboxChecked = _checkboxChecked;
@synthesize meth = _meth;
@synthesize de = _de;
@synthesize home = _home;
@synthesize done = _done;
@synthesize more = _more;
@synthesize compose = _compose;
@synthesize action = _action;
@synthesize flex = _flex;
@synthesize controlVisible = _controlVisible;
@synthesize textEntered = _textEntered;
@synthesize textToDelete = _textToDelete;

//————————————————code used by all pages——————————————————

#pragma mark -
#pragma Setup

-(void)viewDidLoad
{
    //Load view
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.instructionsSeen = [defaults boolForKey:@"seen?"];
    if ([defaults boolForKey:@"checked?"])
    {
        self.checkboxChecked = [defaults boolForKey:@"checked?"];
    }
    else self.checkboxChecked = YES;
	[super viewDidLoad];
    
    
    //Swipe gesture recognizers
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previousHaiku)];
    swipeRight.numberOfTouchesRequired = 1;
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextHaiku)];
    swipeLeft.numberOfTouchesRequired = 1;
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    self.webV.delegate = self;
    self.textView.delegate = self;
    
    
    //Load haiku from documents directory
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"gayHaiku.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath: path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"gayHaiku" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
     
     //UNCOMMENT, RUN, AND THEN RECOMMENT THIS SECTION IF NEED TO DELETE LOCAL HAIKU DOCUMENT (FOR TESTING USER-GENERATED HAIKU, ETC.).
     /*
     else if ([fileManager fileExistsAtPath: path])
    {
        [fileManager removeItemAtPath:path error:&error];
    }
    */
    self.gayHaiku = [[NSMutableArray alloc] initWithContentsOfFile: path];
    NSLog(@"%@",self.gayHaiku);
    
    //Creates a separate plist document for user haiku
    
    NSArray *userPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *userDocumentsDirectory = [userPaths objectAtIndex:0];
    NSString *userPath = [userDocumentsDirectory stringByAppendingPathComponent:@"userHaiku.plist"];
    NSFileManager *userFileManager = [NSFileManager defaultManager];
    if (![userFileManager fileExistsAtPath: userPath])
    {
        NSString *userBundle = [[NSBundle mainBundle] pathForResource:@"userHaiku" ofType:@"plist"];
        [userFileManager copyItemAtPath:userBundle toPath: userPath error:&error];
    }
/*
    else if ([userFileManager fileExistsAtPath: userPath])
    {
        [userFileManager removeItemAtPath:userPath error:&error];
    }
    */
    //merges the contents of the two plists.
    
    NSArray *userH = [[NSArray alloc] initWithContentsOfFile:userPath];
    [self.gayHaiku addObjectsFromArray:userH];
    
    //Visual elements
    

    
    [self.view viewWithTag:5].hidden=YES;
    [self.view viewWithTag:6].hidden=YES;
    [self.view viewWithTag:7].hidden=YES;
    [self.view viewWithTag:8].hidden=YES;
    [self createBarButtons];
    [self displayButton];
    
    
    //Add Parse
    
    [Parse setApplicationId:@"M7vcXO7ccmhNUbnLhmfnnmV8ezLvvuMvHwNZXrs8"
                  clientKey:@"Aw8j7MhJwsHxW1FxoHKuXojNGvrPSjDkACs7egRi"];
    
    
    //And we're a go:
    
    [self nextHaiku];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

-(void)clearScreen
{
    [self.instructions removeFromSuperview];
    [self.textView removeFromSuperview];
    [self.haiku_text removeFromSuperview];
    [self.bar removeFromSuperview];
    [self.toolb removeFromSuperview];
    [self.webV removeFromSuperview];
    [self.view viewWithTag:3].hidden=YES;
}

-(void)viewDidUnload
{
    [self setSegContrAsOutlet:nil];
    self.checkboxChecked=NO;
    [self setUserName:nil];
    self.instructionsSeen=NO;
    [super viewDidUnload];
}

//saveData keeps track, persistently, of whether user has read instructions, so that instructions automatically appear the very first time user writes a haiku ever.
-(void)saveData
{
    if (self.instructionsSeen)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:self.instructionsSeen forKey:@"seen?"];
        [defaults synchronize];
    }
}

//————————————————code to set up navBars——————————————————

#pragma mark -
#pragma NavBars/ToolBars

//This section creates the various navigation bars, toolbars, and buttons used on various screens.

-(void)loadNavBar:(NSString *)titl
{
    [self.bar removeFromSuperview];
    self.bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.titulus = [[UINavigationItem alloc] initWithTitle:titl];
}

-(void)addLeftButton:(NSString *)titl callingMethod:(NSString *)method
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:titl style:UIBarButtonItemStyleBordered target:self action:NSSelectorFromString(method)];
    self.titulus.leftBarButtonItem = button;
}

-(void)addLeftButtons:(NSArray *)titles
{
    self.titulus.leftBarButtonItems = titles;
}

-(void)addCancelButton:(NSString *)blah
{
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:1 target:self action:NSSelectorFromString(blah)];
    cancel.style=UIBarButtonItemStyleBordered;
    self.titulus.rightBarButtonItem = cancel;
}

-(void)addDoneButton:(NSString *)blah
{
    UIBarButtonItem *don = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:0 target:self action:NSSelectorFromString(blah)];
    don.style=UIBarButtonItemStyleBordered;
    self.titulus.rightBarButtonItem = don;
}

-(void)seeNavBar
{
    [self.bar pushNavigationItem:self.titulus animated:YES];
    [self.view addSubview:self.bar];
}

-(void)loadToolbar
{
    CGRect frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 64, [[UIScreen mainScreen] bounds].size.width, 64);
    self.toolb = [[UIToolbar alloc]initWithFrame:frame];
    [self.toolb sizeToFit];
    [self.view addSubview:self.toolb];
}

-(void)createBarButtons
{
    self.compose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:7 target:self action:@selector(userWritesHaiku)];
    
    self.compose.style=UIBarButtonItemStyleBordered;
    
    self.action = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:9 target:self action:@selector(showMessage)];
    
    self.action.style=UIBarButtonItemStyleBordered;
    
    self.more = [[UIBarButtonItem alloc] initWithTitle:@"Buy" style:UIBarButtonItemStyleBordered target:self action:@selector(loadAmazon)];
    
    //self.home = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(hom)];
    
    self.flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    self.done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:0  target:self action:@selector(hom)];
    
    self.de = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteHaiku)];
}

//The next three methods create toolbars.

-(void)addToolbarButtons
{
    NSArray *buttons = [NSArray arrayWithObjects: self.flex, self.compose, self.action, self.more, self.flex, nil];
    [self.toolb setItems:buttons animated:NO];
}

-(void)addToolbarButtonsPlusDone
{
    NSArray *buttons = [NSArray arrayWithObjects: self.flex, self.done, self.compose, self.action, self.flex, nil];
    [self.toolb setItems:buttons animated:NO];
}

-(void)addToolbarButtonsPlusDelete
{
    NSArray *butt = [NSArray arrayWithObjects:self.flex, self.compose, self.action, self.more, self.de, self.flex, nil];
    [self.toolb setItems:butt animated:NO];
}

-(void)addToolbarDone
{
    NSArray *buttons = [NSArray arrayWithObjects:self.flex, self.done, self.flex, nil];
    [self.toolb setItems:buttons animated:NO];
}

//————————————————code for Instructions page——————————————————

#pragma mark - 
#pragma Instructions

//haikuInstructions sets up and displays the page of instructions on how to write haiku.

-(void)haikuInstructions
{
    //Set screen up.
    
    self.textToSave = self.textView.text;
    [self clearScreen];
    [self saveData];
    [self resignFirstResponder];
    

    //Create navigation bar.
    
    [self loadNavBar:@"Instructions"];
    self.meth=@"nextHaiku";
    [self addCancelButton:@"hom"];
    [self addLeftButton:@"Compose" callingMethod:@"userWritesHaiku"];
    
    
    //Make sure category is right.
    
    NSString *cat=@"user";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", cat];
    NSArray *filteredArray = [self.gayHaiku filteredArrayUsingPredicate:predicate];
    if (self.selectedCategory==@"user" && filteredArray.count==0)
    {
        self.selectedCategory=@"Derfner";
        self.segContrAsOutlet.selectedSegmentIndex=0;
    }
    [self seeNavBar];
    
    //Display instructions.
    
    self.instructions = [[UITextView alloc] initWithFrame:CGRectMake(20, 44, 280, 480-44)];
    self.instructions.backgroundColor=[UIColor clearColor];
    self.instructionsSeen=YES;
    self.instructions.text = @"\nFor millennia, the Japanese haiku has allowed great thinkers to express their ideas about the world in three lines of five, seven, and five syllables respectively.  \n\nContrary to popular belief, the three lines need not be three separate sentences.  Rather, either the first two lines are one thought and the third is another or the first line is one thought and the last two are another; the two thoughts are often separated by punctuation.\n\nHave a fabulous time composing your own gay haiku.  Unless you opt out, I'd like to rely upon haiku you save as inspiration for future updates.";
    [self.view addSubview:self.instructions];
    [self loadToolbar];
    [self addToolbarButtons];
    [self resignFirstResponder];
    self.instructions.editable=NO;
}

//————————————————code for Amazon page——————————————————
   
#pragma mark -
#pragma Connection 


//Create navigation functionality for the UIWebView.

//Add a back button to the webview.
-(void)addBackButton
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:NSSelectorFromString(@"webBack")];
    self.titulus.leftBarButtonItem = button;
}

//Add a forward button to the webview.
-(void)addForwardButton
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Forward" style:UIBarButtonItemStyleBordered target:self action:NSSelectorFromString(@"webForward")];
    self.titulus.leftBarButtonItem = button;
}

//Allow the user to go to the previous web page.
-(void)webBack
{
    if (self.webV.canGoBack)
    {
        [self.webV goBack];
    }
}

//Allow the user to follow a link.
-(void)webForward
{
    if (self.webV.canGoForward)
    {
        [self.webV goForward];
    }
}

//Refreshes the current web page.
-(void)webRefresh
{
    [self.webV reload];
}

//Interrupts loading the current web page.
-(void)webStop
{
    [self.webV stopLoading];
}

//Load the web page of Joel Derfner's books.
-(void)loadAmazon
{    
    //Create nav bar and toolbar.
    [self clearScreen];
    [self.view viewWithTag:1].hidden=YES;
    [self loadNavBar:@"Buy"];
    self.titulus.hidesBackButton=YES;
    [self seeNavBar];
    [self loadToolbar];
    [self addToolbarDone];
    
    //Create UIWebView.
    self.webV = [[UIWebView alloc] init];
    self.webV.delegate = self;
    
    //Load Amazon page.
    NSString *baseURLString = @"http://www.amazon.com/Books-by-Joel-Derfner/lm/RVZNXKV59PL51/ref=cm_lm_byauthor_full";
    NSString *urlString = [baseURLString stringByAppendingPathComponent:@"http://www.amazon.com/Books-by-Joel-Derfner/lm/RVZNXKV59PL51/ref=cm_lm_byauthor_full"];
    [self connectWithURL:urlString andBaseURLString:baseURLString];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //Set up and display the navigation bar for the webview.
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    NSMutableArray *rightButtons = [[NSMutableArray alloc] init];
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:NSSelectorFromString(@"webRefresh")];
    UIBarButtonItem *stop = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:NSSelectorFromString(@"webStop")];
    [rightButtons addObject:stop];
    [rightButtons addObject:refresh];
    [self.bar removeFromSuperview];
    [self loadNavBar:@"Buy"];
    self.titulus.rightBarButtonItems=rightButtons;
    self.titulus.hidesBackButton=YES;
    if (self.webV.canGoBack)
    {
        UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:NSSelectorFromString(@"webBack")];
        [buttons addObject:back];
    }
    if (self.webV.canGoForward)
    {
        UIBarButtonItem *forward = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:NSSelectorFromString(@"webForward")];
        [buttons addObject:forward];
    }
    self.titulus.leftBarButtonItems=buttons;
    [self seeNavBar];
    [self.toolb removeFromSuperview];
    [self loadToolbar];
    [self addToolbarDone];
}

//Sets up and displays error message in case of failure to connect.
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)req navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType==UIWebViewNavigationTypeLinkClicked)
    {
        NSURL *scriptUrl = [NSURL URLWithString:@"http://www.google.com"];
        NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
        if (data == nil)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"I'm so sorry!" message:@"Unfortunately, I seem to be having a hard time connecting to the Internet.  Would you mind trying again later?  I promise to make it worth your while." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    return YES;
}

//Connect to the Internet.
-(void)connectWithURL:(NSString *)us andBaseURLString:(NSString *)bus
{
    NSURLRequest *reques = [NSURLRequest requestWithURL:[NSURL URLWithString:us] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval: 10];
    NSURLConnection *connectio = [[NSURLConnection alloc] initWithRequest:reques delegate:self];
    if (connectio)
    {
        [self.webV loadRequest:reques];
    }
    self.webV.scalesPageToFit=YES;
    [self.webV setFrame:(CGRectMake(0,44,320,372))];
    [self.view addSubview:self.webV];
}

//What to do in case of failure to connect.
-(BOOL)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"I'm so sorry!" message:@"Unfortunately, I seem to be having a hard time connecting to the Internet.  Would you mind trying again later?  I promise to make it worth your while." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    return YES;
}

//We're finished with Amazon.
-(void)doneWithAmazon
{
    [self clearScreen];
    [self nextHaiku];
}

//This gets back to the haiku once the user is done with other screens.
-(void)hom
{
    NSString *cat=@"user";
    NSArray *filteredArray;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", cat];
    filteredArray = [self.gayHaiku filteredArrayUsingPredicate:predicate];
    //The condition in this next line is true only when the user is NOT on the home screen.
    if ([self.view viewWithTag:3].hidden==YES)
    {
        if (self.selectedCategory==@"user" && filteredArray.count==0)
        {
            self.selectedCategory=@"Derfner";
            self.segContrAsOutlet.selectedSegmentIndex=0;
        }
            [self nextHaiku];
            [self previousHaiku];
    }
}

//————————————————code for compose page——————————————————

#pragma mark -
#pragma Compose

//This allows the user to edit haiku s/he's already written.
 -(void)editSavedHaiku
{
    self.textToSave = self.haiku_text.text;
    [self userWritesHaiku];
}

//Creates the button to save haiku the user has written.
 -(void)createSaveButton
{
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:3 target:self action:@selector(saveUserHaiku)];
    save.style=UIBarButtonItemStyleBordered;
    self.titulus.rightBarButtonItem = save;
}

//Creates the UITextView for the user to write haiku.
-(void)createSpaceToWrite
{
    [self.webV removeFromSuperview];
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 60, 280, 150)];
    self.textView.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    self.textView.userInteractionEnabled = YES;
    self.textView.backgroundColor = [UIColor colorWithRed:217 green:147 blue:182 alpha:.5];
    self.textView.delegate = self;
    [self.view addSubview: self.textView];
}

//If the user hasn't read the instructions before, this shows them the first time s/he pressed the compose button.
-(void)userNeedsInstructions
{
    NSString *cat = @"user";
    NSArray *filteredArray;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", cat];
    filteredArray = [self.gayHaiku filteredArrayUsingPredicate:predicate];
    if (self.instructionsSeen==NO && filteredArray.count == 0)
    {
        [self haikuInstructions];
    }
}

//This shows the cancel button if no text has been entered; if text has been entered, it shows the done button.
-(void)textViewDidChange:(UITextView *)view
{
    [self.bar removeFromSuperview];
    [self loadNavBar:@"Compose"];
    [self addLeftButton:@"Instructions" callingMethod:@"haikuInstructions"];
    if (view!=self.haiku_text)
    {
        if (view.text.length>0)
        {
            [self addDoneButton:@"userFinishedWritingHaiku"];
        }
        else
        {
            [self addCancelButton:@"hom"];
        }
    }
    [self seeNavBar];
}

//This sets up and displays the screen for the user to write haiku.
-(void)userWritesHaiku
{
    [self clearScreen];
    [self.view viewWithTag:5].hidden=YES;
    [self.view viewWithTag:6].hidden=YES;
    [self.view viewWithTag:7].hidden=YES;
    [self.view viewWithTag:8].hidden=YES;
    [self loadToolbar];
    [self addToolbarButtons];
    NSString *method;
    if (self.textView.text.length>0)
    {
        method=@"userFinishedWritingHaiku";
    }
    else
    {
        method=@"hom";
    }
    [self loadNavBar:@"Compose"];
    [self addLeftButton:@"Instructions" callingMethod:@"haikuInstructions"];
    [self addCancelButton:@"hom"];
    [self seeNavBar];
    
    //Create and add the space for user to write.
    
    if (self.instructionsSeen==YES)
    {
        [self createSpaceToWrite];
        if (self.textToSave!=@"")
        {
            self.textView.text = self.textToSave;
        }
        [self.view addSubview:self.textView];
        [self.textView becomeFirstResponder];
    
    //Keyboard notifications.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)    name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    else if (self.instructionsSeen==NO)
    {
        [self haikuInstructions];
    }
    [self.view viewWithTag:3].hidden=YES;
}

-(void)keyboardWillShow:(NSNotification *)aNotification
{
    if (self.textView.editable)
    {
    CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.view.frame;
    frame.size.height -= keyboardRect.size.height;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView commitAnimations];
    }
}

-(void)userFinishedWritingHaiku
{
    if (!self.textView || self.textView.text.length==0)
    {
        if (self.selectedCategory==@"user")
        {
            self.selectedCategory=@"Derfner";
            self.segContrAsOutlet.selectedSegmentIndex=0;
        }
            [self nextHaiku];
    }
    else
    {
        self.selectedCategory=@"user";
        self.segContrAsOutlet.selectedSegmentIndex=1;
        [self doActionSheet];
    }
}

-(void)doActionSheet
{
    self.textToSave=self.textView.text;
    UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:nil delegate: self cancelButtonTitle:@"Continue Editing" destructiveButtonTitle:@"Delete Haiku" otherButtonTitles:@"Save", @"Opt Out", nil];
    actSheet.tag=1;
    [actSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actSheet.tag==1)
        {
            if (buttonIndex==0)
            {
                [self nextHaiku];
            }
            else if (buttonIndex==1)
            {
                [self saveUserHaiku];
            }
            else if (buttonIndex==2)
            {
                [self takeToOptOut];
            }
            else
            {
                [actSheet dismissWithClickedButtonIndex:2 animated:YES];
            }
        }
        else if (actSheet.tag==2)
        {
            if (buttonIndex == 0)
            {
                 [self openMail];
            }
            else if (buttonIndex == 1)
            {
                [self faceBook];
            }
            else if (buttonIndex == 2)
            {
                [self twit];
            }
        }
}

-(void)twit
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result)
        {
            if (result == SLComposeViewControllerResultCancelled)
            {
                NSLog(@"Cancelled");
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tweet twitted." message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler =myBlock;
        [controller setInitialText:@"A gay haiku for your viewing pleasure."];
        [controller addURL:[NSURL URLWithString:@"http://www.gayhaiku.com"]];
        UIImage *img = [self createImage];
        [controller addImage:img];
        [self presentViewController:controller animated:YES completion:Nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"I'm sorry." message:@"I seem to be having trouble logging in to Twitter.  Would you mind checking your iPhone settings or trying again later?" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)faceBook
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled)
            {
                NSLog(@"Cancelled");
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Haiku posted." message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler = myBlock;
        [controller setInitialText:@"Here is a gay haiku.  Please love me?"];
        [controller addURL:[NSURL URLWithString:@"http://www.gayhaiku.com"]];
        UIImage *img = [self createImage];
        UIImage *pic = [self scaleImage:img];
        [controller addImage:pic];
        [self presentViewController:controller animated:YES completion:Nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"I'm sorry." message:@"I seem to be having trouble logging in to Facebook.  Would you mind checking your iPhone settings or trying again later?" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)deleteHaiku
{
    NSString *textToDelete = self.haiku_text.text;
    NSString *cat=@"user";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", cat];
    if ([self.gayHaiku filteredArrayUsingPredicate:predicate].count==1)
    {
        [self.gayHaiku removeObjectIdenticalTo:[[self.gayHaiku filteredArrayUsingPredicate:predicate]   objectAtIndex:0]];
        //filter so it's only user haiku that get saved here:
        [self saveToDocsFolder:@"gayHaiku.plist"];
    }
    else if ([self.gayHaiku filteredArrayUsingPredicate:predicate].count>1)
    {
        for (int i=0; i<[self.gayHaiku filteredArrayUsingPredicate:predicate].count; i++)
        {
            if ([[[[self.gayHaiku filteredArrayUsingPredicate:predicate] objectAtIndex:i] valueForKey:@"quote"] isEqualToString:textToDelete])
            {
                [self nextHaiku];
                [self.gayHaiku removeObjectIdenticalTo:[[self.gayHaiku filteredArrayUsingPredicate:predicate]   objectAtIndex:i]];
                [self saveToDocsFolder:@"gayHaiku.plist"];
                break;
            }

        }
    }
    [self saveToDocsFolder:@"gayHaiku.plist"];
    if ([self.gayHaiku filteredArrayUsingPredicate:predicate].count==0)
    {
        self.selectedCategory=@"Derfner";
        self.segContrAsOutlet.selectedSegmentIndex=0;
        [self nextHaiku];
    }
    textToDelete=@"";
}

-(void)keyboardWillHide:(NSNotification *)aNotification
{
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView commitAnimations];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveAction:)];
    self.navigationItem.rightBarButtonItem = saveItem;
}

-(void)saveUserHaiku
{   if (self.textView.text.length>0)
    {
        NSArray *quotes = [[NSArray alloc] initWithObjects:@"user", self.textView.text, nil];
        NSArray *keys = [[NSArray alloc] initWithObjects:@"category",@"quote",nil];
        NSDictionary *dictToSave = [[NSDictionary alloc] initWithObjects:quotes forKeys:keys];
        [[self gayHaiku] addObject:dictToSave];
        [self clearScreen];
        self.textToSave=@"";
        [self.view viewWithTag:1].hidden = NO;
        [self.view viewWithTag:3].hidden = NO;
        self.haiku_text.text = [[self.gayHaiku lastObject] valueForKey:@"quote"];
        [self.view addSubview:self.haiku_text];
        [self loadToolbar];
        [self addToolbarButtons];
        //[self saveToDocsFolder:@"gayHaiku.plist"];
        [self saveToDocsFolder:@"userHaiku.plist"];
        PFObject *haikuObject = [PFObject objectWithClassName:@"TestObject"];
        [haikuObject setObject:self.haiku_text.text forKey:@"haiku"];
        [haikuObject setObject:self.userName.text forKey:@"author"];
        NSString *perm;
        if (self.checkboxChecked)
        {
            perm=@"Yes";
        }
        else
        {
            perm=@"No";
        }
        [haikuObject setObject:perm forKey:@"permission"];
        [haikuObject saveEventually];
    }
}

-(void)saveToDocsFolder:(NSString *)string
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:string];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath: path])
    {
        NSString *cat=@"user";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", cat];
        NSArray *filteredArray = [self.gayHaiku filteredArrayUsingPredicate:predicate];
        [filteredArray writeToFile:path atomically:YES];
        //(used to be just [self.gayHaiku writeToFile:path atomically:YES
    }
}
  
//————————————————code for action sheet——————————————————

#pragma mark -
#pragma Share

-(UIImage *)createImage
{
    self.textView.editable = NO;
    CGRect newRect = CGRectMake(0, 0, 320, 416);
    UIGraphicsBeginImageContext(newRect.size); //([self.view frame].size])
    [self.view viewWithTag:3].hidden=YES;
    [[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *myImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIGraphicsBeginImageContext([self.view bounds].size);
    [myImage drawInRect:CGRectMake(0, 0, 320, 416)];
    myImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return myImage;
}

- (UIImage*) scaleImage:(UIImage*)image
{
    //Check to make sure this is right.  Then clean it up.
    CGSize scaledSize;
    scaledSize.height = 156; //Try with this value
    scaledSize.width = 120; //Try with this value
    UIGraphicsBeginImageContextWithOptions( scaledSize, NO, 0.0 );
    CGRect scaledImageRect = CGRectMake(0.0, 0.0, scaledSize.width, scaledSize.height);
    [image drawInRect:scaledImageRect];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)showMessage
{
    [self.instructions removeFromSuperview];
    [self.webV removeFromSuperview];
    //FIND WAY TO GET RID OF NEXT THREE LINES SO THAT CALLING METHOD DOESN'T MAKE IT SEEM LIKE YOU'RE MOVING TO THE PREVIOUS HAIKU.
    [self clearScreen];
    [self nextHaiku];
    [self previousHaiku];
    UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email",@"Facebook",@"Twitter", nil];
    actSheet.tag=2;
    [actSheet showInView:self.view];
}

-(void)takeToOptOut
{
    [self clearScreen];
    [self selectButton];
    [self loadNavBar:@"Your Haiku"];
    [self addLeftButton:@"Back" callingMethod:@"userWritesHaiku"];
    [self seeNavBar];
    self.userName.returnKeyType = UIReturnKeyDone;
    [self textFieldShouldReturn:self.userName];
    self.userName.delegate = self;
    [self.view viewWithTag:8].hidden=NO;
    [self.view viewWithTag:5].hidden=NO;
    [self.view viewWithTag:6].hidden=NO;
    [self.view viewWithTag:7].hidden=NO;
    [self loadToolbar];
    [self addToolbarButtons];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)displayButton
{
    if (self.checkboxChecked)
    {
        [self.checkbox setImage:[UIImage imageNamed:@"checkbox-checked.png"] forState:UIControlStateNormal];
    }
    else if (!self.checkboxChecked)
    {
        [self.checkbox setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)selectButton
{
    (self.checkboxChecked)=!(self.checkboxChecked);
    [self displayButton];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.checkboxChecked forKey:@"checked?"];
    [defaults synchronize];
}

- (void)openMail {
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:[NSString stringWithFormat:@"%@ has sent you a gay haiku.", [[UIDevice currentDevice] name]]];
        [self previousHaiku];
        [self nextHaiku];
        UIImage *myImage = [self createImage];
        NSData *imageData = UIImagePNGRepresentation(myImage);
        [mailer addAttachmentData:imageData mimeType:@"image/jpg" fileName:@"blah"];
        NSString *emailBody = @"I thought you might like this gay haiku from the Gay Haiku iPhone app.  Please love me?";
        [mailer setMessageBody:emailBody isHTML:NO];
        [self presentModalViewController:mailer animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"I'm sorry." message:@"Your device doesn't seem to be able to email this haiku.  Perhaps you'd like to tweet it or post it on Facebook instead?" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissModalViewControllerAnimated:YES];
}

//————————————————code for display page——————————————————

#pragma mark -
#pragma Main View

 - (IBAction)chooseDatabase:(UISegmentedControl *)segment
{
    if (segment.selectedSegmentIndex==1) {
        self.selectedCategory = @"user";
    }
    else if (segment.selectedSegmentIndex==2) {
        self.selectedCategory = @"all";
    }
    else {
        self.selectedCategory = @"Derfner";
    }
}


-(void)nextHaiku
{
    [self clearScreen];
    self.textToSave=@"";
    [self.view viewWithTag:3].hidden = NO;
    [self loadToolbar];
    if (self.selectedCategory==@"user")
    {
        //This isn't working for some reason--makes no sense.  If we remove the if statement and this is the ONLY toolbar that can load, it still doesn't load.  So it's something wrong with the toolbar itself.  If you take the self.de button away it still doesn't load.
        [self addToolbarButtonsPlusDelete];
    }
    else
    {
        [self addToolbarButtons];
    }
    int indexOfHaiku;
    NSMutableArray *arrayOfHaikuSeen;
    NSString *cat;
    if (!self.selectedCategory) cat = @"Derfner";
    else cat = self.selectedCategory;
    NSArray *filteredArray;
    if (cat==@"all")
    {
        filteredArray = self.gayHaiku;
        indexOfHaiku = self.indxAll;
        arrayOfHaikuSeen = self.theseAreDoneAll;
    }
    else
    {
        indexOfHaiku = (cat==@"user")?self.indxU:self.indxD;
        arrayOfHaikuSeen = (cat==@"user")?self.theseAreDoneU:self.theseAreDoneD;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", cat];
        filteredArray = [self.gayHaiku filteredArrayUsingPredicate:predicate];
    }
    int array_tot = [filteredArray count];
    int sortingHat;
    NSString *txt;
    if (array_tot > 0)
    {
        if (array_tot==1 && self.selectedCategory==@"user")
            {
                txt=self.haiku_text.text;
            }
        else if (indexOfHaiku == arrayOfHaikuSeen.count)
        {
            while (true)
            {
                sortingHat = (arc4random() % array_tot);
                if (![arrayOfHaikuSeen containsObject:[filteredArray objectAtIndex:sortingHat]]) break;
            }
            txt = [[filteredArray objectAtIndex:sortingHat] valueForKey:@"quote"];
            if (!arrayOfHaikuSeen || arrayOfHaikuSeen.count==array_tot)
            {
                arrayOfHaikuSeen = [[NSMutableArray alloc] init];
            }
            [arrayOfHaikuSeen addObject:[filteredArray objectAtIndex:sortingHat]];
            indexOfHaiku = arrayOfHaikuSeen.count;
            if (arrayOfHaikuSeen.count==filteredArray.count-1)
            {
                [arrayOfHaikuSeen removeAllObjects];
                indexOfHaiku=0;
            }
        }
        else 
        {
            txt = [[arrayOfHaikuSeen objectAtIndex:indexOfHaiku] valueForKey:@"quote"];
            indexOfHaiku += 1;
        }
    }
    if (self.selectedCategory==@"user")
    {
        self.textToDelete=txt;
    }
    self.haiku_text.text=@"";
    CGSize dimensions = CGSizeMake(320, 400);
    CGSize xySize = [txt sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14.0] constrainedToSize:dimensions lineBreakMode:0];
    self.haiku_text = [[UITextView alloc] initWithFrame:CGRectMake((320/2)-(xySize.width/2),150,320,200)];
    self.haiku_text.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    self.haiku_text.backgroundColor = [UIColor clearColor];
    self.haiku_text.text=txt;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromRight;
    transition.delegate = self;
    [self.view.layer addAnimation:transition forKey:nil];
    [self.view viewWithTag:5].hidden=YES;
    [self.view viewWithTag:6].hidden=YES;
    [self.view viewWithTag:7].hidden=YES;
    [self.view viewWithTag:8].hidden=YES;
    [self.view addSubview:self.haiku_text];
    if (cat==@"user")
    {
        self.theseAreDoneU = arrayOfHaikuSeen;
        self.indxU = indexOfHaiku;
    }
    else if (cat==@"all")
    {
        self.theseAreDoneAll = arrayOfHaikuSeen;
        self.indxAll = indexOfHaiku;
    }
    else 
    {
        self.theseAreDoneD = arrayOfHaikuSeen;
        self.indxD = indexOfHaiku;
    }
    self.haiku_text.editable=NO;
    self.instructions.editable=NO;
}

-(void)previousHaiku
{
    int indexOfHaiku;
    NSMutableArray *arrayOfHaikuSeen;
    NSString *cat;
    if (!self.selectedCategory) cat = @"Derfner";
    else cat = self.selectedCategory;
    NSArray *filteredArray;
    if (cat==@"all")
    {
        filteredArray = self.gayHaiku;
        indexOfHaiku = self.indxAll;
        arrayOfHaikuSeen = self.theseAreDoneAll;
    }
    else
    {
        indexOfHaiku = (cat==@"user")?self.indxU:self.indxD;
        arrayOfHaikuSeen = (cat==@"user")?self.theseAreDoneU:self.theseAreDoneD;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", cat];
        filteredArray = [self.gayHaiku filteredArrayUsingPredicate:predicate];
        if (cat==@"user")
        {
            [self.toolb removeFromSuperview];
            [self loadToolbar];
            [self addToolbarButtonsPlusDelete];
        }
    }
    if (arrayOfHaikuSeen.count>1 && indexOfHaiku>1)
    {
        [self clearScreen];
        [self.webV removeFromSuperview];
        [self.bar removeFromSuperview];
        [self loadToolbar];
        [self addToolbarButtons];
        [self.view viewWithTag:3].hidden=NO;
        indexOfHaiku -= 1;
        CGSize dimensions = CGSizeMake(320, 400);
        CGSize xySize = [[[arrayOfHaikuSeen objectAtIndex:indexOfHaiku-1] valueForKey:@"quote"] sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14.0] constrainedToSize:dimensions lineBreakMode:0];
        [self.haiku_text removeFromSuperview];
        self.haiku_text = [[UITextView alloc] initWithFrame:CGRectMake((320/2)-(xySize.width/2),150,320,200)];
        self.haiku_text.text = [[arrayOfHaikuSeen objectAtIndex:indexOfHaiku-1] valueForKey:@"quote"];
        self.haiku_text.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
        self.haiku_text.backgroundColor = [UIColor clearColor];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.25;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype =kCATransitionFromLeft;
        transition.delegate = self;
        [self.view.layer addAnimation:transition forKey:nil];
        [self.view addSubview:self.haiku_text];
    }
    if (cat==@"user")
    {
        self.theseAreDoneU = arrayOfHaikuSeen;
        self.indxU = indexOfHaiku;
        self.textToDelete=self.haiku_text.text;
    }
    else if (cat==@"all")
    {
        self.theseAreDoneAll = arrayOfHaikuSeen;
        self.indxAll = indexOfHaiku;
    }
    else
    {
        self.theseAreDoneD = arrayOfHaikuSeen;
        self.indxD = indexOfHaiku;
    }
    self.haiku_text.editable=NO;
}

/*
- (void)showHideView:(id)sender
{
    // Fade out the view right away
    [UIView animateWithDuration:1.0
                          delay: 5.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         thirdView.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         // Wait one second and then fade in the view
                         [UIView animateWithDuration:1.0
                                               delay: 1.0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              thirdView.alpha = 1.0;
                                          }
                                          completion:nil];
                     }];
}
*/
- (IBAction)valueChanged:(UISegmentedControl *)sender
{
    NSString *cat;
    if (!self.selectedCategory) cat = @"Derfner";
    else cat = self.selectedCategory;
    NSArray *filteredArray;
    if (cat==@"all")
    {
        filteredArray = self.gayHaiku;
    }
    else
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", cat];
        filteredArray = [self.gayHaiku filteredArrayUsingPredicate:predicate];
    }
    if (sender.selectedSegmentIndex==1 && filteredArray.count==0 && self.instructionsSeen==YES)
    {
        [self userWritesHaiku];
    }
    else if (sender.selectedSegmentIndex==1 && filteredArray.count==0 && self.instructionsSeen==NO)
    {
        [self userNeedsInstructions];
    }
    else if (sender.selectedSegmentIndex==1 && filteredArray.count!=0)
    {
        NSLog(@"%@",filteredArray);
        [self nextHaiku];
    }
    else if (sender.selectedSegmentIndex==0)
    {
        [self nextHaiku];
    }
}

@end