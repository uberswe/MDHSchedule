//
//  Cell.m
//  scheduleTable
//
//  Created by Ice on 2011-10-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Cell.h"
#import "DateHeader.h"
#import "CellBody.h"
#import "TableView.h"

@implementation Cell

@synthesize table;
@synthesize showWeekNumber;
@synthesize row;


- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"DateHeader" owner:self options:nil];
    
        dateHeader = (DateHeader *)[bundle objectAtIndex:0];
        dateHeader.cell = self;
        showWeekNumber = NO;
        
        posts = [[NSMutableArray alloc] init];
        postViews = [[NSMutableArray alloc] init];
        
        _showSubViews = NO;
    }
    
    return self;
}

- (void) addPost:(Post *)post {
    if (firstDate == nil) {
        firstDate = post.StartTime;
        lastDate = post.EndTime;
    }
    else {
        firstDate = [firstDate earlierDate:post.StartTime];
        lastDate = [lastDate laterDate:post.EndTime];
    }
    
    [dateHeader setDate:firstDate andEndTime:lastDate];
    [self.contentView addSubview:dateHeader];
    
    
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"CellBody" owner:self options:nil];
    
    CellBody *body = (CellBody *)[bundle objectAtIndex:0];
    [body setPost:post];
    
    UIColor *backColor = [UIColor colorWithRed:(32.0/255.0) green:(32.0/255.0) blue:(32.0/255.0) alpha:1.0];
        if ([self numberOfPosts] % 2 == 1)
            backColor = [UIColor colorWithRed:(48.0/255.0) green:(48.0/255.0) blue:(48.0/255.0) alpha:1.0];
    [body setBackgroundColor:backColor];
    
    body.frame = CGRectMake(0, 39 + self.numberOfPosts * 75, body.frame.size.width, body.frame.size.height);
    
    [posts addObject:post];
    [postViews addObject:body];
    
    body.hidden = !_showSubViews;
    
    [self.contentView addSubview:body];
    
}

- (void) emptyPosts {
    [posts removeAllObjects];
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    firstDate = nil;
    lastDate = nil;
}

- (NSInteger) numberOfPosts {
    return [posts count];
}

- (void) setShowSubViews:(BOOL)showViews {
    if (_showSubViews != showViews) {
        _showSubViews = showViews;
        for (CellBody *body in postViews) {
            body.hidden = !_showSubViews;
        }
        
        [table reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (BOOL) showSubViews {
    return _showSubViews;
}

- (void) setShowWeekNumber:(BOOL)showWeek {
    showWeekNumber = showWeek;
    if (showWeek) {
        [dateHeader showWeekNumber:[(Post *)[posts objectAtIndex:0] weekNumber]];
    }
    
}


@end
