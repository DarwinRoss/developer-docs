//
//  BSTabViewController.m
//  CayanPos
//
//  Created by CongLi on 2/3/17.
//  Copyright © 2017 CongLi. All rights reserved.
//

#import "BSTabViewController.h"
#import "JCAlertView.h"
#import "IanAlert.h"

@interface BSTabViewController ()

@end

@implementation BSTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showResult:(NSDictionary *)result{
    
    [IanAlert showLoading:@"Loading..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [IanAlert hideLoading];
        NSString *title = [result objectForKey:@"Status"];
        NSString *response = [result objectForKey:@"Result"];
        
        [JCAlertView showOneButtonWithTitle:title Message:response ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"OK" Click:^{
        }];
        
    });
    
    
}
@end
