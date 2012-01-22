//
//  Task.h
//  jsonclient
//
//  Created by Alexandr P on 17.01.12.
//  Copyright (c) 2012 atyx.ru. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, assign) NSInteger remote_id;

- (BOOL)isEqual:(Task *)otherTask;

@end
