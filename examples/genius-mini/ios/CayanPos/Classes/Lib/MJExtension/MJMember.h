//
//  MJMember.h
//  MJExtension
//
//  Created by mj on 14-1-15.
//  Copyright (c) 2015 Tomtop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/message.h>
#import "MJType.h"
#import "MJArgument.h"

@interface MJMember : NSObject
{
    __weak id _srcObject;
    Class _srcClass;
    NSString *_name;
}

@property (nonatomic, assign) Class srcClass;

@property (nonatomic, readonly, getter = isSrcClassFromFoundation) BOOL srcClassFromFoundation;

@property (nonatomic, weak, readonly) id srcObject;

@property (nonatomic, copy, readonly) NSString *name;

/**
 *  initialization
 *
 *  @param srcObject
 *
 *  @return object
 */
- (instancetype)initWithSrcObject:(id)srcObject;
@end
