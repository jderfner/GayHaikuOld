//
//  GHButtons.m
//  GayHaiku
//
//  Created by Joel Derfner on 9/20/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "GHButtons.h"

@implementation GHButtons

@synthesize compose, bac, ed, action, more, flex, done, de, next, nextNext, bar, titulus;

-(void)addLeftButton:(NSString *)titl callingMethod:(NSString *)method
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:titl style:UIBarButtonItemStyleBordered target:self action:NSSelectorFromString(method)];
    self.titulus.leftBarButtonItem = button;
}

//This adds the buttons for webForward and webBack.

-(void)addLeftButtons:(NSArray *)titles
{
    self.titulus.leftBarButtonItems = titles;
}

//This adds the cancel button for userWritesHaiku and haikuInstructions.

-(void)addCancelButton
{
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:1 target:self action:@selector(hom)];
    cancel.style=UIBarButtonItemStyleBordered;
    self.titulus.rightBarButtonItem = cancel;
}

//This adds the done button for userWritesHaiku.

-(void)addDoneButton:(NSString *)blah
{
    UIBarButtonItem *don = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:0 target:self action:NSSelectorFromString(blah)];
    don.style=UIBarButtonItemStyleBordered;
    self.titulus.rightBarButtonItem = don;
}


-(void)loadNB:(NSString *)title
{
    self.bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.titulus = [[UINavigationItem alloc] initWithTitle:title];
}

-(void)createBarButtons
{
    self.compose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:7 target:self action:@selector(userWritesHaiku)];
        
    self.compose.style=UIBarButtonItemStyleBordered;
        
    self.bac = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(userWritesHaiku)];
        
    self.ed = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(userEditsHaiku)];
        
    self.action = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:9 target:self action:@selector(showMessage)];
        
    self.action.style=UIBarButtonItemStyleBordered;
        
    self.more = [[UIBarButtonItem alloc] initWithTitle:@"Buy" style:UIBarButtonItemStyleBordered target:self action:@selector(loadAmazon)];
        
    self.flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
    self.done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:0  target:self action:@selector(hom)];
        
    self.de = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteHaiku)];
        
    self.next = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(haikuInstructions)];
        
    self.nextNext = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(userWritesHaiku)];
}


@end
