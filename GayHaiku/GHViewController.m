//
//  GHViewController.m
//  Gay Haiku
//
//  Created by Joel Derfner on 7/22/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import "GHViewController.h"

@interface GHViewController ()<UITextViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UIAlertViewDelegate,UIWebViewDelegate>

@end

@implementation GHViewController

@synthesize gayHaiku, textView, titulus, bar, instructions, textToSave, haiku_text, selectedCategory, webV, theseAreDoneAll, theseAreDoneD, theseAreDoneU, indxAll, indxD, indxU;


-(void)loadNavBar:(NSString *)titl
{
    self.bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.titulus = [[UINavigationItem alloc] initWithTitle:titl];
}

-(void)addLeftButton:(NSString *)titl callingMethod:method
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:titl style:UIBarButtonItemStyleBordered target:self action:NSSelectorFromString(method)];
    self.titulus.leftBarButtonItem = button;
}

-(void)addRightButton:(NSString *)titl callingMethod:(NSString *)method
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:titl style:UIBarButtonItemStyleBordered target:self action:NSSelectorFromString(method)];
    self.titulus.rightBarButtonItem = button;
}

-(void)addRightButtons:(NSArray *)titl callingMethod:(NSArray *)method
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:[titl objectAtIndex:0] style:UIBarButtonItemStyleBordered target:self action:NSSelectorFromString([method objectAtIndex:0])];
    UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithTitle:[titl objectAtIndex:1] style:UIBarButtonItemStyleBordered target:self action:NSSelectorFromString([method objectAtIndex:1])];
    NSArray *buttons = [[NSArray alloc] initWithObjects:button, button2, nil];
    self.titulus.rightBarButtonItems = buttons;
}

-(void)seeNavBar
{
    [self.bar pushNavigationItem:self.titulus animated:YES];
    [self.view addSubview:self.bar];
}

-(void)haikuInstructions
{
    self.textToSave = self.textView.text;
    NSLog(@"during instructions view %@ save %@", self.textView.text, self.textToSave);
    if (self.bar)
    {
        [self.bar removeFromSuperview];
    }
    [self loadNavBar:@"Instructions"];
    [self addLeftButton:@"Back" callingMethod:@"userWritesHaiku"];
    self.titulus.hidesBackButton=YES;
    [self seeNavBar];
    self.textView.hidden=YES;
    [self.textView resignFirstResponder];
    self.instructions = [[UITextView alloc] initWithFrame:CGRectMake(20, 44, 280, 480-44)];
    self.instructions.backgroundColor=[UIColor clearColor];
    self.instructions.text = @"\n\nFor millennia, the Japanese haiku has allowed great thinkers to express their ideas about the world in three lines of five, seven, and five syllables respectively.  \n\nContrary to popular belief, the three lines need not be three separate sentences.  Rather, either the first two lines are one thought and the third is another or the first line is one thought and the last two are another; the two thoughts are often separated by punctuation or an interrupting word.\n\nHave a fabulous time writing your own gay haiku.  Be aware that the author of this program may rely upon haiku you save as inspiration for future updates.";
    [self.view addSubview:self.instructions];
}
                             
-(void)loadAmazon
{    
    //Create nav bar.
    
    [self.view viewWithTag:1].hidden=YES;
    [self loadNavBar:@"Joel Derfner's Books"];
    [self addRightButton:@"Done" callingMethod:@"doneWithAmazon"];
    self.titulus.hidesBackButton=YES;
    [self seeNavBar];
    
    //Question:  what's the listener that hears when the user has clicked a link so that it can add the left bar button "Back" to the nav bar?
    
    self.webV.delegate = self;
    self.webV = [[UIWebView alloc] init];
    
    
     NSData *urlData;
     NSString *baseURLString =  @"http://www.amazon.com/Books-by-Joel-Derfner/lm/RVZNXKV59PL51/ref=cm_lm_byauthor_full";
    //URL in following line should be replaced by name of a file?
     NSString *urlString = [baseURLString stringByAppendingPathComponent:@"http://www.amazon.com/Books-by-Joel-Derfner/lm/RVZNXKV59PL51/ref=cm_lm_byauthor_full"];
     
     NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval: 10.0];
     
     NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:nil];
    NSError *error=nil;
    NSURLResponse *response=nil;
     if (connection) {
         urlData = [ NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&error];
     NSString *htmlString = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
     [self.webV loadHTMLString:htmlString baseURL:[NSURL URLWithString:baseURLString]];
     }
     
    
    /*NSString *fullURL=@"http://www.amazon.com/Books-by-Joel-Derfner/lm/RVZNXKV59PL51/ref=cm_lm_byauthor_full";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webV loadRequest:requestObj];*/
    self.webV.scalesPageToFit=YES;
    [self.webV setFrame:(CGRectMake(0,44,320,372))];
    [self.view addSubview:self.webV];
    

    
}

-(void)doneWithAmazon
{
    [self.webV removeFromSuperview];
    [self.bar removeFromSuperview];
    [self viewDidLoad];
}

-(void)webBack
{
    if (self.webV.canGoBack)
    {
        [self.webV goBack];
    }
}

-(void)setupForWriting
{
    [self.textView becomeFirstResponder];
}

-(void)createSpaceToWrite
{
    //if (!(self.textView.text.length>0 ))
    //{
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 60, 280, 150)];
        self.textView.delegate = self;
        self.textView.returnKeyType = UIReturnKeyDefault;
        self.textView.keyboardType = UIKeyboardTypeDefault;
        self.textView.scrollEnabled = YES;
        self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    //}
    self.textView.backgroundColor = [UIColor colorWithRed:217 green:147 blue:182 alpha:.5];
    [self.view addSubview: self.textView];
    NSLog(@"after create space to write: view %@, save %@",self.textView.text, self.textToSave);
}

-(void)clearScreen
{
    [self.instructions removeFromSuperview];
    [self.textView removeFromSuperview];
    self.textView.text=@"";
    [self.haiku_text removeFromSuperview];
    [self.bar removeFromSuperview];
    [self.webV removeFromSuperview];
    [self.view viewWithTag:3].hidden=YES;
}

-(void)userWritesHaiku
{
    [self clearScreen];
    
    //Then create and add the new UINavigationBar.
    
    [self loadNavBar:@"Compose"];
    [self addLeftButton:@"Instructions" callingMethod:@"haikuInstructions"];
    //If you've added text before calling haikuInstructions, when you return from haikuInstructions the textView window with the different background color AND the keyboard.
    [self addRightButton:@"Done" callingMethod:@"userFinishedWritingHaiku"];
    self.titulus.hidesBackButton=YES;
    [self seeNavBar];
    
    //Create and add the space for user to write.
    [self createSpaceToWrite];
    if (self.textToSave!=@"")
    {
        self.textView.text = self.textToSave;
    }
    [self.view addSubview:self.textView];

    //Why doesn't this bring the keyboard back and set the cursor blinking in self.textView?
    [self.textView becomeFirstResponder];
    
    //Keyboard notifications.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    NSLog(@"after setup of userWrites:  view %@ textToSave: %@",self.textView.text, self.textToSave);
    /*
     Still to do:
     Give user chance to opt out of sending any haiku s/he composes to my central database.
     */
}

-(void)keyboardWillShow:(NSNotification *)aNotification
{
    CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.view.frame;
    frame.size.height -= keyboardRect.size.height;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView commitAnimations];
}

-(void)userEditsHaiku
{
    //Still need to write this.
}

-(void)userFinishedWritingHaiku
{
    
    //Still need to figure out how to dismiss keyboard.
    if (!self.textView.text || self.textView.text.length==0)
        {
            [self nextHaiku];
        }
    else
    {
        self.textToSave=self.textView.text;
    }
    [self.bar removeFromSuperview];
    [self.textView resignFirstResponder];
    self.textView.backgroundColor= [UIColor clearColor];
    [self loadNavBar:@"Review"];
    [self addLeftButton:@"Edit" callingMethod:@"userWritesHaiku"];
        //If you've entered Edit, the text in the box disappears.
        NSArray *rightButtons = [[NSArray alloc] initWithObjects:@"Dismiss", @"Save", nil];
        NSArray *rightMethods = [[NSArray alloc] initWithObjects:@"nextHaiku", @"saveUserHaiku", nil];
    //[self addRightButton:@"Save" callingMethod:@"saveUserHaiku"];
    //[self addRightButton:@"Dismiss" callingMethod:@"nextHaiku"];
        [self addRightButtons:rightButtons callingMethod:rightMethods];
    self.titulus.hidesBackButton=YES;
    [self seeNavBar];
    [self.view viewWithTag:1].hidden=YES;
    
        //Maybe I should leave this out?  I give instructions.  Maybe no need to play the police officer?
    /*int noOfLines = 0;
    BOOL syllableCountCorrectLineOne = NO;
    BOOL syllableCountCorrectLineTwo = YES;
    BOOL syllableCountCorrectLineThree = YES;
    NSMutableString *warningMessage;
    TO DO:
     1.  Check that haiku is three lines.
     2.  Check that syllable count is correct (as per CMU pronouncing dictionary (in public domain) --how do I load that in?)
    if (noOfLines<3)
    {
        [warningMessage appendString:(@"Your haiku seems to have fewer than three lines.  ")];
    }
    if (noOfLines>3)
    {
        [warningMessage appendString:(@"Your haiku seems to have more than three lines.  ")];
    }
    if (!syllableCountCorrectLineOne)
    {
        [warningMessage appendString:(@"Your first line seems not to have five syllables.  ")];
    }
    if (!syllableCountCorrectLineTwo)
    {
        [warningMessage appendString:(@"Your second line seems not to have seven syllables.  ")];
    }
    if (!syllableCountCorrectLineThree)
    {
        [warningMessage appendString:(@"Your third line seems not to have five syllables.  ")];
    }
    if (warningMessage!=@"")
    {
        [warningMessage appendString:(@"Would you prefer to leave things as they are or go back and edit?")];
    }
    //Why isn't this next line showing?
    self.haiku_text.text=warningMessage;*/
    //Offer choice between saving as is or editing.
    //How is the above choice (save as is or edit) offered?  alertView?  Text plus new UINavigationItem?
    //Write code to deal with the above choice.
    //self.textView.hidden=YES;
    //If haiku was saved, display in self.haiku_text.
    }



-(void)keyboardWillHide:(NSNotification *)aNotification
{
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView commitAnimations];
}

/*- (void)textViewDidBeginEditing:(UITextView *)textView
{
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveAction:)];
    self.navigationItem.rightBarButtonItem = saveItem;
}*/

-(void)viewDidLoad {
	[super viewDidLoad];
	//NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"gayHaiku" ofType:@"plist"];
	//self.gayHaiku = [NSMutableArray arrayWithContentsOfFile:plistCatPath];
    
     NSError *error;
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
     NSString *documentsDirectory = [paths objectAtIndex:0];
     NSString *path = [documentsDirectory stringByAppendingPathComponent:@"gayHaiku.plist"];
     NSFileManager *fileManager = [NSFileManager defaultManager];
     if (![fileManager fileExistsAtPath: path])
     {
     NSString *bundle = [[NSBundle mainBundle] pathForResource:@"gayHaiku" ofType:@"plist"];
     [fileManager copyItemAtPath:bundle toPath: path error:&error];
     }
     self.gayHaiku = [[NSMutableArray alloc] initWithContentsOfFile: path];
     [self nextHaiku];
}

-(void)saveUserHaiku
{   if (self.textView.text.length>0)
    {
        //First, add the haiku to self.gayHaiku.
        
        NSArray *quotes = [[NSArray alloc] initWithObjects:@"user", self.textView.text, nil];
        NSArray *keys = [[NSArray alloc] initWithObjects:@"category",@"quote",nil];
        NSDictionary *dictToSave = [[NSDictionary alloc] initWithObjects:quotes forKeys:keys];
        [[self gayHaiku] addObject:dictToSave];
        if (self.bar) [self.bar removeFromSuperview];
        self.textView.text=@"";
        self.textToSave=@"";
        [self.view viewWithTag:1].hidden = NO;
        [self.view viewWithTag:3].hidden = NO;
        self.haiku_text.text = [[self.gayHaiku lastObject] valueForKey:@"quote"];
        [self.view addSubview:self.haiku_text];
        
        //Then update the array in the documents folder.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"gayHaiku.plist"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath: path])
        {
            [self.gayHaiku writeToFile:path atomically:YES];
        }
        
        //Should there be an option to DELETE haiku the user has written?
        
        /*
         
         This is part of the code to get haiku to "haiku" table on "gayhaiku" MySQL on db.joelderfner.com, but I have no idea what the fuck it says.  Or, rather, I can tell what it says, on a very basic level, sort of, but not how to set up what it's sending the message to.  "gayhaiku'."haiku" is set up, but what's the mechanism to get this haiku there?
         
        NSString *myRequestString = [NSString stringWithFormat:@"%@",self.haiku_text.text];
        NSData *myRequestData = [NSData dataWithBytes:[myRequestString UTF8String] length:[myRequestString length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.joelderfner.com/"]]; 
        [request setHTTPMethod: @"POST"];
        [request setHTTPBody: myRequestData];
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        // To see what the response from your server is, NSLog returnString to the console or use it whichever way you want it.
        NSLog (@"%@", returnString);
         */


    }
    else 
    {
        [self nextHaiku];
    }
}

-(void)viewDidUnload {
	[super viewDidUnload];

}

- (IBAction)chooseDatabase:(UISegmentedControl *)segment {
    if (segment.selectedSegmentIndex==1) {
        self.selectedCategory = @"user";
    }
    else if (segment.selectedSegmentIndex==2) {
        self.selectedCategory = @"all";
    }
    else self.selectedCategory = @"Derfner";
}
  
- (void)openMail {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        //Replace "Someone" in following line with user's name.
        [mailer setSubject:[NSString stringWithFormat:@"%@ has sent you a gay haiku.", [[UIDevice currentDevice] name]]];
        UIView *whatToUse;
        [whatToUse viewWithTag:10];
        [whatToUse viewWithTag:20];
        CGRect newRect = CGRectMake(0, 0, 320, 416);
        UIGraphicsBeginImageContext(newRect.size); //([self.view frame].size])
        [self.view viewWithTag:30].hidden=YES;
        [self.view viewWithTag:40].hidden=YES;
        [self.view viewWithTag:3].hidden=YES;

        [[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *myImage = UIGraphicsGetImageFromCurrentImageContext();
        [self.view viewWithTag:30].hidden=NO;
        [self.view viewWithTag:40].hidden=NO;
        UIGraphicsEndImageContext();
        
        UIGraphicsBeginImageContext([self.view bounds].size);
        [myImage drawInRect:CGRectMake(0, 0, 320,416)];
        myImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSData *imageData = UIImagePNGRepresentation(myImage);
        [mailer addAttachmentData:imageData mimeType:@"image/jpg" fileName:@"blah"];
        
        NSString *emailBody = @"I thought you might like this gay haiku from the Gay Haiku iPhone app.  Please love me?";
        [mailer setMessageBody:emailBody isHTML:NO];
        
        [self presentModalViewController:mailer animated:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure." message:@"Your device doesn't support the composer sheet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}
    
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{  
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

//- work this:
//- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result;

-(IBAction)nextHaiku
{
    [self.bar removeFromSuperview];
    self.textView.text=@"";
    self.textToSave=@"";
    [self.textView removeFromSuperview];
    self.haiku_text.text=@"";
    [self.view viewWithTag:1].hidden = NO;
    [self.view viewWithTag:3].hidden = NO;
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
    }
    int array_tot = [filteredArray count];
    int sortingHat;
    NSString *txt;
    if (array_tot > 0)
    {
        if (indexOfHaiku == arrayOfHaikuSeen.count)
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
            if (indexOfHaiku && arrayOfHaikuSeen.count)
            {
                NSLog(@"%d %d",indexOfHaiku,arrayOfHaikuSeen.count);
            }
            if (arrayOfHaikuSeen.count==filteredArray.count)
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
    //Need to test to make sure it starts over once all 110 haiku have been seen.
    
    CGSize dimensions = CGSizeMake(320, 400);
    CGSize xySize = [txt sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14.0] constrainedToSize:dimensions lineBreakMode:0];
    self.haiku_text = [[UITextView alloc] initWithFrame:CGRectMake((320/2)-(xySize.width/2),200,320,200)];
    //Is the next line necessary?
    //self.haiku_text.delegate = self;
    self.haiku_text.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    self.haiku_text.backgroundColor = [UIColor clearColor];
    self.haiku_text.text=txt;
    [self.view addSubview:self.haiku_text];
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
    //Question:  how will it affect the user's experience if/when haiku s/he's already seen in "user" or "Derfner" categories reappear in "all" category?  Will this need to be adjusted?  If so, how?
}


-(IBAction)previousHaiku
{
    if (self.bar)
    {
        [self.bar removeFromSuperview];
    }
        if (self.textView)
    {
        [self.textView removeFromSuperview];
    }
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
        }
        [self.view viewWithTag:1].hidden = NO;
        [self.view viewWithTag:3].hidden = NO;
    
        if (arrayOfHaikuSeen.count>1 && indexOfHaiku>0)
        {
            
            CGSize dimensions = CGSizeMake(320, 400);
            CGSize xySize = [[[arrayOfHaikuSeen objectAtIndex:indexOfHaiku-2] valueForKey:@"quote"] sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14.0] constrainedToSize:dimensions lineBreakMode:0];
            [self.haiku_text removeFromSuperview];
            self.haiku_text = [[UITextView alloc] initWithFrame:CGRectMake((320/2)-(xySize.width/2),200,320,200)];
            self.haiku_text.text = [[arrayOfHaikuSeen objectAtIndex:indexOfHaiku-2] valueForKey:@"quote"];
            self.haiku_text.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
            self.haiku_text.backgroundColor = [UIColor clearColor];
            [self.view addSubview:self.haiku_text];
            indexOfHaiku -= 1;
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
}
/*
-(void)saveOnCloseApplication
{
    //Reading from File
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"data.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@”gayHaiku” ofType:@”plist”]; //5
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
    }
}*/
/*
 [self.view viewWithTag:60].hidden=YES;
 NSString *plistCatPath = [[NSBundle mainBundle] pathForResource:@"gayHaiku" ofType:@"plist"];
 self.gayHaiku = [NSMutableArray arrayWithContentsOfFile:plistCatPath];
 */


-(IBAction)showMessage
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Email",@"Facebook",@"Twitter", nil];
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex { if (buttonIndex == 1) { 
     [self openMail]; 
    } 
     else if (buttonIndex == 2) { 
         //Deal with Facebook API.
         NSLog(@"Sent to Facebook."); 
     } 
     else if (buttonIndex == 3) {
         //Deal with Twitter API.
         NSLog(@"Sent to Twitter.");
     }
 }
@end
