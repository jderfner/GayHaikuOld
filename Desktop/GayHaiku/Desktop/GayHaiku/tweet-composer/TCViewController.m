//
//  TCViewController.m
//  tweet-composer
//
//  Created by Philip Dow on 7/29/12.
//  Copyright (c) 2012 Philip Dow. All rights reserved.
//  
//  ARC
//

/*
 Copyright (C) 2012 Philip Dow / Sprouted. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.
 
 * Neither the name of the author nor the names of its contributors may be used
   to endorse or promote products derived from this software without specific
   prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#import "TCViewController.h"
#import "TCTweetComposeViewController.h"

@interface TCViewController ()

@end

@implementation TCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)sendTweet:(id)sender
{    
    if (![TCTweetComposeViewController canSendTweet]) {
        NSLog(@"Cannot send tweets, no account set up");
        [[self twitterAccountsAlert] show];
        return;
    }
    
    TCTweetComposeViewController *twitter = [[TCTweetComposeViewController alloc] initComposer];
    [twitter setInitialText:@"This tweet was composed with TCTweet"];
    [twitter addURL:[NSURL URLWithString:@"https://github.com/phildow/TCTweetComposeViewController"]];
    //[twitter addImage:[UIImage imageNamed:@"github.png"]];
    
    twitter.completionHandler = ^(TCTweetComposeViewControllerResult result) {
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self presentViewController:twitter animated:YES completion:nil];
}

- (UIAlertView*) twitterAccountsAlert
{
    NSString *title = NSLocalizedString(@"Twitter Account Unavailable", @"Twitter Account Unavailable");
    NSString *message = NSLocalizedString(@"There was a problem accessing your twitter accounts. You're probably on the simulator.", @"Twitter Account Unavailable Message");
    NSString *button = NSLocalizedString(@"Continue", @"Continue");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:button otherButtonTitles: nil];
    
    return alert;
}


@end
