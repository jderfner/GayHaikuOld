//
//  GHWebViewController.h
//  GayHaiku
//
//  Created by Joel Derfner on 8/9/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GHWebViewController : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView *webView;
}

@property (nonatomic, retain) UIWebView *webView;

@end
