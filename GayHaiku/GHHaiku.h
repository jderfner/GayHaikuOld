//
//  GHHaiku.h
//  GayHaikuReal
//
//  Created by Joel Derfner on 9/15/12.
//  Copyright (c) 2012 Joel Derfner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GHHaiku : NSObject

-(int)chooseNumber;
-(NSString *)haikuToShow;

@property (nonatomic) int index;
@property (nonatomic, strong) NSMutableArray *arrayOfSeen;
@property (nonatomic, strong) NSMutableArray *mutArr;
@property (nonatomic, strong) NSMutableArray *mutArrUser;
@property (nonatomic, strong) NSArray *arrayAfterFiltering;
@property (nonatomic, strong) NSString *selectedCategory;

-(void) loadHaiku;


@end
