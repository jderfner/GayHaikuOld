//
//  GHWeb.m
//  GayHaiku
//
//  Created by Joel Derfner on 9/17/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "GHWeb.h"

@implementation GHWeb

@synthesize webView;

//Connect to the Internet.
-(void)connectWithURL:(NSString *)us andBaseURLString:(NSString *)bus
{
    NSURLRequest *reques = [NSURLRequest requestWithURL:[NSURL URLWithString:us] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval: 10];
    NSURLConnection *connectio = [[NSURLConnection alloc] initWithRequest:reques delegate:self];
    if (connectio)
    {
        [self.webView loadRequest:reques];
    }
    self.webView.scalesPageToFit=YES;
    [self.webView setFrame:(CGRectMake(0,44,320,372))];
    //[self.view addSubview:self.webView];
}

//What to do in case of failure to connect.
-(BOOL)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"I'm so sorry!" message:@"Unfortunately, I seem to be having a hard time connecting to the Internet.  Would you mind trying again later?  I promise to make it worth your while." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    return YES;
}

@end
