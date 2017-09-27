//
//  MBProgressHUD+MJ.m
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013 itcast. All rights reserved.
//

#import "MBProgressHUD+MJ.h"

@implementation MBProgressHUD (MJ)

#pragma mark show message
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view fonColor:(UIColor *)fontColor
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // show message
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    
    hud.lblText.textColor=fontColor;
    // set image
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    // set mode
    hud.mode = MBProgressHUDModeCustomView;
    
    // remove from super view when hide
    hud.removeFromSuperViewOnHide = YES;
    
    // hide after 2 sec
    [hud hide:YES afterDelay:2];
}

#pragma mark show error message
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"badge_circle_fail.png" view:view fonColor:[UIColor colorWithRed:0.886 green:0.227 blue:0.243 alpha:1.000]];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"badge_circle_success.png" view:view fonColor:[UIColor colorWithRed:0.251 green:0.643 blue:0.247 alpha:1.000]];
}

+ (void)showInfo:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"badge_circle_warning" view:view fonColor:[UIColor blackColor]];
}

#pragma mark show image when loading

+ (void)showGIFOnView:(UIView *)view
{
}


#pragma mark show message
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // show message
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // remove from super view when hide
    hud.removeFromSuperViewOnHide = YES;
    // YES: dim background; no: no dim background
    hud.dimBackground = NO;
    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (void)showInfo:(NSString *)info
{
    [self showInfo:info toView:nil];
}

/**
 * show gif
 */

+(void)showGIF
{
    [self showGIFOnView:nil];
}

///**
// * show gif
// */
//
//+(void)showGIF:(UIView *)view
//{
//    [self showGIFOnView:view];
//}

/**
 * show message
 */

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
    
}

+ (void)hideHUDGIFForView:(UIView *)view
{
    if (view ==nil) view=[[UIApplication sharedApplication].windows lastObject];
    for (UIView *tempView in [view subviews]) {
        /*
         if ([tempView isKindOfClass:[YFGIFImageView class]]) {
         [((YFGIFImageView *)tempView) stopGIF];
         [tempView removeFromSuperview];
         [view removeFromSuperview];
         }*/
        if (tempView.tag == 1000000){
            [tempView removeFromSuperview];
        }
    }
    
}
/**
 * hide gif
 */
+ (void)hideHUDGIF
{
    [self performSelector:@selector(hideHUDGIFForView:) withObject:nil afterDelay:0.1f];
}

+ (void)hideHUDForView:(UIView *)view
{
    [self hideHUDForView:view animated:YES];
}

/**
 * hide rotating image
 */

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}


@end
