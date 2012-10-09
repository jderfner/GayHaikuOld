//
//  GHButtons.h
//  GayHaiku
//
//  Created by Joel Derfner on 9/20/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GHButtons : NSObject

@property (nonatomic, strong) UIBarButtonItem *compose;
@property (nonatomic, strong) UIBarButtonItem *bac;
@property (nonatomic, strong) UIBarButtonItem *more;
@property (nonatomic, strong) UIBarButtonItem *action;
@property (nonatomic, strong) UIBarButtonItem *ed;
@property (nonatomic, strong) UIBarButtonItem *de;
@property (nonatomic, strong) UIBarButtonItem *flex;
@property (nonatomic, strong) UIBarButtonItem *done;
@property (nonatomic, strong) UIBarButtonItem *next;
@property (nonatomic, strong) UIBarButtonItem *nextNext;
@property (nonatomic, strong) UINavigationBar *bar;
@property (nonatomic, strong) UINavigationItem *titulus;

-(void)createBarButtons;
-(void)addDoneButton:(NSString *)blah;

@end
