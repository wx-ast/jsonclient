//
//  DataViewController.h
//  jsonclient
//
//  Created by Alexandr P on 17.01.12.
//  Copyright (c) 2012 atyx.ru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskDetailsViewController.h"
#import <sqlite3.h>
#import "Task.h"
#import "PullRefreshTableViewController.h"
#import "TaskStore.h"
#import "ASIHTTPRequest.h"

@interface TasksViewController : PullRefreshTableViewController <TaskDetailsViewControllerDelegate>
{
    TaskStore *taskStore;
}

@property (nonatomic, strong) TaskStore *taskStore;

- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;

@end
