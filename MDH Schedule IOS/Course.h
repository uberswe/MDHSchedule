//
//  Course.h
//  scheduleTable
//
//  Created by Lion User on 2011-10-27.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Post;

@interface Course : NSManagedObject

@property (nonatomic, retain) NSString * CourseCode;
@property (nonatomic, retain) NSString * CourseName;
@property (nonatomic, retain) NSSet *post;
@end

@interface Course (CoreDataGeneratedAccessors)

- (void)addPostObject:(Post *)value;
- (void)removePostObject:(Post *)value;
- (void)addPost:(NSSet *)values;
- (void)removePost:(NSSet *)values;

- (NSString *) CourseCodeAsString;

@end
