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
@synthesize position;

@synthesize descriptionTextField;
@synthesize idLabel;
@synthesize datePicker;
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
    self.task.date = [self.datePicker date];
	[self.delegate taskDetailsViewController:self   
                                  didAddTask:self.task position:position];
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
    [self setIdLabel:nil];
    [self setDatePicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    if (self.task.id > 0) {
        [[self.tableView cellForRowAtIndexPath:indexPath] setHidden:NO];
    } else {
        [[self.tableView cellForRowAtIndexPath:indexPath] setHidden:YES];
    }
    [self.idLabel setText:[NSString stringWithFormat:@"id: %i", self.task.id]];
    [self.nameTextField setText: self.task.name];
    [self.descriptionTextField setText: self.task.description];
    [self.datePicker setDate:self.task.date animated:NO];
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
