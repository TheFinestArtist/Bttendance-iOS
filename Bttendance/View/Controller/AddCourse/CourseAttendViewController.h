//
//  CourseAttendViewController.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 7. 25..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseAttendViewController : UITableViewController <UITextFieldDelegate, UIAlertViewDelegate> {
    NSIndexPath *codeIndex;
    NSDictionary *userInfo;
}

@end
