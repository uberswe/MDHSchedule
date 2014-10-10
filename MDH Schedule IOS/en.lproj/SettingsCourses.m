//
//  SettingsCourses.m
//  scheduleTable
//
//  Created by Markus Tenghamn on 4/13/12.
//  Copyright (c) 2012 Markspixel. All rights reserved.
//

#import "SettingsCourses.h"

@implementation SettingsCourses

@synthesize settingsCourses;
@synthesize Delegate;
@synthesize BackButton;
@synthesize DeleteButton;
@synthesize table;
@synthesize courses;
@synthesize dataHandler;
@synthesize DeleteAllCourses;
@synthesize DeleteAllButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dataHandler = [[DataHandler alloc] init];
        dataHandler.coursesDelegate = self;
        courses = [dataHandler fetchCourses];
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    [table reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (courses) {
        //NSLog(@"Count: %i", [courses count]);
        return [courses count];
    }
    else {
        //NSLog(@"Count: 0");
        DeleteButton.enabled = FALSE;
        DeleteAllButton.enabled = FALSE;
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"courseCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    UIColor *backgroundColor = [UIColor colorWithWhite:0.15 alpha:1.0];
    UIColor *textColor = [UIColor colorWithRed:1.0 green:(144.0/255) blue:0 alpha:1.0];
    
    cell.backgroundColor = backgroundColor;
    cell.textLabel.backgroundColor = backgroundColor;
    cell.textLabel.textColor = textColor;
    cell.detailTextLabel.backgroundColor = backgroundColor;
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = [(NSArray *)[courses objectAtIndex:[indexPath row]] valueForKey:@"CourseCode"];
    cell.detailTextLabel.text = [(NSArray *)[courses objectAtIndex:[indexPath row]] valueForKey:@"CourseName"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    [cell setTag:[indexPath row]];
    
    return cell;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.table.dataSource = self;
    self.table.delegate = self;
}

- (void)viewDidUnload
{
    [self setSettingsCourses:nil];
    [self setBackButton:nil];
    [self setDeleteButton:nil];
    [self setTable:nil];
    table = nil;
    [self setDeleteAllButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)Delete:(id)sender {
    if ([table indexPathsForSelectedRows] > 0) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"remove", @"Delete") message:NSLocalizedString(@"sureremove", @"Are you sure you want to delete?") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"Ok") otherButtonTitles:NSLocalizedString(@"cancel", @"Cancel"),nil];
    [alert show];
    }
    else {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"remove", @"Delete") message:NSLocalizedString(@"noselected", @"No courses were selected") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"cancel", @"Cancel"),nil];
    [alert show];
    }
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        if ([table indexPathsForSelectedRows] > 0) {
        NSMutableArray *selectedCourses = [[NSMutableArray alloc] init];
        
        NSArray *paths = [table indexPathsForSelectedRows];
        
        for (NSIndexPath *path in paths) {
            NSInteger row = [path row];
                Course *course = [courses objectAtIndex:row];
                [selectedCourses addObject:course];
        
        }
        
        [self.Delegate userHasSelectedCoursesToDelete:selectedCourses];
            
        [table reloadData];
        }
        if (DeleteAllCourses) {
            //NSLog(@"Delete all courses");
            [dataHandler removeAllCourses];
            DeleteAllCourses = FALSE;
            [self dismissModalViewControllerAnimated:YES];
        }
        else {
            //NSLog(@"cancel");
        }
    }
    else if (buttonIndex == 1)
    {
        //NSLog(@"cancel");
        DeleteAllCourses = FALSE;
    }
}

- (void) userHasSelectedCoursesToDelete:(NSMutableArray *)coursesToDelete {
    [self dismissModalViewControllerAnimated:YES];
    
    //    [dataHandler removeAllCourses];
    //    [dataHandler removeAllSchedulePosts];
    
    for (NSManagedObject *course in coursesToDelete) {
        NSManagedObjectID *courseID = [course objectID];
        [dataHandler removeCourse:courseID];
    }
}

- (void) userHasCancelled {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)Back:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)DeleteAll:(id)sender {
    if (courses.count > 0) {
    DeleteAllCourses = TRUE;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"removeall", @"Delete all courses") message:NSLocalizedString(@"removeallmsg", @"Are you sure you want to delete all courses?") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"Ok") otherButtonTitles:NSLocalizedString(@"cancel", @"Cancel"),nil];
    [alert show];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"removeall", @"Delete all courses") message:NSLocalizedString(@"nonetoremove", @"There are no courses to delete") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"cancel", @"Cancel"),nil];
        [alert show];
    }
}
@end
