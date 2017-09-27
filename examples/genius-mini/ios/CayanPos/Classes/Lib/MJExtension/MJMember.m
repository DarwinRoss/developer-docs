//
//  MJMember.m
//  MJExtension
//
//  Created by mj on 14-1-15.
//  Copyright (c) 2015 . All rights reserved.
//

#import "MJMember.h"
#import "MJExtension.h"

@implementation MJMember
- (instancetype)initWithSrcObject:(id)srcObject
{
    if (self = [super init]) {
        _srcObject = srcObject;
    }
    return self;
}

- (void)setSrcClass:(Class)srcClass
{
    _srcClass = srcClass;
    
    _srcClassFromFoundation = [NSStringFromClass(srcClass) hasPrefix:@"NS"];
}

MJLogAllIvrs
@end
