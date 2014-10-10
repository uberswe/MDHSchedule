//
//  DateHeader.m
//  scheduleTable
//
//  Created by Ice on 2011-10-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DateHeader.h"
#import "Post.h"
#import "Cell.h"
#import <QuartzCore/QuartzCore.h>


@implementation DateHeader

@synthesize post;
@synthesize cell;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:@"DateHeader" bundle:nil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        //UIView *view = [self contentView]; //[[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)] autorelease];
        weekNumberLabel.hidden = YES;
        weekLabel.hidden = YES;
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(0, 0, 320, 37); //view.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:0.10 alpha:1.0] CGColor], (id)[[UIColor colorWithWhite:0.15 alpha:1.0] CGColor], nil];
        [self.layer insertSublayer:gradient atIndex:0];
    }
    return self;
}


- (void) setDate:(NSDate *)date andEndTime:(NSDate *)endTime {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"EEE"];
    weekDayLabel.text = [[formatter stringFromDate:date] capitalizedString];
    
    
    [formatter setDateFormat:@"dd MMM"];
    dateLabel.text = [formatter stringFromDate:date];
    
    [formatter setDateFormat:@"HH:mm"];
    startTimeLabel.text = [formatter stringFromDate:date];
    endTimeLabel.text = [formatter stringFromDate:endTime];
    
}

- (void) showWeekNumber:(NSInteger) weekNumber {
    weekNumberLabel.text = [NSString stringWithFormat:@"%02i", weekNumber];
    weekLabel.hidden = NO;
    weekNumberLabel.hidden = NO;
}


- (void)handleTap:(UITapGestureRecognizer *)gesture {
    cell.showSubViews = !cell.showSubViews;
    
    collapsed.hidden = cell.showSubViews;
    expanded.hidden = !cell.showSubViews;
}


@end
