//
//  SelectCourses.m
//  scheduleTable
//
//  Created by Lion User on 2011-10-27.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SelectCourses.h"
#import "Reachability.h"

@implementation SelectCourses 
@synthesize Delegate;
@synthesize btnDone;
@synthesize filteredCourses;
@synthesize coursesForSearch;
@synthesize ActivityIndicator;
@synthesize btnCancel;
@synthesize btnOK;
@synthesize highlightedCourses;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        courses = nil;
        dataHandler = [[DataHandler alloc] init];
        dataHandler.coursesDelegate = self;
        
        Reachability * reach = [Reachability reachabilityWithHostname:@"schema.grupp3.se"];
        
        reach.reachableBlock = ^(Reachability * reachability)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Connected");
                [dataHandler fetchNetworkCourses];
            });
        };
        
        reach.unreachableBlock = ^(Reachability * reachability)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Can't connect");
                btnCancel.enabled = TRUE;
                ActivityIndicator.hidden = TRUE;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"wifierrortitle", @"No connection") message:NSLocalizedString(@"wifidetailerror", @"The application is uable to connect to the schedule server, please make sure 3G or WIFI is enabled.") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @"Ok"),nil];
                [alert show];
            });
        };
        
        [reach startNotifier];
    }
    return self;
}

- (void) dataHandlerHasLoadedCourseData:(NSArray *)courseData {
    coursesForSearch = courseData;
    courses = courseData;
    [table reloadData];
    btnCancel.enabled = TRUE;
    ActivityIndicator.hidden = TRUE;
    if ([courses count] > 10) {
    btnOK.enabled = TRUE;
    searchFilter.hidden = FALSE;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isFiltered){
        //NSLog(@"Count: %i", [filteredCourses count]);
        return [filteredCourses count];
    }
    if (courses) {
        //NSLog(@"Count: %i", [courses count]);
        
        //We assume the school always has more than 10 courses :P
        if (courses.count <= 10) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"Error") message:NSLocalizedString(@"coursedataerror" ,@"Unable to load course data at the moment.") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"Ok") otherButtonTitles:nil];
            [alert show];
            return 0;
        }
        return [courses count];
    }
    else
        return 0;
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
    
    if(isFiltered) {
        for (NSString *course in highlightedCourses) {
            //NSLog(@"Checking: %@", [NSString stringWithFormat:course]);
            //NSLog(@"Against: %@", [(NSArray *)[filteredCourses objectAtIndex:[indexPath row]] objectAtIndex:0]);
            if ([course isEqual:[NSString stringWithFormat:[(NSArray *)[filteredCourses objectAtIndex:[indexPath row]] objectAtIndex:0]]]) {
        [table selectRowAtIndexPath:indexPath animated:YES scrollPosition:0];
                //NSLog(@"Selected: %@", [NSString stringWithFormat:[(NSArray *)[filteredCourses objectAtIndex:[indexPath row]] objectAtIndex:0]]);
            }
        }
        
        
        cell.textLabel.text = [(NSArray *)[filteredCourses objectAtIndex:[indexPath row]] objectAtIndex:0];
        cell.detailTextLabel.text = [(NSArray *)[filteredCourses objectAtIndex:[indexPath row]] objectAtIndex:1];
    }
    else {
        for (NSString *course in highlightedCourses) {
            //NSLog(@"Checking: %@", [NSString stringWithFormat:course]);
            //NSLog(@"Against: %@", [(NSArray *)[filteredCourses objectAtIndex:[indexPath row]] objectAtIndex:0]);
            if ([course isEqual:[(NSArray *)[courses objectAtIndex:[indexPath row]] objectAtIndex:0]]) {
                [table selectRowAtIndexPath:indexPath animated:YES scrollPosition:0];
                //NSLog(@"Selected: %@", [NSString stringWithFormat:[(NSArray *)[courses objectAtIndex:[indexPath row]] objectAtIndex:0]]);
            }
        }
        cell.textLabel.text = [(NSArray *)[courses objectAtIndex:[indexPath row]] objectAtIndex:0];
        cell.detailTextLabel.text = [(NSArray *)[courses objectAtIndex:[indexPath row]] objectAtIndex:1];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    [cell setTag:[indexPath row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSInteger row = [indexPath row];
    if (isFiltered) {
        NSArray *course = [filteredCourses objectAtIndex:row];
        [highlightedCourses removeObject:[NSString stringWithFormat:[course objectAtIndex:0]]];
        //NSLog(@"Removed selection: %@", [NSString stringWithFormat:[course objectAtIndex:0]]);
    }
    else {
        NSArray *course = [courses objectAtIndex:row];
        [highlightedCourses removeObject:[NSString stringWithFormat:[course objectAtIndex:0]]];
        //NSLog(@"Removed selection: %@", [NSString stringWithFormat:[course objectAtIndex:0]]);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        match = false;
        NSInteger row = [indexPath row];
        if (isFiltered) {
            for (NSString *course in highlightedCourses) {
                if ([course isEqual:[NSString stringWithFormat:[(NSArray *)[filteredCourses objectAtIndex:row] objectAtIndex:0]]]) {
                    match = true;
                }
            }
            if (!match) {
            NSArray *course = [filteredCourses objectAtIndex:row];
            [highlightedCourses addObject:[NSString stringWithFormat:[course objectAtIndex:0]]];
            //NSLog(@"Added selection: %@", [NSString stringWithFormat:[course objectAtIndex:0]]);
            }
        }
        else {
            for (NSString *course in highlightedCourses) {
                if ([course isEqual:[NSString stringWithFormat:[(NSArray *)[courses objectAtIndex:row] objectAtIndex:0]]]) {
                    match = true;
                }
            }
            if (!match) {
            NSArray *course = [courses objectAtIndex:row];
            [highlightedCourses addObject:[NSString stringWithFormat:[course objectAtIndex:0]]];
            //NSLog(@"Added selection: %@", [NSString stringWithFormat:[course objectAtIndex:0]]);
            }
        }
    
    
}

- (void)OK:(id)sender {
    if ([table indexPathsForSelectedRows] > 0) {
    SEL updateMethod = @selector(userHasSelectedCourses:);
    
    if ([self.Delegate respondsToSelector:updateMethod]) {
        
        NSMutableArray *selectedCourses = [[NSMutableArray alloc] init];
        
        for (NSArray *course2 in courses) {
            for (NSString *course in highlightedCourses) {
                //NSLog(@"Checking: %@", [NSString stringWithFormat:course]);
                //NSLog(@"Against: %@", [(NSArray *)[filteredCourses objectAtIndex:[indexPath row]] objectAtIndex:0]);
                if ([course isEqual:[course2 objectAtIndex:0]]) {
                    [selectedCourses addObject:course2];
                }
            }
        }
        
        [self.Delegate userHasSelectedCourses:selectedCourses];
        selectedCourses = nil;
    }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"addcourses", @"Add courses") message:NSLocalizedString(@"nocoursesselected", @"You did not select any courses") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"cancel", @"Cancel"),nil];
        [alert show];
    }

}

- (void)Cancel:(id)sender {
    SEL updateMethod = @selector(userHasCancelled);
    
    if ([self.Delegate respondsToSelector:updateMethod]) {
        [self.Delegate userHasCancelled];
    }

}

- (IBAction)Done:(id)sender {
    if(searchFilter.text.length == 0)
    {
        isFiltered = FALSE;
        [table reloadData];
    }
    [btnDone setHidden:TRUE];
    [searchFilter resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchFiltery {
    //NSLog(@"searchBarTextDidBeginEditing");//More debugging
    [btnDone setHidden:FALSE];
    if (searchFiltery.text.length != 0) {
        isFiltered = TRUE;
    }
    else {
        isFiltered = FALSE;
    }
    [table reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchFiltert { 
    //NSLog(@"searchBarSearchButtonClicked");//More debugging
    if(searchFilter.text.length == 0)
    {
        isFiltered = FALSE;
    }
    else
    {
        //NSLog(@"Searched: %@", [NSString stringWithFormat:searchFilter.text]);
        isFiltered = true;
        NSUInteger countWhile = 0;
        while (coursesForSearch.count > countWhile) {
            NSString *classCode = [[coursesForSearch objectAtIndex:countWhile] objectAtIndex:0];
            NSRange codeRange = [classCode rangeOfString:searchFilter.text options:NSCaseInsensitiveSearch];
            //NSRange nameRange = [[[coursesForSearch objectAtIndex:countWhile] objectAtIndex:1] rangeOfString:searchFilter.text options:NSCaseInsensitiveSearch];
            //if(codeRange.location != NSNotFound || nameRange.location != NSNotFound)
            if(codeRange.location != NSNotFound)
            {
                //[filteredCourses addObject:[coursesForSearch objectAtIndex:countWhile]];
            }
            countWhile += 1;
        }
    }
    [table reloadData];
    [btnDone setHidden:TRUE];
    [searchFilter resignFirstResponder];
}

//Filter function for search

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if(searchText.length == 0)
    {
        isFiltered = FALSE;
        coursesForSearch = courses;
    }
    else
    {
        filteredCourses = [[NSMutableArray alloc] init];
        isFiltered = true;
        NSUInteger countWhile = 0;
        while (coursesForSearch.count > countWhile) {
            NSString *classCode = [[coursesForSearch objectAtIndex:countWhile] objectAtIndex:0];
            NSRange codeRange = [classCode rangeOfString:searchText options:NSCaseInsensitiveSearch];
            //NSRange nameRange = [[[coursesForSearch objectAtIndex:countWhile] objectAtIndex:1] rangeOfString:searchFilter.text options:NSCaseInsensitiveSearch];
            //if(codeRange.location != NSNotFound || nameRange.location != NSNotFound)
            if(codeRange.location != NSNotFound)
            {
                [filteredCourses addObject:[coursesForSearch objectAtIndex:countWhile]];
            }
            countWhile += 1;
        }
    }
    [table reloadData];
}

#pragma mark - Life Cycle

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    searchFilter.delegate = (id)self;
    coursesForSearch = [[NSMutableArray alloc] init];
    [ActivityIndicator startAnimating];
    highlightedCourses = nil;
    highlightedCourses = [[NSMutableArray alloc] init];
}

- (void)viewDidUnload
{
    [self setBtnDone:nil];
    [self setActivityIndicator:nil];
    [self setBtnCancel:nil];
    [self setBtnOK:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
