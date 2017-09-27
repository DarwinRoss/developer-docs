//
//  NSObject+MJMember.m
//  MJExtension
//
//  Created by mj on 14-1-15.
//  Copyright (c) 2015 Tomtop. All rights reserved.
//

#import "NSObject+MJMember.h"


@implementation NSObject (MJMember)

- (void)enumerateIvarsWithBlock:(MJIvarsBlock)block
{
    [self enumerateClassesWithBlock:^(__unsafe_unretained Class c, BOOL *stop) {
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList(c, &outCount);
        
        for (int i = 0; i<outCount; i++) {
            MJIvar *ivar = [[MJIvar alloc] initWithIvar:ivars[i] srcObject:self];
            ivar.srcClass = c;
            block(ivar, stop);
        }
        
        free(ivars);
    }];
}

- (void)enumerateMethodsWithBlock:(MJMethodsBlock)block
{
    [self enumerateClassesWithBlock:^(__unsafe_unretained Class c, BOOL *stop) {
        unsigned int outCount = 0;
        Method *methods = class_copyMethodList(c, &outCount);
        
        for (int i = 0; i<outCount; i++) {
            MJMethod *method = [[MJMethod alloc] initWithMethod:methods[i] srcObject:self];
            method.srcClass = c;
            block(method, stop);
        }
        
        free(methods);
    }];
}

- (void)enumerateClassesWithBlock:(MJClassesBlock)block
{
    if (block == nil) return;
    
    BOOL stop = NO;
    
    Class c = [self class];
    
    while (c && !stop) {
        block(c, &stop);
        
        c = class_getSuperclass(c);
    }
}
@end
