//
//  Serial.m
//  bttendance
//
//  Created by TheFinestArtist on 2014. 4. 24..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "Serial.h"
#import "BTDateFormatter.h"
#import "User.h"
#import "NSDictionary+Bttendance.h"

@implementation SimpleSerial

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];

    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.key = [dictionary objectForKey:@"key"];
        self.school = [[dictionary objectForKey:@"school"] integerValue];
    }
    return self;
}

@end


@implementation Serial

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    dictionary = [dictionary dictionaryByReplacingNullsWithStrings];
    self = [super init];

    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.createdAt = [BTDateFormatter dateFromString:[dictionary objectForKey:@"createdAt"]];
        self.updatedAt = [BTDateFormatter dateFromString:[dictionary objectForKey:@"updatedAt"]];
        self.key = [dictionary objectForKey:@"key"];
        self.school = [[SimpleSchool alloc] initWithDictionary:[dictionary objectForKey:@"school"]];
        
        NSMutableArray *owners = [NSMutableArray array];
        for (NSDictionary *dic in [dictionary objectForKey:@"owners"]) {
            SimpleUser *user = [[SimpleUser alloc] initWithDictionary:dic];
            [owners addObject:user];
        }
        self.owners = owners;
    }
    return self;
}

@end
