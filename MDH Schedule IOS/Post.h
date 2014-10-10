//
//  Post.h
//  scheduleTable
//
//  Created by Ice on 2011-10-18.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

enum post {
    BOOKING_ID = 0,
    STARTDATE = 1,
    ENDDATE = 2,
    COURSE = 3,
    GROUP = 4,
    SIGN = 5,
    PREMISES = 6,
    ELEMENT = 7,
    CHANGED = 8
};


@interface Post : NSManagedObject {
    
@private
    NSDateFormatter *dateFormatter;
}

@property (nonatomic, strong) NSString * BookingId;
@property (nonatomic, strong) NSString * Course;
@property (nonatomic, strong) NSDate * StartTime;
@property (nonatomic, strong) NSString * Group;
@property (nonatomic, strong) NSDate * Changed;
@property (nonatomic, strong) NSString * Premises;
@property (nonatomic, strong) NSString * Sign;
@property (nonatomic, strong) NSDate * EndTime;
@property (nonatomic, strong) NSString * Element;
@property BOOL Hidden;
@property (nonatomic, strong) NSManagedObject * courseCode;
@property (nonatomic, strong) NSManagedObject * signature;

- (void) setDataFromServerStringArray:(NSArray *)fields;
- (NSString *) dateAsString;
- (NSString *) startTimeAsString;
- (NSString *) endTimeAsString;
- (NSString *) courseAsString;
- (NSInteger) weekNumber;

@end
