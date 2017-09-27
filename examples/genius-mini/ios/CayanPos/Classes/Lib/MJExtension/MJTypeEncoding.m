//
//  MJTypeEncoding.m
//  MJExtension
//
//  Created by mj on 14-1-15.
//  Copyright (c) 2015 Tomtop. All rights reserved.
//
/**
 *  Type (attribute type)
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NSString *const MJTypeInt = @"i";
NSString *const MJTypeFloat = @"f";
NSString *const MJTypeDouble = @"d";
NSString *const MJTypeLong = @"q";
NSString *const MJTypeLongLong = @"q";
NSString *const MJTypeChar = @"c";
NSString *const MJTypeBOOL = @"c";
NSString *const MJTypePointer = @"*";

NSString *const MJTypeIvar = @"^{objc_ivar=}";
NSString *const MJTypeMethod = @"^{objc_method=}";
NSString *const MJTypeBlock = @"@?";
NSString *const MJTypeClass = @"#";
NSString *const MJTypeSEL = @":";
NSString *const MJTypeId = @"@";

/**
 *  Return value type(If unsigned，capital letter)
 */
NSString *const MJReturnTypeVoid = @"v";
NSString *const MJReturnTypeObject = @"@";



