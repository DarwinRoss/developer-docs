//
//  NSObject+MJMember.h
//  MJExtension
//
//  Created by mj on 14-1-15.
//  Copyright (c) 2015 Tomtop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJIvar.h"
#import "MJMethod.h"

typedef void (^MJClassesBlock)(Class c, BOOL *stop);

@interface NSObject (MJMember)


- (void)enumerateIvarsWithBlock:(MJIvarsBlock)block;


- (void)enumerateMethodsWithBlock:(MJMethodsBlock)block;


- (void)enumerateClassesWithBlock:(MJClassesBlock)block;
@end
