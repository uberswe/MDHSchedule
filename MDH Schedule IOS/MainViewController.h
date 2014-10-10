//
//  MainViewController.h
//  mdhschedule
//
//  Created by Lion User on 2011-10-24.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataHandler.h"
#import "TableView.h"
#import "SelectCourses.h"
#import "SettingsCourses.h"


@interface MainViewController : UIViewController <UITabBarDelegate, DataHandlerDelegate, SelectCoursesDelegate>
{
    
    UITabBar *tabBar;
    IBOutlet UIView *viewHeader;
    IBOutlet UIView *viewBody;
    IBOutlet UILabel *labelTitle;
    IBOutlet TableView *tableView;
    IBOutlet UIButton *addButton;
    IBOutlet UIButton *settingsButton;
    IBOutlet UIButton *reloadButtonOutlet;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    
    DataHandler *dataHandler;
    NSMutableArray *cells;
    NSMutableArray *CoursesSchedules;
    BOOL *match;
    BOOL *connection;
}

//@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (nonatomic, strong) NSMutableArray *Courses;
//@property (weak, nonatomic) IBOutlet UIButton *reloadButtonOutlet;
//@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;


- (IBAction) reloadButton_Clicked:(id)sender;
- (IBAction) addButton_Clicked:(id)sender;
- (IBAction) settingsButton_Clicked:(id)sender;

- (void) dataHandlerHasLoadedScheduleData:(NSArray *)scheduleData;
- (void) userHasSelectedCourses:(NSMutableArray *)courses;
- (void) userHasCancelled;



@end
