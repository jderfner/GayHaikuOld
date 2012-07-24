//
//  GHAppDelegate.h
//  GayHaiku
//
//  Created by Joel Derfner on 7/23/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GHViewController;

@interface GHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) GHViewController *viewController;

@end
