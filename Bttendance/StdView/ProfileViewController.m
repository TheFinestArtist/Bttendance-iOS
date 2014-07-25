//
//  StdProfileView.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 1. 15..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "ProfileViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "BTUserDefault.h"
#import "ProfileNameEditViewController.h"
#import "ProfileEmailEditViewController.h"
#import "ProfileIdentityEditViewController.h"
#import "ProfileUpdatePassViewController.h"
#import "ProfileCell.h"
#import "SchoolInfoCell.h"
#import "PasswordCell.h"
#import "BTAPIs.h"
#import "BTColor.h"
#import "User.h"
#import "Identification.h"
#import "BTNotification.h"

@interface ProfileViewController ()

@property(strong, nonatomic) User *user;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [BTUserDefault getUser];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:UserUpdated object:nil];
    
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:16.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = NSLocalizedString(@"Profile", nil);
    [titlelabel sizeToFit];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.translucent = NO;
    
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [menuButton addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menu@2x.png"] forState:UIControlStateNormal];
    UIBarButtonItem *menuButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    [self.navigationItem setLeftBarButtonItem:menuButtonItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.user = [BTUserDefault getUser];
}

- (void)reloadTableView:(NSNotification *)noti {
    self.user = [BTUserDefault getUser];
    [self.tableview reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.user getClosedCourses] count] + [self.user.employed_schools count] + [self.user.enrolled_schools count] + 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger closedCourses = [[self.user getClosedCourses] count];
    NSInteger employedSchools = [self.user.employed_schools count];
    NSInteger enrolledSchools = [self.user.enrolled_schools count];
    
    if (indexPath.row == 0
        || indexPath.row == 1
        || indexPath.row == closedCourses + employedSchools + enrolledSchools + 5)
        return 47;
    
    if (indexPath.row == 2
        || indexPath.row == closedCourses + 3)
        return 60;
    
    if (indexPath.row == closedCourses + employedSchools + enrolledSchools + 4)
        return 55;
    
    if (indexPath.row == closedCourses + employedSchools + enrolledSchools + 6)
        return 33;
    
    if (indexPath.row < closedCourses + employedSchools + enrolledSchools + 4)
        return 74;
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger closedCourses = [[self.user getClosedCourses] count];
    NSInteger employedSchools = [self.user.employed_schools count];
    NSInteger enrolledSchools = [self.user.enrolled_schools count];
    
    if (indexPath.row == 0 || indexPath.row == 1) {
        static NSString *CellIdentifier = @"ProfileCell";
        ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        switch (indexPath.row) {
            case 0:
                cell.title.text = NSLocalizedString(@"Name", nil);
                cell.data.text = self.user.full_name;
                return cell;
            case 1:
            default:
                cell.title.text = NSLocalizedString(@"Email", nil);
                cell.data.text = self.user.email;
                return cell;
        }
    }
    
    else if (indexPath.row == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [BTColor BT_grey:1.0];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(14, 39, 280, 14)];
        title.text = NSLocalizedString(@"CLOSED LECTURES", nil);
        title.font = [UIFont boldSystemFontOfSize:12];
        title.textColor = [BTColor BT_silver:1.0];
        [cell addSubview:title];
        return cell;
    }
    
    else if (indexPath.row > 2 && indexPath.row < closedCourses + 3) {
        static NSString *CellIdentifier = @"SchoolInfoCell";
        SchoolInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.Info_SchoolName.textColor = [BTColor BT_cyan:1.0];
        
        NSArray *closedCourses = [self.user getClosedCourses];
        SimpleCourse *course = [closedCourses objectAtIndex:indexPath.row - 3];
        cell.Info_SchoolName.text = course.name;
        cell.Info_SchoolID.text = [self.user getSchoolNameFromId:course.school];
        cell.arrow.hidden = NO;
        return  cell;
    }
    
    else if (indexPath.row == closedCourses + 3) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [BTColor BT_grey:1.0];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(14, 39, 280, 14)];
        title.text = NSLocalizedString(@"SCHOOL", nil);
        title.font = [UIFont boldSystemFontOfSize:12];
        title.textColor = [BTColor BT_silver:1.0];
        [cell addSubview:title];
        return cell;
    }
    
    else if (indexPath.row > closedCourses + 3 && indexPath.row < closedCourses + employedSchools + enrolledSchools + 4) {
        static NSString *CellIdentifier = @"SchoolInfoCell";
        SchoolInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.Info_SchoolName.textColor = [BTColor BT_navy:1.0];
        
        NSInteger index = indexPath.row - closedCourses - 4;
        if (index < employedSchools) {
            cell.simpleSchool = self.user.employed_schools[index];
            cell.Info_SchoolName.text = ((SchoolInfoCell *) cell).simpleSchool.name;
            cell.Info_SchoolID.text = NSLocalizedString(@"Professor", nil);
            cell.arrow.hidden = YES;
        } else {
            cell.simpleSchool = self.user.enrolled_schools[index - employedSchools];
            cell.Info_SchoolName.text = ((SchoolInfoCell *) cell).simpleSchool.name;
            NSString *identity = @"";
            for (int j = 0; j < [self.user.identifications count]; j++)
                if (((SimpleIdentification *)self.user.identifications[j]).school == ((SchoolInfoCell *) cell).simpleSchool.id)
                    identity = ((SimpleIdentification *)self.user.identifications[j]).identity;
            ((SchoolInfoCell *) cell).Info_SchoolID.text = [NSString stringWithFormat:NSLocalizedString(@"Student - %@", nil), identity];
            cell.arrow.hidden = NO;
        }
        return  cell;
    }
    
    else if (indexPath.row == closedCourses + employedSchools + enrolledSchools + 4) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 55)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [BTColor BT_grey:1.0];
        return cell;
    }
    
    else if (indexPath.row == closedCourses + employedSchools + enrolledSchools + 5) {
        static NSString *CellIdentifier = @"PasswordCell";
        PasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.password.text = NSLocalizedString(@"Update Password", nil);
        cell.password.textColor = [BTColor BT_red:1.0];
        return cell;
    }
    
    else if (indexPath.row == closedCourses + employedSchools + enrolledSchools + 6) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 33)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [BTColor BT_grey:1.0];
        return cell;
    }
    
    else {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [BTColor BT_grey:1.0];
        return cell;
    }
}

//#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger closedCourses = [[self.user getClosedCourses] count];
    NSInteger employedSchools = [self.user.employed_schools count];
    NSInteger enrolledSchools = [self.user.enrolled_schools count];
    
    if (indexPath.row == 0)
        [self editName];
    
    if (indexPath.row == 1)
        [self editEmail];
    
    if (indexPath.row == closedCourses + employedSchools + enrolledSchools + 5)
        [self updatePass];
    
    
    else if (indexPath.row > 2 && indexPath.row < closedCourses + 3) {
        NSArray *closedCourses = [self.user getClosedCourses];
        SimpleCourse *course = [closedCourses objectAtIndex:indexPath.row - 3];
    }
    
    else if (indexPath.row > closedCourses + employedSchools + 3 && indexPath.row < closedCourses + employedSchools + enrolledSchools + 4) {
        NSInteger index = indexPath.row - closedCourses - employedSchools - 4;
        SimpleSchool *school = self.user.enrolled_schools[index];
        for (int j = 0; j < [self.user.identifications count]; j++)
            if (((SimpleIdentification *)self.user.identifications[j]).school == school.id)
                [self editIdentity:self.user.identifications[j]];
    }
}

#pragma Actions
- (void)editName {
    ProfileNameEditViewController *profileNameEditView = [[ProfileNameEditViewController alloc] init];
    profileNameEditView.fullname = self.user.full_name;
    [self.navigationController pushViewController:profileNameEditView animated:YES];
}

- (void)editEmail {
    ProfileEmailEditViewController *profileEmailEditView = [[ProfileEmailEditViewController alloc] init];
    profileEmailEditView.email = self.user.email;
    [self.navigationController pushViewController:profileEmailEditView animated:YES];
}

- (void)editIdentity:(SimpleIdentification *)identification {
    ProfileIdentityEditViewController *profileIdentityEditView = [[ProfileIdentityEditViewController alloc] init];
    profileIdentityEditView.identification = identification;
    [self.navigationController pushViewController:profileIdentityEditView animated:YES];
}

- (void)updatePass {
    ProfileUpdatePassViewController *profileUpdatePassView = [[ProfileUpdatePassViewController alloc] init];
    [self.navigationController pushViewController:profileUpdatePassView animated:YES];
}

@end
