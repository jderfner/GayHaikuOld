//
//  GHWebViewController.m
//  GayHaiku
//
//  Created by Joel Derfner on 8/9/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "GHWebViewController.h"

@implementation GHWebViewController

@synthesize webView = _webView;

-(void)viewDidLoad
{
    [super viewDidLoad];
    NSString *fullURL=@"http://www.amazon.com/Books-by-Joel-Derfner/lm/RVZNXKV59PL51/ref=cm_lm_byauthor_full";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];

    [webView loadRequest:requestObj];
}

@end
