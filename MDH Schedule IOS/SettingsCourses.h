//
//  SettingsCourses.h
//  scheduleTable
//
//  Created by Markus Tenghamn on 4/13/12.
//  Copyright (c) 2012 Markspixel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dataHandler.h"

@interface SettingsCourses : UIViewController <DataHandlerDelegate, UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (strong, nonatomic) DataHandler *dataHandler;
@property (strong, nonatomic) NSMutableArray *courses;
@property BOOL *DeleteAllCourses;
@property (strong, nonatomic) IBOutlet UIView *settingsCourses;
@property (nonatomic, strong) id Delegate;
@property (weak, nonatomic) IBOutlet UIButton *BackButton;
@property (weak, nonatomic) IBOutlet UIButton *DeleteButton;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIButton *DeleteAllButton;


- (IBAction)Delete:(id)sender;
- (IBAction)Back:(id)sender;
- (IBAction)DeleteAll:(id)sender;

@end
