//
//  DataViewController.h
//  jsonclient
//
//  Created by Alexandr P on 17.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskDetailsViewController.h"

@interface TasksViewController : UITableViewController <TaskDetailsViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *tasks;

@end
