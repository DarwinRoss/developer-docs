//
//  AppDelegate.h
//  CayanPos
//
//  Created by CongLi on 28/6/16.
//  Copyright © 2016 CongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) BOOL allowRotation;

@end

