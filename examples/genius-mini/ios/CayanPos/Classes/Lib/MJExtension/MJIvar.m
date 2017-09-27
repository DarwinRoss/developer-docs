//
//  MJIvar.m
//  MJExtension
//
//  Created by mj on 14-1-15.
//  Copyright (c) 2015 Tomtop. All rights reserved.
//

#import "MJIvar.h"
#import "MJTypeEncoding.h"

@implementation MJIvar
/**
 *  initialization
 *
 *  @param ivar      Member variables
 *  @param srcObject Member variables of object
 *
 *  @return object
 */
- (instancetype)initWithIvar:(Ivar)ivar srcObject:(id)srcObject
{
    if (self = [super initWithSrcObject:srcObject]) {
        self.ivar = ivar;
    }
    return self;
}


- (void)setIvar:(Ivar)ivar
{
    _ivar = ivar;
    
    _name = [NSString stringWithUTF8String:ivar_getName(ivar)];
    
    if ([_name hasPrefix:@"_"]) {
        _propertyName = [_name stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    } else {
        _propertyName = _name;
    }
    
    NSString *code = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
//    NSLog(@"---%@-%@---", _name, code);
    _type = [[MJType alloc] initWithCode:code];
}

- (id)value
{
    if (_type.KVCDisabled) return [NSNull null];
    return [_srcObject valueForKey:_propertyName];
}

- (void)setValue:(id)value
{
    if (_type.KVCDisabled) return;
    [_srcObject setValue:value forKey:_propertyName];
}

@end
