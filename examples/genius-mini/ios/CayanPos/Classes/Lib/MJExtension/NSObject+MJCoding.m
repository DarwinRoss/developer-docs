//
//  NSObject+MJCoding.m
//  MJExtension
//
//  Created by mj on 14-1-15.
//  Copyright (c) 2015 Tomtop. All rights reserved.
//

#import "NSObject+MJCoding.h"
#import "NSObject+MJMember.h"

@implementation NSObject (MJCoding)
- (void)encode:(NSCoder *)encoder
{
    [self enumerateIvarsWithBlock:^(MJIvar *ivar, BOOL *stop) {
        if (ivar.isSrcClassFromFoundation) return;
        [encoder encodeObject:ivar.value forKey:ivar.name];
    }];
}

- (void)decode:(NSCoder *)decoder
{
    [self enumerateIvarsWithBlock:^(MJIvar *ivar, BOOL *stop) {
        if (ivar.isSrcClassFromFoundation) return;
        ivar.value = [decoder decodeObjectForKey:ivar.name];
    }];
}
@end
