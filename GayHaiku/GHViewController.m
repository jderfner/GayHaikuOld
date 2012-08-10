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
    [self.wView viewWithTag:70].hidden=NO;
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
        //Right now this shows only my haiku.  Adjust so that, according to UISegmentedControl, it will also show only the user's haiku or all haiku.
		// 2.1 - determine category
        //[self chooseDatabase:selectedCategory];
        self.selectedCategory=@"Derfner";
		// 2.2 - filter array by category using predicate
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", self.selectedCategory];
		NSArray *filteredArray = [self.gayHaiku filteredArrayUsingPredicate:predicate];
		// 2.3 - get total number in filtered array
		int array_tot = [filteredArray count];
		// 2.4 - as a safeguard only get quote when the array has rows in it
        int sortingHat;
		if (array_tot > 0) 
        {
            // 2.5 - get random index
            while (true)
            {
                sortingHat = (arc4random() % array_tot);
                NSString *isThisARepeat = [[filteredArray objectAtIndex:sortingHat] valueForKey:@"done"];
                if (isThisARepeat != @"done") break;
            }
			// 2.6 - get the quote string for the index
			NSString *quote = [[filteredArray objectAtIndex:sortingHat] valueForKey:@"quote"];
			// 2.9 - Display haiku
			self.haiku_text.text = quote;
			// 2.10 - Update row to indicate that it has been displayed
			int haiku_array_tot = [self.gayHaiku count];
			NSString *haiku1 = [[filteredArray objectAtIndex:sortingHat] valueForKey:@"quote"];
			for (int x=0; x < haiku_array_tot; x++) {
				NSString *haiku2 = [[self.gayHaiku objectAtIndex:x] valueForKey:@"quote"];
				if ([haiku1 isEqualToString:haiku2]) {
					NSMutableDictionary *itemAtIndex = (NSMutableDictionary *)[self.gayHaiku objectAtIndex:x];
					[itemAtIndex setValue:@"done" forKey:@"done"];
				}
			}
		} else {
			self.haiku_text.text = [NSString stringWithFormat:@"No quotes to display."];
		}
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


     - (IBAction)loadAmazon:(id)sender {
     }
@end
