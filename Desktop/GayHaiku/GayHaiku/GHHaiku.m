//
//  GHHaiku.m
//  GayHaikuReal
//
//  Created by Joel Derfner on 9/15/12.
//  Copyright (c) 2012 Joel Derfner. All rights reserved.
//

#import "GHHaiku.h"

@implementation GHHaiku

@synthesize arrayOfSeen, arrayAfterFiltering, index, selectedCategory;

-(int)chooseNumber
{
    int x;
    x = (arc4random() % self.arrayAfterFiltering.count);
    return x;
}

-(NSString *)haikuToShow
{
    NSString *txt;
    int sortingHat;
    if (!self.index) self.index=0;
    if (!self.arrayOfSeen) self.arrayOfSeen = [[NSMutableArray alloc] init];
    
//If there are any haiku in the array
    
    if (self.arrayAfterFiltering.count>0)
    {

//1.  If you're in the user category and there's one haiku left:
        
        if (self.arrayAfterFiltering.count==1 && self.selectedCategory==@"user")
        {
            txt = [[self.arrayAfterFiltering objectAtIndex:0] valueForKey:@"quote"];
        }
        
//2.  If you haven't called previousHaiku
        
        else if (self.index == self.arrayOfSeen.count)
        {
            while (true)
            {
                sortingHat = [self chooseNumber];
                
    //If you haven't already seen the haiku at the chosen number....
                
                if (![self.arrayOfSeen containsObject:[self.arrayAfterFiltering objectAtIndex:sortingHat]])
                {
                    break;
                }
            }
            
    //Set text to quote for chosen number
            
            txt = [[self.arrayAfterFiltering objectAtIndex:sortingHat] valueForKey:@"quote"];
            
    //Add haiku to array of haiku seen.
            
            [self.arrayOfSeen addObject:[self.arrayAfterFiltering objectAtIndex:sortingHat]];
            
    //change index to new index
            
            self.index = self.arrayOfSeen.count;
            
            //If the haiku just chosen was the last available, start over.
            
            if (self.arrayOfSeen.count == self.arrayAfterFiltering.count)
            {
                [self.arrayOfSeen removeAllObjects];
                self.index=0;
            }
            
        }
        
//3.  If you have called previousHaiku

        else
        {
            txt = [[self.arrayOfSeen objectAtIndex:self.index] valueForKey:@"quote"];
            self.index += 1;
        }
    }
    return txt;
}


@end
