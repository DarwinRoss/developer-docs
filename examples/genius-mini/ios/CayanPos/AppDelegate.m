//
//  AppDelegate.m
//  CayanPos
//
//  Created by CongLi on 28/6/16.
//  Copyright © 2016 CongLi. All rights reserved.
//

#import "AppDelegate.h"
#import "LJNavigationController.h"
#import "POSViewController.h"
#import "SignatureViewController.h"
#import "AgreementViewController.h"
#import "SettingViewController.h"
#import "BSTabViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    BSTabViewController *tb=[[BSTabViewController alloc]init];
    self.window.rootViewController=tb;
    
    POSViewController *c1=[[POSViewController alloc]init];
    c1.view.backgroundColor=[UIColor whiteColor];
    c1.title = @"POS Emulator";
    c1.tabBarItem.title=@"POS Emulator";
    c1.tabBarItem.image=[UIImage imageNamed:@"ic-pos-on"];
    
    SignatureViewController *c2=[[SignatureViewController alloc]init];
    c2.view.backgroundColor=[UIColor whiteColor];
    c2.tabBarItem.title=@"Signature";
    c2.title = @"Signature";
    c2.tabBarItem.image=[UIImage imageNamed:@"ic-sign-on"];
    
    AgreementViewController *c3=[[AgreementViewController alloc]init];
    c3.view.backgroundColor = [UIColor whiteColor];
    c3.tabBarItem.title=@"Get Agreement";
    c3.title = @"Get Agreement";
    c3.tabBarItem.image=[UIImage imageNamed:@"ic-agreement-on"];
    
    SettingViewController *c4=[[SettingViewController alloc]init];
    c4.tabBarItem.title=@"Settings";
    c4.title = @"Settings";
    c4.tabBarItem.image=[UIImage imageNamed:@"ic-settings-on"];

    LJNavigationController *nav1 = [[LJNavigationController alloc]initWithRootViewController:c1];
    LJNavigationController *nav2 = [[LJNavigationController alloc]initWithRootViewController:c2];
    LJNavigationController *nav3 = [[LJNavigationController alloc]initWithRootViewController:c3];
    LJNavigationController *nav4 = [[LJNavigationController alloc]initWithRootViewController:c4];
    tb.viewControllers=@[nav1,nav2,nav3,nav4];
    
    //init merchant name,siteID, key
    
    NSUserDefaults *userDefault =  [NSUserDefaults standardUserDefaults];
    if([userDefault objectForKey:@"KName"] == nil || [[userDefault objectForKey:@"KName"] isEqualToString:@""]){
        [userDefault setObject:@"TEST MERCHANT DBA" forKey:@"KName"];
        [userDefault synchronize];
    }
    if([userDefault objectForKey:@"KSiteID"] == nil || [[userDefault objectForKey:@"KSiteID"] isEqualToString:@""]){
        [userDefault setObject:@"TEST SITE ID" forKey:@"KSiteID"];
        [userDefault synchronize];
    }
    if([userDefault objectForKey:@"KKey"] == nil || [[userDefault objectForKey:@"KKey"] isEqualToString:@""]){
        [userDefault setObject:@"TEST API KEY" forKey:@"KKey"];
        [userDefault synchronize];
    }
    
    
    [self.window makeKeyAndVisible];
    return YES;
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    if (!url) {
        return NO;
    }
    
    // Unencode the URL's query string
    NSString *queryString = [[url query] stringByRemovingPercentEncoding];
    
    // Extract the JSON string from the query string
    queryString = [queryString stringByReplacingOccurrencesOfString:@"response=" withString:@""];
    
    // Convert the JSON string to an NSData object for serialization
    NSData *queryData = [queryString dataUsingEncoding:NSUTF8StringEncoding];
    
    // Serialize the JSON data into a dictionary
    NSDictionary* jsonObject = [NSJSONSerialization JSONObjectWithData:queryData options:0 error:nil];
    
    BSTabViewController *tabVc =((BSTabViewController *)self.window.rootViewController);
    [tabVc showResult:jsonObject];
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end
