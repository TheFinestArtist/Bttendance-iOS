//
//  AttdDetailListViewController.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 8. 8..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "AttdDetailListViewController.h"
#import "UIViewController+Bttendance.h"
#import "StudentInfoCell.h"
#import "SocketAgent.h"

@interface AttdDetailListViewController ()

@end

@implementation AttdDetailListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:NSLocalizedString(@"Attendance Check", nil) withSubTitle:nil];
    [self setLeftMenu:LeftMenuType_Back];
    
    [self.segmentcontrol setTitle:NSLocalizedString(@"이름순", nil) forSegmentAtIndex:0];
    [self.segmentcontrol setTitle:NSLocalizedString(@"학번순", nil) forSegmentAtIndex:1];
    [self.segmentcontrol setTitle:NSLocalizedString(@"출석순", nil) forSegmentAtIndex:2];
    
    data = [NSArray array];
    
    [BTDatabase getStudentsWithCourseID:self.post.course.id withData:^(NSArray *students) {
        data = students;
        if (self.start)
            [self center: nil];
        else
            [self right:nil];
        dispatch_async( dispatch_get_main_queue(), ^{
            [self.tableview reloadData];
        });
    }];
    
    [BTAPIs studentsForCourse:[NSString stringWithFormat:@"%ld", (long)self.post.course.id]
                      success:^(NSArray *simpleUsers) {
                          data = simpleUsers;
                          switch (self.segmentcontrol.selectedSegmentIndex) {
                              case 0:
                                  [self left:nil];
                                  break;
                              case 1:
                                  [self center:nil];
                                  break;
                              case 2:
                              default:
                                  [self right:nil];
                                  break;
                          }
                          [self.tableview reloadData];
                      } failure:^(NSError *error) {
                      }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAttendance:) name:AttendanceUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePost:) name:PostUpdated object:nil];
    
    [[SocketAgent sharedInstance] socketConnect];
};

#pragma NSNotificationCenter
- (void)updateAttendance:(NSNotification *)notification {
    if ([notification object] == nil)
        return;
    
    Attendance *attendance = [notification object];
    if (self.post.attendance.id != attendance.id)
        return;
    
    [self.post.attendance copyDataFromAttendance:attendance];
    [self.tableview reloadData];
}

- (void)updatePost:(NSNotification *)notification {
    if ([notification object] == nil)
        return;
    
    Post *newPost = [notification object];
    if (self.post.id != newPost.id)
        return;
    
    self.post = newPost;
    [self.tableview reloadData];
}

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return data.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UIFont *cellfont = [UIFont systemFontOfSize:12];
        NSString *rawmessage = NSLocalizedString(@"Click on the student’s name to toggle the student’s attendance status in the order of Absent ➜ Present ➜ Tardy ➜ Absent.", nil);
        NSAttributedString *message = [[NSAttributedString alloc] initWithString:rawmessage attributes:@{NSFontAttributeName:cellfont}];
        CGRect MessageLabelSize = [message boundingRectWithSize:(CGSize){280, CGFLOAT_MAX} options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
        return ceil(MessageLabelSize.size.height) + 14;
    }
    return 53;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        UIFont *cellfont = [UIFont systemFontOfSize:12];
        NSString *rawmessage = NSLocalizedString(@"Click on the student’s name to toggle the student’s attendance status in the order of Absent ➜ Present ➜ Tardy ➜ Absent.", nil);
        NSAttributedString *message = [[NSAttributedString alloc] initWithString:rawmessage attributes:@{NSFontAttributeName:cellfont}];
        CGRect MessageLabelSize = [message boundingRectWithSize:(CGSize){280, CGFLOAT_MAX} options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, ceil(MessageLabelSize.size.height) + 10)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor grey:1];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, 280, 0)];
        label.textColor = [UIColor silver:1];
        label.font = [UIFont systemFontOfSize:12];
        label.text = rawmessage;
        label.numberOfLines = 0;
        [label sizeToFit];
        
        [cell addSubview:label];
        
        return cell;
    } else {
        static NSString *CellIdentifier = @"StudentInfoCell";
        
        StudentInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"StudentInfoCell" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }
        
        SimpleUser *simpleUser = [data objectAtIndex:indexPath.row - 1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.name.text = simpleUser.full_name;
        cell.idnumber.text = simpleUser.studentID;
        cell.underline.hidden = YES;
        switch ([self.post.attendance stateInt:simpleUser.id]) {
            case 1:
                cell.detail.text = NSLocalizedString(@"Present", nil);
                [cell.icon setImage:[UIImage imageNamed:@"small_attended.png"]];
                cell.background_bg.backgroundColor = [UIColor navy:0.1];
                cell.selected_bg.backgroundColor = [UIColor navy:0.15];
                break;
            case 2:
                cell.detail.text = NSLocalizedString(@"Tardy", nil);
                [cell.icon setImage:[UIImage imageNamed:@"small_late.png"]];
                cell.background_bg.backgroundColor = [UIColor cyan:0.1];
                cell.selected_bg.backgroundColor = [UIColor cyan:0.15];
                break;
            default:
                cell.detail.text = NSLocalizedString(@"결석", nil);
                [cell.icon setImage:[UIImage imageNamed:@"small_absent.png"]];
                cell.background_bg.backgroundColor = [UIColor silver:0.1];
                cell.selected_bg.backgroundColor = [UIColor silver:0.15];
                break;
        };
        
        return cell;
    }
}

//#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0)
        return;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    
    SimpleUser *simpleUser = [data objectAtIndex:indexPath.row - 1];
    [self.post.attendance toggleStatus:simpleUser.id];
    [self.tableview reloadData];
    
    [BTAPIs toggleManuallyWithAttendance:[NSString stringWithFormat:@"%ld", (long)self.post.attendance.id]
                                    user:[NSString stringWithFormat:@"%ld", (long)simpleUser.id]
                                 success:^(Attendance *attendance) {
                                 } failure:^(NSError *error) {
                                 }];
}

#pragma IBAction
- (IBAction)left:(id)sender {
    self.segmentcontrol.selectedSegmentIndex = 0;
    
    NSArray *sorting = [data sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        return [((SimpleUser *)a).full_name compare:((SimpleUser *)b).full_name options:NSNumericSearch];
    }];
    data = [NSArray arrayWithArray:sorting];
    
    [self.tableview reloadData];
}

- (IBAction)center:(id)sender {
    self.segmentcontrol.selectedSegmentIndex = 1;
    
    NSArray *sorting = [data sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        return [((SimpleUser *)a).studentID compare:((SimpleUser *)b).studentID options:NSNumericSearch];
    }];
    data = [NSArray arrayWithArray:sorting];
    
    [self.tableview reloadData];
}

- (IBAction)right:(id)sender {
    self.segmentcontrol.selectedSegmentIndex = 2;
    
    NSArray *sorting1 = [data sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        return [((SimpleUser *)a).full_name compare:((SimpleUser *)b).full_name options:NSNumericSearch];
    }];
    data = [NSArray arrayWithArray:sorting1];
    
    NSArray *sorting = [data sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSInteger first = [self.post.attendance stateInt:((SimpleUser *)a).id];
        NSInteger second = [self.post.attendance stateInt:((SimpleUser *)b).id];
        
        if (first == 1)
            first = 2;
        else if (first == 2)
            first = 1;
        
        if (second == 1)
            second = 2;
        else if (second == 2)
            second = 1;
        
        if (first > second)
            return (NSComparisonResult)NSOrderedDescending;
        else
            return (NSComparisonResult)NSOrderedAscending;
    }];
    data = [NSArray arrayWithArray:sorting];
    
    [self.tableview reloadData];
}

@end
