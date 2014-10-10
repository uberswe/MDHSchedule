//
//  scheduleTableAppDelegate.m
//  scheduleTable
//
//  Created by Ice on 2011-10-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "scheduleTableAppDelegate.h"
#import "MainViewController.h"

@implementation scheduleTableAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    MainViewController *mainController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    
    [self.window setRootViewController:mainController];
    
//    UITabBarItem *item0 = [[UITabBarItem alloc] initWithTitle:@"All courses" image:nil tag:0];
//    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"DVA213" image:nil tag:1];
    
    
//    TableView *tableAll = [[TableView alloc] initWithStyle:UITableViewStylePlain showCourse:nil];
//    tableAll.backgroundColor = [UIColor colorWithRed:(32.0/255.0) green:(32.0/255.0) blue:(32.0/255.0) alpha:1.0];
    
    //[tables addObject:tableAll];
    
        
    
    /*
    NSMutableArray *tabbars = [[NSMutableArray alloc] init];
    int i = 0;
    for (NSManagedObject *course in courses) {
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:[course valueForKey:@"CourseCode"] image:nil tag:i++];
        [tabbars addObject:item];
        TableView *table1 = [[TableView alloc] initWithStyle:UITableViewStylePlain showCourse:[course valueForKey:@"CourseCode"]];
        
        table1.backgroundColor = [UIColor colorWithRed:(32.0/255.0) green:(32.0/255.0) blue:(32.0/255.0) alpha:1.0];
        [tables addObject:table1];
    }
    */
    
//    mainController.tableViews = tables;
    //[tabbar setViewControllers:[NSArray arrayWithObjects:tControllerAll, tController, nil] animated:NO];
    
    //[mainController.contentView addSubview:tabbar.view];
    
    //[self.window setRootViewController:tController];
    //[self.window setRootViewController:tabbar];
    
    
    
    [self.window makeKeyAndVisible];
     
     
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


@end
