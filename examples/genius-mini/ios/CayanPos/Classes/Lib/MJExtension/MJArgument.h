//
//  MJArgument.h
//  com.tomtop.cn
//
//  Created by mj on 14-1-15.
//  Copyright (c) 2015 Tomtop. All rights reserved.
//  

#import <Foundation/Foundation.h>

@interface MJArgument : NSObject
/** Parameter index */
@property (nonatomic, assign) int index;
/** Parameter type */
@property (nonatomic, copy) NSString *type;
@end
