//
//  tableViewController.m
//  scheduleTable
//
//  Created by Ice on 2011-10-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TableView.h"
#import <QuartzCore/QuartzCore.h>
#import "Cell.h"
#import "MainViewController.h"


@implementation TableView

//@synthesize Course;
//@synthesize handler;
@synthesize schedule = _schedule;

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [super setDelegate:self];
    [super setDataSource:self];
    return self;
}

/*
- (id)initWithStyle:(UITableViewStyle)style showCourse:(NSString *)course
{
    self = [super initWithFrame:[self superview].frame style:style];
    //self = [super initWithStyle:style];
    if (self) {
        self.Course = course;
        handler = [[DataHandler alloc] init];
        handler.delegate = self;
        if (Course == nil) {
            [handler fetchEntries];
        }
        else {
            [handler fetchEntriesForCourse:Course];
        }
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}
 */

- (void) setSchedule:(NSMutableArray *)schedule {
    _schedule = schedule;
    [self reloadData];
}
//    Post *post = [handler getPostMinutesFromNow:30];
//    NSString *textString = [NSString stringWithFormat:@"%@ %@ %@", [post dateAsString], [post startTimeAsString], [post Premises]];
//    
//    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Next class" message:textString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [av show];
//    [av autorelease];
//}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
////#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_schedule) {
        NSLog(@"Schedule count: %i", [_schedule count]);
        return [_schedule count];
    }
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    static NSString *CellIdentifier = @"Cell";
    
    //Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //if (cell == nil) {
//     Cell* cell = [[[Cell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
//        
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    //}
    
    
    
//    for (UIView *view in cell.contentView.subviews) {
//        [view removeFromSuperview];
//    }
    
//    [cell emptyPosts];
    
    NSUInteger row = [indexPath row];
    NSMutableArray *posts = [schedule objectAtIndex:row];
    
    
    //NSLog(@"Row: %i", row);
    
    //NSArray *splitString = [[[schedule objectAtIndex:row] componentsSeparatedByString:@","] retain];
    
    //NSString *textString = [NSString stringWithFormat:@"%@ %@ %@", [splitString objectAtIndex:0], [splitString objectAtIndex:1], [splitString objectAtIndex:6]];
    
//    NSString *textString = [NSString stringWithFormat:@"%@ %@ %@", [post dateAsString], [post startTimeAsString], [post Premises]];
    
    //NSString *subString = [NSString stringWithFormat:@"%@, %@", [[[splitString objectAtIndex:3] componentsSeparatedByString:@"."] objectAtIndex:0], [splitString objectAtIndex:7]];
    
//    NSString *subString = [NSString stringWithFormat:@"%@ %@", [post courseAsString], post.Element];
    
    //[splitString release];
    
    //NSLog(@"%@", okString);
    
//    UIColor *backColor = [UIColor colorWithRed:(32.0/255.0) green:(32.0/255.0) blue:(32.0/255.0) alpha:1.0];
//    if (row % 2 == 1)
//        backColor = [UIColor colorWithRed:(48.0/255.0) green:(48.0/255.0) blue:(48.0/255.0) alpha:1.0];
    //[cell.contentView setBackgroundColor:backColor];
    
//    [[cell textLabel] setText:textString];
//    [[cell textLabel] setTextColor:[UIColor orangeColor]];
//    [[cell textLabel] setBackgroundColor:backColor];
//    
//    [[cell detailTextLabel] setText:subString];
//    [[cell detailTextLabel] setTextColor:[UIColor whiteColor]];
//    [[cell detailTextLabel] setBackgroundColor:backColor];
    
    
//    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"DateHeader" owner:self options:nil];
//    DateHeader *header;
//    
//    header = (DateHeader *)[bundle objectAtIndex:0];
//        
//    
//    [header setDate:post.StartTime andEndTime:post.EndTime];
//    header.post = post;
       
    UILongPressGestureRecognizer *longPressRecognizer = 
    [[UILongPressGestureRecognizer alloc]
     initWithTarget:self 
     action:@selector(longPressDetected:)];
    longPressRecognizer.minimumPressDuration = 1;
    longPressRecognizer.numberOfTouchesRequired = 1;
    [cell.contentView addGestureRecognizer:longPressRecognizer];
    [longPressRecognizer release];
    
    
    for (Post *post in posts) {
        [cell addPost:post];
    }
    */
    
    Cell *cell = (Cell *)[_schedule objectAtIndex:[indexPath row]];
    
    //[cell setTag:row];
    cell.table = self;

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    UIColor *backColor = [UIColor colorWithRed:(32.0/255.0) green:(32.0/255.0) blue:(32.0/255.0) alpha:1.0];
//    if ([indexPath row] % 2 == 1)
//        backColor = [UIColor colorWithRed:(48.0/255.0) green:(48.0/255.0) blue:(48.0/255.0) alpha:1.0];
//    [cell.contentView setBackgroundColor:backColor];
//    
//    [[cell textLabel] setBackgroundColor:backColor];
//    
//    [[cell detailTextLabel] setBackgroundColor:backColor];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (((Cell *)[_schedule objectAtIndex:[indexPath row]]).showSubViews) {
        NSInteger numberOfPostsThisDay = [(Cell *)[_schedule objectAtIndex:[indexPath row]] numberOfPosts];
        return 37 + (75 * numberOfPostsThisDay);
    }
    else {
        return 37.0;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     
}
*/
@end
