//
//  dataHandler.h
//  scheduleTable
//
//  Created by Ice on 2011-10-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerHandler.h"
#import "Post.h"
#import "CoreDataHandler.h"

@protocol DataHandlerDelegate <NSObject>

@optional

- (void) dataHandlerHasLoadedScheduleData:(NSArray *)scheduleData;
- (void) dataHandlerHasLoadedCourseData:(NSArray *)courseData;
- (void) dataHandlerReturnedError:(NSError *) error;

@end


@interface DataHandler : NSObject <ServerHandlerDelegate>{
    
@private
    ServerHandler *server;
    CoreDataHandler *coreData;
    NSMutableArray *allPosts;
    NSMutableArray *allCourses;
}


@property (unsafe_unretained, nonatomic) id scheduleDelegate;
@property (unsafe_unretained, nonatomic) id coursesDelegate;

- (void) fetchEntries;
- (NSMutableArray *) fetchEntriesForCourse:(NSString *)Course;
- (void) fetchNetworkEntries;
- (void) fetchNetworkCourses;
- (NSMutableArray *) fetchCourses;
- (NSManagedObject *) addCourse:(NSString *) courseCode;
- (void) removeCourse:(NSManagedObjectID *) courseCode;
- (void) removeAllCourses;
- (void) removeAllSchedulePosts;
- (void) createPostsFromStringArray:(NSArray *)stringArray;
- (NSMutableArray *) fetchCoreData;
- (void) alertDelegateSchedule;
- (void) alertDelegateCourses:(NSArray *) courses;
- (Post *) getPostMinutesFromNow:(NSInteger)minutes;
- (NSMutableArray *) orderPostsByDate:(NSMutableArray *)inArray;
- (NSMutableArray *) createCellsFromPosts:(NSMutableArray *)posts;
+ (BOOL)isSameDay:(NSDate*)date1 otherDay:(NSDate*)date2;

@end
