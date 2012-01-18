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

@interface TasksViewController : UITableViewController <TaskDetailsViewControllerDelegate>
{
    NSString *databasePath;
    sqlite3 *contactDB;
}

@property (nonatomic, strong) NSMutableArray *tasks;

- (void) addTask:(NSString *) name description:(NSString *) description;

@end
