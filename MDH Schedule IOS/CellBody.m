//
//  CellBody.m
//  scheduleTable
//
//  Created by Lion User on 2011-10-24.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CellBody.h"
#import "Post.h"

@implementation CellBody


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setPost:(Post *)cellPost {
    timeLabel.text = [NSString stringWithFormat:@"%@ - %@", [cellPost startTimeAsString], [cellPost endTimeAsString]];
    courselabel.text = [cellPost courseAsString];
    eventLabel.text = [cellPost Element];
    groupLabel.text = [cellPost Group];
    roomLabel.text = [cellPost Premises];
    _post = cellPost;
}

- (Post *) post {
    
    return _post;
}

- (void) setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    
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
