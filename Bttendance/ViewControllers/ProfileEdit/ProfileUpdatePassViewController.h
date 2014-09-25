//
//  ProfileUpdatePassViewController.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 7. 17..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileUpdatePassViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property(weak, nonatomic) IBOutlet UITableView *tableview;
@property(strong, nonatomic) IBOutlet UITextField *password_old_field;
@property(strong, nonatomic) IBOutlet UITextField *password_new_field;

- (void)update_pass;

@end