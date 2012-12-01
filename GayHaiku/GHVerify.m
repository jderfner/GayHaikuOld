//
//  GHVerify.m
//  GayHaiku
//
//  Created by Joel Derfner on 12/1/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import "GHVerify.h"

@implementation GHVerify

@synthesize haikuToCheck, listOfLines;

-(NSArray *)splitHaikuIntoLines {
    self.listOfLines = [self.haikuToCheck componentsSeparatedByString:@"\n"];
    return self.listOfLines;
}

-(int) numberOfLines {
    NSLog(@"No of lines : %d",[self.listOfLines count]);
    return [self.listOfLines count];
}

-(int) syllablesInLine: (NSString *)line {
    int number = [line syllableCount];
    NSLog(@"Syllables in line: %d",number);
    return number;
}

@end
