//
//  MJIvar.h
//  MJExtension
//
//  Created by mj on 14-1-15.
//  Copyright (c) 2015 Tomtop. All rights reserved.
// 

#import "MJMember.h"
@class MJType;


@interface MJIvar : MJMember
@property (nonatomic, assign) Ivar ivar;
@property (nonatomic, copy, readonly) NSString *propertyName;
@property (nonatomic) id value;
@property (nonatomic, strong, readonly) MJType *type;

/**
 *  initialization
 *
 *  @param ivar      Member variables
 *  @param srcObject Member variables of object
 *
 *  @return object
 */
- (instancetype)initWithIvar:(Ivar)ivar srcObject:(id)srcObject;
@end

/**
 *
 *  @param ivar Member variables
 *  @param stop       YES: stop, NO: continue
 */
typedef void (^MJIvarsBlock)(MJIvar *ivar, BOOL *stop);