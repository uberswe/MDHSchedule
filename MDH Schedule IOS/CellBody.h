//
//  CellBody.h
//  scheduleTable
//
//  Created by Lion User on 2011-10-24.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Post;

@interface CellBody : UIView{
    
@private
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *courselabel;
    IBOutlet UILabel *eventLabel;
    IBOutlet UILabel *roomLabel;
    IBOutlet UILabel *groupLabel;
    Post *_post;
    
}

@property (nonatomic, strong) Post *post;


@end
