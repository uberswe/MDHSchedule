//
//  Post.m
//  scheduleTable
//
//  Created by Ice on 2011-10-18.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Post.h"


@implementation Post

@dynamic BookingId;
@dynamic Course;
@dynamic StartTime;
@dynamic Group;
@dynamic Changed;
@dynamic Premises;
@dynamic Sign;
@dynamic EndTime;
@dynamic Element;
@synthesize Hidden;
@dynamic courseCode;
@dynamic signature;


- (id) initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context {
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    dateFormatter = [[NSDateFormatter alloc] init];
    return self;
}


- (void) setDataFromServerStringArray:(NSArray *)fields {
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.Changed = [dateFormatter dateFromString:[fields objectAtIndex:CHANGED]];
    
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.StartTime = [dateFormatter dateFromString:[fields objectAtIndex:STARTDATE]];
    self.EndTime = [dateFormatter dateFromString:[fields objectAtIndex:ENDDATE]];
    
    self.Course = [fields objectAtIndex:COURSE];
    self.Element = [[fields objectAtIndex:ELEMENT] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    self.Premises = [fields objectAtIndex:PREMISES];
    self.Sign = [fields objectAtIndex:SIGN];
    self.Group = [fields objectAtIndex:GROUP];
    
    self.Hidden = NO;
    
    
}

- (NSString *) dateAsString {
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *tempDate = self.StartTime; 
    NSString *dateString = [dateFormatter stringFromDate:tempDate];
    return dateString;
}

- (NSString *) startTimeAsString {
    [dateFormatter setDateFormat:@"HH:mm"];
    return [dateFormatter stringFromDate:self.StartTime];
}

- (NSString *) endTimeAsString {
    [dateFormatter setDateFormat:@"HH:mm"];
    return [dateFormatter stringFromDate:self.EndTime];
}

- (NSString *) courseAsString {
    return [[self.Course componentsSeparatedByString:@"."] objectAtIndex:0];
}

- (NSInteger) weekNumber {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [cal components:NSWeekCalendarUnit fromDate:self.StartTime];
    return [components week];
}


@end
