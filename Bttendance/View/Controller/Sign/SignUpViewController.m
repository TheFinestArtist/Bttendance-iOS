//
//  SignUpController.m
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 11. 19..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import "SignUpViewController.h"
#import "UITableViewController+Bttendance.h"
#import "SideMenuViewController.h"
#import "TextInputCell.h"
#import "TextCommentCell.h"
#import "SignButtonCell.h"
#import "WebViewController.h"
#import "BTUUID.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:NSLocalizedString(@"Sign Up", @"") withSubTitle:nil];
    [self setLeftMenu:LeftMenuType_Back];
    [self initTableView];
    
    fullNameIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    emailIndex = [NSIndexPath indexPathForRow:1 inSection:0];
    passwordIndex = [NSIndexPath indexPathForRow:2 inSection:0];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)appDidBecomeActive:(NSNotification *)notification {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)appDidEnterForeground:(NSNotification *)notification {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    TextInputCell *cell1 = (TextInputCell *) [self.tableView cellForRowAtIndexPath:fullNameIndex];
    [cell1.textfield becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[TextInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor white:1];
    }

    switch (indexPath.row) {
        case 0: {
            [[cell textLabel] setText:NSLocalizedString(@"Full Name", nil)];
            [[cell textLabel] setTextColor:[UIColor navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
            [cell textLabel].backgroundColor = [UIColor clearColor];

            [(TextInputCell *) cell textfield].placeholder = NSLocalizedString(@"John Smith", nil);
            [(TextInputCell *) cell textfield].delegate = self;
            [(TextInputCell *) cell textfield].returnKeyType = UIReturnKeyNext;
            [(TextInputCell *) cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(TextInputCell *) cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard

            [[(TextInputCell *) cell textfield] setTextColor:[UIColor black:1]];
            [[(TextInputCell *) cell textfield] setFont:[UIFont systemFontOfSize:16]];
            [(TextInputCell *) cell textfield].backgroundColor = [UIColor clearColor];
            break;
        }
        case 1: {
            [[cell textLabel] setText:NSLocalizedString(@"Email", nil)];
            [[cell textLabel] setTextColor:[UIColor navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
            [cell textLabel].backgroundColor = [UIColor clearColor];
            
            [(TextInputCell *) cell textfield].placeholder = NSLocalizedString(@"john@bttendance.com", nil);
            [(TextInputCell *) cell textfield].delegate = self;
            [(TextInputCell *) cell textfield].returnKeyType = UIReturnKeyNext;
            [(TextInputCell *) cell textfield].autocorrectionType = UITextAutocorrectionTypeNo;
            [(TextInputCell *) cell textfield].autocapitalizationType = UITextAutocapitalizationTypeNone;//lower case keyboard setting
            [(TextInputCell *) cell textfield].keyboardType = UIKeyboardTypeEmailAddress;
            [[(TextInputCell *) cell textfield] setTextColor:[UIColor black:1]];
            [[(TextInputCell *) cell textfield] setFont:[UIFont systemFontOfSize:16]];
            [(TextInputCell *) cell textfield].backgroundColor = [UIColor clearColor];
            break;
        }
        case 2: {
            [[cell textLabel] setText:NSLocalizedString(@"Password", nil)];
            [[cell textLabel] setTextColor:[UIColor navy:1]];
            [[cell textLabel] setFont:[UIFont boldSystemFontOfSize:15]];
            [cell textLabel].backgroundColor = [UIColor clearColor];

            [(TextInputCell *) cell textfield].placeholder = NSLocalizedString(@"more than 6 letters..", nil);
            [(TextInputCell *) cell textfield].delegate = self;
            [(TextInputCell *) cell textfield].secureTextEntry = YES;
            [(TextInputCell *) cell textfield].returnKeyType = UIReturnKeyDone;

            [[(TextInputCell *) cell textfield] setTextColor:[UIColor black:1]];
            [[(TextInputCell *) cell textfield] setFont:[UIFont systemFontOfSize:16]];
            [(TextInputCell *) cell textfield].backgroundColor = [UIColor clearColor];
            break;
        }
        case 3: {
            static NSString *CellIdentifier1 = @"SignButtonCell";
            SignButtonCell *cell_new = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];

            if (cell_new == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SignButtonCell" owner:self options:nil];
                cell_new = [topLevelObjects objectAtIndex:0];
                cell_new.selectionStyle = UITableViewCellSelectionStyleNone;
            }

            [cell_new.button setTitle:NSLocalizedString(@"Sign Up", nil) forState:UIControlStateNormal];
            [cell_new.button setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:1.0]] forState:UIControlStateNormal];
            [cell_new.button setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:0.85]] forState:UIControlStateHighlighted];
            [cell_new.button setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:0.85]] forState:UIControlStateSelected];
            
            [cell_new.button addTarget:self action:@selector(SignUnButton:) forControlEvents:UIControlEventTouchUpInside];

            return cell_new;
        }
        case 4: {
            TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(20, 20, 280, 60)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor silver:1];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
            label.numberOfLines = 0;
            label.textAlignment = NSTextAlignmentCenter;
            label.enabledTextCheckingTypes = NSTextCheckingTypeLink;
            label.delegate = self;
            
            label.text = NSLocalizedString(@"By tapping \"Sign Up\" above, you are agreeing to the Terms of Service and Privacy Policy.", nil);
            
            NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
            if ([locale isEqualToString:@"ko"]) {
                [label addLinkToURL:[NSURL URLWithString:@"http://www.bttendance.com/terms"]
                         withRange:[label.text rangeOfString:NSLocalizedString(@"Terms of Service", nil)]];
                [label addLinkToURL:[NSURL URLWithString:@"http://www.bttendance.com/privacy"]
                         withRange:[label.text rangeOfString:NSLocalizedString(@"Privacy Policy", nil)]];
            } else {
                [label addLinkToURL:[NSURL URLWithString:@"http://www.bttendance.com/terms-en"]
                         withRange:[label.text rangeOfString:NSLocalizedString(@"Terms of Service", nil)]];
                [label addLinkToURL:[NSURL URLWithString:@"http://www.bttendance.com/privacy-en"]
                         withRange:[label.text rangeOfString:NSLocalizedString(@"Privacy Policy", nil)]];
            }
            
            NSArray *keys = [[NSArray alloc] initWithObjects:(id)NSForegroundColorAttributeName, (id)kCTForegroundColorAttributeName,(id)NSForegroundColorAttributeName,(id)kCTUnderlineStyleAttributeName, nil];
            NSArray *objects = [[NSArray alloc] initWithObjects:[UIColor navy:1.0],[UIColor navy:1.0],[UIColor navy:1.0],[NSNumber numberWithInt:kCTUnderlineStyleSingle], nil];
            NSDictionary *linkAttributes = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
            label.linkAttributes = linkAttributes;
            label.activeLinkAttributes = linkAttributes;
            
            NSString *title = label.text;
            NSMutableAttributedString *aStr = [[NSMutableAttributedString alloc] initWithString:title];
            [aStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f] range:[title rangeOfString:title]];
            [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor silver:1.0] range:[title rangeOfString:title]];
            [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor navy:1.0] range:[title rangeOfString:NSLocalizedString(@"Terms of Service", nil)]];
            [aStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:kCTUnderlineStyleSingle] range:[title rangeOfString:NSLocalizedString(@"Terms of Service", nil)]];
            [aStr addAttribute:NSForegroundColorAttributeName value:[UIColor navy:1.0] range:[title rangeOfString:NSLocalizedString(@"Privacy Policy", nil)]];
            [aStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:kCTUnderlineStyleSingle] range:[title rangeOfString:NSLocalizedString(@"Privacy Policy", nil)]];
            label.attributedText = aStr;
            
            [cell addSubview:label];
            [cell contentView].backgroundColor = [UIColor grey:1];
            [(TextInputCell *) cell textfield].hidden = YES;
            break;
        }
        default:
            break;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return 44;
        case 1:
            return 44;
        case 2:
            return 44;
        case 3:
            return 78;
        case 4:
            return 60;
        default:
            return 44;
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    WebViewController *webView = [[WebViewController alloc] initWithURLString:[url absoluteString]];
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)SignUnButton:(id)sender {
    NSString *fullname = [((TextInputCell *) [self.tableView cellForRowAtIndexPath:fullNameIndex]).textfield text];
    NSString *email = [((TextInputCell *) [self.tableView cellForRowAtIndexPath:emailIndex]).textfield text];
    NSString *password = [((TextInputCell *) [self.tableView cellForRowAtIndexPath:passwordIndex]).textfield text];

    UIButton *button = (UIButton *) sender;
    button.enabled = NO;
    
    BOOL pass = YES;
    
    if (fullname == nil || fullname.length == 0) {
        ((TextInputCell *) [self.tableView cellForRowAtIndexPath:fullNameIndex]).contentView.backgroundColor = [UIColor red:0.1];
        pass = NO;
    } else {
        ((TextInputCell *) [self.tableView cellForRowAtIndexPath:fullNameIndex]).contentView.backgroundColor = [UIColor clearColor];
    }
    
    if (email == nil || email.length == 0) {
        ((TextInputCell *) [self.tableView cellForRowAtIndexPath:emailIndex]).contentView.backgroundColor = [UIColor red:0.1];
        pass = NO;
    } else {
        ((TextInputCell *) [self.tableView cellForRowAtIndexPath:emailIndex]).contentView.backgroundColor = [UIColor clearColor];
    }
    
    if (password == nil || password.length < 6) {
        ((TextInputCell *) [self.tableView cellForRowAtIndexPath:passwordIndex]).contentView.backgroundColor = [UIColor red:0.1];
        pass = NO;
    } else {
        ((TextInputCell *) [self.tableView cellForRowAtIndexPath:passwordIndex]).contentView.backgroundColor = [UIColor clearColor];
    }
    
    if (!pass) {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        button.enabled = YES;
        return;
    }
    
    [MBProgressHUD showWithMessage:NSLocalizedString(@"Signing Up Bttendance", nil) toView:self.view];
    [BTAPIs signUpWithFullName:fullname email:email password:password success:^(User *user) {
        [MBProgressHUD hideForView:self.view];
        SideMenuViewController *sideMenu = [[SideMenuViewController alloc] initByItSelf];
        self.navigationController.navigationBarHidden = YES;
        [self.navigationController setViewControllers:[NSArray arrayWithObject:sideMenu] animated:NO];
    } failure:^(NSError *error) {
        [MBProgressHUD hideForView:self.view];
        button.enabled = YES;
    }];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:((TextInputCell *) [self.tableView cellForRowAtIndexPath:fullNameIndex]).textfield]) {
        [((TextInputCell *) [self.tableView cellForRowAtIndexPath:emailIndex]).textfield becomeFirstResponder];
        return YES;
    }

    if ([textField isEqual:((TextInputCell *) [self.tableView cellForRowAtIndexPath:emailIndex]).textfield]) {
        [((TextInputCell *) [self.tableView cellForRowAtIndexPath:passwordIndex]).textfield becomeFirstResponder];
        return YES;
    }

    if ([textField isEqual:((TextInputCell *) [self.tableView cellForRowAtIndexPath:passwordIndex]).textfield]) {
        [((TextInputCell *) [self.tableView cellForRowAtIndexPath:passwordIndex]).textfield resignFirstResponder];
        [self SignUnButton:nil];
    }

    return NO;

}

@end
