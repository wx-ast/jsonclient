//
//  TaskStore.m
//  jsonclient
//
//  Created by Alexandr P on 20.01.12.
//  Copyright (c) 2012 atyx.ru. All rights reserved.
//

#import "TaskStore.h"

@implementation TaskStore

@synthesize tasks;

- (NSObject *)init:(NSString *)dbName
{
    if (self = [super init]) {
        
        NSString *docsDir;
        NSArray *dirPaths;
        
        // Get the documents directory
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        docsDir = [dirPaths objectAtIndex:0];
        
        // Build the path to the database file
        databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: dbName]];
        NSLog(@"%@", databasePath);
        
        NSFileManager *filemgr = [NSFileManager defaultManager];
        
        if ([filemgr fileExistsAtPath: databasePath ] == NO)
        {
            [self createDb];
        } else {
            NSLog(@"Db file exists");
        }
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        self.tasks = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

- (void)createDb
{
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        char *errMsg;
        const char *sql_stmt = 
        "CREATE TABLE IF NOT EXISTS task (id integer PRIMARY KEY AUTOINCREMENT, name varchar(200), description text, start_date datetime, finish_date datetime NULL, update_date datetime NULL, change_date datetime, delete_flag integer, remote_id integer UNIQUE)";
        
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
    [self.tasks removeAllObjects];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT id, name, description, start_date, remote_id FROM task LIMIT 20"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                Task *task = [[Task alloc] init];
                
                task.id = sqlite3_column_int(statement, 0);
                task.name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                task.description = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                NSString *date = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                task.date = [dateFormatter dateFromString: date];
                task.remote_id = sqlite3_column_int(statement, 4);
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
        NSString *querySQL = [NSString stringWithFormat: @"insert into task (name, description, start_date, remote_id) VALUES(?, ?, ?, ?)"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        { 
            sqlite3_bind_text(statement, 1, [task.name UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [task.description UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [[dateFormatter stringFromDate:task.date] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(statement, 4, task.remote_id);
            sqlite3_step(statement);
            sqlite3_finalize(statement);
            NSInteger ret = sqlite3_last_insert_rowid(contactDB);
            if (ret > 0) {
                task.id = ret;
                [self.tasks addObject:task];
            }
            return ret;
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
        NSString *querySQL = [NSString stringWithFormat: @"DELETE FROM task WHERE id=?"];
        
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
        NSString *querySQL = [NSString stringWithFormat: @"UPDATE task set name=?, description=?, start_date=? WHERE id=?"];
        
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

- (NSDate *) dateFromString:(NSString *)date
{
    return [dateFormatter dateFromString:date];
}


@end
