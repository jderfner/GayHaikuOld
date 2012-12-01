//
//  GHVerify.h
//  GayHaiku
//
//  Created by Joel Derfner on 12/1/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+RNTextStatistics.h"

@interface GHVerify : NSObject

@property (nonatomic, strong) NSString *haikuToCheck;
@property (nonatomic, strong) NSArray *listOfLines;

-(int)numberOfLines;
-(int)syllablesInLine: (NSString *)line;
-(NSArray *)splitHaikuIntoLines;

@end
