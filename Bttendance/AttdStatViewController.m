//
//  CourseView.m
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 12. 27..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import "AttdStatViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "BTUserDefault.h"
#import "BTColor.h"
#import "BTAPIs.h"

@interface AttdStatViewController ()

@end

@implementation AttdStatViewController
@synthesize courseId, courseName, postId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        rowcount0 = 0;
        rowcount1 = 0;
        data0 = [[NSMutableArray alloc] init];
        data1 = [[NSMutableArray alloc] init];

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

    //set tableview background color
    [self tableview].backgroundColor = [BTColor BT_grey:1];

    //Navigation title
    //set title
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titlelabel.backgroundColor = [UIColor clearColor];
    titlelabel.font = [UIFont boldSystemFontOfSize:18.0];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    titlelabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titlelabel;
    titlelabel.text = courseName;
    [titlelabel sizeToFit];
}

- (void)viewWillAppear:(BOOL)animated {
    [self refreshStat];
}

- (void)refreshStat {
    
    [BTAPIs studentsForCourse:[NSString stringWithFormat: @"%ld", courseId]
                      success:^(NSArray *users) {
//                          NSDictionary *checks = [responseObject_ objectForKey:@"checks"];
//                          
//                          [data0 removeAllObjects];
//                          [data1 removeAllObjects];
//                          
//                          if (studentlist.count != 0) {
//                              for (int i = 0; i < studentlist.count; i++) {
//                                  BOOL checked = false;
//                                  for (int j = 0; j < checks.count; j++) {
//                                      
//                                      NSString *value = [[responseObject_ objectForKey:@"checks"] objectAtIndex:j];
//                                      int checkedId = [value intValue];
//                                      int studentId = [[[responseObject objectAtIndex:i] objectForKey:@"id"] intValue];
//                                      
//                                      if (studentId == checkedId) {
//                                          checked = true;
//                                      }
//                                  }
//                                  
//                                  if (checked) {
//                                      NSLog(@"unchecked %@", [responseObject objectAtIndex:i]);
//                                      [data1 addObject:[responseObject objectAtIndex:i]];
//                                  } else {
//                                      NSLog(@"checked %@", [responseObject objectAtIndex:i]);
//                                      [data0 addObject:[responseObject objectAtIndex:i]];
//                                  }
//                              }
//                              rowcount0 = data0.count;
//                              rowcount1 = data1.count;
//                              [self.tableview reloadData];
//                          }
//                          else {
//                              data0 = responseObject;
//                              rowcount0 = data0.count;
//                              rowcount1 = 0;
//                              [self.tableview reloadData];
//                          }
                      } failure:^(NSError *error) {
                      }];
}

- (IBAction)check_button_action:(id)sender {

    //attendance check manually
    UIButton *comingbutton = (UIButton *) sender;
    UserInfoCell *comingcell = (UserInfoCell *) comingbutton.superview.superview.superview;
    currentcell = comingcell;

    //alert showing
    NSString *string = [NSString stringWithFormat:@"Do you want to approve %@'s attendance check manually?", comingcell.user.full_name];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attendance Check" message:string delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
    [alert show];

    //disable button
    [comingbutton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return rowcount0;
        case 1:
        default:
            return rowcount1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Attendance un-checked students";
        case 1:
        default:
            return @"Attendance checked students";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UserInfoCell";

    UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"UserInfoCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    if (indexPath.section == 0) {
        cell.user = [data0 objectAtIndex:indexPath.row];
        cell.Username.text = cell.user.full_name;
        cell.Email.text = cell.user.email;
        cell.backgroundColor = [BTColor BT_white:1];
        [cell.Check addTarget:self action:@selector(check_button_action:) forControlEvents:UIControlEventTouchUpInside];
        [cell.Check setBackgroundImage:[UIImage imageNamed:@"enrolladd@2x.png"] forState:UIControlStateNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 1) {
        cell.user = [data1 objectAtIndex:indexPath.row];
        cell.Username.text = cell.user.full_name;
        cell.Email.text = cell.user.email;
        cell.backgroundColor = [BTColor BT_white:1];
        [cell.Check setBackgroundImage:[UIImage imageNamed:@"enrollconfirm@2x.png"] forState:UIControlStateNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [BTAPIs checkManuallyWithAttendance:[NSString stringWithFormat:@"%ld", (long) postId]
                                       user:[NSString stringWithFormat:@"%ld", (long) currentcell.user.id]
                                    success:^(Attendance *attendance) {
                                        [[self tableview] beginUpdates];
                                        [currentcell.Check setBackgroundImage:[UIImage imageNamed:@"enrollconfirm@2x.png"] forState:UIControlStateNormal];
                                        rowcount1++;
                                        rowcount0--;
                                        NSIndexPath *comingcell_index = [[self tableview] indexPathForCell:currentcell];
                                        for (int i = 0; i < [data0 count]; i++) {
                                            if ([[[data0 objectAtIndex:i] objectForKey:@"id"] intValue] == currentcell.user.id) {
                                                [data1 addObject:[data0 objectAtIndex:i]];
                                                [data0 removeObjectAtIndex:i];
                                                break;
                                            }
                                        }
                                        [[self tableview] moveRowAtIndexPath:comingcell_index toIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
                                        [[self tableview] endUpdates];
                                    } failure:^(NSError *error) {
                                        NSString *message = @"Attendance check failed, please try again";
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                                        message:message
                                                                                       delegate:nil
                                                                              cancelButtonTitle:@"OK"
                                                                              otherButtonTitles:nil];
                                        [alert show];
                                        [currentcell.Check addTarget:self action:@selector(check_button_action:) forControlEvents:UIControlEventTouchUpInside];
                                    }];
    }
    if (buttonIndex == 0) {
        [currentcell.Check addTarget:self action:@selector(check_button_action:) forControlEvents:UIControlEventTouchUpInside];
    }
}

@end
