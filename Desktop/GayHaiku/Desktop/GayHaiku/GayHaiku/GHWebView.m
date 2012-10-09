//
//  GHWebView.m
//  GayHaiku
//
//  Created by Joel Derfner on 8/20/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "GHWebView.h"
#import "GHViewController.h"

@interface GHWebView () <UIWebViewDelegate>

@end

@implementation GHWebView

@synthesize requ, conn, urlData, delegate;

-(void)loadWebViewWithbaseURLString:bus withURLString:us
{
    self.requ = [NSURLRequest requestWithURL:[NSURL URLWithString:us] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval: 20];
    self.conn=[[NSURLConnection alloc] initWithRequest:self.requ delegate:nil];
    NSError *error=nil;
    NSURLResponse *resp=nil;
    if (self.conn)
    {
        self.urlData = [NSURLConnection sendSynchronousRequest: self.requ returningResponse:&resp error:&error];
        NSString *htmlString = [[NSString alloc] initWithData:self.urlData encoding:NSUTF8StringEncoding];
        [self loadHTMLString:htmlString baseURL:[NSURL URLWithString:bus]];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.title = @"Unfortunately, I seem to be having a hard time connecting to the Internet.  Would you mind trying again later?  I'll make it worth your while, I promise.";
        [alert show];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //This does nothing.
    NSLog(@"Yah, yah, yah.");
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError *)error
{
    //This does nothing.
    NSLog(@"Wah, wah, wah.");
}

-(void)webBack
{
    if ([self canGoBack])
    {
        [self goBack];
    }
}

@end
