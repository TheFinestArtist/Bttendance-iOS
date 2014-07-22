//
//  SignInController.h
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 11. 19..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate> {

    NSIndexPath *email_index, *password_index;
}

@property(weak, nonatomic) IBOutlet UITableView *tableview;
@property(weak, nonatomic) NSDictionary *user_info;

@end
