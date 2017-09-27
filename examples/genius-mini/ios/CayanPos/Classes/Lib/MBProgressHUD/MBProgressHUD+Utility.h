//
//  MBProgressHUD+Utility.h
//  WinWorld
//
//  Created by Cyril Hu on 14-6-7.
//  Copyright (c) 2014 WinWorld. All rights reserved.
//

#import "MBProgressHUD.h"

/** Display reminder
 only display one reminder at a time, when display a new one, the old one will be deleted automatically
 */
@interface MBProgressHUD (Utility)

/** Display text reminder, automatically disappear after 1.5s, text will be displayed on new line display if text is too long */
+ (void)showText:(NSString *)text;
+ (void)showText:(NSString *)text title:(NSString *)title;

/** Display UIActivityIndicatorView，will not automatically disappear, can call `hide`,` showText: `or` showImage: ` to hide, text will be displayed on new line display if text is too long */
+ (void)showLoading:(NSString *)text;
+ (void)showLoading:(NSString *)text title:(NSString *)title color:(UIColor *)color;
+ (void)showLoading:(NSString *)text title:(NSString *)title color:(UIColor *)color delay:(NSTimeInterval)delay;

/** Display circular progress bar, will not automatically disappear, can call `hide`,` showText: `or` showImage: ` to hide, text will be displayed on new line display if text is too long */
+ (void)showProgress:(NSString *)text;
+ (void)showProgress:(NSString *)text title:(NSString *)title;
+ (void)updateProgress:(float)progress;

/** Display the picture, the default size of 37 X 37,1.5s automatically disappear, text will be displayed on new line display if text is too long */
+ (void)showImage:(UIImage *)image text:(NSString *)text;
+ (void)showImage:(UIImage *)image text:(NSString *)text title:(NSString *)title;

/** Hide all reminders right away */
+ (void)hide;

@end
