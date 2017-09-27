//
//  MJType.h
//  MJExtension
//
//  Created by mj on 14-1-15.
//  Copyright (c) 2015 Tomtop. All rights reserved.
//  

#import <Foundation/Foundation.h>
@interface MJType : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, assign, readonly) Class typeClass;

@property (nonatomic, readonly, getter = isFromFoundation) BOOL fromFoundation;

@property (nonatomic, readonly, getter = isKVCDisabled) BOOL KVCDisabled;

- (instancetype)initWithCode:(NSString *)code;
@end