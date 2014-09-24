//
//  Question.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 7. 31..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Question.h"
#import "User.h"
#import "NSDate+Bttendance.h"
#import "NSDictionary+Bttendance.h"

@implementation SimpleQuestion

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];
    
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.message = [dictionary objectForKey:@"message"];
        self.choice_count = [[dictionary objectForKey:@"choice_count"] integerValue];
        self.progress_time = [[dictionary objectForKey:@"progress_time"] integerValue];
        self.show_info_on_select = [[dictionary objectForKey:@"show_info_on_select"] boolValue];
        self.detail_privacy = [dictionary objectForKey:@"detail_privacy"];
        self.a_option_text = [dictionary objectForKey:@"a_option_text"];
        self.b_option_text = [dictionary objectForKey:@"b_option_text"];
        self.c_option_text = [dictionary objectForKey:@"c_option_text"];
        self.d_option_text = [dictionary objectForKey:@"d_option_text"];
        self.e_option_text = [dictionary objectForKey:@"e_option_text"];
    }
    return self;
}

@end


@implementation Question

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];
    
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.createdAt = [NSDate dateFromString:[dictionary objectForKey:@"createdAt"]];
        self.updatedAt = [NSDate dateFromString:[dictionary objectForKey:@"updatedAt"]];
        self.message = [dictionary objectForKey:@"message"];
        self.choice_count = [[dictionary objectForKey:@"choice_count"] integerValue];
        self.progress_time = [[dictionary objectForKey:@"progress_time"] integerValue];
        self.show_info_on_select = [[dictionary objectForKey:@"show_info_on_select"] boolValue];
        self.detail_privacy = [dictionary objectForKey:@"detail_privacy"];
        self.a_option_text = [dictionary objectForKey:@"a_option_text"];
        self.b_option_text = [dictionary objectForKey:@"b_option_text"];
        self.c_option_text = [dictionary objectForKey:@"c_option_text"];
        self.d_option_text = [dictionary objectForKey:@"d_option_text"];
        self.e_option_text = [dictionary objectForKey:@"e_option_text"];
        self.owner = [[SimpleUser alloc] initWithDictionary:[dictionary objectForKey:@"owner"]];
    }
    return self;
}


@end
