//
//  AppDelegate.m
//  jsonclient
//
//  Created by Alexandr P on 17.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "Task.h"
#import "TasksViewController.h"

@implementation AppDelegate {
    NSMutableArray *tasks;
}

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    tasks = [NSMutableArray arrayWithCapacity:20];
	Task *task = [[Task alloc] init];
	task.name = @"task 1";
	task.description = @"description of task 1";
	[tasks addObject:task];
    task = [[Task alloc] init];
    task.name = @"task 2";
	task.description = @"description of task 2";
	[tasks addObject:task];
    task = [[Task alloc] init];
    task.name = @"task 3";
	task.description = @"description of task 3";
	[tasks addObject:task];
    task = [[Task alloc] init];
    task.name = @"task 4";
	task.description = @"description of task 4";
	[tasks addObject:task];
    
	UITabBarController *tabBarController = 
    (UITabBarController *)self.window.rootViewController;
	UINavigationController *navigationController = 
    [[tabBarController viewControllers] objectAtIndex:0];
	TasksViewController *tasksViewController = 
    [[navigationController viewControllers] objectAtIndex:0];
	tasksViewController.tasks = tasks;
    
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
     Use this method to release shared resources, save user data, invalidate timers, and e enough application state information to ree your application to its current state in case it is terminated later. 
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
