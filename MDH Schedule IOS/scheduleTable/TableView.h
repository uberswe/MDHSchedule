//
//  tableViewController.h
//  scheduleTable
//
//  Created by Ice on 2011-10-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataHandler.h"
#import "Post.h"
#import "DateHeader.h"
#import "subView.h"


@interface TableView : UITableView <UITableViewDelegate, DataHandlerDelegate, UITableViewDataSource> {
    
}

//@property (nonatomic, retain) DataHandler *handler;
//@property (nonatomic, retain) NSString *Course;
@property (nonatomic, strong) NSMutableArray *schedule;

//- (id)initWithStyle:(UITableViewStyle)style showCourse:(NSString *)course;

@end
