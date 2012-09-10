//
//  TCTweetComposeViewController.m
//  tweet-composer
//
//  Created by Philip Dow on 7/29/12.
//  Copyright (c) 2012 Philip Dow. All rights reserved.
//  
//  ARC
//

/*
 Copyright (C) 2012 Philip Dow / Sprouted. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.
 
 * Neither the name of the author nor the names of its contributors may be used
   to endorse or promote products derived from this software without specific
   prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#import "TCTweetComposeViewController.h"

// user default key for last selected account
static NSString * TCTwitterLastSelectedUserNameKey = @"TCTwitterLastSelectedUserName";

// localizable strings
static NSString * TCTweetNavBarTitle = @"Tweet";
static NSString * TCSendButtonTitle = @"Send";
static NSString * TCAccountLabel = @"Account:";

// additional localizable strings used for error reporting
// see bottom of class

// API access points
// https://dev.twitter.com/docs/ios/posting-images-using-twrequest
static NSString * TCStatusUpdateURLString = @"https://api.twitter.com/1/statuses/update.json";
static NSString * TCMediaStatusUpdateURLString = @"https://upload.twitter.com/1/statuses/update_with_media.json";

// UI View Tags

static NSInteger TCAccountFieldTag = 101;
static NSInteger TCCharCountFieldTag = 102;
static NSInteger TCMessageTextViewTag = 101;
static NSInteger TCMessageImageViewTag = 102;

// UI Frames
static CGFloat TCTableRowHeight = 44.f;

#define TCTweetTableFrame CGRectMake(0, 0, 320, 200)
#define TCAccountPickerViewFrame CGRectMake(0, 200, 320, 216)

#define TCAccountCellFrame CGRectMake(0, 0, 44, 480)
#define TCAccountLabelFrame CGRectMake(8, 44/2-20/2, 70, 21)
#define TCAccountFieldFrame CGRectMake(8+70, 44/2-20/2, 320-(70+8+36+8), 21)
#define TCAccountCharacterCountFrame CGRectMake(320-(36+8), 44/2-20/2, 36, 21)

#define TCMessageCellFrame CGRectMake(0, 0, 320, 480-44-44)
#define TCMessageTextFrame CGRectMake(8, 8, 320-(8+8), 200-44)
#define TCMessageImageFrame CGRectMake(320-(64+8), 8, 64, 64)

#pragma mark -

@interface TWTeetComposeRootViewController : UIViewController

// placeholder

@end

@implementation TWTeetComposeRootViewController

// placeholder

@end

#pragma mark -

@interface TCTweetComposeViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate> {
    
    // interface
    UITableViewCell *_accountCell;
    UITableViewCell *_messageCell;
    UIViewController *_controller;
    UITableView *_tableView;
    UIPickerView *_pickerView;
    
    // account
    ACAccountStore *_accountStore;
    NSArray *_accounts;
    NSInteger _selectedAccount;
    
    // tweet
    NSMutableArray *_images;
    NSMutableArray *_URLs;
    
    BOOL _showsImages;
    BOOL _showsURLs;
    BOOL _isPresented;
    BOOL _sending;
}

- (UIViewController*) initializedRootViewController;
- (UITableViewCell*) accountCell;
- (UITableViewCell*) messageCell;

- (void) setImageViewHidden:(BOOL)hidden;
- (void) updateAttachedURLs;
- (void) updateCharacterCount;
- (void) updateSendButton;

- (UITextView*) messageTextView;
- (UIImageView*) messageImageView;
- (UITextField*) accountTextField;
- (UILabel*) charCountTextField;

- (void) twitterAccounts:(void(^)(NSArray *accounts, NSError *error))handler;
- (void) performTwitterPostStatusRequest:(TWRequest*)request;
- (void) postStatusUpdateWithMedia;
- (void) postStatusUpdate;

- (UIAlertView*) twitterAccountsAlert;
- (UIAlertView*) postStatusFailedAlert;

@end

#pragma mark -
#pragma mark TCTweetComposeViewController

@implementation TCTweetComposeViewController

+ (BOOL) canSendTweet
{
    // which seems to have access to underlying account info without having to
    // actually request access to it
    return [TWTweetComposeViewController canSendTweet];
}

- (id) initComposer
{
    return [super initWithRootViewController:[self initializedRootViewController]];
}

- (UIViewController*) initializedRootViewController
{
    TWTeetComposeRootViewController *controller = [[TWTeetComposeRootViewController alloc] init];
    UITableView *tableView = [[UITableView alloc] initWithFrame:TCTweetTableFrame style:UITableViewStylePlain];
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:TCAccountPickerViewFrame];
    
    controller.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
    pickerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth); // fix
    
    controller.title = NSLocalizedString(TCTweetNavBarTitle, TCTweetNavBarTitle);
    controller.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    [controller.view addSubview:tableView];
    [controller.view addSubview:pickerView];
    
    controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    controller.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(TCSendButtonTitle, TCSendButtonTitle) style:UIBarButtonItemStyleDone target:self action:@selector(send:)];
    
    pickerView.hidden = YES;
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    tableView.dataSource = self;
    tableView.delegate = self;
    
    _controller = controller;
    _pickerView = pickerView;
    _tableView = tableView;
    
    _images = [[NSMutableArray alloc] init];
    _URLs = [[NSMutableArray alloc] init];
    
    _accounts = [[NSArray alloc] init];
    _selectedAccount = NSNotFound;
    
    _showsImages = YES;
    _showsURLs = YES;
    _isPresented = NO;
    _sending = NO;
        
    return controller;
}

- (UITableViewCell*) accountCell
{
    if (_accountCell) {
        return _accountCell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:TCAccountCellFrame];
    UILabel *label = [[UILabel alloc] initWithFrame:TCAccountLabelFrame];
    UITextField *field = [[UITextField alloc] initWithFrame:TCAccountFieldFrame];
    UILabel *count = [[UILabel alloc] initWithFrame:TCAccountCharacterCountFrame];
    
    count.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    count.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    count.textAlignment = UITextAlignmentRight;
    count.tag = TCCharCountFieldTag;
    count.text = @"140";
    
    label.text = NSLocalizedString(TCAccountLabel, TCAccountLabel);
    label.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    
    field.tag = TCAccountFieldTag;
    field.delegate = self;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell addSubview:field];
    [cell addSubview:label];
    [cell addSubview:count];
    
    _accountCell = cell;
    return cell;
}

- (UITableViewCell*) messageCell
{
    if (_messageCell) {
        return _messageCell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:TCMessageCellFrame];
    UITextView *field = [[UITextView alloc] initWithFrame:TCMessageTextFrame];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:TCMessageImageFrame];
    
    field.contentInset = UIEdgeInsetsMake(-8,-8,-8,-8);
    field.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
    //field.dataDetectorTypes = UIDataDetectorTypeLink;
    field.showsHorizontalScrollIndicator = NO;
    field.showsVerticalScrollIndicator = NO;
    field.tag = TCMessageTextViewTag;
    field.delegate = self;
    
    imageView.tag = TCMessageImageViewTag;
    imageView.hidden = YES;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell addSubview:imageView];
    [cell addSubview:field];
    
    _messageCell = cell;
    return cell;
}

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    _accountCell = nil;
    _messageCell = nil;
    _controller = nil;
    _pickerView = nil;
    _tableView = nil;
    
    _accounts = nil;
    _accountStore = nil;
    
    _images = nil;
    _URLs = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    // update the appearance
    [self setImageViewHidden:([_images count]==0)];
    [self updateAttachedURLs];
    [self updateCharacterCount];
    
    // show the keyboard
    [[self messageTextView] becomeFirstResponder];
    
    // get the accounts
    [self twitterAccounts:^(NSArray *accounts, NSError *error) {
        if (error) {
            // display the error
            NSLog(@"Error acquiring twitter accounts: %@",error);
            [[self twitterAccountsAlert] show];
            return;
        }
        _accounts = accounts;
                
        // accounts should always be greater than 0, otherwise canSendTweet
        // returns false
        
        if ([_accounts count]>0) {
            
            NSInteger defaultIndex = 0;
            NSString *defaultUser = [[NSUserDefaults standardUserDefaults] objectForKey:TCTwitterLastSelectedUserNameKey];
            
            if ( defaultUser ) {
                defaultIndex = [_accounts indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                    if ( [[(ACAccount*)obj username] isEqualToString:defaultUser] ) {
                        *stop = YES;
                        return YES;
                    } else {
                        return NO;
                    }
                }];
                if ( defaultIndex == NSNotFound ) {
                    defaultIndex = 0;
                }
            }
            
            _selectedAccount = defaultIndex;
            NSString *username = [[_accounts objectAtIndex:defaultIndex] username];
            NSString *text = [NSString stringWithFormat:@"@%@",username];
            [self accountTextField].text = text;
        }
        
        [_pickerView reloadAllComponents];
        [_pickerView selectRow:_selectedAccount inComponent:0 animated:NO];
        [self updateSendButton];
    }];
}

- (void) viewDidAppear:(BOOL)animated
{
    _isPresented = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Public API

- (BOOL)setInitialText:(NSString *)text;
{
    if (_isPresented) {
        return NO;
    }
    
    [self messageTextView].text = text;
    [self updateCharacterCount];
    return YES;
}

- (BOOL)addImage:(UIImage *)image
{
    if (_isPresented) {
        return NO;
    }
    if ([_images count] >= 1) {
        return NO;
    }
    
    [_images addObject:image];
    [self messageImageView].image = image;
    return YES;
}

- (BOOL)addURL:(NSURL *)url
{
    if (_isPresented) {
        return NO;
    }
    
    [_URLs addObject:url];
    return YES;
}

- (BOOL)removeAllImages
{
    if (_isPresented) {
        return NO;
    }
    
    [_images removeAllObjects];
    [self messageImageView].image = nil;
    return YES;
}

- (BOOL)removeAllURLs
{
    if (_isPresented) {
        return NO;
    }
    
    [_URLs removeAllObjects];
    return YES;
}

#pragma mark -

- (BOOL) setShowsImages:(BOOL)showsImages
{
    if (_isPresented) {
        return NO;
    }
    
    _showsImages = showsImages;
    return YES;
}

- (BOOL) setShowsURLs:(BOOL)showsURLs
{
    if (_isPresented) {
        return NO;
    }
    
    _showsURLs = showsURLs;
    return YES;
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if ( indexPath.row == 0 ) {
        cell = [self accountCell];
    } else if ( indexPath.row == 1) {
        cell = [self messageCell];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
    case 0:
        return TCTableRowHeight;
        break;
    case 1:
        return TCTweetTableFrame.size.height - TCTableRowHeight;
        break;
    default:
        return TCTableRowHeight;
        break;
    }
}

#pragma mark - Picker View Delegate and Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_accounts count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"@%@",[[_accounts objectAtIndex:row] username]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectedAccount = row;
    NSString *username = [[_accounts objectAtIndex:row] username];
    [self accountTextField].text = [NSString stringWithFormat:@"@%@",username];
    
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:TCTwitterLastSelectedUserNameKey];
}

#pragma mark - Text Field / Text View Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _pickerView.hidden = NO;
    [[self messageTextView] resignFirstResponder];
    return NO;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self updateCharacterCount];
}

#pragma mark - UI Utilities

- (void) setImageViewHidden:(BOOL)hidden
{
    if ( !_showsImages ) {
        return;
    }
    
    CGRect textFrame = TCMessageTextFrame;
    if (!hidden) textFrame.size.width -= TCMessageImageFrame.size.width;
    
    [self messageImageView].hidden = hidden;
    [self messageTextView].frame = textFrame;
}

- (void) updateAttachedURLs
{
    if ( !_showsURLs ) {
        return;
    }
    
    for ( NSURL *URL in _URLs ) {
        [self messageTextView].text = [[self messageTextView].text stringByAppendingFormat:@" %@",[URL absoluteString]];
    }
}

- (void) updateCharacterCount
{
    // seems a safe value for now, discover dynamically?
    // https://api.twitter.com/1/help/configuration.json
    
    static NSInteger kTwitterPicURLLength = 28;
    static NSInteger kTwitterURLLength = 22;
    static NSInteger kMaxTweetLength = 140;
    
    UITextView *textView = [self messageTextView];
    UILabel *field = [self charCountTextField];
    NSString *text = textView.text;
    
    NSInteger length = [text length];
    length += ([_images count]*kTwitterPicURLLength);
    
    if ( !_showsURLs ) {
        // length should include hidden URLs if we aren't showing them
        length += ([_URLs count]*kTwitterURLLength);
    } else {
        // we actually want to remove the length of the urls and replace them
        // with the twitter url length
        
        NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
        NSArray *matches = [detector matchesInString:text options:0 range:NSMakeRange(0, [text length])];
        for (NSTextCheckingResult *match in matches) {
            NSRange matchRange = [match range];
            length -= matchRange.length;
            length += kTwitterURLLength;
        }
    }
    
    NSInteger remaining = kMaxTweetLength - length;
    
    field.text = [NSString stringWithFormat:@"%i",remaining];
    if ( remaining < 0 ) {
        field.textColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.2 alpha:1.0];
    } else {
        field.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    }
    
    // always update the send button whenever the text changes
    [self updateSendButton];
}

- (void) updateSendButton
{
    BOOL hasText = [[self messageTextView] hasText];
    BOOL canSend = (hasText && _selectedAccount != NSNotFound);
    _controller.navigationItem.rightBarButtonItem.enabled = canSend;
}

#pragma mark -

- (UITextField*) accountTextField
{
    return (UITextField*)[[self accountCell] viewWithTag:TCAccountFieldTag];
}

- (UILabel*) charCountTextField
{
    return (UILabel*)[[self accountCell] viewWithTag:TCCharCountFieldTag];
}

- (UITextView*) messageTextView
{
    return (UITextView*)[[self messageCell] viewWithTag:TCMessageTextViewTag];
}

- (UIImageView*) messageImageView
{
    return (UIImageView*)[[self messageCell] viewWithTag:TCMessageImageViewTag];
}

#pragma mark - User Actions

- (IBAction)cancel:(id)sender
{
    if (self.completionHandler) {
        dispatch_async(dispatch_get_main_queue(),^{
            self.completionHandler(TCTweetComposeViewControllerResultCancelled);
        });
    }
}

- (IBAction)send:(id)sender
{
    if (_sending) {
        return;
    }
    
    if ([_images count] == 0) {
        [self postStatusUpdate];
    } else {
        [self postStatusUpdateWithMedia];
    }
    
    _sending = YES;
}

#pragma mark - Twitter Acounts and API

- (void) postStatusUpdateWithMedia
{
    TWRequest *request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:TCMediaStatusUpdateURLString] parameters:nil requestMethod:TWRequestMethodPOST];
    
    // Add the data of the image with the correct parameter name, "media[]"
    for (NSUInteger i = 0; i < [_images count]; i++ ) {
        NSData *imageData = UIImagePNGRepresentation([_images objectAtIndex:i]);
        NSString *name = @"media[]";
        [request addMultiPartData:imageData withName:name type:@"multipart/form-data"];
    }
    
    //  Add the data of the status as parameter "status"
    NSString *status = [self messageTextView].text;
    
    // append URLs only if we aren't already showing them
    if ( !_showsURLs ) {
        for ( NSURL *URL in _URLs ) {
            status = [status stringByAppendingFormat:@" %@", [URL absoluteString]];
        }
    }
    
    [request addMultiPartData:[status dataUsingEncoding:NSUTF8StringEncoding] withName:@"status" type:@"multipart/form-data"];
    
    request.account = [_accounts objectAtIndex:_selectedAccount];
    [self performTwitterPostStatusRequest:request];
}

- (void) postStatusUpdate
{
    //  Add the data of the status as parameter "status"
    NSString *status = [self messageTextView].text;
    
    // append URLs only if we aren't already showing them
    if ( !_showsURLs ) {
        for ( NSURL *URL in _URLs ) {
            status = [status stringByAppendingFormat:@" %@", [URL absoluteString]];
        }
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:status forKey:@"status"];
    
    TWRequest *request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:TCStatusUpdateURLString] parameters:params requestMethod:TWRequestMethodPOST];
    
    request.account = [_accounts objectAtIndex:_selectedAccount];
    [self performTwitterPostStatusRequest:request];
}

- (void) performTwitterPostStatusRequest:(TWRequest*)request
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if ( error ) {
            NSLog(@"Error performing twitter request: %@", error);
            dispatch_async(dispatch_get_main_queue(),^{
                UIAlertView *alert = [self postStatusFailedAlert];
                alert.message = [error localizedDescription];
                [alert show];
            });
            _sending = NO;
            return;
        }/* else {
            NSStringEncoding responseEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding((__bridge CFStringRef)[urlResponse textEncodingName]));
            NSString *responseString = [[NSString alloc] initWithData:responseData encoding:responseEncoding];
            
            NSLog(@"%@", [urlResponse allHeaderFields]);
            NSLog(@"%@", responseString);
        } */
        
        if ( self.completionHandler) {
            dispatch_async(dispatch_get_main_queue(),^{
                self.completionHandler(TCTweetComposeViewControllerResultDone);
            });
        }
    }];
}

- (void) twitterAccounts:(void(^)(NSArray *accounts, NSError *error))handler
{
    // First, we need to obtain the account instance for the user's Twitter account
    // Account store is an instance variable because it apparently needs to be
    // kept around.
    
    _accountStore = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    //  Request access from the user for access to his Twitter accounts
    //  This method is not guaranteed to call into the block on the main thread
    
    [_accountStore requestAccessToAccountsWithType:twitterAccountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            if (handler) {
                dispatch_async(dispatch_get_main_queue(),^{
                    handler(nil,error);
                });
            }
        }
        else {
            // Grab the available accounts
            NSArray *twitterAccounts = [_accountStore accountsWithAccountType:twitterAccountType];
            if (handler) {
                dispatch_async(dispatch_get_main_queue(),^{
                    handler(twitterAccounts,nil);
                });
            }
        }
    }];
}

#pragma mark Error Alerts

- (UIAlertView*) twitterAccountsAlert
{
    NSString *title = NSLocalizedString(@"Twitter Account Unavailable", @"Twitter Account Unavailable");
    NSString *message = NSLocalizedString(@"There was a problem accessing your twitter accounts", @"Twitter Account Unavailable Message");
    NSString *button = NSLocalizedString(@"Continue", @"Continue");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:button otherButtonTitles: nil];
    
    return alert;
}

- (UIAlertView*) postStatusFailedAlert
{
    NSString *title = NSLocalizedString(@"Unable to Send Tweet", @"Unable to Send Tweet");
    NSString *message = NSLocalizedString(@"There was a problem sending your tweet. Check your internet connection and the length of your tweet.", @"Unable to Send Tweet Message");
    NSString *button = NSLocalizedString(@"Continue", @"Continue");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:button otherButtonTitles: nil];
    
    return alert;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // any alert indicates an error, and we dispatch to the completion handler
    // with a cancel. a delegate must be set on the alert
    
    if ( self.completionHandler) {
        dispatch_async(dispatch_get_main_queue(),^{
            self.completionHandler(TCTweetComposeViewControllerResultCancelled);
        });
    }
}

@end
