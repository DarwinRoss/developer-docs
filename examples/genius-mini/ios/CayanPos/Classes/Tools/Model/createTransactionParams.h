//
//  createTransactionParams.h
//  CayanPos
//
//  Created by CongLi on 28/6/16.
//  Copyright © 2016 CongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface createTransactionParams : NSObject

@property(copy,nonatomic)NSString *merchantName;

@property(copy,nonatomic)NSString *merchantSiteId;

@property(copy,nonatomic)NSString *merchantKey;

@property(strong,nonatomic)NSDictionary *request;
@end
