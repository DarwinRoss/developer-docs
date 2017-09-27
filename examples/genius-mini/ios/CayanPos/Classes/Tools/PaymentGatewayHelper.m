//
//  PaymentGatewayHelper.m
//  EMVProj
//
//  Created by CongLi on 16/6/16.
//  Copyright © 2016 CongLi. All rights reserved.
//

#import "PaymentGatewayHelper.h"
#import "soaputility.h"
#import "createTransactionParams.h"
#import "MJExtension.h"
#import "SoapService.h"

@implementation PaymentGatewayHelper

+(void)CreateTransaction:(createTransactionParams *)params success:(void (^)(NSString *result))success failure:(void (^)(NSError *error))failure{
    
    
    NSString *methodName=@"CreateTransaction";  //webservice name
    SoapUtility *soaputility=[[SoapUtility alloc] initFromFile:@"CayanTransactionsWebservices"];
    NSString *postData=[soaputility BuildSoapwithMethodName:methodName withParas:params.keyValues];
    
    SoapService *soaprequest=[[SoapService alloc] init];
    soaprequest.PostUrl=webServiceUrl;
    soaprequest.SoapAction=[soaputility GetSoapActionByMethodName:methodName SoapType:SOAP];
    
    [soaprequest PostAsync:postData Success:^(NSString *response) {
        NSLog(@"%@",response);
        if (success) {
            success(response);
        }
    } falure:^(NSError *error) {
        NSLog(@"error %@",error);
        if (failure) {
            failure(error);
        }
    }];

}


@end
