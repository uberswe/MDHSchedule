//
//  dataHandler.m
//  scheduleTable
//
//  Created by Ice on 2011-10-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "dataHandler.h"
#import "Cell.h"
#import "CellBody.h"
#import "DateHeader.h"

@implementation DataHandler

@synthesize scheduleDelegate;
@synthesize coursesDelegate;

- (id) init {
    
    self = [super init];
    server = [[ServerHandler alloc] init];
    [server setDelegate:self];
    
    coreData = [[CoreDataHandler alloc] init];
    
    //[coreData emptyCoreData];
    
    return self;
}

#pragma mark - Get Data

- (NSMutableArray *) fetchCoreData {
    return [self createCellsFromPosts:[coreData getAllPosts]];
}

- (void) fetchEntries {
    allPosts = [self fetchCoreData];
    
    if ([allPosts count] == 0) {
        [self fetchNetworkEntries];
    }
    else {
        [self alertDelegateSchedule];
    }
}

- (NSMutableArray *) fetchEntriesForCourse:(NSString *)Course {
    if (Course) {
        if ([Course isEqualToString:@"NoCourses"]) {
            NSMutableArray *temp = [[NSMutableArray alloc] init];
            return temp;
        }
        if ([Course isEqualToString:@"nil"]) {
            NSMutableArray *temp = [[NSMutableArray alloc] init];
            return temp;
        }
        else {
        return [self createCellsFromPosts:[coreData getPostsForCourse:Course]];
        
        // Course = @"DVA213.44000"
        }
    }
    else {
        return [self fetchCoreData];
    }
}

- (NSMutableArray *) fetchCourses {
    return [coreData getAllCourses];
}

- (NSString *)stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement {
    return target;
}

- (void) fetchNetworkEntries {
    NSMutableArray *courses = [self fetchCourses];
    NSMutableString *urlString = [NSMutableString stringWithString:@"http://schema.grupp12.se/?getSchedule="];
    
    for (Course *course in courses) {
        course.CourseCode = [[course CourseCode] stringByReplacingOccurrencesOfString:@"Å" withString:@"%C5"];
        course.CourseCode = [[course CourseCode] stringByReplacingOccurrencesOfString:@"Ä" withString:@"%C4"];
        course.CourseCode = [[course CourseCode] stringByReplacingOccurrencesOfString:@"Ö" withString:@"%C3%96"];
        [urlString appendFormat:@"k.%@,", [course CourseCode]];
        NSLog(@"k.%@,", [course CourseCode]);
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    //@"http://schema.grupp12.se/?kurs=CDT224.44073&kurs=DVA205.44012&kurs=DVA213.44000"];
    
    [server fetchEntries:url];
    
}

- (void) fetchNetworkCourses {
    NSURL *url = [NSURL URLWithString:@"http://schema.grupp3.se/?getCourses=-"];
    [server fetchEntries:url];
}

- (Post *) getPostMinutesFromNow:(NSInteger)minutes {
    
    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:(minutes * 60)];
    
    Post *post = [coreData getPostAfterDate:now];
    
    return post;
}

#pragma mark - Edit Data
- (NSManagedObject *) addCourse:(NSString *)courseCode {
    NSManagedObject *newCourse = [coreData createCourseWithCourseCode:courseCode];
    return newCourse;
}

- (void) removeCourse:(NSManagedObjectID *)courseCode {
    [coreData removeCourseWithCourseCode:courseCode];
}

- (void) removeAllCourses {
    [coreData removeAllCourses];
}

- (void) removeAllSchedulePosts {
    [coreData removeAllSchedulePosts];
}

- (NSMutableArray *) createCellsFromPosts:(NSMutableArray *)posts {
    NSMutableArray *cells = nil;
    if ([posts count] != 0)
    {	
        NSString *cellIdentifier = [NSString stringWithFormat:@"expandableListCell"];
        cells = [[NSMutableArray alloc] init];
        //[cells addObject:[[Cell alloc] init]];
        
        NSDate *lastDate = nil;//[(Post *)[posts objectAtIndex:0] StartTime];
        NSInteger lastWeekNumber = -1;
        
        for (Post *post in posts) {
            if ([DataHandler isSameDay:post.StartTime otherDay:lastDate]) {
                [(Cell *)[cells lastObject] addPost:post];
            }
            else {
                Cell* cell = [[Cell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [cell addPost:post];
                [cells addObject:cell];
                
                NSInteger week = [post weekNumber];
                cell.showWeekNumber = (week != lastWeekNumber);
                lastWeekNumber = week;
                
                lastDate = post.StartTime;
            }
        }
    }
    return cells;
}

- (void) createPostsFromStringArray:(NSArray *)stringArray {
    
    //NSString *date = nil;
    
    /*
     NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@",(?=([^\"]*\"[^\"]*\")*(?![^\"]*\"))" options:NSRegularExpressionCaseInsensitive error:&error];
     */
    
    
    for (NSString *string in stringArray) {
        
        NSMutableArray *fields = (NSMutableArray *)[string componentsSeparatedByString:@","];
        
        //if ([(NSString *)[fields objectAtIndex:DATE] length] != 0) {
        //    date = [fields objectAtIndex:DATE];
        //}
        //else
        //    [fields replaceObjectAtIndex:DATE withObject:date];
        
        if (fields.count >= 9) {
            Post *post = [coreData createPost];        
            [post setDataFromServerStringArray:fields];
        }
    }
    
    
    [coreData saveChanges];
    
}

#pragma mark - Else

- (void) alertDelegateSchedule {
    SEL updateMethod = @selector(dataHandlerHasLoadedScheduleData:);
    
    if ([self.scheduleDelegate respondsToSelector:updateMethod]) {
        [self.scheduleDelegate dataHandlerHasLoadedScheduleData:allPosts];
    }
}

- (void) alertDelegateCourses:(NSArray *)courses {
    SEL updateMethod = @selector(dataHandlerHasLoadedCourseData:);
    
    if ([self.coursesDelegate respondsToSelector:updateMethod]) {
        [self.coursesDelegate dataHandlerHasLoadedCourseData:courses];
    }
}

- (void) serverHandlerHasLoadedScheduleData:(NSArray *)scheduleData {
    NSLog(@"serverHasLoadedData");
    
    if ([(NSString *)[scheduleData objectAtIndex:0] hasPrefix:@"BokningsId_"]) {
        [coreData removeAllSchedulePosts];
        
        [self createPostsFromStringArray:scheduleData];
    
        [self fetchCoreData];
        [self alertDelegateSchedule];
    }
    else {
        NSMutableArray *courses = [[NSMutableArray alloc] init];
        
        for (NSString *string in scheduleData) {
            [courses addObject:[string componentsSeparatedByString:@","]];
        }
        
        [self alertDelegateCourses:courses];
    }
    
}

- (NSMutableArray *) orderPostsByDate:(NSMutableArray *)inArray {
    NSMutableArray *outArray = nil;
    if ([inArray count] != 0)
    {	
        outArray = [[NSMutableArray alloc] init];
        [outArray addObject:[[NSMutableArray alloc] init]];
        
        NSDate *lastDate = [(Post *)[inArray objectAtIndex:0] StartTime];
        
        for (Post *post in inArray) {
            if ([DataHandler isSameDay:post.StartTime otherDay:lastDate]) {
                [[outArray lastObject] addObject:post];
            }
            else {
                [outArray addObject:[[NSMutableArray alloc] init]];
                [[outArray lastObject] addObject:post];
                lastDate = post.StartTime;
            }
        }
    }
    return outArray;
}

+ (BOOL)isSameDay:(NSDate*)date1 otherDay:(NSDate*)date2 {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}


@end
