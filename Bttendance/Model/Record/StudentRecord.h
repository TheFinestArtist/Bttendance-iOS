//
//  StudentRecord.h
//  bttendance
//
//  Created by TheFinestArtist on 2014. 11. 4..
//  Copyright (c) 2014년 Bttendance. All rights reserved.
//

#import "BTSimpleObject.h"

@interface StudentRecord : BTSimpleObject

@property NSString          *email;
@property NSString          *full_name;

//Added by APIs
@property NSString          *student_id;
@property NSInteger         course_id;

@end
RLM_ARRAY_TYPE(StudentRecord)