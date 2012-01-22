//
//  TaskStore.h
//  jsonclient
//
//  Created by Alexandr P on 20.01.12.
//  Copyright (c) 2012 atyx.ru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"
#import <sqlite3.h>

@interface TaskStore : NSObject
{
    NSMutableArray *tasks;
    NSString *databasePath;
    sqlite3 *contactDB;
    
    NSDateFormatter *dateFormatter;
}

@property (nonatomic, strong) NSMutableArray *tasks;

-(NSObject *)init:(NSString *)dbName;
- (void)createDb;
- (void) loadTasks;
- (NSInteger) addTask:(Task *)task;
- (void) deleteTask:(Task *)task;
- (void) updateTask:(Task *)task;
- (NSDate *) dateFromString:(NSString *)date;

@end
