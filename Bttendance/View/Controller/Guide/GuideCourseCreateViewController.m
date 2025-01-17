//
//  GuideCourseCreateViewController.m
//  Bttendance
//
//  Created by TheFinestArtist on 2014. 7. 8..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "GuideCourseCreateViewController.h"
#import "UIColor+Bttendance.h"
#import "UIImage+Bttendance.h"

@interface GuideCourseCreateViewController ()

@property (strong) UILabel *message1;
@property (strong) UILabel *message2;
@property (strong) UILabel *message3;

@end

@implementation GuideCourseCreateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.message1 = [[UILabel alloc]initWithFrame:CGRectMake(82, 12, 212, 60)];
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle1.lineSpacing = 7;
    NSString *string1 = NSLocalizedString(@"Please inform the students in detail why you are using BTTENDANCE.", nil);
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:string1];
    [str1 addAttributes:@{NSParagraphStyleAttributeName: paragraphStyle1} range:[string1 rangeOfString:string1]];
    self.message1.attributedText = str1;
    self.message1.numberOfLines = 0;
    self.message1.font = [UIFont systemFontOfSize:14];
    self.message1.textColor = [UIColor black:1.0];
    [self.message1 sizeToFit];
    
    self.message2 = [[UILabel alloc]initWithFrame:CGRectMake(82, 12, 212, 60)];
    NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle2.lineSpacing = 7;
    NSString *string2 = NSLocalizedString(@"It is important to tell the students that during class, smartphones may not be used for anything other than BTTENDANCE.", nil);
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:string2];
    [str2 addAttributes:@{NSParagraphStyleAttributeName: paragraphStyle2} range:[string2 rangeOfString:string2]];
    self.message2.attributedText = str2;
    self.message2.numberOfLines = 0;
    self.message2.font = [UIFont systemFontOfSize:14];
    self.message2.textColor = [UIColor black:1.0];
    [self.message2 sizeToFit];
    
    self.message3 = [[UILabel alloc]initWithFrame:CGRectMake(82, 12, 212, 60)];
    NSMutableParagraphStyle *paragraphStyle3 = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle3.lineSpacing = 7;
    NSString *string3 = NSLocalizedString(@"기능 사용에 어려움을 느끼신다면 언제든지 가이드를 확인해주세요!", nil);
    NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:string3];
    [str3 addAttributes:@{NSParagraphStyleAttributeName: paragraphStyle3} range:[string3 rangeOfString:string3]];
    self.message3.attributedText = str3;
    self.message3.numberOfLines = 0;
    self.message3.font = [UIFont systemFontOfSize:14];
    self.message3.textColor = [UIColor black:1.0];
    [self.message3 sizeToFit];
    
    [self.nextBt setTitle:NSLocalizedString(@"시작하기", nil) forState:UIControlStateNormal];
    [self.nextBt setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:1.0]] forState:UIControlStateNormal];
    [self.nextBt setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:0.85]] forState:UIControlStateHighlighted];
    [self.nextBt setBackgroundImage:[UIImage imageWithColor:[UIColor cyan:0.85]] forState:UIControlStateSelected];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    //all view component fade in
    self.tableview.alpha = 0;
    self.nextBt.alpha = 0;
    [UIImageView beginAnimations:nil context:NULL];
    [UIImageView setAnimationDuration:1];
    self.tableview.alpha = 1;
    self.nextBt.alpha = 1;
    [UIImageView commitAnimations];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

#pragma mark UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return 67.5;
        case 1:
            return 165;
        case 2:
            return 60;
        case 3:
            return 24 + MAX(41, self.message1.frame.size.height);
        case 4:
            return 24 + MAX(41, self.message2.frame.size.height);
        case 5:
            return 24 + MAX(41, self.message3.frame.size.height);
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 67.5)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor white:1.0];
            
            UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 25.5, 320, 20)];
            title.text = NSLocalizedString(@"Your course has been created!", nil);
            title.font = [UIFont boldSystemFontOfSize:18];
            title.textAlignment = NSTextAlignmentCenter;
            title.textColor = [UIColor black:1.0];
            [cell addSubview:title];
            
            return cell;
        }
        case 1: {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 165)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor grey:1.0];
            
            UIView *header = [[UIView alloc]initWithFrame:CGRectMake(30, 26, 107.5, 37)];
            header.layer.cornerRadius = 3;
            header.backgroundColor = [UIColor navy:1.0];
            [cell addSubview:header];
            
            UIView *header2 = [[UIView alloc]initWithFrame:CGRectMake(30, 53, 107.5, 10)];
            header2.backgroundColor = [UIColor navy:1.0];
            [cell addSubview:header2];
            
            UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(30, 63, 107.5, 77.5)];
            footer.layer.cornerRadius = 3;
            footer.backgroundColor = [UIColor white:1.0];
            [cell addSubview:footer];
            
            UIView *footer2 = [[UIView alloc]initWithFrame:CGRectMake(30, 63, 107.5, 10)];
            footer2.backgroundColor = [UIColor white:1.0];
            [cell addSubview:footer2];
            
            UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(30, 26, 107.5, 37)];
            title.text = NSLocalizedString(@"클래스 코드", nil);
            title.font = [UIFont systemFontOfSize:14];
            title.textAlignment = NSTextAlignmentCenter;
            title.textColor = [UIColor white:1.0];
            [cell addSubview:title];
            
            UILabel *code = [[UILabel alloc]initWithFrame:CGRectMake(30, 63, 107.5, 77.5)];
            code.text = [self.courseCode uppercaseString];
            code.font = [UIFont boldSystemFontOfSize:30];
            code.textAlignment = NSTextAlignmentCenter;
            code.textColor = [UIColor navy:1.0];
            [cell addSubview:code];
            
            UILabel *message = [[UILabel alloc]initWithFrame:CGRectMake(150, 27, 143, 140)];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            
            NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
            if ([locale isEqualToString:@"ko"]) {
                message.font = [UIFont systemFontOfSize:14];
                paragraphStyle.lineSpacing = 7;
            } else {
                message.font = [UIFont systemFontOfSize:12];
                paragraphStyle.lineSpacing = 5;
            }
            
            NSString *string = NSLocalizedString(@"학생들에게 좌측의 클래스코드를 알려주세요. 학생들은 클래스코드를 입력해서 개설된 강의에 쉽게 등록할 수 있습니다.", nil);
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
            [str addAttributes:@{NSParagraphStyleAttributeName: paragraphStyle} range:[string rangeOfString:string]];
            message.attributedText = str;
            message.numberOfLines = 0;
            
            message.textColor = [UIColor silver:1.0];
            [message sizeToFit];
            [cell addSubview:message];
            
            return cell;
        }
        case 2: {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor white:1.0];
            
            UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 28, 320, 20)];
            title.text = NSLocalizedString(@"Tips for BTTENDANCE", nil);
            title.font = [UIFont boldSystemFontOfSize:18.5];
            title.textAlignment = NSTextAlignmentCenter;
            title.textColor = [UIColor navy:1.0];
            [cell addSubview:title];
            
            return cell;
        }
        case 3: {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 24 + MAX(41, self.message1.frame.size.height))];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor white:1.0];
            
            UILabel *number = [[UILabel alloc]initWithFrame:CGRectMake(30, 2, 30, 60)];
            number.text = @"1";
            number.font = [UIFont boldSystemFontOfSize:49];
            number.textAlignment = NSTextAlignmentCenter;
            number.textColor = [UIColor navy:1.0];
            [cell addSubview:number];
            
            [cell addSubview:self.message1];
            
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(72, 15, 1.5, self.message1.frame.size.height - 6)];
            line.backgroundColor = [UIColor navy:1];
            [cell addSubview:line];
            
            return cell;
        }
        case 4: {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 24 + MAX(41, self.message2.frame.size.height))];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor white:1.0];
            
            UILabel *number = [[UILabel alloc]initWithFrame:CGRectMake(30, 2, 30, 60)];
            number.text = @"2";
            number.font = [UIFont boldSystemFontOfSize:49];
            number.textAlignment = NSTextAlignmentCenter;
            number.textColor = [UIColor navy:1.0];
            [cell addSubview:number];
            
            [cell addSubview:self.message2];
            
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(72, 15, 1.5, self.message2.frame.size.height - 6)];
            line.backgroundColor = [UIColor navy:1];
            [cell addSubview:line];
            
            return cell;
        }
        case 5: {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 24 + MAX(41, self.message3.frame.size.height))];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor white:1.0];
            
            UILabel *number = [[UILabel alloc]initWithFrame:CGRectMake(30, 2, 30, 60)];
            number.text = @"3";
            number.font = [UIFont boldSystemFontOfSize:49];
            number.textAlignment = NSTextAlignmentCenter;
            number.textColor = [UIColor navy:1.0];
            [cell addSubview:number];
            
            [cell addSubview:self.message3];
            
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(72, 15, 1.5, self.message3.frame.size.height - 6)];
            line.backgroundColor = [UIColor navy:1];
            [cell addSubview:line];
            
            return cell;
        }
        default: {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor white:1.0];
            return cell;
        }
    }
}

#pragma IBAction
- (IBAction)next:(id)sender {
    self.tableview.alpha = 1;
    self.nextBt.alpha = 1;
    [UIView animateWithDuration:0.4f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.tableview.alpha = 0;
        self.nextBt.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

@end
