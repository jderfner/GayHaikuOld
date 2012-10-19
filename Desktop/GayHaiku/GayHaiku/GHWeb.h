//
//  GHWeb.h
//  GayHaiku
//
//  Created by Joel Derfner on 9/17/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GHWeb : NSObject

@property (nonatomic, strong) UIWebView *webView;

-(void)connectWithURL:(NSString *)us andBaseURLString:(NSString *)bus;

@end
