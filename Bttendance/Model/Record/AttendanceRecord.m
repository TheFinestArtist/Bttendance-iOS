//
//  AttendanceRecord.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 3..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "AttendanceRecord.h"

@implementation AttendanceRecord

#pragma Override RLMObject Method
+ (NSDictionary *)defaultPropertyValues {
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithDictionary:[super defaultPropertyValues]];
    [jsonDict addEntriesFromDictionary:@{@"email" : @"",
                                         @"full_name" : @"",
                                         @"grade" : @"",
                                         @"studentID" : @"",
                                         @"courseID" : @0}];
    return jsonDict;
}

@end
