//
//  coreDataHandler.m
//  scheduleTable
//
//  Created by Ice on 2011-10-20.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CoreDataHandler.h"


@implementation CoreDataHandler;

- (id) init {
    
    self = [super init];
    
    model = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    NSString *path = pathInDocumentDirectory(@"store.data");
    NSURL *storeUrl = [NSURL fileURLWithPath:path];
    NSLog(@"%@", path);
    NSError *error = nil;
    
    if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
    }
    
    context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:psc];
    
    [context setUndoManager:nil];

    return self;
}


- (void) createCoreData {
    
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    NSString *path = pathInDocumentDirectory(@"store.data");
    NSURL *storeUrl = [NSURL fileURLWithPath:path];
    
    NSError *error = nil;
    
    if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
    }
    context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:psc];
    
}

- (NSMutableArray *) getAllPosts {
    return [self getPostsWithPredicate:nil];
}

- (NSMutableArray *) getPostsForCourse:(NSString *)course {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Course like %@", course]; 
    
    return [self getPostsWithPredicate:predicate];
}

- (NSMutableArray *) getAllCourses {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [[model entitiesByName] objectForKey:@"Course"];
    [request setEntity:entity];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"CourseCode" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch failed" format:@"Error: %@", [error localizedDescription]];
    }
    
    return [NSMutableArray arrayWithArray:result];
}

- (void) removeAllSchedulePosts {
    [self emptyEntity:@"Post"];
}

- (void) removeAllCourses {
    [self emptyEntity:@"Course"];

}

- (void) emptyEntity:(NSString *) entity {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:entity inManagedObjectContext:context];
    [fetchRequest setEntity:entityDesc];
    
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
        [context deleteObject:managedObject];
    }
    if (![context save:&error]) {
        NSLog(@"Error deleting %@ - error:%@",entityDesc,error);
    }

}

- (void)removePost:(Post *)p {
    [context deleteObject:p];
    [self saveChanges];
    //[allPosts removeObjectIdenticalTo:p];
}

- (void) emptyCoreData {
    NSPersistentStore *store = [[[context persistentStoreCoordinator] persistentStores] objectAtIndex:0];
    NSError *error = nil;
    NSURL *storeUrl = store.URL;
    [[context persistentStoreCoordinator] removePersistentStore:store error:&error];
    [[NSFileManager defaultManager] removeItemAtURL:storeUrl error:&error];
    
    [self createCoreData];
}

- (BOOL) saveChanges {
    NSError *err = nil;
    BOOL successful = [context save:&err];
    if (!successful) {
        NSLog(@"Error saving: %@", [err localizedDescription]);
    }
    return successful;
}

- (Post *) createPost {
    Post *post = [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:context];
    [self saveChanges];
    return post;
}

- (NSManagedObject *) createCourseWithCourseCode:(NSString *) courseCode {
    NSManagedObject *course = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:context];
    [course setValue:courseCode forKey:@"CourseCode"];
    [self saveChanges];
    return course;}

- (void) removeCourseWithCourseCode:(NSManagedObjectID *) courseCode {
    [context deleteObject:[context existingObjectWithID:courseCode error:nil]];
    NSLog(@"Removed Course");
    [self saveChanges];
}


- (Post *) getPostAfterDate:(NSDate *) date {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"StartTime > %@", date];
    return [[self getPostsWithPredicate:predicate] objectAtIndex:0];
}

- (NSMutableArray *) getPostsWithPredicate:(NSPredicate *) predicate {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [[model entitiesByName] objectForKey:@"Post"];
    [request setEntity:entity];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"StartTime" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch failed" format:@"Error: %@", [error localizedDescription]];
    }
    
    //NSString *course = [(Post *)[result objectAtIndex:0] Course];
    
    //return [[NSMutableArray alloc] initWithArray:result];
    return [[NSMutableArray alloc] initWithArray:result];

}

@end
