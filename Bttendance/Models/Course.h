//
//  Course.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "School.h"

@class SimpleSchool;

@interface SimpleCourse : NSObject

@property(assign) NSInteger id;
@property(strong, nonatomic) NSString  *name;
@property(strong, nonatomic) NSString  *professor_name;
@property(assign) NSInteger  school;
@property(assign) BOOL opened;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSDictionary *)toDictionary:(SimpleCourse *)course;

@end


@interface Course : NSObject

@property(assign) NSInteger id;
@property(strong, nonatomic) NSDate  *createdAt;
@property(strong, nonatomic) NSDate  *updatedAt;
@property(strong, nonatomic) NSString  *name;
@property(strong, nonatomic) NSString  *professor_name;
@property(strong, nonatomic) SimpleSchool  *school;
@property(strong, nonatomic) NSArray  *managers;
@property(assign) NSInteger  students_count;
@property(assign) NSInteger  posts_count;
@property(strong, nonatomic) NSString  *code;
@property(assign) BOOL opened;

//Added by APIs
@property(assign) NSInteger attendance_rate;
@property(assign) NSInteger clicker_rate;
@property(assign) NSInteger notice_unseen;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end