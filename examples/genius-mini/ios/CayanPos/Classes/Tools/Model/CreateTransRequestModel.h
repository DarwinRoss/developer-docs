//
//  CreateTransRequestModel.h
//  CayanPos
//
//  Created by CongLi on 28/6/16.
//  Copyright © 2016 CongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreateTransRequestModel : NSObject

/*
 <TransactionType>SALE</TransactionType>
 <Amount>1.23</Amount>
 <ClerkId>ABC123</ClerkId>
 <OrderNumber>ABC123</OrderNumber>
 <Dba>ZERO BRANDS</Dba>
 <SoftwareName>ABC SOFTWARE</SoftwareName>
 <SoftwareVersion>1.0.0.0</SoftwareVersion>
 <Cardholder>VISA TEST CARD</Cardholder>
 <TransactionId>ABC123</TransactionId>
 <ForceDuplicate>FALSE</ForceDuplicate>
 <CustomerCode>ABC123</CustomerCode>
 <PoNumber>ABC123</PoNumber>
 <TaxAmount>0.09</TaxAmount>
 <TerminalId>01</TerminalId>
 */

@property(copy,nonatomic)NSString *TransactionType;

@property(copy,nonatomic)NSString *Amount;

@property(copy,nonatomic)NSString *ClerkId;

@property(copy,nonatomic)NSString *OrderNumber;

@property(copy,nonatomic)NSString *Dba;

@property(copy,nonatomic)NSString *SoftwareName;

@property(copy,nonatomic)NSString *SoftwareVersion;

@property(copy,nonatomic)NSString *Cardholder;

@property(copy,nonatomic)NSString *TransactionId;

@property(copy,nonatomic)NSString *ForceDuplicate;

@property(copy,nonatomic)NSString *CustomerCode;

@property(copy,nonatomic)NSString *PoNumber;

@property(copy,nonatomic)NSString *TaxAmount;

@property(copy,nonatomic)NSString *TerminalId;

@property(strong,nonatomic)NSDictionary *HealthCareAmountDetails;

@end
