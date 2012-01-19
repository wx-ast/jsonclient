//
//  DataViewController.m
//  jsonclient
//
//  Created by Alexandr P on 17.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TasksViewController.h"
#import "Task.h"


@implementation TasksViewController

@synthesize tasks;

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
        taskDetailsViewController.task = [self.tasks objectAtIndex: selectedIndexPath.row];
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
        NSInteger id = [self addTask:task];
        task.id = id;
        [self.tasks addObject:task];
    } else {
        [self updateTask:task];
        [self.tasks replaceObjectAtIndex:position withObject:task];
    }
    [self.tableView reloadData];
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createDb
{
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        char *errMsg;
        const char *sql_stmt = 
        "CREATE TABLE IF NOT EXISTS task (id integer PRIMARY KEY, name varchar(200), description text, start_date datetime, finish_date datetime NULL)";
        
        if (sqlite3_exec(contactDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            NSLog(@"Failed to create table");
        } else {
            NSLog(@"Db created");
        }
        sqlite3_close(contactDB);
    } else {
        NSLog(@"Failed to open/create database");
    }
}

- (void) loadTasks
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT id, name, description, start_date FROM task LIMIT 20"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                Task *task = [[Task alloc] init];
                
                task.id = sqlite3_column_int(statement, 0);
                task.name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                task.description = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                NSString *date = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                task.date = [dateFormatter dateFromString: date];
                [self.tasks addObject:task];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

- (NSInteger) addTask:(Task *)task
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString *querySQL = [NSString stringWithFormat: @"insert into task (name, description, start_date) VALUES('?', '?', '?')"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        { 
            sqlite3_bind_text(statement, 1, [task.name UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [task.description UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [[dateFormatter stringFromDate:task.date] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(statement);
            sqlite3_finalize(statement);
            return sqlite3_last_insert_rowid(contactDB);
        } else {
            NSLog(@"error sqlite3_prepare_v2");
        }
        sqlite3_close(contactDB);
    } else {
        NSLog(@"cant open db");
    }
    
    return 0;
}

- (void) deleteTask:(Task *)task
{
    NSLog(@"delete task: %i", task.id);
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"DELETE FROM task WHERE id='?'"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        { 
            sqlite3_bind_int(statement, 1, task.id);
            sqlite3_step(statement);
            sqlite3_finalize(statement);
        } else {
            NSLog(@"error sqlite3_prepare_v2");
        }
        sqlite3_close(contactDB);
    } else {
        NSLog(@"cant open db");
    }
}

- (void) updateTask:(Task *)task
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString *querySQL = [NSString stringWithFormat: @"UPDATE task set name='?', description='?', start_date='?' WHERE id='?'"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        { 
            sqlite3_bind_text(statement, 1, [task.name UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [task.description UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [[dateFormatter stringFromDate:task.date] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(statement, 4, task.id);
            sqlite3_step(statement);
            sqlite3_finalize(statement);
        } else {
            NSLog(@"error sqlite3_prepare_v2");
        }
        sqlite3_close(contactDB);
    } else {
        NSLog(@"cant open db");
    }
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    tasks = [NSMutableArray arrayWithCapacity:20];
    
    /**
     *  Create sqlite database
     */
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"lite.sqlite"]];
    NSLog(@"%@", databasePath);
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        [self createDb];
    } else {
        NSLog(@"Db file exists");
    }
    [self loadTasks];
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
    return [self.tasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:@"TaskCell"];
	Task *task = [self.tasks objectAtIndex:indexPath.row];
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
        [self deleteTask:[self.tasks objectAtIndex:indexPath.row]];
        [self.tasks removeObjectAtIndex:indexPath.row];
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
    Task *task = [self.tasks objectAtIndex:fromIndexPath.row];
    [self.tasks removeObjectAtIndex:fromIndexPath.row];
    [self.tasks insertObject:task atIndex:toIndexPath.row];
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
