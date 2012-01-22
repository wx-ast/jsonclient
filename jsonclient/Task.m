//
//  Task.m
//  jsonclient
//
//  Created by Alexandr P on 17.01.12.
//  Copyright (c) 2012 atyx.ru. All rights reserved.
//

#import "Task.h"

@implementation Task

@synthesize id;
@synthesize name;
@synthesize description;
@synthesize date;
@synthesize remote_id;

- (BOOL)isEqual:(Task *)otherTask {
    if (self.id == otherTask.id) {
        return YES;
    }
    return NO;
}

@end
