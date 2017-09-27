//
//  NSObject+MJKeyValue.h
//  MJExtension
//
//  Created by mj on 13-8-24.
//  Copyright (c) 2013 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol MJKeyValue <NSObject>
@optional
- (NSDictionary *)replacedKeyFromPropertyName;

- (NSDictionary *)objectClassInArray;
@end

@interface NSObject (MJKeyValue) <MJKeyValue>

- (void)setKeyValues:(NSDictionary *)keyValues;


- (NSDictionary *)keyValues;


+ (NSArray *)keyValuesArrayWithObjectArray:(NSArray *)objectArray;

#pragma mark

+ (instancetype)objectWithKeyValues:(NSDictionary *)keyValues;

+ (instancetype)objectWithFilename:(NSString *)filename;

+ (instancetype)objectWithFile:(NSString *)file;

#pragma mark

+ (NSArray *)objectArrayWithKeyValuesArray:(NSArray *)keyValuesArray;

+ (NSArray *)objectArrayWithFilename:(NSString *)filename;

+ (NSArray *)objectArrayWithFile:(NSString *)file;
@end
