//
//  MJExtension.h
//  MJExtension
//
//  Created by mj on 14-1-15.
//  Copyright (c) 2015 年 Tomtop. All rights reserved.
//

#import "MJTypeEncoding.h"
#import "NSObject+MJCoding.h"
#import "NSObject+MJMember.h"
#import "NSObject+MJKeyValue.h"

#define MJLogAllIvrs \
- (NSString *)description \
{ \
    return [self keyValues].description; \
}
