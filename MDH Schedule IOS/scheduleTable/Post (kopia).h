//
//  Post.h
//  scheduleTable
//
//  Created by Ice on 2011-10-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum post {
    DATE = 0,
    STARTTIME = 1,
    ENDTIME = 2,
    COURSE = 3,
    GROUP = 4,
    SIGN = 5,
    PREMISES = 6,
    ELEMENT = 7,
    CHANGED = 8
};

@interface Post : NSObject {
    NSDateFormatter *dateFormatter;
}

//@property (retain, nonatomic) NSDate *date;
@property (retain, nonatomic) NSDate *startTime;
@property (retain, nonatomic) NSDate *endTime;
@property (retain, nonatomic) NSString *course;
@property (retain, nonatomic) NSString *element;
@property (retain, nonatomic) NSString *premises;
@property (retain, nonatomic) NSString *sign;
@property (retain, nonatomic) NSString *group;
@property (retain, nonatomic) NSDate *changed;

- (id) initWithServerStringArray:(NSArray *)fields;
- (NSString *) dateAsString;
- (NSString *) startTimeAsString;
- (NSString *) endTimeAsString;
- (NSString *) courseAsString;

@end
