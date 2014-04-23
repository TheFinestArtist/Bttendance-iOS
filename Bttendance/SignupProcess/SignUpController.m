//
//  SignUpController.m
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 11. 19..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import <AFNetworking.h>
#import "SignUpController.h"
#import "MainViewController.h"
#import "CustomCell.h"
#import "SignButtonCell.h"
#import "BTColor.h"
#import "BTAPIs.h"
#import "WebViewController.h"
#import "BTUserDefault.h"

NSString *signupRequest;


@interface SignUpController ()
@end

@implementation SignUpController
@synthesize schoolId;
@synthesize serial;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    signupRequest = [BTURL stringByAppendingString:@"/user/signup"];
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        fullname_index = [NSIndexPath indexPathForRow:0 inSection:0];
        email_index = [NSIndexPath indexPathForRow:1 inSection:0];
        username_index = [NSIndexPath indexPathForRow:2 inSection:0];
        password_index = [NSIndexPath indexPathForRow:3 inSection:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    //status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    //Navigation title
    //set title
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:18.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Sign up", @"");
    [titlelabel sizeToFit];

    [self showNavigation];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)appDidBecomeActive:(NSNotification *)notification {
    [self showNavigation];
}

- (void)appDidEnterForeground:(NSNotification *)notification {
    [self showNavigation];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showNavigation {
    //Navigation showing
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"set autofocus");
    CustomCell *cell1 = (CustomCell *) [self.tableView cellForRowAtIndexPath:fullname_index];
    [cell1.textfield becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {

}

- (void)viewWillAppear:(BOOL)animated {
    [self showNavigation];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell contentView].backgroundColor = [BTColor BT_white:1];
    }

    switch (indexPath.row) {
        case 0: {
            [[cell textLabel] setText:@"Full Name"];
            [[cell textLabel] setTextColor:[BTColor BT_navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];

            [(CustomCell *) cell textfield].placeholder = @"John Smith";
            [(CustomCell *) cell textfield].delegate = self;
            [(CustomCell *) cell textfield].returnKeyType = UIReturnKeyNext;
            [(CustomCell *) cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(CustomCell *) cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard

            [[(CustomCell *) cell textfield] setTextColor:[BTColor BT_black:1]];
            [[(CustomCell *) cell textfield] setFont:[UIFont systemFontOfSize:16]];
            break;
        }
        case 1: {
            [[cell textLabel] setText:@"Email"];
            [[cell textLabel] setTextColor:[BTColor BT_navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];

            [(CustomCell *) cell textfield].placeholder = @"john@bttendance.com";
            [(CustomCell *) cell textfield].delegate = self;
            [(CustomCell *) cell textfield].returnKeyType = UIReturnKeyNext;
            [(CustomCell *) cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(CustomCell *) cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard setting
            [(CustomCell *) cell textfield].keyboardType = UIKeyboardTypeEmailAddress;
            [[(CustomCell *) cell textfield] setTextColor:[BTColor BT_black:1]];
            [[(CustomCell *) cell textfield] setFont:[UIFont systemFontOfSize:16]];
            break;
        }
        case 2: {
            [[cell textLabel] setText:@"User ID"];
            [[cell textLabel] setTextColor:[BTColor BT_navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];

            [(CustomCell *) cell textfield].placeholder = @"@ID";
            [(CustomCell *) cell textfield].delegate = self;
            [(CustomCell *) cell textfield].returnKeyType = UIReturnKeyNext;
            [(CustomCell *) cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(CustomCell *) cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard setting

            [[(CustomCell *) cell textfield] setTextColor:[BTColor BT_black:1]];
            [[(CustomCell *) cell textfield] setFont:[UIFont systemFontOfSize:16]];
            break;
        }
        case 3: {
            [[cell textLabel] setText:@"Password"];
            [[cell textLabel] setTextColor:[BTColor BT_navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];

            [(CustomCell *) cell textfield].placeholder = @"Required";
            [(CustomCell *) cell textfield].delegate = self;
            [(CustomCell *) cell textfield].secureTextEntry = YES;
            [(CustomCell *) cell textfield].returnKeyType = UIReturnKeyDone;

            [[(CustomCell *) cell textfield] setTextColor:[BTColor BT_black:1]];
            [[(CustomCell *) cell textfield] setFont:[UIFont systemFontOfSize:16]];
            break;
        }
        case 4: {
            static NSString *CellIdentifier1 = @"SignButtonCell";
            SignButtonCell *cell_new = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
            cell_new.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            if (cell_new == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SignButtonCell" owner:self options:nil];
                cell_new = [topLevelObjects objectAtIndex:0];
            }

            [cell_new.button setTitle:@"Sign Up" forState:UIControlStateNormal];
            cell_new.button.layer.cornerRadius = 3;
            [cell_new.button addTarget:self action:@selector(SignUnButton:) forControlEvents:UIControlEventTouchUpInside];

            return cell_new;
        }
        case 5: {
            NIAttributedLabel *label = [[NIAttributedLabel alloc] initWithFrame:CGRectMake(20, 20, 280, 60)];
            label.backgroundColor = [UIColor clearColor];
            label.text = @"By tapping \"Sign up\" above, you are agreeing to the Terms of Service and Privacy Policy.";
            [label addLink:[NSURL URLWithString:@"http://www.bttendance.com/terms"]
                     range:[label.text rangeOfString:@"Terms of Service"]];
            [label addLink:[NSURL URLWithString:@"http://www.bttendance.com/privacy"]
                     range:[label.text rangeOfString:@"Privacy Policy"]];
            label.textAlignment = NSTextAlignmentRight;
            label.linkColor = [BTColor BT_navy:1];
            label.linksHaveUnderlines = YES;
            label.textColor = [BTColor BT_silver:1];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
            label.numberOfLines = 0;
            label.delegate = self;
            [cell addSubview:label];
            [cell contentView].backgroundColor = [BTColor BT_grey:1];
            break;
        }
        default:
            break;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 4:
            return 78;
        case 5:
            return 60;
        default:
            return 44;
    }
}

- (void)attributedLabel:(NIAttributedLabel *)attributedLabel didSelectTextCheckingResult:(NSTextCheckingResult *)result atPoint:(CGPoint)point {
    WebViewController *webView = [[WebViewController alloc] initWithURLString:[NSString stringWithFormat:@"%@", result.URL]];
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)SignUnButton:(id)sender {
    NSString *fullname = [((CustomCell *) [self.tableView cellForRowAtIndexPath:fullname_index]).textfield text];
    NSString *email = [((CustomCell *) [self.tableView cellForRowAtIndexPath:email_index]).textfield text];
    NSString *username = [((CustomCell *) [self.tableView cellForRowAtIndexPath:username_index]).textfield text];
    NSString *password = [((CustomCell *) [self.tableView cellForRowAtIndexPath:password_index]).textfield text];

    if (username.length < 5 || username.length > 20) {
        //alert showing
        NSString *string = @"Username must be between 5 to 20 letters in length";
        NSString *title = @"Invalidate Username";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    }
    else if (password.length < 6) {
        //alert showing
        NSString *string = @"Password must be longer than 6 letters";
        NSString *title = @"Invalidate Password";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    }

    else {
        [self JSONSignupRequest:username :email :fullname :password :sender];
        NSLog(@"fullname : %@", fullname);
        NSLog(@"email : %@", email);
        NSLog(@"usename : %@", username);
        NSLog(@"password : %@", password);

    }

}


- (NSDictionary *)loadAccountinfor {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userinfo = @{@"username" : [defaults objectForKey:UsernameKey],
            @"password" : [defaults objectForKey:PasswordKey]};
    return userinfo;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    NSLog(@"return call!");

    if ([textField isEqual:((CustomCell *) [self.tableView cellForRowAtIndexPath:fullname_index]).textfield]) {
        [((CustomCell *) [self.tableView cellForRowAtIndexPath:email_index]).textfield becomeFirstResponder];
        return YES;
    }

    if ([textField isEqual:((CustomCell *) [self.tableView cellForRowAtIndexPath:email_index]).textfield]) {

        [((CustomCell *) [self.tableView cellForRowAtIndexPath:username_index]).textfield becomeFirstResponder];
        return YES;
    }

    if ([textField isEqual:((CustomCell *) [self.tableView cellForRowAtIndexPath:username_index]).textfield]) {

        [((CustomCell *) [self.tableView cellForRowAtIndexPath:password_index]).textfield becomeFirstResponder];
        return YES;
    }

    if ([textField isEqual:((CustomCell *) [self.tableView cellForRowAtIndexPath:password_index]).textfield]) {

        [((CustomCell *) [self.tableView cellForRowAtIndexPath:password_index]).textfield resignFirstResponder];
        [self SignUnButton:nil];
    }

    return NO;

}

- (void)JSONSignupRequest:(NSString *)username :(NSString *)email :(NSString *)fullname :(NSString *)password :(id)sender {

    UIButton *button = (UIButton *) sender;
    button.enabled = NO;

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    NSString *uuid = [BTUserDefault representativeString:[BTUserDefault getUserService].UUID];
    NSDictionary *params = @{@"username" : username,
            @"email" : email,
            @"full_name" : fullname,
            @"password" : password,
            @"device_type" : @"iphone",
            @"device_uuid" : uuid};

    [AFmanager POST:signupRequest parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"SignUp success : %@", responseObject);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:TRUE forKey:FirstLaunchKey];
        [BTUserDefault setUserInfo:responseObject];

        if (serial != nil) {
            NSDictionary *userinfo = [BTUserDefault getUserInfo];
            NSString *username = [userinfo objectForKey:UsernameKey];
            NSString *password = [userinfo objectForKey:PasswordKey];

            NSDictionary *params = @{@"username" : username,
                    @"password" : password,
                    @"school_id" : [NSString stringWithFormat:@"%ld", (long) schoolId],
                    @"serial" : serial};
            [AFmanager PUT:[BTURL stringByAppendingString:@"/user/employ/school"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Getting success : %@", responseObject);
                [BTUserDefault setUserInfo:responseObject];
                MainViewController *stdMainView = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
                self.navigationController.navigationBarHidden = YES;
                [self.navigationController setViewControllers:[NSArray arrayWithObject:stdMainView] animated:YES];
            }      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                MainViewController *stdMainView = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
                self.navigationController.navigationBarHidden = YES;
                [self.navigationController setViewControllers:[NSArray arrayWithObject:stdMainView] animated:YES];
            }];
        } else {
            MainViewController *stdMainView = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
            self.navigationController.navigationBarHidden = YES;
            [self.navigationController setViewControllers:[NSArray arrayWithObject:stdMainView] animated:YES];
        }

    }       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *rawstring = [[[operation responseObject] objectForKey:@"message"] objectAtIndex:0];
        NSLog(@"error json : %@", rawstring);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        button.enabled = YES;

        NSString *string = @"Error in sign up.\nPlease try again.";
        NSString *title = @"Sign Up Error";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

//        NSRange user_email = [rawstring rangeOfString:@"\"user_email_key\"" options:NSCaseInsensitiveSearch];
//        NSRange user_name = [rawstring rangeOfString:@"\"user_username_key\"" options:NSCaseInsensitiveSearch];
//        NSRange user_uuid = [rawstring rangeOfString:@"\"user_device_uuid_key\"" options:NSCaseInsensitiveSearch];
//        
////        NSString *user
//        if(user_email.location != NSNotFound){ //email duplicate
//            //alert showing
//            NSString *string = @"Email currently in use.\nPlease try a different address.";
//            NSString *title = @"Duplication Error";
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//
//        }
//        if (user_name.location != NSNotFound){ //username duplicate
//            //alert showing
//            NSString *string = @"Username currently in use.\nPlease try a different Username";
//            NSString *title = @"Duplication Error";
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//        }
//        if(user_uuid.location != NSNotFound){ //uuid duplicate!!! critical!
//            //alert showing
//            NSString *string = @"Your device currently in use.\n Any further progress in signing up may result in disadvantage on your end.";
//            NSString *title = @"Critical Error in Validation";
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//        }

    }];
}

@end
