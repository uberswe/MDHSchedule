//
//  subView.m
//  scheduleTable
//
//  Created by Ice on 2011-10-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "subView.h"


@implementation subView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (subView *) newSubView {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"View" owner:nil options:nil];
    return [array objectAtIndex:0];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@end
