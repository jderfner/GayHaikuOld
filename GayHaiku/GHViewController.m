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
@synthesize wView = _wView;
@synthesize theseAreDone;
@synthesize indx;



-(IBAction)userWritesHaiku
{
    [self.view viewWithTag:50].hidden=NO;
    [self.view viewWithTag:60].hidden=NO;
    //Load keyboard.
    //Give user option to get instructions on how to write a haiku.
    //Give user option to opt out of sending any haiku s/he composes to my central database.
    //Let user compose haiku, edit, save to plist under category USER.
}

-(void)viewDidLoad {
	[super viewDidLoad];
	NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"gayHaiku" ofType:@"plist"];
	self.gayHaiku = [[NSMutableArray arrayWithContentsOfFile:plistCatPath] copy];
}

-(void)viewDidUnload {
	[super viewDidUnload];
	self.gayHaiku=nil;
	self.haiku_text=nil;
}
-(IBAction)loadAmazon
{
    //This UIWebView shit is making my head hurt.  I think the reason is that I'm using delegates wrong, but that could be totally incorrect.
    [self.wView viewWithTag:70].hidden=NO;
    GHWebViewController *wv;
    [self.wView addSubview:wv];
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
        NSLog(@"About to do new haiku: %d",self.indx);
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
                NSLog(@"About to add int to  array with %d",self.theseAreDone.count);
                [theseAreDone addObject:[filteredArray objectAtIndex:sortingHat]];
                NSLog(@"Just added int to array for %d",self.theseAreDone.count);
                self.indx = self.theseAreDone.count;
                NSLog(@"Just did new haiku: %d",self.indx);
            }
            else 
            {
                self.haiku_text.text = [[self.theseAreDone objectAtIndex:indx] valueForKey:@"quote"];
                self.indx += self.indx;
            }
	}
}

-(IBAction)previousHaiku
{
    //Why is self.indx 0 here no matter how many new haiku you've done (and so no matter what number self.indx is after newHaiku)?
    NSLog(@"About to do previous haiku: %d",self.indx);
    self.haiku_text.text = [[self.theseAreDone objectAtIndex:self.indx-1] valueForKey:@"quote"];
    self.indx -= self.indx;
    NSLog(@"Just did previous haiku: %d",self.indx);
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
