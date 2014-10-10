//
//  SelectCourses.h
//  scheduleTable
//
//  Created by Lion User on 2011-10-27.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dataHandler.h"

@protocol SelectCoursesDelegate <NSObject>

@optional

- (void) userHasSelectedCourses: (NSMutableArray *) courses;
- (void) userHasCancelled;

@end

@interface SelectCourses : UIViewController <DataHandlerDelegate, UITableViewDataSource, UITableViewDelegate, UITableViewDataSource> {
    DataHandler *dataHandler;
    NSArray *courses;
    IBOutlet UITableView *table;
    IBOutlet UISearchBar *searchFilter;
    BOOL isFiltered;
    BOOL match;
}

@property (nonatomic, strong) id Delegate;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (strong, nonatomic) NSMutableArray* filteredCourses;
@property (strong, nonatomic) NSMutableArray* highlightedCourses;
@property (strong, nonatomic) NSArray* coursesForSearch;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *ActivityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnOK;


- (void) dataHandlerHasLoadedCourseData:(NSArray *)courseData;
- (IBAction)OK:(id)sender;
- (IBAction)Cancel:(id)sender;
- (IBAction)Done:(id)sender;


@end
