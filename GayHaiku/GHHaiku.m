//
//  GHHaiku.m
//  GayHaikuReal
//
//  Created by Joel Derfner on 9/15/12.
//  Copyright (c) 2012 Joel Derfner. All rights reserved.
//

#import "GHHaiku.h"

@implementation GHHaiku

@synthesize arrayOfSeen, mutArr, mutArrUser, arrayAfterFiltering, index, selectedCategory;

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
    if (self.arrayAfterFiltering.count==self.arrayOfSeen.count)
    {
        [self.arrayOfSeen removeAllObjects];
        self.index=0;
    }
    if (!self.arrayOfSeen) self.arrayOfSeen = [[NSMutableArray alloc] init];
    
//If there are any haiku in the array
    
    if (self.arrayAfterFiltering.count>0)
    {

//1.  If you're in the user category and there's one haiku left:
        
        if (self.arrayAfterFiltering.count==1 && [self.selectedCategory isEqual: @"user"])
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

-(void) loadHaiku
{
    //This loads the haiku from gayHaiku.plist to the file "path".
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"gayHaiku.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath: path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"gayHaiku" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    
    //UNCOMMENT, RUN, AND THEN RECOMMENT THIS SECTION IF NEED TO DELETE LOCAL HAIKU DOCUMENT (FOR TESTING USER-GENERATED HAIKU, ETC.).
    /*
     else if ([fileManager fileExistsAtPath: path])
     {
     [fileManager removeItemAtPath:path error:&error];
     }
     */
    
    //Loads an array with the contents of "path".
    
    self.mutArr = [[NSMutableArray alloc] initWithContentsOfFile: path];
    
    //This loads the haiku from userHaiku.plist to the file "userPath".
    
    NSArray *userPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *userDocumentsDirectory = [userPaths objectAtIndex:0];
    NSString *userPath = [userDocumentsDirectory stringByAppendingPathComponent:@"userHaiku.plist"];
    NSFileManager *userFileManager = [NSFileManager defaultManager];
    if (![userFileManager fileExistsAtPath: userPath])
    {
        NSString *userBundle = [[NSBundle mainBundle] pathForResource:@"userHaiku" ofType:@"plist"];
        [userFileManager copyItemAtPath:userBundle toPath: userPath error:&error];
    }
    //UNCOMMENT, RUN, AND THEN RECOMMENT THIS SECTION IF NEED TO DELETE LOCAL HAIKU DOCUMENT (FOR TESTING USER-GENERATED HAIKU, ETC.).
    /*
     else if ([userFileManager fileExistsAtPath: userPath])
     {
     [userFileManager removeItemAtPath:userPath error:&error];
     }
     */
    
    //Loads an array with the contents of "userPath".

    self.mutArrUser = [[NSMutableArray alloc] initWithContentsOfFile:userPath];
}


@end
