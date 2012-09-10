//
//  TCTweetComposeViewController.h
//  tweet-composer
//
//  Created by Philip Dow on 7/29/12.
//  Copyright (c) 2012 Philip Dow / Sprouted. All rights reserved.
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


/*  Usage
    Drop-in replacement for the TWTweetComposeViewController, which I think is
    astonishingly ugly. Change the class, use initComposer instead of init,
    and change the block and result types for the completiongHandler.
    
    Limitiations
    Only supports Portrait orientation
    Only supports a single image upload at a time
    */

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>

/*  Type definitions for the completion block, identicaly in functionality to 
    TWTweetComposeViewController
    */

enum TCTweetComposeViewControllerResult {
   TCTweetComposeViewControllerResultCancelled,
   TCTweetComposeViewControllerResultDone
};
typedef enum TCTweetComposeViewControllerResult TCTweetComposeViewControllerResult;

typedef void (^TCTweetComposeViewControllerCompletionHandler)(TCTweetComposeViewControllerResult result);

@interface TCTweetComposeViewController : UINavigationController

@property (nonatomic,copy) TCTweetComposeViewControllerCompletionHandler completionHandler;

/*  Returns NO if no Twitter accounts have been set up or if access to the Twitter 
    API has been denied or turned off for this application
    */

+ (BOOL)canSendTweet;

/*  Use initComposer instead of init
    Avoids some weird internal infinite recursion loop when using init
    */

- (id) initComposer;

/*  The following methods must be called prior to showing the tweet composer
    From the documentation:
    Although you may perform Twitter requests on behalf of the user, you cannot append text, images, or URLs to tweets without the user’s knowledge. Hence, you can set the initial text and other content before presenting the tweet to the user but cannot change the tweet after the user views it. All of the methods used to set the content of the tweet return a Boolean value. The methods return NO if the content doesn’t fit in the tweet or if the view was already presented to the user and the tweet can no longer be changed.
    */

/*  It is only possible to add a single image at this time, and the method will
    return NO if you attempt to add more than one.
    */

- (BOOL)setInitialText:(NSString *)text;
- (BOOL)addImage:(UIImage *)image;
- (BOOL)addURL:(NSURL *)url;

- (BOOL)removeAllImages;
- (BOOL)removeAllURLs;

/*  Custom additions. Again they must be called prior to displaying the view and
    will return NO if the view is already being displayed. The default value is
    YES. 
    
    A UI note on showing URLs: The URLs are editable and the edited version will
    be included in the tweet, not the original URL. Character counts reflect the
    http://t.co/xxxxx length of the URL and not the length of the URL in the 
    text, so that character counts may jump strangely as the user edits the URL.
    */

- (BOOL) setShowsImages:(BOOL)showsImages;
- (BOOL) setShowsURLs:(BOOL)showsURLs;

@end
