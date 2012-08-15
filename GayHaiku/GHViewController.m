//
//  GHViewController.m
//  Gay Haiku
//
//  Created by Joel Derfner on 7/22/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import "GHViewController.h"
#import <Twitter/Twitter.h>
#import <Twitter/TWTweetComposeViewController.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface GHViewController ()<UITextViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UIAlertViewDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate>

@end

@implementation GHViewController

@synthesize gayHaiku, textView, titulus, bar, instructions, textToSave, haiku_text, selectedCategory, webV, theseAreDoneAll, theseAreDoneD, theseAreDoneU, indxAll, indxD, indxU, tweetView;

//————————————————code to set up navBars——————————————————

-(void)loadNavBar:(NSString *)titl
{
    self.bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.titulus = [[UINavigationItem alloc] initWithTitle:titl];
}

-(void)addLeftButton:(NSString *)titl callingMethod:method
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:titl style:UIBarButtonItemStyleBordered target:self action:NSSelectorFromString(method)];
    self.titulus.leftBarButtonItem = button;
}

-(void)addRightButton:(NSString *)titl callingMethod:(NSString *)method
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
}

-(void)seeNavBar
{
    [self.bar pushNavigationItem:self.titulus animated:YES];
    [self.view addSubview:self.bar];
}

//————————————————code for Instructions page——————————————————

-(void)haikuInstructions
{
    self.textToSave = self.textView.text;
    if (self.bar)
    {
        [self.bar removeFromSuperview];
    }
    [self loadNavBar:@"Instructions"];
    [self addLeftButton:@"Compose" callingMethod:@"userWritesHaiku"];
    self.titulus.hidesBackButton=YES;
    [self seeNavBar];
    self.textView.hidden=YES;
    [self.textView resignFirstResponder];
    self.instructions = [[UITextView alloc] initWithFrame:CGRectMake(20, 44, 280, 480-44)];
    self.instructions.backgroundColor=[UIColor clearColor];
    self.instructions.text = @"\n\nFor millennia, the Japanese haiku has allowed great thinkers to express their ideas about the world in three lines of five, seven, and five syllables respectively.  \n\nContrary to popular belief, the three lines need not be three separate sentences.  Rather, either the first two lines are one thought and the third is another or the first line is one thought and the last two are another; the two thoughts are often separated by punctuation or an interrupting word.\n\nHave a fabulous time composing your own gay haiku.  Be aware that the author of this program may rely upon haiku you save as inspiration for future updates.";
    [self.view addSubview:self.instructions];
}

//————————————————code for Amazon page——————————————————
                             
-(void)loadAmazon
{    
    //Create nav bar.
    
    [self.view viewWithTag:1].hidden=YES;
    [self loadNavBar:@"Joel Derfner's Books"];
    [self addRightButton:@"Done" callingMethod:@"doneWithAmazon"];
    self.titulus.hidesBackButton=YES;
    [self seeNavBar];
    
    //Question:  what's the listener that hears when the user has clicked a link so that it can add the left bar button "Back" to the nav bar?
    
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
    [self.webV removeFromSuperview];
    [self.bar removeFromSuperview];
    [self viewDidLoad];
}

-(void)webBack
{
    if (self.webV.canGoBack)
    {
        [self.webV goBack];
    }
}

//————————————————code for compose page——————————————————

-(void)setupForWriting
{
    [self.textView becomeFirstResponder];
}

-(void)createSpaceToWrite
{
    //if (!(self.textView.text.length>0 ))
    //{
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
    
    //Then create and add the new UINavigationBar.
    
    [self loadNavBar:@"Compose"];
    [self addLeftButton:@"Instructions" callingMethod:@"haikuInstructions"];
    //If you've added text before calling haikuInstructions, when you return from haikuInstructions the textView window with the different background color AND the keyboard.
    [self addRightButton:@"Done" callingMethod:@"userFinishedWritingHaiku"];
    self.titulus.hidesBackButton=YES;
    [self seeNavBar];
    
    //Create and add the space for user to write.
    [self createSpaceToWrite];
    if (self.textToSave!=@"")
    {
        self.textView.text = self.textToSave;
    }
    [self.view addSubview:self.textView];
    [self.textView becomeFirstResponder];
    
    //Keyboard notifications.
    if (self.textView.editable=YES);
    {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
    if (!self.textView.text || self.textView.text.length==0)
        {
            [self nextHaiku];
            //But currently it goes to Review navBar--why?
        }
    else
    {
        self.textToSave=self.textView.text;
    }
    [self.bar removeFromSuperview];
    [self.textView resignFirstResponder];
    self.textView.backgroundColor= [UIColor clearColor];
    [self.textView removeFromSuperview];
    [self loadNavBar:@"Review"];
    [self addLeftButton:@"Edit" callingMethod:@"userWritesHaiku"];
        //If you've entered Edit, the text in the box disappears.
        NSArray *rightButtons = [[NSArray alloc] initWithObjects:@"Dismiss", @"Save", nil];
        NSArray *rightMethods = [[NSArray alloc] initWithObjects:@"nextHaiku", @"saveUserHaiku", nil];
    //[self addRightButton:@"Save" callingMethod:@"saveUserHaiku"];
    //[self addRightButton:@"Dismiss" callingMethod:@"nextHaiku"];
        [self addRightButtons:rightButtons callingMethod:rightMethods];
    self.titulus.hidesBackButton=YES;
    [self seeNavBar];
    [self.view viewWithTag:1].hidden=YES;
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
    [[self.view viewWithTag:4] resignFirstResponder];
    if (self.bar) [self.bar removeFromSuperview];
    self.textView.text=@"";
    self.textToSave=@"";
    [self.view viewWithTag:1].hidden = NO;
    [self.view viewWithTag:3].hidden = NO;
    self.haiku_text.text = [[self.gayHaiku lastObject] valueForKey:@"quote"];
    [self.view addSubview:self.haiku_text];
    self.textView.editable=NO;
    
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
    
    //THIS IS WHERE I DID THE HIDDEN TEXT VIEW THING.
    //[[self.view viewWithTag:4] becomeFirstResponder];
    
    [self nextHaiku];
    self.textView.editable=NO;
}

-(void)clearScreen
{
    [self.instructions removeFromSuperview];
    [self.textView removeFromSuperview];
    self.textView.text=@"";
    [self.haiku_text removeFromSuperview];
    [self.bar removeFromSuperview];
    [self.webV removeFromSuperview];
    [self.view viewWithTag:3].hidden=YES;
    [self.textView setEditable:NO];
}

-(void)viewDidUnload {
	[super viewDidUnload];

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
-(IBAction)showMessage
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Email",@"Facebook",@"Twitter", nil];
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex { if (buttonIndex == 1) {
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

/*-(void)postToFacebook
{
 
    THIS DOESN'T WORK WITHOUT FACEBOOK SDK INSTALLED.  HOW THE FUCK DO I INSTALL FACEBOOK SDK WHEN FACEBOOK SDK IS FULL OF [RELEASE]S AND THIS IS AN ARC PROJECT?  I CAN'T FLAG THE FACEBOOK FILES AS -FNO-OBJ-WHATEVER BECAUSE THERE'S NO FLAG COLUMN IN BUILD PHASES IN TARGET VIEW.
 
    UIImage *pic = [self createImage];
    NSString *list = self.haiku_text.text;
    NSString *kAppId=@"446573368720507";
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:kAppId, @"app_id",pic, @"picture",@"Gay Haiku", @"name",@"Maybe he'll love me if I give him a gay haiku....",@"message",nil];
    [facebook dialog:@"feed"
           andParams:params
         andDelegate:self];

    
}*/

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
    self.textView.editable=NO;
    [self.textView removeFromSuperview];
}

-(void)nextHaiku
{
    [self.view.layer removeAllAnimations];
    self.textView.editable=NO;
    [self.textView removeFromSuperview];
    [self.bar removeFromSuperview];
    self.textToSave=@"";
    self.haiku_text.text=@"";
    [self.view viewWithTag:1].hidden = NO;
    [self.view viewWithTag:3].hidden = NO;
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
    if (cat==@"user" && array_tot==0)
    {
        [self userWritesHaiku];
    }
    else
    {
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
}


-(void)previousHaiku
{
    self.textView.editable=NO;
    [self textViewShouldBeginEditing:self.textView];
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



@end
