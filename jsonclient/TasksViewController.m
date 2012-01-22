//
//  DataViewController.m
//  jsonclient
//
//  Created by Alexandr P on 17.01.12.
//  Copyright (c) 2012 atyx.ru. All rights reserved.
//

#import "TasksViewController.h"
#import "Task.h"
#import <Foundation/NSJSONSerialization.h>

@implementation TasksViewController

@synthesize taskStore;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        //
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"AddTask"])
	{
        NSLog(@"AddTask");
		UINavigationController *navigationController = 
        segue.destinationViewController;
		TaskDetailsViewController *taskDetailsViewController = [[navigationController viewControllers] objectAtIndex:0];
        taskDetailsViewController.task = [[Task alloc] init];
        taskDetailsViewController.task.date = [NSDate date];
        taskDetailsViewController.position = -1;
		taskDetailsViewController.delegate = self;
	} else if ([segue.identifier isEqualToString:@"DetailTask"])
    {
        UINavigationController *navigationController = 
        segue.destinationViewController;
		TaskDetailsViewController *taskDetailsViewController = [[navigationController viewControllers] objectAtIndex:0];
        NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
        
        NSLog(@"DetailTask: %i", selectedIndexPath.row);
        taskDetailsViewController.task = [self.taskStore.tasks objectAtIndex: selectedIndexPath.row];
        taskDetailsViewController.position = selectedIndexPath.row;
		taskDetailsViewController.delegate = self;
    }
}

- (void)taskDetailsViewControllerDidCancel:
(TaskDetailsViewController *)controller
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)taskDetailsViewController:(TaskDetailsViewController *)controller didAddTask:(Task *)task position:(int) position
{
    NSLog(@"position before save: %i", position);
    if (position < 0) {
        [self.taskStore addTask:task];
    } else {
        [self.taskStore updateTask:task];
        [self.taskStore.tasks replaceObjectAtIndex:position withObject:task];
    }
    [self.tableView reloadData];
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)refresh {
    NSURL *url = [NSURL URLWithString:@"http://jsonapi.atyx.ru/changes/"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTag:1];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSInteger status = [request responseStatusCode];
    if (status == 200) {
        switch ([request tag]) {
            case 1: {
                NSLog(@"get changes");
                NSError *error = nil;
                NSData *responseData = [request responseData];
                
                NSDictionary *jsonDict = [NSJSONSerialization
                                          JSONObjectWithData:responseData
                                          options:NSJSONReadingMutableLeaves
                                          error:&error];
                NSMutableArray *newEls = [[NSMutableArray alloc] init];
                for (NSDictionary *el in jsonDict) {
                    Task *task = [[Task alloc] init];
                    [task setName:[el valueForKey:@"name"]];
                    [task setDescription:[el valueForKey:@"description"]];
                    [task setDate:[self.taskStore dateFromString:[el valueForKey:@"start_date"]]];
                    [task setRemote_id:[[el valueForKey:@"id"] integerValue]];
                    [self.taskStore addTask:task];
                    [newEls addObject:task];
                }
                for (Task *task in newEls) {
                    NSLog(@"%i", task.remote_id);
                }
                [self.tableView reloadData];
                
                break;
            }
            default:
                break;
        }
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"HTTP wrong status!"
                                                          message:[NSString stringWithFormat:@"status: %i", status]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
    }
    
    // Use when fetching binary data
//    NSData *responseData = [request responseData];
    
    [self performSelector:@selector(stopLoading) withObject:nil];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", error);
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"HTTP loading error!"
                                                      message:[NSString stringWithFormat:@"%@", [error localizedDescription]]
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
    
    [self performSelector:@selector(stopLoading) withObject:nil];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.taskStore = [[TaskStore alloc] init:@"db.sqlite"];
    [self.taskStore loadTasks];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.taskStore.tasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:@"TaskCell"];
	Task *task = [self.taskStore.tasks objectAtIndex:indexPath.row];
	cell.textLabel.text = task.name;
	cell.detailTextLabel.text = task.description;
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.taskStore deleteTask:[self.taskStore.tasks objectAtIndex:indexPath.row]];
        [self.taskStore.tasks removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    if (fromIndexPath.row == toIndexPath.row) {
        return;
    }
    Task *task = [self.taskStore.tasks objectAtIndex:fromIndexPath.row];
    [self.taskStore.tasks removeObjectAtIndex:fromIndexPath.row];
    [self.taskStore.tasks insertObject:task atIndex:toIndexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - TaskDetailsViewControllerDelegate


@end
