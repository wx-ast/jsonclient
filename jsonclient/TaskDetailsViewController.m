//
//  TaskDetailsViewController.m
//  jsonclient
//
//  Created by Alexandr P on 17.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TaskDetailsViewController.h"
#import "Task.h"

@implementation TaskDetailsViewController

@synthesize task;

@synthesize descriptionTextField;
@synthesize delegate;
@synthesize nameTextField;

- (IBAction)cancel:(id)sender
{
	[self.delegate taskDetailsViewControllerDidCancel:self];
}
- (IBAction)done:(id)sender
{
    
	self.task.name = self.nameTextField.text;
	self.task.description= self.descriptionTextField.text;
	[self.delegate taskDetailsViewController:self   
                                  didAddTask:self.task];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setNameTextField:nil];
    [self setDescriptionTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.nameTextField setText: self.task.name];
    [self.descriptionTextField setText: self.task.description];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
		[self.nameTextField becomeFirstResponder];
    } else if (indexPath.section == 1) {
        [self.descriptionTextField becomeFirstResponder];
    }
}

@end
