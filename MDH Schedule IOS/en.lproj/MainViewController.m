//
//  MainViewController.m
//  mdhschedule
//
//  Created by Lion User on 2011-10-24.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "TableView.h"
#import "CourseDummyObject.h"
#import "CourseDummyObject2.h"
#import "SelectCourses.h"
#import "SettingsCourses.h"
#import "Reachability.h"

@implementation MainViewController
@synthesize Courses = _Courses;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dataHandler = [[DataHandler alloc] init];
        dataHandler.scheduleDelegate = self;
        
        //[dataHandler removeAllSchedulePosts];
        
        //CDT224.44073.-.-&kurs=DVA201.44098.-.-&kurs=DVA205.44012.-.-&kurs=DVA213.44000
        //if ([[dataHandler fetchCourses] count] == 0)
//       [dataHandler removeAllCourses];
//        [dataHandler addCourse:@"DVA213.44000"];
//        [dataHandler addCourse:@"DVA201.44098"];
//        [dataHandler addCourse:@"DVA205.44012"];
//        [dataHandler addCourse:@"CDT224.44073"];
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        if (screenBounds.size.height == 568) {
            tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, 499, 320, 49)];
        } else {
            tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, 411, 320, 49)];
        }
        tabBar.delegate = self;
        [self.view addSubview:tabBar];
        
        //self.Courses = [dataHandler fetchCourses];
        [activityIndicator setHidden:YES];
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    reloadButtonOutlet.enabled = FALSE;
//    activityIndicator.hidden = FALSE;
//    [reloadButtonOutlet setEnabled:NO];
//    [activityIndicator setHidden:NO];
    
    //if (connection == TRUE) {
        //reloadButtonOutlet.enabled = TRUE;
        //addButton.enabled = TRUE;
      //  [self setCourses:[dataHandler fetchCourses]];
    //}
    //else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No connection" message:@"The application is uable to connect to the schedule server, please make sure 3G or WIFI is enabled." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
//        [alert show];
        //reloadButtonOutlet.enabled = FALSE;
        //addButton.enabled = FALSE;
        [self setCourses:[dataHandler fetchCourses]];
    //}
}

- (void) setCourses:(NSMutableArray *)courses {
    _Courses = courses;
    CoursesSchedules = nil;
    CoursesSchedules = [[NSMutableArray alloc] init];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    if (_Courses.count != 0) {
    
    [_Courses insertObject:[[CourseDummyObject2 alloc] init] atIndex:0];
    UITabBarItem *itemAllCourses = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"all", @"All") image:nil tag:0];
    [items addObject:itemAllCourses];
    NSMutableArray *tempCourse = [dataHandler fetchEntriesForCourse:[[_Courses objectAtIndex:0] valueForKey:@"CourseCode"]];
    [CoursesSchedules addObject:tempCourse];
    
    for (int i = 1; i < [_Courses count]; i++) {
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:((Course *) [courses objectAtIndex:i]).CourseCodeAsString image:nil tag:i];
        [items addObject:item];
        NSMutableArray *theCourse = [dataHandler fetchEntriesForCourse:[[_Courses objectAtIndex:i] valueForKey:@"CourseCode"]];
        //[CoursesSchedules addObject:theCourse];
        if (theCourse != nil) {
            [CoursesSchedules addObject:theCourse];
        }
        else {
            [_Courses removeObjectAtIndex:i];
            [_Courses insertObject:[[CourseDummyObject alloc] init] atIndex:i];
            NSMutableArray *temp2Course = [dataHandler fetchEntriesForCourse:[[_Courses objectAtIndex:i] valueForKey:@"CourseCode"]];
            [CoursesSchedules addObject:temp2Course];
        }
    }
    
    [tabBar setItems:items animated:NO];
    //[tabBar setItems:[[NSArray alloc] initWithObjects:itemAllCourses, nil] animated:NO];
    [tabBar setSelectedItem:itemAllCourses];
    [self tabBar:tabBar didSelectItem:itemAllCourses];
    }
    else {
        [tabBar setItems:nil animated:NO];
        tableView.schedule = nil;
    }
//    activityIndicator.hidden = TRUE;
//    reloadButtonOutlet.enabled = TRUE;
//    [activityIndicator setHidden:YES];
//    [reloadButtonOutlet setEnabled:YES];
}

- (void) reloadButton_Clicked:(id)sender {
//    reloadButtonOutlet.enabled = FALSE;
//    activityIndicator.hidden = FALSE;
    if (_Courses.count != 0) {
    if (connection == TRUE) {
    [reloadButtonOutlet setEnabled:NO];
    [activityIndicator setHidden:NO];
    [dataHandler fetchNetworkEntries];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"wifierrortitle", @"No connection") message:NSLocalizedString(@"wifidetailerror", @"The application is uable to connect to the schedule server, please make sure 3G or WIFI is enabled.") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @"Ok"),nil];
        [alert show];
    }
    }
//    [self setCourses:[dataHandler fetchCourses]];
}

- (void) settingsButton_Clicked:(id)sender {
    SettingsCourses *settings = [[SettingsCourses alloc] initWithNibName:@"SettingsCourses" bundle:nil];
    settings.Delegate = self;
    settings.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:settings animated:YES];
}

- (void) addButton_Clicked:(id)sender {
    SelectCourses *select = [[SelectCourses alloc] initWithNibName:@"SelectCourses" bundle:nil];
    select.Delegate = self;
    select.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:select animated:YES];
}

//- (void) setTableViews:(NSMutableArray *)tableViews {
//    _tableViews = tableViews;
//    NSMutableArray *tables = [[NSMutableArray alloc] init];
//    for (NSInteger i = 0; i < [tableViews count]; i++) {
//        [tables addObject:[[UITabBarItem alloc] initWithTitle:((TableView *)[tableViews objectAtIndex:i]).Course  image:nil tag:i]];
//    }
//    [tabBar setItems:tables];
//    tabBar.selectedItem = [[tabBar items] objectAtIndex:0];
//}

#pragma mark - Delegate Methods


- (void) tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger index = [item tag];
    //NSMutableArray *schedule = [dataHandler fetchEntriesForCourse:[[_Courses objectAtIndex:index] valueForKey:@"CourseCode"]];
    if ([[[_Courses objectAtIndex:index] valueForKey:@"CourseCode"] isEqualToString:@"NoCourses"]) {
        NSMutableArray *schedule = [dataHandler fetchEntriesForCourse:nil];
        tableView.schedule = schedule;    
    }
    else if ([[[_Courses objectAtIndex:index] valueForKey:@"CourseCode"] isEqualToString:@"nil"]) {
        tableView.schedule = nil;
    }
    else {
        NSMutableArray *schedule = [CoursesSchedules objectAtIndex:index];
        if (_Courses.count > 1) {
            tableView.schedule = schedule;
        }
        else {
            tableView.schedule = nil;
//            [reloadButtonOutlet setEnabled:YES];
//            [activityIndicator setHidden:YES];
        }
    }
    
}

- (void) dataHandlerHasLoadedScheduleData:(NSArray *)scheduleData {
    [tabBar setSelectedItem:[tabBar selectedItem]];
    NSInteger index = [tabBar.selectedItem tag];
    NSMutableArray *schedule = [[NSMutableArray alloc] init];
    if ([[[_Courses objectAtIndex:index] valueForKey:@"CourseCode"] isEqualToString:@"NoCourses"]) {
        schedule = [dataHandler fetchEntriesForCourse:nil];
    }
    else {
        //schedule = [dataHandler fetchEntriesForCourse:[[_Courses objectAtIndex:index] valueForKey:@"CourseCode"]];
        schedule = [CoursesSchedules objectAtIndex:index];
    }
    tableView.schedule = schedule;
    [reloadButtonOutlet setEnabled:YES];
    [activityIndicator setHidden:YES];
}

- (void) userHasSelectedCourses:(NSMutableArray *)courses {
//    [reloadButtonOutlet setEnabled:NO];
//    [activityIndicator setHidden:NO];
//courses contains an array with the selected courses
    [self dismissModalViewControllerAnimated:YES];
    
//    [dataHandler removeAllCourses];
//    [dataHandler removeAllSchedulePosts];
    
    for (NSArray *course in courses) {
//        match = FALSE;
//        int i = 0;
//        for (NSArray *course2 in self.Courses) {
//            if (i != 0) {
//                if ([[NSString stringWithFormat:[course2 objectAtIndex:0]] isEqual:[NSString stringWithFormat:[course objectAtIndex:0]]]) {
//                    match = TRUE;
//                }
//                i++;
//            }
//            else {
//                i++;
//            }
//        }
//        if (!match) {
            //Adds each course to the db
            [dataHandler addCourse:[course objectAtIndex:0]];
//        }
    }
    //This will fetch all the courses with the new courses and update the _Courses array
    //This will then call setCourses
    self.Courses = [dataHandler fetchCourses];
    //CoursesSchedules = _Courses;
    
    [dataHandler fetchNetworkEntries];
}

- (void) userHasSelectedCoursesToDelete:(NSMutableArray *)coursesToDelete {
    [self dismissModalViewControllerAnimated:YES];
    
    //    [dataHandler removeAllCourses];
    //    [dataHandler removeAllSchedulePosts];
    
    for (NSManagedObject *course in coursesToDelete) {
        NSManagedObjectID *courseID = [course objectID];
        [dataHandler removeCourse:courseID];
    }
    self.Courses = [dataHandler fetchCourses];
}

- (void) userHasCancelled {
    [self dismissModalViewControllerAnimated:YES];
}




#pragma mark - View lifecycle

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [activityIndicator startAnimating];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    Reachability * reach = [Reachability reachabilityWithHostname:@"schema.grupp12.se"];
    
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Connected");
            connection = TRUE;
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Can't connect");
            connection = FALSE;
        });
    };
    
    [reach startNotifier];
}

- (void)viewDidUnload
{
    activityIndicator = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        NSLog(@"Connected");
        connection = TRUE;
    }
    else
    {
        NSLog(@"Can't connect");
        connection = FALSE;
    }
}

@end
