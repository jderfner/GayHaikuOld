//
//  GHViewController.m
//  Gay Haiku
//
//  Created by Joel Derfner on 7/22/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

/*
 //write code that runs haikuInstructions if user presses "My Haiku" in the segmented controller and it's never been pressed before:
 //Question:  what's the listener that hears when the user has clicked a link so that it can add the left bar button "Back" to the nav bar?
 //The answer might be that I have to make UIWebView a separate class.
 //NEED TO ADD:  Code that displays an error message if user clicks on Amazon link while not connected.
 Still to do:
 Give user chance to opt out of sending any haiku s/he composes to my central database.
 //CHECK TO MAKE SURE THERE ISN'T ALREADY A USER HAIKU WITH THIS TEXT.
 //Should there be an option to DELETE haiku the user has written?
 //Question:  how will it affect the user's experience if/when haiku s/he's already seen in "user" or "Derfner" categories reappear in "all" category?  Will this need to be adjusted?  If so, how?
 //Need to test to make sure it starts over once all 110 haiku have been seen.
 */

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import "GHViewController.h"
#import <Twitter/Twitter.h>
#import <Twitter/TWTweetComposeViewController.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <FacebookSDK/FacebookSDK.h>

@interface GHViewController ()<UITextViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UIAlertViewDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePic;
@property (strong, nonatomic) IBOutlet UIButton *buttonPostStatus;
@property (strong, nonatomic) IBOutlet UIButton *buttonPostPhoto;
@property (strong, nonatomic) IBOutlet UIButton *buttonPickFriends;
@property (strong, nonatomic) IBOutlet UIButton *buttonPickPlace;
@property (strong, nonatomic) IBOutlet UILabel *labelFirstName;
@property (strong, nonatomic) FBLoginView *loginView;
@property (strong, nonatomic) id<FBGraphUser> loggedInUser;

- (IBAction)postStatusUpdateClick:(UIButton *)sender;
- (IBAction)postPhotoClick:(UIButton *)sender;
- (IBAction)pickFriendsClick:(UIButton *)sender;
- (IBAction)pickPlaceClick:(UIButton *)sender;

- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error;


@end

@implementation GHViewController

@synthesize gayHaiku, textView, titulus, bar, instructions, textToSave, haiku_text, selectedCategory, webV, theseAreDoneAll, theseAreDoneD, theseAreDoneU, indxAll, indxD, indxU, tweetView, toolb, tb, instructionsSeen;

@synthesize buttonPostStatus = _buttonPostStatus;
@synthesize buttonPostPhoto = _buttonPostPhoto;
@synthesize buttonPickFriends = _buttonPickFriends;
@synthesize buttonPickPlace = _buttonPickPlace;
@synthesize labelFirstName = _labelFirstName;
@synthesize loggedInUser = _loggedInUser;
@synthesize profilePic = _profilePic;
@synthesize loginView = _loginView;


//————————————————code for all pages——————————————————

-(void)viewDidLoad {
	[super viewDidLoad];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previousHaiku)];
    swipeRight.numberOfTouchesRequired = 1;
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextHaiku)];
    swipeLeft.numberOfTouchesRequired = 1;
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
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
    
    //write code that runs haikuInstructions if user presses "My Haiku" in the segmented controller and it's never been pressed before:
    //if ([self chooseDatabase:1] && self.gayHaiku==0)
    
    //Here's the facebook stuff:
    
    //FBLoginView *loginview =
    
    self.loginView = 
    [[FBLoginView alloc] initWithPermissions:[NSArray arrayWithObject:@"status_update"]];
    
    self.loginView.frame = CGRectOffset(self.loginView.frame, 5, 5);
    //THIS NEXT LINE IS NOT GOOD.
    self.loginView.delegate = self;
    
    [self.loginView sizeToFit];
    
    [self nextHaiku];
}

-(void)clearScreen
{
    [self.instructions removeFromSuperview];
    [self.textView removeFromSuperview];
    self.textView.hidden = YES;
    [self.haiku_text removeFromSuperview];
    [self.bar removeFromSuperview];
    [self.toolb removeFromSuperview];
    [self.webV removeFromSuperview];
    self.textView.text=@"";
    [self.toolb removeFromSuperview];
    [self.view viewWithTag:3].hidden=YES;
    self.textView.editable=NO;
}

-(void)viewDidUnload
{
	[super viewDidUnload];
}

//————————————————code to set up navBars——————————————————

-(void)loadNavBar:(NSString *)titl
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
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:0 target:self action:@selector(nextHaiku)];
    done.style=UIBarButtonItemStyleBordered;
    self.titulus.rightBarButtonItem = done;
}

-(void)addDoneButtonCompose
{
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:0 target:self action:@selector(userFinishedWritingHaiku)];
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

//————————————————code for Instructions page——————————————————

-(void)haikuInstructions
{
    self.textToSave = self.textView.text;
    [self clearScreen];
    [self loadNavBar:@"Instructions"];
    [self addLeftButton:@"Compose" callingMethod:@"userWritesHaiku"];
    self.titulus.hidesBackButton=YES;
    [self seeNavBar];
    self.instructions = [[UITextView alloc] initWithFrame:CGRectMake(20, 44, 280, 480-44)];
    self.instructions.backgroundColor=[UIColor clearColor];
    [self loadToolbar];
    [self addComposeAndActionAndMore];
    self.instructions.text = @"\n\nFor millennia, the Japanese haiku has allowed great thinkers to express their ideas about the world in three lines of five, seven, and five syllables respectively.  \n\nContrary to popular belief, the three lines need not be three separate sentences.  Rather, either the first two lines are one thought and the third is another or the first line is one thought and the last two are another; the two thoughts are often separated by punctuation or an interrupting word.\n\nHave a fabulous time composing your own gay haiku.  Be aware that the author of this program may rely upon haiku you save as inspiration for future updates.";
    [self.view addSubview:self.instructions];
    self.instructionsSeen=YES;
}

//————————————————code for Amazon page——————————————————
      
-(void)addBackButton
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(webBack)];
    self.titulus.leftBarButtonItem = button;
}

-(void)loadAmazon
{    
    //Create nav bar.
    [self clearScreen];
    [self.view viewWithTag:1].hidden=YES;
    [self loadNavBar:@"Joel Derfner's Books"];
    [self addBackButton];
    [self.titulus.leftBarButtonItem setEnabled:[self.webV canGoBack]];
    [self addDoneButton];
    self.titulus.hidesBackButton=YES;
    [self seeNavBar];
    [self loadToolbar];
    [self addComposeAndAction];
    
    //Question:  what's the listener that hears when the user has clicked a link so that it can add the left bar button "Back" to the nav bar?
    //The answer might be that I have to make UIWebView a separate class.
    
    self.webV.delegate = self;
    self.webV = [[UIWebView alloc] init];
    
     NSData *urlData;
     NSString *baseURLString =  @"http://www.amazon.com/Books-by-Joel-Derfner/lm/RVZNXKV59PL51/ref=cm_lm_byauthor_full";
     //URL in following line should be replaced by name of a file?
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
    self.webV.scalesPageToFit=YES;
    [self.webV setFrame:(CGRectMake(0,44,320,372))];
    [self.view addSubview:self.webV];
    
    //NEED TO ADD:  Code that displays an error message if user clicks on Amazon link while not connected.
}

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

//————————————————code for compose page——————————————————


-(void)createSaveButton
{
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:3 target:self action:@selector(saveUserHaiku)];
    
    save.style=UIBarButtonItemStyleBordered;
    
    self.titulus.rightBarButtonItem = save;
}

-(void)createSpaceToWrite
{
    //if (!(self.textView.text.length>0 ))
    //{
    [self.webV removeFromSuperview];
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 60, 280, 150)];
        self.textView.delegate = self;
        self.textView.returnKeyType = UIReturnKeyDefault;
        self.textView.keyboardType = UIKeyboardTypeDefault;
        self.textView.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
        self.textView.scrollEnabled = YES;
        self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.textView.userInteractionEnabled = YES;

    //}
    self.textView.backgroundColor = [UIColor colorWithRed:217 green:147 blue:182 alpha:.5];
    [self.view addSubview: self.textView];
}

-(void)userWritesHaiku
{
    [self clearScreen];
    NSString *cat = @"user";
    NSArray *filteredArray;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", cat];
    filteredArray = [self.gayHaiku filteredArrayUsingPredicate:predicate];
    if (self.instructionsSeen==NO && filteredArray.count == 0)
    {
        [self haikuInstructions];
    }
    else
    {
    //Then create and add the new UINavigationBar.
    
    [self loadNavBar:@"Compose"];
    [self addLeftButton:@"Instructions" callingMethod:@"haikuInstructions"];
    //If you've added text before calling haikuInstructions, when you return from haikuInstructions the textView window with the different background color AND the keyboard.

    [self addDoneButtonCompose];
    self.titulus.hidesBackButton=YES;
    [self seeNavBar];
    [self loadToolbar];
    [self addComposeAndActionAndMore];
    
    //Create and add the space for user to write.
    [self createSpaceToWrite];
    if (self.textToSave!=@"")
    {
        self.textView.text = self.textToSave;
    }
    [self.view addSubview:self.textView];
        //NOTE:  IF THE NEXT LINE IS REMOVED, WHEN THE USER TOUCHES THE "COMPOSE" BUTTON, THE COMPOSE SPACE SHOWS UP BUT THE KEYBOARD DOESN'T AUTOMATICALLY APPEAR--IT'S ONLY WHEN THE USER TOUCHES INSIDE THE COMPOSE SPACE THAT THE KEYBOARD APPEARS.  PERHAPS THIS CAN HELP WITH THE GODDAMN KEYBOARD PROBLEM.
    [self.textView becomeFirstResponder];
    
    //Keyboard notifications.
    if (self.textView.editable=YES);
    {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    }
    /*
     Still to do:
     Give user chance to opt out of sending any haiku s/he composes to my central database.
     */
}

-(void)keyboardWillShow:(NSNotification *)aNotification
{
    if (self.textView)
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

-(void)userEditsHaiku
{
    //Still need to write this.
}

-(void)userFinishedWritingHaiku
{
    if (!self.textView || self.textView.text.length==0)
        {
            [self nextHaiku];
        }
    
        //CHECK TO MAKE SURE THERE ISN'T ALREADY A USER HAIKU WITH THIS TEXT.
    else
    {
        NSLog(@"alg uFW is working");
        self.textToSave=self.textView.text;
        NSLog(@"textToSave saved");
        UIActionSheet *ash = [[UIActionSheet alloc] initWithTitle:nil delegate: self cancelButtonTitle:@"Continue Editing" destructiveButtonTitle:@"Delete Haiku" otherButtonTitles:@"Save", nil];
        NSLog(@"action sheet created");
        [ash showInView:self.view];
        NSLog(@"action sheet shown in view");
    }
}

-(void)actionSheet:(UIActionSheet *)ash clickedButtonAtIndex:(NSInteger)buttonIndex
{
        NSLog(@"%d",buttonIndex);
    if (buttonIndex==0)
    {
        [self nextHaiku];
    }
    else if (buttonIndex==1)
    {
        [self saveUserHaiku];
    }
    else
    {
        [ash dismissWithClickedButtonIndex:2 animated:YES];
    }
}

-(void)keyboardWillHide:(NSNotification *)aNotification
{
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView commitAnimations];
}

/*- (void)textViewDidBeginEditing:(UITextView *)textView
{
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveAction:)];
    self.navigationItem.rightBarButtonItem = saveItem;
}*/

-(void)saveUserHaiku
{   if (self.textView.text.length>0)
{
    //First, add the haiku to self.gayHaiku.
    
    NSArray *quotes = [[NSArray alloc] initWithObjects:@"user", self.textView.text, nil];
    NSArray *keys = [[NSArray alloc] initWithObjects:@"category",@"quote",nil];
    NSDictionary *dictToSave = [[NSDictionary alloc] initWithObjects:quotes forKeys:keys];
    [[self gayHaiku] addObject:dictToSave];
        self.textView.editable=NO;
    [self clearScreen];
    self.textToSave=@"";
    [self.view viewWithTag:1].hidden = NO;
    [self.view viewWithTag:3].hidden = NO;
    self.haiku_text.text = [[self.gayHaiku lastObject] valueForKey:@"quote"];
    [self.view addSubview:self.haiku_text];
    self.textView.editable=NO;
    [self loadToolbar];
    [self addComposeAndActionAndMore];
    
    //Then update the array in the documents folder.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"gayHaiku.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath: path])
    {
        [self.gayHaiku writeToFile:path atomically:YES];
    }
    
    
    //Should there be an option to DELETE haiku the user has written?
    
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
}
else
{
    [self nextHaiku];
}
}


  
//————————————————code for action sheet——————————————————

-(UIImage *)createImage
{
    UIView *whatToUse;
    self.textView.userInteractionEnabled = NO;
    [whatToUse viewWithTag:10];
    [whatToUse viewWithTag:20];
    CGRect newRect = CGRectMake(0, 0, 320, 416);
    UIGraphicsBeginImageContext(newRect.size); //([self.view frame].size])
    //[self.view viewWithTag:30].hidden=YES;
    [self.view viewWithTag:40].hidden=YES;
    [self.view viewWithTag:3].hidden=YES;
    
    [[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *myImage = UIGraphicsGetImageFromCurrentImageContext();
    [self.view viewWithTag:30].hidden=NO;
    [self.view viewWithTag:40].hidden=NO;
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext([self.view bounds].size);
    [myImage drawInRect:CGRectMake(0, 0, 320,416)];
    myImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return myImage;
}

//Replace this with an action sheet after finding out what an action sheet is.
-(void)showMessage
{
    [self.webV removeFromSuperview];
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Email",@"Facebook",@"Twitter", nil];
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
    [self openMail];
}
else if (buttonIndex == 2) {
    //Deal with Facebook API.
    NSLog(@"Sent to Facebook.");
}
else if (buttonIndex == 3) {
    [self tweetTapped];
    
}
}

- (void)tweetTapped
{
    if ([TWTweetComposeViewController canSendTweet])
    {
        TWTweetComposeViewController *tweetSheet =
        [[TWTweetComposeViewController alloc] init];
        [tweetSheet setInitialText:
         @"Ignore this tweet--testing something."];
        NSLog(@"Tweet sent.");
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
}

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
}

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
    
-(void)postToFacebook
{
    UIImage *pic = [self createImage];
    NSString *list = self.haiku_text.text;
    NSString *kAppId=@"446573368720507";
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:kAppId, @"app_id",nil, @"link", pic, @"picture",@"Gay Haiku", @"name",nil, @"caption",@"Maybe he'll love me if I give him a gay haiku....",@"description",nil];
    
     //ARGH!  IN THE NEXT LINE, "facebook" GIVES AN UNRECOGNIZED IDENTIFIER ERROR.  WHAT IS IT SUPPOSED TO BE AN INSTANTIATION OF?
    
    /*[facebook dialog:@"feed"
           andParams:params
         andDelegate:self];
*/
   
///////////
            [self.view addSubview:self.loginView];
}

    
    // UIAlertView helper for post buttons
- (void)showAlert:(NSString *)message
result:(id)result
error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertMsg = error.localizedDescription;
        alertTitle = @"Error";
    } else {
        NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.\nPost ID: %@",
                    message, [resultDict valueForKey:@"id"]];
        alertTitle = @"Success";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}
    
    // Post Photo button handler
    - (IBAction)postPhotoClick:(UIButton *)sender {
        
        // Just use the icon image from the application itself.  A real app would have a more
        // useful way to get an image.
        UIImage *img = [UIImage imageNamed:@"Icon-72@2x.png"];
        
        [FBRequestConnection startForUploadPhoto:img
                               completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                   [self showAlert:@"Photo Post" result:result error:error];
                                   self.buttonPostPhoto.enabled = YES;
                               }];
        
        self.buttonPostPhoto.enabled = NO;
    }
    
    // Post Status Update button handler
    - (IBAction)postStatusUpdateClick:(UIButton *)sender {
        
        // Post a status update to the user's feed via the Graph API, and display an alert view
        // with the results or an error.
        
        NSString *message = [NSString stringWithFormat:@"Updating %@'s status at %@",
                             self.loggedInUser.first_name, [NSDate date]];
        
        [FBRequestConnection startForPostStatusUpdate:message
                                    completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                        
                                        [self showAlert:message result:result error:error];
                                        self.buttonPostStatus.enabled = YES;
                                    }];
        
        self.buttonPostStatus.enabled = NO;
    }
    
    - (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
        // first get the buttons set for login mode
        self.buttonPostPhoto.enabled = YES;
        self.buttonPostStatus.enabled = YES;
        self.buttonPickFriends.enabled = YES;
        self.buttonPickPlace.enabled = YES;
    }
    
    - (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
user:(id<FBGraphUser>)user {
    // here we use helper properties of FBGraphUser to dot-through to first_name and
    // id properties of the json response from the server; alternatively we could use
    // NSDictionary methods such as objectForKey to get values from the my json object
    self.labelFirstName.text = [NSString stringWithFormat:@"Hello %@!", user.first_name];
    // setting the profileID property of the FBProfilePictureView instance
    // causes the control to fetch and display the profile picture for the user
    self.profilePic.profileID = user.id;
    self.loggedInUser = user;
}
    
    - (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
        self.buttonPostPhoto.enabled = NO;
        self.buttonPostStatus.enabled = NO;
        self.buttonPickFriends.enabled = NO;
        self.buttonPickPlace.enabled = NO;
        
        self.profilePic.profileID = nil;
        self.labelFirstName.text = nil;
    
    
}

//////////////////////////////////HERE ENDS THE FACEBOOK STUFF

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

//- work this:
//- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result;

//————————————————code for display page——————————————————

- (IBAction)chooseDatabase:(UISegmentedControl *)segment {
    
    if (segment.selectedSegmentIndex==1) {
        self.selectedCategory = @"user";
    }
    else if (segment.selectedSegmentIndex==2) {
        self.selectedCategory = @"all";
    }
    else self.selectedCategory = @"Derfner";
    NSArray *filteredArray = self.gayHaiku;
    NSLog(@"%d",filteredArray.count);
    NSString *user = @"user";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", user];
    NSLog(@"%@",user);
    filteredArray = [self.gayHaiku filteredArrayUsingPredicate:predicate];
    NSLog(@"%d",filteredArray.count);
    int array_tot = [filteredArray count];
    if (self.selectedCategory==@"user" && array_tot==3 && self.instructionsSeen==NO)
        //actually array_tot should = 0
    {
        [self haikuInstructions];
    }
}

-(void)nextHaiku
{
    [self clearScreen];
    self.textToSave=@"";
    self.haiku_text.text=@"";
    [self.view viewWithTag:1].hidden = NO;
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
    
    //Need to test to make sure it starts over once all 110 haiku have been seen.
    
    CGSize dimensions = CGSizeMake(320, 400);
    CGSize xySize = [txt sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14.0] constrainedToSize:dimensions lineBreakMode:0];
    self.haiku_text = [[UITextView alloc] initWithFrame:CGRectMake((320/2)-(xySize.width/2),200,320,200)];
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
    self.textView.editable=NO;
    [self.textView removeFromSuperview];
}


-(void)previousHaiku
{
    [self clearScreen];
    [self.webV removeFromSuperview];
    self.textView.editable=NO;
    [self.textView setEditable:NO];
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
        }
        [self.view viewWithTag:1].hidden = NO;
        [self.view viewWithTag:3].hidden = NO;
    
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

//////////////////////////////////////////////////////////////////////////////////////


/*
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create Login View so that the app will be granted "status_update" permission.

}

- (void)viewDidUnload {
    self.buttonPickFriends = nil;
    self.buttonPickPlace = nil;
    self.buttonPostPhoto = nil;
    self.buttonPostStatus = nil;
    self.labelFirstName = nil;
    self.loggedInUser = nil;
    self.profilePic = nil;
    [super viewDidUnload];
}
*/

@end
