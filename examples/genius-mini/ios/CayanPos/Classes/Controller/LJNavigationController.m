//
//  IWNavigationController.m
//  ItcastWeibo
//
//  Created by apple on 14-5-6.
//  Copyright (c) 2014 itcast. All rights reserved.
//

#import "LJNavigationController.h"
#import "AppDelegate.h"

@interface LJNavigationController ()

@end

@implementation LJNavigationController


+ (void)initialize
{
    [self setupNavBarTheme];
    
    [self setupBarButtonItemTheme];
}

+ (void)setupBarButtonItemTheme
{
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    UIFont *font = [UIFont systemFontOfSize:15.f];
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName : font,
                                     NSForegroundColorAttributeName :[UIColor whiteColor]
                                     };
    
    [item setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    [item setTitleTextAttributes:textAttributes forState:UIControlStateHighlighted];
    
    NSDictionary *disabletextAttributes = @{
                                            NSFontAttributeName : font,
                                            NSForegroundColorAttributeName :[UIColor lightGrayColor]
                                            };
    [item setTitleTextAttributes:disabletextAttributes forState:UIControlStateDisabled];
}


+ (void)setupNavBarTheme
{
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setTintColor:[UIColor whiteColor]];
    navBar.barTintColor=[UIColor colorWithRed:0.843 green:0.086 blue:0.055 alpha:0.6];
    
    UIFont *font = [UIFont systemFontOfSize:16.f];
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName : font,
                                     NSForegroundColorAttributeName :[UIColor whiteColor]
                                     };
    
    [navBar setTitleTextAttributes:textAttributes];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}


-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if(ApplicationDelegate.allowRotation){
        return UIInterfaceOrientationMaskLandscapeRight|UIInterfaceOrientationMaskLandscapeLeft;
    }
    return UIInterfaceOrientationMaskPortraitUpsideDown | UIInterfaceOrientationMaskPortrait;
}

@end
