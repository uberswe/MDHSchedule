//
//  coreDataHandler.h
//  scheduleTable
//
//  Created by Ice on 2011-10-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"
#import "Course.h"
#import <CoreData/CoreData.h>


@interface CoreDataHandler : NSObject {
    
    //NSManagedObjectContext *context;
    
@private
    NSManagedObjectModel *model;
    NSManagedObjectContext *context;
    //NSMutableArray *allPosts;
    //NSMutableArray *allCourses;
}
//@property (strong, nonatomic) NSManagedObjectContext *context;

- (void) emptyEntity:(NSString *) entity;
- (NSMutableArray *) getAllPosts;
- (NSMutableArray *) getPostsForCourse:(NSString *)course;
- (NSMutableArray *) getAllCourses;
- (void) removeAllCourses;
- (void) removeAllSchedulePosts;
- (BOOL) saveChanges;
- (void) removePost:(Post *)p;
- (void) emptyCoreData;
- (Post *) createPost;
- (NSManagedObject *) createCourseWithCourseCode:(NSString *) courseCode;
- (void) removeCourseWithCourseCode:(NSManagedObjectID *) courseCode;
- (Post *) getPostAfterDate:(NSDate *)date;
- (NSMutableArray *) getPostsWithPredicate:(NSPredicate *)predicate;
- (void) createCoreData;

@end
