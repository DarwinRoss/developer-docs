//
//  NSObject+MJKeyValue.m
//  MJExtension
//
//  Created by mj on 13-8-24.
//  Copyright (c) 2013 itcast. All rights reserved.
//

#import "NSObject+MJKeyValue.h"
#import "NSObject+MJMember.h"

@implementation NSObject (MJKeyValue)

+ (instancetype)objectWithKeyValues:(NSDictionary *)keyValues
{
    if (![keyValues isKindOfClass:[NSDictionary class]]) {
        return nil;
        //[NSException raise:@"keyValues is not a NSDictionary" format:nil];
    }
    
    id model = [[self alloc] init];
    [model setKeyValues:keyValues];
    return model;
}

+ (instancetype)objectWithFilename:(NSString *)filename
{
    NSString *file = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    return [self objectWithFile:file];
}

+ (instancetype)objectWithFile:(NSString *)file
{
    NSDictionary *keyValues = [NSDictionary dictionaryWithContentsOfFile:file];
    return [self objectWithKeyValues:keyValues];
}

- (void)setKeyValues:(NSDictionary *)keyValues
{
    if (![keyValues isKindOfClass:[NSDictionary class]]) {
        [NSException raise:@"keyValues is not a NSDictionary" format:nil];
    }
    
    [self enumerateIvarsWithBlock:^(MJIvar *ivar, BOOL *stop) {
        if (ivar.isSrcClassFromFoundation) return;
        
        NSString *key = [self keyWithPropertyName:ivar.propertyName];
        id value = keyValues[key];
        if (!value) return;
        
        if (ivar.type.typeClass && !ivar.type.fromFoundation) {
            value = [ivar.type.typeClass objectWithKeyValues:value];
        } else if ([self respondsToSelector:@selector(objectClassInArray)]) {
            Class objectClass = self.objectClassInArray[ivar.propertyName];
            if (objectClass) {
                value = [objectClass objectArrayWithKeyValuesArray:value];
            }
        }
        
        ivar.value = value;
    }];
}

- (NSDictionary *)keyValues
{
    NSMutableDictionary *keyValues = [NSMutableDictionary dictionary];
    
    [self enumerateIvarsWithBlock:^(MJIvar *ivar, BOOL *stop) {
        if (ivar.isSrcClassFromFoundation) return;
        
        id value = ivar.value;
        if (!value) return;
        
        if (ivar.type.typeClass && !ivar.type.fromFoundation) {
            value = [value keyValues];
        } else if ([self respondsToSelector:@selector(objectClassInArray)]) {
            Class objectClass = self.objectClassInArray[ivar.propertyName];
            if (objectClass) {
                value = [objectClass keyValuesArrayWithObjectArray:value];
            }
        }
        
        NSString *key = [self keyWithPropertyName:ivar.propertyName];
        keyValues[key] = value;
    }];
    
    return keyValues;
}

+ (NSArray *)keyValuesArrayWithObjectArray:(NSArray *)objectArray
{
    if (![objectArray isKindOfClass:[NSArray class]]) {
//        [NSException raise:@"objectArray is not a NSArray" format:nil];
        NSLog(@"objectArray is not a NSArray");
        return nil;
    }
    
    if (![objectArray isKindOfClass:[NSArray class]]) return objectArray;
    if (![[objectArray lastObject] isKindOfClass:self]) return objectArray;

    NSMutableArray *keyValuesArray = [NSMutableArray array];
    for (id object in objectArray) {
        [keyValuesArray addObject:[object keyValues]];
    }
    return keyValuesArray;
}

+ (NSArray *)objectArrayWithKeyValuesArray:(NSArray *)keyValuesArray
{
    if (![keyValuesArray isKindOfClass:[NSArray class]]) {
//        [NSException raise:@"keyValuesArray is not a NSArray" format:nil];
        NSLog(@"objectArray is not a NSArray");
        return nil;
    }
    
    NSMutableArray *modelArray = [NSMutableArray array];
    
    for (NSDictionary *keyValues in keyValuesArray) {
        if (![keyValues isKindOfClass:[NSDictionary class]]) continue;
        
        id model = [self objectWithKeyValues:keyValues];
        [modelArray addObject:model];
    }
    
    return modelArray;
}

+ (NSArray *)objectArrayWithFilename:(NSString *)filename
{
    NSString *file = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    return [self objectArrayWithFile:file];
}

+ (NSArray *)objectArrayWithFile:(NSString *)file
{
    NSArray *keyValuesArray = [NSArray arrayWithContentsOfFile:file];
    return [self objectArrayWithKeyValuesArray:keyValuesArray];
}

- (NSString *)keyWithPropertyName:(NSString *)propertyName
{
    NSString *key = nil;
    if ([self respondsToSelector:@selector(replacedKeyFromPropertyName)]) {
        key = self.replacedKeyFromPropertyName[propertyName];
    }
    if (!key) key = propertyName;
    
    return key;
}
@end
