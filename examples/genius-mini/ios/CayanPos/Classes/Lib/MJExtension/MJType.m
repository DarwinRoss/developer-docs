//
//  MJType.m
//  MJExtension
//
//  Created by mj on 14-1-15.
//  Copyright (c) 2015 Tomtop. All rights reserved.
//

#import "MJType.h"
#import "MJExtension.h"

@implementation MJType

- (instancetype)initWithCode:(NSString *)code
{
    if (self = [super init]) {
        self.code = code;
    }
    return self;
}

- (void)setCode:(NSString *)code
{
    _code = code;
    
    if (_code.length == 0 || [_code isEqualToString:MJTypeSEL] ||
        [_code isEqualToString:MJTypeIvar] ||
        [_code isEqualToString:MJTypeMethod]) {
        _KVCDisabled = YES;
    } else if ([_code hasPrefix:@"@"] && _code.length > 3) {
        _code = [_code substringFromIndex:2];
        _code = [_code substringToIndex:_code.length - 1];
        _typeClass = NSClassFromString(_code);
        
        _fromFoundation = [_code hasPrefix:@"NS"];
    }
}

MJLogAllIvrs
@end
