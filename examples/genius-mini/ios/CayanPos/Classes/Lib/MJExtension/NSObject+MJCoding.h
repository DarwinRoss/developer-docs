//
//  NSObject+MJCoding.h
//  MJExtension
//
//  Created by mj on 14-1-15.
//  Copyright (c) 2015 Tomtop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MJCoding)
- (void)decode:(NSCoder *)decoder;
- (void)encode:(NSCoder *)encoder;
@end

#define MJCodingImplementation \
- (id)initWithCoder:(NSCoder *)decoder \
{ \
if (self = [super init]) { \
[self decode:decoder]; \
} \
return self; \
} \
\
- (void)encodeWithCoder:(NSCoder *)encoder \
{ \
[self encode:encoder]; \
}