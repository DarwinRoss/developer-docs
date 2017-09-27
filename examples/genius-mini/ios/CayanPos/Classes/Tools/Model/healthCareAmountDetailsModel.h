//
//  healthCareAmountDetailsModel.h
//  CayanPos
//
//  Created by CongLi on 29/6/16.
//  Copyright © 2016 CongLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface healthCareAmountDetailsModel : NSObject


/*
 <HealthCareTotalAmount>1.23</HealthCareTotalAmount>
 <ClinicalAmount>0.23</ClinicalAmount>
 <CopayAmount>0.25</CopayAmount>
 <DentalAmount>0.25</DentalAmount>
 <PrescriptionAmount>0.25</PrescriptionAmount>
 <VisionAmount>0.25</VisionAmount>
 */

@property(copy,nonatomic)NSString *HealthCareTotalAmount;

@property(copy,nonatomic)NSString *ClinicalAmount;

@property(copy,nonatomic)NSString *CopayAmount;

@property(copy,nonatomic)NSString *DentalAmount;

@property(copy,nonatomic)NSString *PrescriptionAmount;

@property(copy,nonatomic)NSString *VisionAmount;

@end
