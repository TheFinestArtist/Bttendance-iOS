//
//  SignInController.h
//  Bttendance
//
//  Created by TheFinestArtist on 2013. 11. 19..
//  Copyright (c) 2013년 Bttendance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInViewController : UITableViewController <UITextFieldDelegate> {
    NSIndexPath *emaiIndex, *passwordIndex;
}

@property(weak, nonatomic) NSDictionary *user_info;

@end
