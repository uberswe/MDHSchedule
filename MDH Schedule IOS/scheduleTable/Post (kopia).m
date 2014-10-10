//
//  Post.m
//  scheduleTable
//
//  Created by Ice on 2011-10-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Post.h"



@implementation Post

//@synthesize date;
@synthesize startTime;
@synthesize endTime;
@synthesize course;
@synthesize element;
@synthesize premises;
@synthesize sign;
@synthesize group;
@synthesize changed;

- (id) init {
    self = [super init];
    dateFormatter = [[NSDateFormatter alloc] init];
    
    return self;
}

- (void) dealloc {
    [dateFormatter dealloc]; 
    [super dealloc];
}

- (id) initWithServerStringArray:(NSArray *)fields {
    self = [super init];
    [fields retain];
    
    
    dateFormatter = [[NSDateFormatter alloc] init];
    
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //self.date = [dateFormatter dateFromString:[fields objectAtIndex:DATE]];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    changed = [dateFormatter dateFromString:[fields objectAtIndex:CHANGED]];
    
    //[dateFormatter setDateFormat:@"HH:mm"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.startTime = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ %@",[fields objectAtIndex:DATE], [fields objectAtIndex:STARTTIME]]];
    self.endTime = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ %@",[fields objectAtIndex:DATE], [fields objectAtIndex:ENDTIME]]];
    
    self.course = [fields objectAtIndex:COURSE];
    self.element = [fields objectAtIndex:ELEMENT];
    self.premises = [fields objectAtIndex:PREMISES];
    sign = [fields objectAtIndex:SIGN];
    group = [fields objectAtIndex:GROUP];
    
    
    //[formatter setDateStyle:NSDateFormatterMediumStyle];
    //NSString *sdate = [formatter stringFromDate:self.date];
    
    /*
    NSError *error = nil;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@",(?=([^\"]*\"[^\"]*\")*(?![^\"]*\"))" options:NSRegularExpressionCaseInsensitive error:&error];
    
    
    if (!error) {
        NSArray *array = [regex matchesInString:serverString
                                          options:0
                                            range:NSMakeRange(0, [serverString length])];
        NSString *tempString = [array objectAtIndex:0];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH-mm"];
        
        NSString *start = [NSString stringWithFormat:@"%@ - %@", [array objectAtIndex:DATE], [array objectAtIndex:STARTTIME]];
        
        self.startTime = [formatter dateFromString:start];
        
    }
    */
    [fields release];
    return self;
}

- (NSString *) dateAsString {
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    return [dateFormatter stringFromDate:startTime];
}

- (NSString *) startTimeAsString {
    [dateFormatter setDateFormat:@"HH-mm"];
    return [dateFormatter stringFromDate:startTime];
}

- (NSString *) endTimeAsString {
    [dateFormatter setDateFormat:@"HH-mm"];
    return [dateFormatter stringFromDate:endTime];
}

- (NSString *) courseAsString {
    return [[course componentsSeparatedByString:@"."] objectAtIndex:0];
}

@end
