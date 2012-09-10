//
//  GHHaikuController.m
//  GayHaiku
//
//  Created by Joel Derfner on 8/31/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "GHHaikuController.h"
#import "GHViewController.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import "GHViewController.h"
#import <Twitter/Twitter.h>
#import <Twitter/TWTweetComposeViewController.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Parse/Parse.h>
#import <Social/Social.h>

@interface GHHaikuController ()<UITextViewDelegate,MFMailComposeViewControllerDelegate,UIAlertViewDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,UITextFieldDelegate>

@end

@implementation GHHaikuController

@synthesize userName = _userName;
@synthesize segContrAsOutlet = _segContrAsOutlet;
@synthesize checkbox = _checkbox;
@synthesize gayHaiku = _gayHaiku;
@synthesize textView = _textView;
@synthesize titulus = _titulus;
@synthesize bar = _bar;
@synthesize instructions = _instructions;
@synthesize textToSave = _textToSave;
@synthesize haiku_text = _haiku_text;
@synthesize selectedCategory = _selectedCategory;
@synthesize webV = _webV;
@synthesize theseAreDoneAll = _theseAreDoneAll;
@synthesize theseAreDoneD = _theseAreDoneD;
@synthesize theseAreDoneU = _theseAreDoneU;
@synthesize indxAll = _indxAll;
@synthesize indxD = _indxD;
@synthesize indxU = _indxU;
@synthesize toolb = _toolb;
@synthesize instructionsSeen = _instructionsSeen;
@synthesize checkboxChecked = _checkboxChecked;
@synthesize meth = _meth;
@synthesize delet = _delet;
@synthesize home = _home;
@synthesize done = _done;
@synthesize more = _more;
@synthesize compose = _compose;
@synthesize action = _action;
@synthesize flex = _flex;
@synthesize controlVisible = _controlVisible;
@synthesize textEntered = _textEntered;

-(void)next
{
    [self.gh clearScreen];
    self.textToSave=@"";
    [self.gh.view viewWithTag:3].hidden = NO;
    [self.gh loadToolbar];
    [self.gh addToolbarButtons];
    int indexOfHaiku;
    NSMutableArray *arrayOfHaikuSeen;
    NSString *cat;
    if (!self.selectedCategory) cat = @"Derfner";
    else cat = self.selectedCategory;
    NSArray *filteredArray;
    if (cat==@"all")
    {
        filteredArray = self.gayHaiku;
        indexOfHaiku = self.indxAll;
        arrayOfHaikuSeen = self.theseAreDoneAll;
    }
    else
    {
        indexOfHaiku = (cat==@"user")?self.indxU:self.indxD;
        arrayOfHaikuSeen = (cat==@"user")?self.theseAreDoneU:self.theseAreDoneD;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", cat];
        filteredArray = [self.gayHaiku filteredArrayUsingPredicate:predicate];
        if (cat==@"user")
        {
            [self.toolb removeFromSuperview];
            [self.gh loadToolbar];
            [self.gh addToolbarButtonsPlusDelete];
        }
    }
    int array_tot = [filteredArray count];
    int sortingHat;
    NSString *txt;
    if (array_tot > 0)
    {
        if (array_tot==1 && self.selectedCategory==@"user")
        {
            txt=self.haiku_text.text;
        }
        else if (indexOfHaiku == arrayOfHaikuSeen.count)
        {
            while (true)
            {
                sortingHat = (arc4random() % array_tot);
                if (![arrayOfHaikuSeen containsObject:[filteredArray objectAtIndex:sortingHat]]) break;
            }
            txt = [[filteredArray objectAtIndex:sortingHat] valueForKey:@"quote"];
            if (!arrayOfHaikuSeen || arrayOfHaikuSeen.count==array_tot)
            {
                arrayOfHaikuSeen = [[NSMutableArray alloc] init];
            }
            [arrayOfHaikuSeen addObject:[filteredArray objectAtIndex:sortingHat]];
            indexOfHaiku = arrayOfHaikuSeen.count;
            if (arrayOfHaikuSeen.count==filteredArray.count-1)
            {
                [arrayOfHaikuSeen removeAllObjects];
                indexOfHaiku=0;
            }
        }
        else
        {
            txt = [[arrayOfHaikuSeen objectAtIndex:indexOfHaiku] valueForKey:@"quote"];
            indexOfHaiku += 1;
        }
    }
    self.haiku_text.text=@"";
    CGSize dimensions = CGSizeMake(320, 400);
    CGSize xySize = [txt sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14.0] constrainedToSize:dimensions lineBreakMode:0];
    self.haiku_text = [[UITextView alloc] initWithFrame:CGRectMake((320/2)-(xySize.width/2),150,320,200)];
    self.haiku_text.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    self.haiku_text.backgroundColor = [UIColor clearColor];
    self.haiku_text.text=txt;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromRight;
    transition.delegate = self;
    [self.gh.view.layer addAnimation:transition forKey:nil];
    [self.gh.view viewWithTag:5].hidden=YES;
    [self.gh.view viewWithTag:6].hidden=YES;
    [self.gh.view viewWithTag:7].hidden=YES;
    [self.gh.view viewWithTag:8].hidden=YES;
    [self.gh.view addSubview:self.haiku_text];
    if (cat==@"user")
    {
        self.theseAreDoneU = arrayOfHaikuSeen;
        self.indxU = indexOfHaiku;
    }
    else if (cat==@"all")
    {
        self.theseAreDoneAll = arrayOfHaikuSeen;
        self.indxAll = indexOfHaiku;
    }
    else
    {
        self.theseAreDoneD = arrayOfHaikuSeen;
        self.indxD = indexOfHaiku;
    }
    self.haiku_text.editable=NO;
    self.instructions.editable=NO;
}

-(void)previous
{
    int indexOfHaiku;
    NSMutableArray *arrayOfHaikuSeen;
    NSString *cat;
    if (!self.selectedCategory) cat = @"Derfner";
    else cat = self.selectedCategory;
    NSArray *filteredArray;
    if (cat==@"all")
    {
        filteredArray = self.gayHaiku;
        indexOfHaiku = self.indxAll;
        arrayOfHaikuSeen = self.theseAreDoneAll;
    }
    else
    {
        indexOfHaiku = (cat==@"user")?self.indxU:self.indxD;
        arrayOfHaikuSeen = (cat==@"user")?self.theseAreDoneU:self.theseAreDoneD;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", cat];
        filteredArray = [self.gayHaiku filteredArrayUsingPredicate:predicate];
        if (cat==@"user")
        {
            [self.toolb removeFromSuperview];
            [self.gh loadToolbar];
            [self.gh addToolbarButtonsPlusDelete];
        }
    }
    if (arrayOfHaikuSeen.count>=2 && indexOfHaiku>=2)
    {
        [self.gh clearScreen];
        [self.webV removeFromSuperview];
        [self.bar removeFromSuperview];
        [self.gh loadToolbar];
        [self.gh addToolbarButtons];
        [self.gh.view viewWithTag:3].hidden=NO;
        indexOfHaiku -= 1;
        CGSize dimensions = CGSizeMake(320, 400);
        CGSize xySize = [[[arrayOfHaikuSeen objectAtIndex:indexOfHaiku-1] valueForKey:@"quote"] sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14.0] constrainedToSize:dimensions lineBreakMode:0];
        [self.haiku_text removeFromSuperview];
        self.haiku_text = [[UITextView alloc] initWithFrame:CGRectMake((320/2)-(xySize.width/2),150,320,200)];
        self.haiku_text.text = [[arrayOfHaikuSeen objectAtIndex:indexOfHaiku-1] valueForKey:@"quote"];
        self.haiku_text.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
        self.haiku_text.backgroundColor = [UIColor clearColor];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.25;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype =kCATransitionFromLeft;
        transition.delegate = self;
        [self.gh.view.layer addAnimation:transition forKey:nil];
        [self.gh.view addSubview:self.haiku_text];
    }
    if (cat==@"user")
    {
        self.theseAreDoneU = arrayOfHaikuSeen;
        self.indxU = indexOfHaiku;
    }
    else if (cat==@"all")
    {
        self.theseAreDoneAll = arrayOfHaikuSeen;
        self.indxAll = indexOfHaiku;
    }
    else
    {
        self.theseAreDoneD = arrayOfHaikuSeen;
        self.indxD = indexOfHaiku;
    }
    self.haiku_text.editable=NO;
}

@end
