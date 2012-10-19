//
//  GHWebView.h
//  GayHaiku
//
//  Created by Joel Derfner on 8/20/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHViewController.h"

@protocol GHWebView;
@protocol GHWebViewDelegate;

@interface GHWebView : UIWebView <UIWebViewDelegate>//<GHWebViewDelegate, UIWebViewDelegate>

@property (nonatomic, strong) NSURLRequest *requ;
@property (nonatomic, strong) NSURLConnection *conn;
@property (nonatomic, strong) NSData *urlData;
//@property (nonatomic, assign) id<GHWebViewDelegate> delegate;

-(void)loadWebViewWithbaseURLString:bus withURLString:us;

@end

@protocol GHWebViewDelegate <UIWebViewDelegate>

-(BOOL) webView:(GHWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;

@end
