//
//  Cell.h
//  scheduleTable
//
//  Created by Ice on 2011-10-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Post.h"
@class DateHeader;
@class TableView;

@interface Cell : UITableViewCell {
    DateHeader *dateHeader;
    NSDate *firstDate, *lastDate;
    NSMutableArray *posts;
    NSMutableArray *postViews;
    
    @private
    BOOL _showSubViews;
}

@property (nonatomic) BOOL showSubViews;
@property (nonatomic) BOOL showWeekNumber;
@property (nonatomic, strong) TableView *table;
@property (nonatomic) NSInteger row;

- (NSInteger) numberOfPosts;
- (void) addPost:(Post *)post;
- (void) emptyPosts;

@end
