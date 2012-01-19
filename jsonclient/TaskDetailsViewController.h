//
//  TaskDetailsViewController.h
//  jsonclient
//
//  Created by Alexandr P on 17.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TaskDetailsViewController;

@class Task;

@protocol TaskDetailsViewControllerDelegate <NSObject>
- (void)taskDetailsViewControllerDidCancel:
(TaskDetailsViewController *)controller;
- (void)taskDetailsViewController:
(TaskDetailsViewController *)controller 
                       didAddTask:(Task *)task position: (int) position;
@end

@interface TaskDetailsViewController : UITableViewController
{
    Task *task;
    NSInteger position;
}

@property (nonatomic, retain) Task *task;
@property (assign, nonatomic) NSInteger position;

@property (nonatomic, weak) id <TaskDetailsViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (strong, nonatomic) IBOutlet UILabel *idLabel;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
