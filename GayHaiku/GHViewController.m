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

-(IBAction)haikuInstructions
{
    
}

-(IBAction)loadAmazon
{    
    self.webV.delegate = self;
    self.webV = [[UIWebView alloc] init];
    NSString *fullURL=@"http://www.amazon.com/Books-by-Joel-Derfner/lm/RVZNXKV59PL51/ref=cm_lm_byauthor_full";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    self.webV.scalesPageToFit=YES;
    [self.webV loadRequest:requestObj];
    [self.webV setFrame:(CGRectMake(0,44,320,372))];
    [self.view addSubview:self.webV];
    [self.view viewWithTag:80].hidden=NO;
    /*
     Still to do:
     1.  Prevent back button (tag:90) from appearing until user has clicked a link.
     2.  Move title to right when back button appears.
     */
}

-(IBAction)doneWithAmazon
{
    [self.webV removeFromSuperview];
    [self.view viewWithTag:80].hidden=YES;
}

- (IBAction)haikuInstructions:(id)sender {
}

-(IBAction)webBack
{
    if (self.webV.canGoBack)
    {
        [self.webV goBack];
    }
}

-(IBAction)userWritesHaiku
{
    [self.view viewWithTag:50].hidden=NO;
    [self.view viewWithTag:60].hidden=NO;
    self.textView = (UITextView *)[self.view viewWithTag:50];
    self.textView.delegate = self;
    self.textView.returnKeyType = UIReturnKeyDefault;
    self.textView.keyboardType = UIKeyboardTypeDefault;
    self.textView.scrollEnabled = YES;
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview: self.textView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    /*
     Still to do:
     1.  Give user option to get instructions on how to write a haiku.
     2.  Give user option to opt out of sending any haiku s/he composes to my central database.
     3.  Let user compose haiku, edit, save to plist under category USER.
     4.  Connect to CMU pronunciation dictionary and set up method whereby, if haiku is done incorrectly (wrong number of lines, wrong number of syllables in a line) user is alerted and given the option to go back and edit.
     5.  Create new method showing user a preview of new haiku and asking whether to a) save or b) edit.
     6.  Animate appearance of title bar?
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


-(IBAction)userFinishedWritingHaiku
{
        [self.view viewWithTag:50].hidden=YES;
        [self.view viewWithTag:60].hidden=YES;
        [self.textView resignFirstResponder];
        [self.view viewWithTag:40].hidden=NO;
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

- (void)saveAction
{
    [self.textView resignFirstResponder]; 
}

-(void)viewDidLoad {
	[super viewDidLoad];
	NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"gayHaiku" ofType:@"plist"];
	self.gayHaiku = [[NSMutableArray arrayWithContentsOfFile:plistCatPath] copy];
}

-(void)viewDidUnload {
    navBarForAmazon = nil;
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
}
  
- (IBAction)openMail {
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
    {
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
	}
}

-(IBAction)previousHaiku
{
    if (self.theseAreDone.count>0 && self.indx>0)
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
