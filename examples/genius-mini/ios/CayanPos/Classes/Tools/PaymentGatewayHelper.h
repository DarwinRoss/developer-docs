//
//  PaymentGatewayHelper.h
//  EMVProj
//
//  Created by CongLi on 16/6/16.
//  Copyright © 2016 CongLi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class createTransactionParams;

@interface PaymentGatewayHelper : NSObject

+(void)CreateTransaction:(createTransactionParams *)params success:(void (^)(NSString *result))success failure:(void (^)(NSError *error))failure;

@end
