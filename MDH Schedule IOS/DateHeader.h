//
//  DateHeader.h
//  scheduleTable
//
//  Created by Ice on 2011-10-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Post;
@class Cell;


@interface DateHeader : UIView {
    IBOutlet UILabel *weekNumberLabel;
    IBOutlet UILabel *weekLabel;
    IBOutlet UILabel *weekDayLabel;
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *startTimeLabel;
    IBOutlet UILabel *endTimeLabel;
    IBOutlet UIImageView *collapsed;
    IBOutlet UIImageView *expanded;
}

@property (nonatomic, strong) Post *post;
@property (nonatomic, strong) Cell *cell;

- (void) showWeekNumber:(NSInteger)weekNumber;
- (void) setDate:(NSDate *)date andEndTime:(NSDate *)endTime;
- (IBAction) handleTap:(UITapGestureRecognizer *) gesture;

@end
