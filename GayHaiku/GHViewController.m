//
//  GHViewController.m
//  Gay Haiku
//
//  Created by Joel Derfner on 7/22/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

/*
 Code I don't know how to write:
 
 1.  Fix keyboard thing.
 
 2.  Get "back" button to appear if user clicks a link in UIWebView but not otherwise.
 Is it necessary to create GHWebView as a separate class?
 
 3.  Write code that gives error if user tries to click on Amazon and a
 connection isn't available.  Use Reachability classes I just downloaded?
 
 4.  Connect app to central database so that haiku can be sent there.
 
 5.  Need to get checkbox in opt-out working (I can probably figure this out) and opt-out connected to database (no clue).
 
 Other thoughts:
 
 6.  Question:  how will it affect the user's experience if/when haiku
 s/he's already seen in "user" or "Derfner" categories reappear in "all"
 category?  Will this need to be adjusted?  If so, how?

 */

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import "GHViewController.h"
#import <Twitter/Twitter.h>
#import <Twitter/TWTweetComposeViewController.h>
//#import <MobileCoreServices/MobileCoreServices.h>
#import <FacebookSDK/FacebookSDK.h>

@interface GHViewController ()<UITextViewDelegate,MFMailComposeViewControllerDelegate,UIAlertViewDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,UITextFieldDelegate,MFMessageComposeViewControllerDelegate>

@end

@implementation GHViewController
@synthesize userName;
@synthesize segContrAsOutlet;
@synthesize checkbox;

@synthesize gayHaiku, textView, titulus, bar, instructions, textToSave, haiku_text, selectedCategory, webV, theseAreDoneAll, theseAreDoneD, theseAreDoneU, indxAll, indxD, indxU, tweetView, toolb, tb, instructionsSeen, savedEdit, boxSelected, meth;


//————————————————code for all pages——————————————————

-(void)viewDidLoad {
	[super viewDidLoad];
    
    /*TEMPORARILY CODED OUT
    //Swipe gesture recognizers
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previousHaiku)];
    swipeRight.numberOfTouchesRequired = 1;
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextHaiku)];
    swipeLeft.numberOfTouchesRequired = 1;
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    */
     
    /*TEMPORARILY CODED OUT
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
    self.gayHaiku = [[NSMutableArray alloc] initWithContentsOfFile: path];
    */
    //Visual elements
    [self.view viewWithTag:5].hidden=YES;
    [self.view viewWithTag:6].hidden=YES;
    [self.view viewWithTag:7].hidden=YES;
    [self.view viewWithTag:8].hidden=YES;
    self.checkboxSelected=NO;
    //TEMPORARILY COMMENTED OUT
    //[self nextHaiku];
}
/* TEMPORARILY CODED OUT
-(void)clearScreen
{
    [self.instructions removeFromSuperview];
    [self.textView removeFromSuperview];
    [self.haiku_text removeFromSuperview];
    [self.bar removeFromSuperview];
    [self.toolb removeFromSuperview];
    [self.webV removeFromSuperview];
    [self.toolb removeFromSuperview];
    [self.view viewWithTag:3].hidden=YES;
}
 */

-(void)viewDidUnload
{
    /*[self setSegContrAsOutlet:nil];
    self.boxSelected=NO;
    [self setUserName:nil];
    self.instructionsSeen=NO;
    self.savedEdit=NO;*/
    [super viewDidUnload];
}

//————————————————code to set up navBars——————————————————

/*-(void)loadNavBar:(NSString *)titl
{
    self.bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.titulus = [[UINavigationItem alloc] initWithTitle:titl];
}

-(void)addLeftButton:(NSString *)titl callingMethod:(NSString *)method
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:titl style:UIBarButtonItemStyleBordered target:self action:NSSelectorFromString(method)];
    self.titulus.leftBarButtonItem = button;
}

-(void)createCancelButton
{
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:1 target:self action:@selector(userWritesHaiku)];
    
    cancel.style=UIBarButtonItemStyleBordered;
}

-(void)addDoneButton
{
    NSString *blah=self.meth;
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:0 target:self action:NSSelectorFromString(blah)];
    done.style=UIBarButtonItemStyleBordered;
    self.titulus.rightBarButtonItem = done;
}

/*-(void)addRightButton:(NSString *)titl callingMethod:(NSString *)method
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:titl style:UIBarButtonItemStyleBordered target:self action:NSSelectorFromString(method)];
    self.titulus.rightBarButtonItem = button;
}

-(void)addRightButtons:(NSArray *)titl callingMethod:(NSArray *)method
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:[titl objectAtIndex:0] style:UIBarButtonItemStyleBordered target:self action:NSSelectorFromString([method objectAtIndex:0])];
    UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithTitle:[titl objectAtIndex:1] style:UIBarButtonItemStyleBordered target:self action:NSSelectorFromString([method objectAtIndex:1])];
    NSArray *buttons = [[NSArray alloc] initWithObjects:button, button2, nil];
    self.titulus.rightBarButtonItems = buttons;
}*/
/*
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

-(void)addComposeAndAction
{
    UIBarButtonItem *compose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:7 target:self action:@selector(userWritesHaiku)];
    
    compose.style=UIBarButtonItemStyleBordered;
  
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *action = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:9 target:self action:@selector(showMessage)];
    
    action.style=UIBarButtonItemStyleBordered;
    
    NSArray *buttons = [NSArray arrayWithObjects: flex, compose, flex, action, flex, nil];
    [self.toolb setItems:buttons animated:NO];
}

-(void)addComposeAndActionAndMore
{
    UIBarButtonItem *compose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:7 target:self action:@selector(userWritesHaiku)];
    
    compose.style=UIBarButtonItemStyleBordered;
    
    UIBarButtonItem *action = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:9 target:self action:@selector(showMessage)];
    
    action.style=UIBarButtonItemStyleBordered;
 
    UIBarButtonItem *more = [[UIBarButtonItem alloc] initWithTitle:@"More" style:UIBarButtonItemStyleBordered target:self action:@selector(loadAmazon)];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    NSArray *buttons = [NSArray arrayWithObjects:compose, flex, action, flex, more, nil];
    [self.toolb setItems:buttons animated:NO];
    
}

-(void)addComposeAndActionAndMoreAndDelete
{
    UIBarButtonItem *compose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:7 target:self action:@selector(userWritesHaiku)];
    
    compose.style=UIBarButtonItemStyleBordered;
    
    UIBarButtonItem *action = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:9 target:self action:@selector(showMessage)];
    
    action.style=UIBarButtonItemStyleBordered;
    
    UIBarButtonItem *more = [[UIBarButtonItem alloc] initWithTitle:@"More" style:UIBarButtonItemStyleBordered target:self action:@selector(loadAmazon)];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editSavedHaiku)];
    
    UIBarButtonItem *delete = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteHaiku)];
    
    NSArray *buttons = [NSArray arrayWithObjects:compose, flex, action, flex, edit, flex, delete, flex, more, nil];
    [self.toolb setItems:buttons animated:NO];
}
*/

//————————————————code for Instructions page——————————————————
/* TEMPORARILY CODED OUT
-(void)haikuInstructions
{
    self.textToSave = self.textView.text;
    [self clearScreen];
    //TEMPORARILY COMMENTED OUT
    //[self loadNavBar:@"Instructions"];
    self.meth=@"userWritesHaiku";
        //TEMPORARILY COMMENTED OUT
    //[self addDoneButton];
    //Why does hitting Compose send nextHaiku rather than userWritesHaiku?
        //TEMPORARILY COMMENTED OUT
    //[self addLeftButton:@"Compose" callingMethod:@"userWritesHaiku"];
    NSString *cat=@"user";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", cat];
    NSArray *filteredArray = [self.gayHaiku filteredArrayUsingPredicate:predicate];
    if (self.selectedCategory==@"user" && filteredArray.count==0)
    {
        self.selectedCategory=@"Derfner";
        self.segContrAsOutlet.selectedSegmentIndex=0;
    }
        //TEMPORARILY COMMENTED OUT
    //[self seeNavBar];
    self.instructions = [[UITextView alloc] initWithFrame:CGRectMake(20, 44, 280, 480-44)];
    self.instructions.backgroundColor=[UIColor clearColor];
        //TEMPORARILY COMMENTED OUT
    //[self loadToolbar];
        //TEMPORARILY COMMENTED OUT
    //[self addComposeAndActionAndMore];
    self.instructionsSeen=YES;
    self.instructions.text = @"\n\nFor millennia, the Japanese haiku has allowed great thinkers to express their ideas about the world in three lines of five, seven, and five syllables respectively.  \n\nContrary to popular belief, the three lines need not be three separate sentences.  Rather, either the first two lines are one thought and the third is another or the first line is one thought and the last two are another; the two thoughts are often separated by punctuation or an interrupting word.\n\nHave a fabulous time composing your own gay haiku.  Be aware that the author of this program may rely upon haiku you save as inspiration for future updates.";
    [self.view addSubview:self.instructions];
}
*/
//————————————————code for Amazon page——————————————————
      /*
-(void)addBackButton
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(webBack)];
    self.titulus.leftBarButtonItem = button;
}*/
/*TEMPORARILY COMMENTED OUT
-(void)loadAmazon
{    
    //Create nav bar and toolbar.
    [self clearScreen];
    [self.view viewWithTag:1].hidden=YES;
    [self loadNavBar:@"Joel Derfner's Books"];
    [self addBackButton];
    [self.titulus.leftBarButtonItem setEnabled:[self.webV canGoBack]];
    self.meth=@"nextHaiku";
    [self addDoneButton];
    self.titulus.hidesBackButton=YES;
    [self seeNavBar];
    [self loadToolbar];
    [self addComposeAndAction];
    
    //Create UIWebView.
    self.webV.delegate = self;
    self.webV = [[UIWebView alloc] init];
    
    //Load Amazon page.
     NSData *urlData;
     NSString *baseURLString =  @"http://www.amazon.com/Books-by-Joel-Derfner/lm/RVZNXKV59PL51/ref=cm_lm_byauthor_full";
     NSString *urlString = [baseURLString stringByAppendingPathComponent:@"http://www.amazon.com/Books-by-Joel-Derfner/lm/RVZNXKV59PL51/ref=cm_lm_byauthor_full"];
     NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval: 20];
     NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:nil];
     NSError *error=nil;
     NSURLResponse *response=nil;
     if (connection)
     {
         urlData = [ NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&error];
     NSString *htmlString = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
     [self.webV loadHTMLString:htmlString baseURL:[NSURL URLWithString:baseURLString]];
     }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.title = @"Yuck!";
        NSLog(@"Yuck.");
        [alert show];
    }
    self.webV.scalesPageToFit=YES;
    [self.webV setFrame:(CGRectMake(0,44,320,372))];
    [self.view addSubview:self.webV];
}
  */
    //NEED TO ADD:  Code that displays an error message if user clicks on Amazon link while not connected.  It's this next method, I just don't understand how it works.
/*TEMPORARILY CODED OUT
-(void)webView:(UIWebView *)webview didFailLoadWithError:(NSError *)error {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Sucks to be you."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    NSLog(@"Yuck.");
    NSLog(@"error: %@",[error localizedDescription]);
}
*/
//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedString ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];

/*TEMPORARILY CODED OUT
-(void)doneWithAmazon
{
    [self clearScreen];
    [self nextHaiku];
}

-(void)webBack
{
    if (self.webV.canGoBack)
    {
        [self.webV goBack];
    }
}
 */

//————————————————code for compose page——————————————————


/*TEMPORARILY CODED OUT
 -(void)editSavedHaiku
{
    self.textToSave = self.haiku_text.text;
    self.savedEdit=YES;
    [self userWritesHaiku];
}*/

/*TEMPORARILY CODED OUT
 -(void)createSaveButton
{
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:3 target:self action:@selector(saveUserHaiku)];
    
    save.style=UIBarButtonItemStyleBordered;
    
    self.titulus.rightBarButtonItem = save;
}*/

/*TEMPORARILY CODED OUT FOR TESTING.
 
-(void)createSpaceToWrite
{
    [self.webV removeFromSuperview];
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 60, 280, 150)];
    self.textView.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    self.textView.userInteractionEnabled = YES;
    self.textView.backgroundColor = [UIColor colorWithRed:217 green:147 blue:182 alpha:.5];
    [self.view addSubview: self.textView];
}*/
/*
-(void)userNeedsInstructions
{
    NSString *cat = @"user";
    NSArray *filteredArray;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", cat];
    filteredArray = [self.gayHaiku filteredArrayUsingPredicate:predicate];
    if (self.instructionsSeen==NO && filteredArray.count == 0)
    {
            //TEMPORARILY COMMENTED OUT
        //[self haikuInstructions];
    }
}
*/
/*TEMPORARILY CODED OUT
-(void)userWritesHaiku
{
    NSLog(@"instructionsSeen at beginning of userWritesHaiku:  %d",self.instructionsSeen);
    [self clearScreen];
    [self.view viewWithTag:5].hidden=YES;
    [self.view viewWithTag:6].hidden=YES;
    [self.view viewWithTag:7].hidden=YES;
    [self.view viewWithTag:8].hidden=YES;
    [self loadNavBar:@"Compose"];
    [self addLeftButton:@"Instructions" callingMethod:@"haikuInstructions"];
    self.meth=@"userFinishedWritingHaiku";
    [self addDoneButton];
    self.titulus.hidesBackButton=YES;
    [self seeNavBar];
    [self loadToolbar];
    [self addComposeAndActionAndMore];
    
    //Create and add the space for user to write.
    if (self.instructionsSeen==YES)
    {
        //[self createSpaceToWrite];
        if (self.textToSave!=@"")
        {
            self.textView.text = self.textToSave;
        }
        [self.view addSubview:self.textView];
    
        //NOTE:  IF THE NEXT LINE IS REMOVED, WHEN THE USER TOUCHES THE "COMPOSE" BUTTON, THE COMPOSE SPACE SHOWS UP BUT THE KEYBOARD DOESN'T AUTOMATICALLY APPEAR--IT'S ONLY WHEN THE USER TOUCHES INSIDE THE COMPOSE SPACE THAT THE KEYBOARD APPEARS.  PERHAPS THIS CAN HELP WITH THE GODDAMN KEYBOARD PROBLEM.
        [self.textView becomeFirstResponder];
    
        //Keyboard notifications.
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)    name:UIKeyboardWillShowNotification object:nil];
        
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    else if (self.instructionsSeen==NO)
    {
        [self haikuInstructions];
    }
}*/

/*TEMPORARILY CODED OUT.
 
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
}*/
/*
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
        [self doActionSheet];
    }
}

-(void)doActionSheet
{
    self.textToSave=self.textView.text;
    UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:nil delegate: self cancelButtonTitle:@"Continue Editing" destructiveButtonTitle:@"Delete Haiku" otherButtonTitles:@"Save", @"Opt Out", nil];
    actSheet.tag=1;
    [actSheet showInView:self.view];
}*/
/*
-(void)actionSheet:(UIActionSheet *)actSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"actSheet.tag:  %d",actSheet.tag);
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
                //TEMPORARILY CODED OUT
                //[self takeToOptOut];
            }
            else
            {
                [actSheet dismissWithClickedButtonIndex:2 animated:YES];
            }
        }
        else if (actSheet.tag==2)
        {
            if (buttonIndex == 1)
            {*/
                /*TEMPORARILY CODED OUT
                 [self openMail];
                 */
            /*}
            else if (buttonIndex == 2)
            {
                //Deal with Facebook API.
                NSLog(@"Sent to Facebook.");
            }
            else if (buttonIndex == 3)
            {
                TEMPORARILY CODED OUT
                 [self tweetTapped];
                 
            }
        }
}

-(void)deleteHaiku
{
    NSString *textToDelete = self.haiku_text.text;
    NSString *cat=@"user";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", cat];
    NSArray *blah = [self.gayHaiku filteredArrayUsingPredicate:predicate];
    if (blah.count>0)
    for (int i=0; i<blah.count; i++)
    {
        if ([[[blah objectAtIndex:i] valueForKey:@"quote"] isEqualToString:textToDelete])
        {
            [self.gayHaiku removeObjectIdenticalTo:[blah objectAtIndex:i]];
            [self saveToDocsFolder:@"gayhaiku.plist"];
            if (blah.count>1)
            {
                [self nextHaiku];   
            }
            else if (blah.count==1)
            {
                    //TEMPORARILY COMMENTED OUT
                //[self haikuInstructions];
            }
            break;
        }
    }
}
*/
/*TEMPORARILY CODED OUT.

-(void)keyboardWillHide:(NSNotification *)aNotification
{
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView commitAnimations];
}*/

/*- (void)textViewDidBeginEditing:(UITextView *)textView
{
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveAction:)];
    self.navigationItem.rightBarButtonItem = saveItem;
}*/
/*
-(void)saveUserHaiku
{   if (self.textView.text.length>0)
    {
        NSArray *quotes = [[NSArray alloc] initWithObjects:@"user", self.textView.text, nil];
        NSArray *keys = [[NSArray alloc] initWithObjects:@"category",@"quote",nil];
        NSDictionary *dictToSave = [[NSDictionary alloc] initWithObjects:quotes forKeys:keys];
        [[self gayHaiku] addObject:dictToSave];
        //[self clearScreen];
        self.textToSave=@"";
        [self.view viewWithTag:1].hidden = NO;
        [self.view viewWithTag:3].hidden = NO;
        self.haiku_text.text = [[self.gayHaiku lastObject] valueForKey:@"quote"];
        [self.view addSubview:self.haiku_text];
            //TEMPORARILY COMMENTED OUT
        //[self loadToolbar];
        //[self addComposeAndActionAndMore];
        [self saveToDocsFolder:@"gayHaiku.plist"];
    }
}
*/
/*
-(void)saveToDocsFolder:(NSString *)string
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:string];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath: path])
    {
        [self.gayHaiku writeToFile:path atomically:YES];
    }
}
*/
    /*
     
     This is part of the code to get haiku to "haiku" table on "gayhaiku" MySQL on db.joelderfner.com, but I have no idea what the fuck it says.  Or, rather, I can tell what it says, on a very basic level, sort of, but not how to set up what it's sending the message to.  "gayhaiku'."haiku" is set up, but what's the mechanism to get this haiku there?
     
     NSString *myRequestString = [NSString stringWithFormat:@"%@",self.haiku_text.text];
     NSData *myRequestData = [NSData dataWithBytes:[myRequestString UTF8String] length:[myRequestString length]];
     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.joelderfner.com/"]];
     [request setHTTPMethod: @"POST"];
     [request setHTTPBody: myRequestData];
     NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
     NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
     // To see what the response from your server is, NSLog returnString to the console or use it whichever way you want it.
     NSLog (@"%@", returnString);
     */
  
//————————————————code for action sheet——————————————————
/*
-(UIImage *)createImage
{
    UIView *whatToUse;
    self.textView.editable = NO;
    [whatToUse viewWithTag:10];
    [whatToUse viewWithTag:20];
    CGRect newRect = CGRectMake(0, 0, 320, 416);
    UIGraphicsBeginImageContext(newRect.size); //([self.view frame].size])
    [self.view viewWithTag:30].hidden=YES;
    [self.view viewWithTag:40].hidden=YES;
    [self.view viewWithTag:3].hidden=YES;
    
    [[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *myImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext([self.view bounds].size);
    [myImage drawInRect:CGRectMake(0, 0, 320,416)];
    myImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return myImage;
}
*/
//Replace this with an action sheet after finding out what an action sheet is.
/*
-(void)showMessage
{
    [self.webV removeFromSuperview];
    UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email",@"Facebook",@"Twitter",@"Opt-Out", nil];
    actSheet.tag=2;
    [actSheet showInView:self.view];
    //UIAlertView *message = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Email",@"Facebook",@"Twitter", nil];
    //[message show];
}*/
/* TEMPORARILY COMMENTED OUT
-(void)takeToOptOut
{
    [self clearScreen];
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
    [self addComposeAndActionAndMore];
    //Need to connect this with database.
    //Need to get checkbox working.
}
 */
/*
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
*/
/*
- (IBAction)SelectButton
{
    if (self.boxSelected == 0)
    {
        self.boxSelected = 1;
    }
    else
    {
        self.boxSelected = 0;
    }
}
*/
/*TEMPORARILY CODED OUT.
- (void)tweetTapped
{
    if ([TWTweetComposeViewController canSendTweet])
    {
        TWTweetComposeViewController *tweetSheet =
        [[TWTweetComposeViewController alloc] init];
        [tweetSheet setInitialText:
         @"Ignore this tweet--testing something."];
        [self presentModalViewController:tweetSheet animated:YES];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"Can't send."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}*/
/*TEMPORARILY CODED OUT.

- (void)openMail {
    if ([MFMailComposeViewController canSendMail]) {
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
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure." message:@"Your device doesn't support the composer sheet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}*/

/*
 
    APPARENTLY THIS CODE ENABLES DEALING WITH FACEBOOK?  BUT FACEBOOK ISN'T RECOGNIZED AS A POSSIBLE VARIABLE.  WTF!?!?

    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        Facebook *facebook = [[Facebook alloc] initWithAppId:@"XXXXXXXXXX" andDelegate:fbControl];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"FBAccessTokenKey"]
            && [defaults objectForKey:@"FBExpirationDateKey"]) {
            facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
            facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        }
        
        if (![facebook isSessionValid]) {
            [facebook authorize:nil];
        }
        
    }
    
    - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [facebook handleOpenURL:url];
}
    
    - (void)fbDidLogin {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
        [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
        [defaults synchronize];
        
        [facebook dialog:@"feed" andDelegate:self];
    }
*/
 /*
-(void)postToFacebook
{
    UIImage *pic = [self createImage];
    NSString *list = self.haiku_text.text;
    NSString *kAppId=@"446573368720507";
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:kAppId, @"app_id",nil, @"link", pic, @"picture",@"Gay Haiku", @"name",nil, @"caption",@"Maybe he'll love me if I give him a gay haiku....",@"description",nil];
    
}
*/
/*
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{  
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}
*/
//- work this:


//————————————————code for display page——————————————————

/*

An attempt to create the segmented control programmatically--but I somehow can't connect it to anything.  Argh!

-(UISegmentedControl *)createSegmentedControl
{
    NSArray *items = [[NSArray alloc] initWithObjects:@"Gay Haiku",@"My Haiku",@"All Haiku", nil];
    UISegmentedControl *segContr = [[UISegmentedControl alloc] initWithItems:items];
    segContr.frame = CGRectMake(20, 40, 280, 25);
    segContr.tintColor=[UIColor colorWithRed:217/256.0 green:147/256.0 blue:182/256.0 alpha:1.0];
    //segContr.backgroundColor=[UIColor colorWithRed:217/256.0 green:147/256.0 blue:182/256.0 alpha:1.0];
    segContr.segmentedControlStyle = UISegmentedControlStyleBar;
    if (segContr.selectedSegmentIndex==1) {
        self.selectedCategory = @"user";
        NSString *method;
        if (segContr.selectedSegmentIndex==1 && self.instructionsSeen==NO)
        {
            method=@"userNeedsInstructions";
        }
        else if (segContr.selectedSegmentIndex==1 && self.instructionsSeen==YES)
        {
            method=@"userWritesHaiku";
        }
        [segContr addTarget:self action:NSSelectorFromString(method) forControlEvents:UIControlEventValueChanged];
    }
    else if (segContr.selectedSegmentIndex==2) {
        self.selectedCategory = @"all";
    }
    else {
        self.selectedCategory = @"Derfner";
    }
    [self.view addSubview:segContr];
    return segContr;
}

*/
/*
 - (IBAction)chooseDatabase:(UISegmentedControl *)segment 
 {
    if (segment.selectedSegmentIndex==1) {
        self.selectedCategory = @"user";
        //[self valueChanged:segment];
    }
    else if (segment.selectedSegmentIndex==2) {
        self.selectedCategory = @"all";
    }
    else {
        self.selectedCategory = @"Derfner";
    }
}
 */
/*
-(void)nextHaiku
{
    [self clearScreen];
    self.textToSave=@"";
    self.haiku_text.text=@"";
    [self.view viewWithTag:3].hidden = NO;
    [self loadToolbar];
    [self addComposeAndActionAndMore];
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
            [self addComposeAndActionAndMoreAndDelete];
        }
    }
    int array_tot = [filteredArray count];
    int sortingHat;
    NSString *txt;
    if (array_tot > 0)
    {
        if (indexOfHaiku == arrayOfHaikuSeen.count)
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
            if (arrayOfHaikuSeen.count==filteredArray.count)
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

    CGSize dimensions = CGSizeMake(320, 400);
    CGSize xySize = [txt sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14.0] constrainedToSize:dimensions lineBreakMode:0];
    self.haiku_text = [[UITextView alloc] initWithFrame:CGRectMake((320/2)-(xySize.width/2),200,320,200)];
    self.haiku_text.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    self.haiku_text.backgroundColor = [UIColor clearColor];
    self.haiku_text.text=txt;
    self.haiku_text.editable=NO;
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
    
    //Question:  how will it affect the user's experience if/when haiku s/he's already seen in "user" or "Derfner" categories reappear in "all" category?  Will this need to be adjusted?  If so, how?
}
*/

/* TEMPORARILY CODED OUT
-(void)previousHaiku
{
    [self clearScreen];
    [self.webV removeFromSuperview];
    [self.bar removeFromSuperview];
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
                [self addComposeAndActionAndMoreAndDelete];
            }
        }
        [self.view viewWithTag:1].hidden = NO;
        //[self.view viewWithTag:3].hidden = NO;
    
        if (arrayOfHaikuSeen.count>=2 && indexOfHaiku>=2)
        {
            indexOfHaiku -= 1;
            CGSize dimensions = CGSizeMake(320, 400);
            CGSize xySize = [[[arrayOfHaikuSeen objectAtIndex:indexOfHaiku] valueForKey:@"quote"] sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14.0] constrainedToSize:dimensions lineBreakMode:0];
            [self.haiku_text removeFromSuperview];
            self.haiku_text = [[UITextView alloc] initWithFrame:CGRectMake((320/2)-(xySize.width/2),200,320,200)];

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
}
*//*
- (IBAction)valueChanged:(UISegmentedControl *)sender
{
        if (sender.selectedSegmentIndex==1 && self.instructionsSeen==YES)
        {
                [self userWritesHaiku];
        }
        else if (sender.selectedSegmentIndex==1 && self.instructionsSeen==NO)
        {
            //[self userNeedsInstructions];
        }
}*/

@end
