//
//  MJMethod.m
//  MJExtension
//
//  Created by mj on 14-1-15.
//  Copyright (c) 2015 Tomtop. All rights reserved.
//

#import "MJMethod.h"

@implementation MJMethod
- (instancetype)initWithMethod:(Method)method srcObject:(id)srcObject
{
    if (self = [super initWithSrcObject:srcObject]) {
        self.method = method;
    }
    return self;
}

/**
 *  set method
 */
- (void)setMethod:(Method)method
{
    _method = method;
    
    // 1.method selector
    _selector = method_getName(method);
    _name = NSStringFromSelector(_selector);
    
    // 2.parameter
    int step = 2; // Skip the previous two parameters
    int argsCount = method_getNumberOfArguments(method);
    NSMutableArray *args = [NSMutableArray arrayWithCapacity:argsCount - step];
    for (int i = step; i<argsCount; i++) {
        MJArgument *arg = [[MJArgument alloc] init];
        arg.index = i - step;
        char *argCode = method_copyArgumentType(method, i);
        arg.type = [NSString stringWithUTF8String:argCode];
        free(argCode);
        [args addObject:arg];
    }
    _arguments = args;
    
    // 3.Return value type
    char *returnCode = method_copyReturnType(method);
    _returnType = [NSString stringWithUTF8String:returnCode];
    free(returnCode);
}
@end
