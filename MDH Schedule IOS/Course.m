//
//  Course.m
//  scheduleTable
//
//  Created by Lion User on 2011-10-27.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Course.h"
#import "Post.h"


@implementation Course

@dynamic CourseCode;
@dynamic CourseName;
@dynamic post;


- (NSString *)CourseCodeAsString {
    //NSArray *arr = [self.CourseCode componentsSeparatedByString:@"-"];
    //return [arr objectAtIndex:0];
    NSString *codeString = self.CourseCode;
    if ( [codeString length] > 0) {
        codeString = [codeString substringToIndex:6];
    }
    return codeString;
}

@end
