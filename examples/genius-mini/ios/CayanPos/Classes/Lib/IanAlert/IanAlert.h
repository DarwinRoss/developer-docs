//
//  IanAlert.h
//  SVProgressHUD
//  loading popup
//  Created by ian on 14/11/27.
//
//

#import <Foundation/Foundation.h>

@interface IanAlert : NSObject

// popup UIAlertView title content YesButton NoButton
+(void)confirmWithTitle:(NSString *)title message:(NSString *)message yes:(NSString *)yes actionYes:(void(^)(void))actionYes andno:(NSString *)no actionNo:(void(^)(void))actionNo;

// popup UIAlertView title content
+(void)alertWithTitle:(NSString *)title message:(NSString *)message;
// popup UIAlertView title content YesButton
+(void)alertWithTitle:(NSString *)title message:(NSString *)message yes:(NSString *)yes confirm:(void(^)())confirm;

// popup error alert
+(void)alertError:(NSString *)string;
// popup error alert(dismiss time interval)
+(void)alertError:(NSString *)string length:(NSTimeInterval)length;

// popup success alert
+(void)alertSuccess:(NSString *)string;
// popup succes alert(dismiss time interval)
+(void)alertSuccess:(NSString *)string length:(NSTimeInterval)length;

// popup loading animation
+(void)showloading;
// popup loading animation(is clickable by user or not)
+(void)showloadingAllowUserInteraction:(BOOL)allowUserInteraction;

// popup loading animation and message
+(void)showLoading:(NSString *)string;
// popup loading animation and message(is clickable by user or not)
+(void)showLoading:(NSString *)string allowUserInteraction:(BOOL)allowUserInteraction;

// popup loading
+(void)hideLoading;
// popup loading and send message after completion
+(void)hideLoading:(void(^)(BOOL finished))completion;

@end
