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

@interface GHViewController ()<UITextViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UIAlertViewDelegate,UIWebViewDelegate>

@end

@implementation GHViewController

@synthesize gayHaiku = _gayHaiku;
@synthesize haiku_text = _haiku_text;
@synthesize selectedCategory = _selectedCategory;
@synthesize webV = _webV;
@synthesize theseAreDone;
@synthesize indx;
@synthesize textView;
@synthesize titulus;
@synthesize bar;

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

-(void)seeNavBar
{
    [self.bar pushNavigationItem:self.titulus animated:YES];
    [self.view addSubview:self.bar];
}

-(void)loadToolBar:(NSArray *)buttons
{
    
}

-(void)haikuInstructions
{
    [self.view viewWithTag:1].hidden=YES;
    [self loadNavBar:@"Instructions"];
    [self addLeftButton:@"Back" callingMethod:@"userWritesHaiku"];
    self.titulus.hidesBackButton=YES;
    [self seeNavBar];

    UITextView *instructions = [[UITextView alloc] initWithFrame:CGRectMake(0, 44, 320, 480-44)];
    instructions.backgroundColor=[UIColor clearColor];
    instructions.text = @"\n\nFor millennia, the Japanese haiku has allowed great thinkers to express their ideas about the world in three lines of five, seven, and five syllables respectively.  \n\nContrary to popular belief, the three lines should not be three separate sentences.  Rather, either the first two lines are one thought and the third is another or the first line is one thought and the last two are another; the two thoughts are often separated by punctuation or another interrupting word.\n\nHave a fabulous time writing your own gay haiku.  Be aware that the author of this program may rely upon haiku you save as inspiration for future updates."; 
    [self.view addSubview:instructions];
    
}
                             
-(void)loadAmazon
{    
    [self.view viewWithTag:1].hidden=YES;
    [self loadNavBar:@"Joel Derfner's Books"];
    [self addRightButton:@"Done" callingMethod:@"doneWithAmazon"];
    [self addLeftButton:@"Back" callingMethod:@"webBack"];
    self.titulus.hidesBackButton=YES;
    [self seeNavBar];
    self.webV.delegate = self;
    self.webV = [[UIWebView alloc] init];
    NSString *fullURL=@"http://www.amazon.com/Books-by-Joel-Derfner/lm/RVZNXKV59PL51/ref=cm_lm_byauthor_full";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    self.webV.scalesPageToFit=YES;
    [self.webV loadRequest:requestObj];
    [self.webV setFrame:(CGRectMake(0,44,320,372))];
    [self.view addSubview:self.webV];
    [self.view viewWithTag:30].hidden=YES;
    [self.view viewWithTag:60].hidden=NO;

    /*
     Still to do:
     1.  Prevent back button (tag:90) from appearing until user has clicked a link.
     */
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

-(void)userWritesHaiku
{
    [self.view viewWithTag:3].hidden=YES;
    [self loadNavBar:@"Compose"];
    [self addLeftButton:@"Instructions" callingMethod:@"haikuInstructions"];
    [self addRightButton:@"Done" callingMethod:@"userFinishedWritingHaiku"];
    self.titulus.hidesBackButton=YES;
    [self seeNavBar];
    [self.view viewWithTag:1].hidden=YES;
    [self.webV removeFromSuperview];
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 60, 280, 200)];
    //self.textView = (UITextView *)[self.view viewWithTag:2];
    self.textView.hidden=NO;
    self.textView.delegate = self;
    self.textView.returnKeyType = UIReturnKeyDefault;
    self.textView.keyboardType = UIKeyboardTypeDefault;
    self.textView.scrollEnabled = YES;
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.textView.backgroundColor = [UIColor colorWithRed:217 green:147 blue:182 alpha:.5];
    [self.view addSubview: self.textView];
    //[self.view viewWithTag:90].hidden=NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    /*
     Still to do:
     Give user option to opt out of sending any haiku s/he composes to my central database.
     */
}

-(void)keyboardWillShow:(NSNotification *)aNotification
{
    CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.view.frame;
    frame.size.height -= keyboardRect.size.height;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView commitAnimations];
}

-(void)userEditsHaiku
{
    
}

-(void)saveUserHaiku
{
    
}

-(void)userFinishedWritingHaiku
{
    [self.bar removeFromSuperview];
    [self.textView resignFirstResponder];
    self.textView.backgroundColor= [UIColor clearColor];
    [self loadNavBar:@"Review"];
    [self addLeftButton:@"Edit" callingMethod:@"userEditsHaiku"];
    [self addRightButton:@"Save" callingMethod:@"saveUserHaiku"];
    self.titulus.hidesBackButton=YES;
    [self seeNavBar];
    [self.view viewWithTag:1].hidden=YES;
    
    int noOfLines = 0;
    BOOL syllableCountCorrectLineOne = NO;
    BOOL syllableCountCorrectLineTwo = YES;
    BOOL syllableCountCorrectLineThree = YES;
    NSMutableString *warningMessage;
    /*TO DO:
     1.  Check that haiku is three lines.
     2.  Check that syllable count is correct (as per CMU pronouncing dictionary (in public domain) --how do I load that in?)
     */
    if (noOfLines<3)
    {
        [warningMessage appendString:(@"Your haiku seems to have fewer than three lines.  ")];
    }
    if (noOfLines>3)
    {
        [warningMessage appendString:(@"Your haiku seems to have more than three lines.  ")];
    }
    if (!syllableCountCorrectLineOne)
    {
        [warningMessage appendString:(@"Your first line seems not to have five syllables.  ")];
    }
    if (!syllableCountCorrectLineTwo)
    {
        [warningMessage appendString:(@"Your second line seems not to have seven syllables.  ")];
    }
    if (!syllableCountCorrectLineThree)
    {
        [warningMessage appendString:(@"Your third line seems not to have five syllables.  ")];
    }
    if (warningMessage!=@"")
    {
        [warningMessage appendString:(@"Would you prefer to leave things as they are or go back and edit?")];
    }
    self.haiku_text.text=warningMessage;
    [self.view viewWithTag:1].hidden=NO;
    self.haiku_text.hidden=NO;
    //How is the above choice offered?  alertView?  Text plus new UINavigationItem?
    //Write code to deal with the above choice.
    //Then, after all is done and dusted:
    //self.textView.hidden=YES;
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
    UIBarButtonItem* saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveAction:)];
    self.navigationItem.rightBarButtonItem = saveItem;
}

-(void)viewDidLoad {
	[super viewDidLoad];
    [self.view viewWithTag:60].hidden=YES;
	NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"gayHaiku" ofType:@"plist"];
	self.gayHaiku = [[NSMutableArray arrayWithContentsOfFile:plistCatPath] copy];
    [self nextHaiku];
}

-(void)viewDidUnload {
    //navBarForAmazon = nil;
	[super viewDidUnload];
	self.gayHaiku=nil;
	self.haiku_text=nil;
}

- (IBAction)chooseDatabase:(UISegmentedControl *)segment {
    if (segment.selectedSegmentIndex==1) {
        self.selectedCategory = @"user";
    }
    else if (segment.selectedSegmentIndex==2) {
        self.selectedCategory = @"all";
    }
    else self.selectedCategory = @"Derfner";
    //Make sure UISegmentedControl count starts at 0--if not, adjust up.
}
  
- (void)openMail {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        //Replace "Someone" in following line with user's name.
        [mailer setSubject:@"Someone has sent you a gay haiku."];
        UIView *whatToUse;
        [whatToUse viewWithTag:10];
        [whatToUse viewWithTag:20];
        CGRect newRect = CGRectMake(0, 0, 320, 416);
        UIGraphicsBeginImageContext(newRect.size); //([self.view frame].size])
        [self.view viewWithTag:30].hidden=YES;
        [self.view viewWithTag:40].hidden=YES;

        [[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *myImage = UIGraphicsGetImageFromCurrentImageContext();
        [self.view viewWithTag:30].hidden=NO;
        [self.view viewWithTag:40].hidden=NO;
        UIGraphicsEndImageContext();
        
        UIGraphicsBeginImageContext([self.view bounds].size);
        [myImage drawInRect:CGRectMake(0, 0, 320,416)];
        myImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
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

-(IBAction)nextHaiku
{
    self.textView.backgroundColor= [UIColor clearColor];
    if ([self.view viewWithTag:2])
         {
            NSLog(@"yes");
           [self.view viewWithTag:2].hidden=YES;  
         }
    [self.view viewWithTag:1].hidden = NO;
        if (!self.indx)
        {
            self.indx=0;
        }
        NSString *cat = self.selectedCategory;
        //For now (adjust later so that, according to UISegmentedControl, it will also show only the user's haiku or all haiku):
        cat = @"Derfner";
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", cat];
		NSArray *filteredArray = [self.gayHaiku filteredArrayUsingPredicate:predicate];
		int array_tot = [filteredArray count];
        int sortingHat;
		if (array_tot > 0)
            if (self.indx == self.theseAreDone.count)
            {
                while (true)
                {
                    sortingHat = (arc4random() % array_tot);
                    if (![theseAreDone containsObject:[filteredArray objectAtIndex:sortingHat]]) break;
                }
                self.haiku_text.text = [[filteredArray objectAtIndex:sortingHat] valueForKey:@"quote"];
                if (!self.theseAreDone || self.theseAreDone.count==array_tot)
                {
                    self.theseAreDone = [[NSMutableArray alloc] init];
                }
                [theseAreDone addObject:[filteredArray objectAtIndex:sortingHat]];
                self.indx = self.theseAreDone.count;
            }
            else 
            {
                self.haiku_text.text = [[self.theseAreDone objectAtIndex:indx] valueForKey:@"quote"];
                self.indx += 1;
            }
    //Test to make sure it starts over once all 110 haiku have been seen.
}

-(IBAction)previousHaiku
{
    if (self.theseAreDone.count>1 && self.indx>1)
    {
    self.indx -= 1;
    self.haiku_text.text = [[self.theseAreDone objectAtIndex:self.indx-1] valueForKey:@"quote"];
    }
}

-(IBAction)showMessage:(int)sender
{
    //NSInteger *buttonIndex = NULL;
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
         //Deal with Twitter API.
         NSLog(@"Sent to Twitter.");
     }
 }
@end
