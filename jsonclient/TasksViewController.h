//
//  DataViewController.h
//  jsonclient
//
//  Created by Alexandr P on 17.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskDetailsViewController.h"
#import <sqlite3.h>
#import "Task.h"

@interface TasksViewController : UITableViewController <TaskDetailsViewControllerDelegate>
{
    NSString *databasePath;
    sqlite3 *contactDB;
}

@property (nonatomic, strong) NSMutableArray *tasks;

- (void)createDb;
- (void) loadTasks;
- (NSInteger) addTask:(Task *)task;
- (void) deleteTask:(Task *)task;
- (void) updateTask:(Task *)task;

@end
