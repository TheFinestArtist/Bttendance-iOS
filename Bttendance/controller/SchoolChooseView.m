//
//  SchoolView.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 1. 23..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "SchoolChooseView.h"
#import <AFNetworking/AFNetworking.h>
#import "BTUserDefault.h"
#import "BTColor.h"
#import "BTAPIs.h"
#import "CourseAttendView.h"
#import "CourseCreateController.h"
#import "SerialViewController.h"

@interface SchoolChooseView ()

@end

@implementation SchoolChooseView
@synthesize auth;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        rowcount0 = 0;
        rowcount1 = 0;
        data0 = [[NSMutableArray alloc] init];
        data1 = [[NSMutableArray alloc] init];

        userinfo = [BTUserDefault getUserInfo];

        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 9.5, 15)];
        [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back@2x.png"] forState:UIControlStateNormal];
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [self.navigationItem setLeftBarButtonItem:backButtonItem];
        self.navigationItem.leftItemsSupplementBackButton = NO;
    }
    return self;
}

- (void)back:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    //set tableview background color
    [self tableview].backgroundColor = [BTColor BT_grey:1];

    //navigation title
    //set title
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:18.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Choose School", @"");
    [titlelabel sizeToFit];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.tableview reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];


    NSString *username = [userinfo objectForKey:UsernameKey];
    NSString *password = [userinfo objectForKey:PasswordKey];

    NSDictionary *params = @{@"username" : username,
            @"password" : password};

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
    [AFmanager GET:[BTURL stringByAppendingString:@"/school/all"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *schoollist = responseObject;

        NSArray *userschoollist;
        if (auth)
            userschoollist = [[NSUserDefaults standardUserDefaults] objectForKey:EmployedSchoolsKey];
        else
            userschoollist = [[NSUserDefaults standardUserDefaults] objectForKey:EnrolledSchoolsKey];

        data0 = [[NSMutableArray alloc] init];
        data1 = [[NSMutableArray alloc] init];
        if (userschoollist.count != 0) {
            for (int i = 0; i < schoollist.count; i++) {
                Boolean joined = false;
                for (int j = 0; j < userschoollist.count; j++) {
                    int school_id = [[[responseObject objectAtIndex:i] objectForKey:@"id"] intValue];
                    int userschool_id = [[userschoollist[j] objectForKey:@"id"] intValue];
                    if (school_id == userschool_id) {
                        joined = true;
                        break;
                    }
                }

                if (joined)
                    [data0 addObject:[responseObject objectAtIndex:i]];
                else
                    [data1 addObject:[responseObject objectAtIndex:i]];
            }

            rowcount0 = data0.count;
            rowcount1 = data1.count;
            [self.tableview reloadData];

        } else {
            data0 = nil;
            rowcount0 = 0;
            data1 = responseObject;
            rowcount1 = data1.count;
            [self.tableview reloadData];
        }

        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return rowcount0;
    else if (section == 1)
        return rowcount1;
    else
        return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            if (auth)
                return @"Employed Schools";
            else
                return @"Enrolled Schools";
        case 1:
        default:
            return @"Joinable Schools";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SchoolInfoCell";
    SchoolInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SchoolInfoCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    if (indexPath.section == 0) {
        cell.Info_SchoolName.text = [[data0 objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.Info_SchoolID_int = [[[data0 objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
        cell.Info_SchoolID.text = [[data0 objectAtIndex:indexPath.row] objectForKey:@"website"];
        cell.backgroundColor = [BTColor BT_white:1];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    if (indexPath.section == 1) {
        cell.Info_SchoolName.text = [[data1 objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.Info_SchoolID_int = [[[data1 objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
        cell.Info_SchoolID.text = [[data1 objectAtIndex:indexPath.row] objectForKey:@"website"];
        cell.backgroundColor = [BTColor BT_white:1];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (auth) {
        NSInteger scid = ((SchoolInfoCell *) [self.tableview cellForRowAtIndexPath:indexPath]).Info_SchoolID_int;
        NSString *scname = ((SchoolInfoCell *) [self.tableview cellForRowAtIndexPath:indexPath]).Info_SchoolName.text;
        NSString *prfname = [userinfo objectForKey:FullNameKey];
        if (indexPath.section == 0) {
            NSArray *school_list = [[NSUserDefaults standardUserDefaults] objectForKey:EmployedSchoolsKey];
            for (int i = 0; i < school_list.count; i++) {
                if ([[school_list[i] objectForKey:@"id"] intValue] == scid) {
                    AFHTTPRequestOperationManager *AFmanager = [AFHTTPRequestOperationManager manager];
                    NSDictionary *params = @{@"serial" : [school_list[i] objectForKey:@"key"]};
                    [AFmanager GET:[BTURL stringByAppendingString:@"/serial/validate"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if ([[responseObject objectForKey:@"id"] integerValue] == scid) {
                            CourseCreateController *courseCreateController = [[CourseCreateController alloc] initWithNibName:@"CourseCreateController" bundle:nil];
                            courseCreateController.schoolId = scid;
                            courseCreateController.schoolName = scname;
                            courseCreateController.prfName = prfname;
                            [self.navigationController pushViewController:courseCreateController animated:YES];
                        } else {
                            [self showSerialView:scid name:scname];
                        }
                    }      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [self showSerialView:scid name:scname];
                    }];
                    break;
                }
            }
        } else {
            [self showSerialView:scid name:scname];
        }
    } else {
        CourseAttendView *courseAttendView = [[CourseAttendView alloc] initWithNibName:@"CourseAttendView" bundle:nil];
        courseAttendView.sid = ((SchoolInfoCell *) [self.tableview cellForRowAtIndexPath:indexPath]).Info_SchoolID_int;
        courseAttendView.sname = ((SchoolInfoCell *) [self.tableview cellForRowAtIndexPath:indexPath]).Info_SchoolName.text;
        [self.navigationController pushViewController:courseAttendView animated:YES];
    }
}

- (void)showSerialView:(NSInteger)schoolId name:(NSString *)schoolName {
    SerialViewController *serialViewController = [[SerialViewController alloc] initWithNibName:@"SerialViewController" bundle:nil];
    serialViewController.isSignUp = false;
    serialViewController.schoolId = schoolId;
    serialViewController.schoolName = schoolName;
    [self.navigationController pushViewController:serialViewController animated:YES];
}

@end
