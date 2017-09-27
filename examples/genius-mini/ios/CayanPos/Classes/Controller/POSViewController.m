//
//  POSViewController.m
//  CayanPos
//
//  Created by CongLi on 1/3/17.
//  Copyright © 2017 CongLi. All rights reserved.
//

#import "POSViewController.h"
#import "BSTextFieldCell.h"
#import "BSAmountTextFieldCell.h"
#import "IanAlert.h"
#import "createTransactionParams.h"
#import "CreateTransRequestModel.h"
#import "healthCareAmountDetailsModel.h"
#import "MJExtension.h"
#import "PaymentGatewayHelper.h"
#import "MBProgressHUD+MJ.h"
#import "DDXMLDocument.h"
#import "XWMoneyTextField.h"

@interface POSViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *table;


@end

@implementation POSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HJColor(0xebebf0);
    
    self.title = @"POS Emulator";
    
    [self.view addSubview:self.table];
}

- (UITableView *)table{
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height) style: UITableViewStyleGrouped];
        _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _table.delegate = self;
        _table.dataSource = self;
    }
    return _table;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section ==1 ){
        return 2;
    }
    return 1;
}


- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section ==1){
        return 30;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==0){
        return 100;
    }else if(indexPath.section ==1){
        return 44;
    }else if(indexPath.section ==2){
        return 44;
    }
    return 44;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section ==1 ){
        return @"Keyed entry";
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==0){
        BSAmountTextFieldCell *cell = [[BSAmountTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.placeHold = @"Input Amount";
        cell.title = @"Amount";
        cell.text = @"0.60";
        cell.titleLabel.textColor = HJColor        (0x505050);
        return cell;
    }else if(indexPath.section ==1){
        if(indexPath.row ==0){
            UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = @"No Gift";
            cell.textLabel.textColor = HJColor(0x0b60fe);
            return cell;
        }else if(indexPath.row ==1){
            UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = @"With Gift";
            cell.textLabel.textColor = HJColor(0x0b60fe);
            return cell;
        }

        
        
    }else if(indexPath.section ==2){
        UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"Send";
        cell.textLabel.textColor = HJColor(0x0b60fe);
        return cell;

    }
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(indexPath.section == 2){
        //charge
        NSIndexPath *row = [NSIndexPath indexPathForRow:0 inSection:0];
        BSAmountTextFieldCell *cell =(BSAmountTextFieldCell *) [tableView cellForRowAtIndexPath:row];
        if(cell.textField.text == nil || [cell.textField.text isEqualToString:@""]){
            [MBProgressHUD showError:@"Amount can't be zero"];
            return;
        }
        double totalPrice = [cell.textField.text doubleValue];
        if(totalPrice == 0.0){
            [MBProgressHUD showError:@"Amount can't be zero"];
            return;
        }
        [self charge:totalPrice];
    }else if(indexPath.section ==1){
        if(indexPath.row==0){
            //keyed entry
            [self KeyedEntry:NO];
        }else{
            //keyed entry
            [self KeyedEntry:YES];
        }
        
    }
}

-(void)KeyedEntry:(BOOL )isGift{
    NSDictionary *requestParams = @{
                                    @"Action" :@"InitiateKeyedEntry",
                                    @"Format":@"XML",
                                    @"CallbackURL":@"POSAPP",
                                    @"PaymentType":isGift?@"GIFT":@""
                                    };
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestParams
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString *requestStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *requestEncodedString = [requestStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"Genius://v2/pos/?request=%@",requestEncodedString]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

-(void)charge:(double)totalPrice{
    
    [IanAlert showLoading:@"Loading..."];
    
    createTransactionParams *params=[[createTransactionParams alloc]init];
    
    NSUserDefaults *userDefault =  [NSUserDefaults standardUserDefaults];
    
    params.merchantKey=[userDefault objectForKey:@"KKey"];
    params.merchantName=[userDefault objectForKey:@"KName"];
    params.merchantSiteId=[userDefault objectForKey:@"KSiteID"];
    
    CreateTransRequestModel *requestModel=[[CreateTransRequestModel alloc]init];
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
    requestModel.TransactionType=@"SALE";//@"_REFUND";
    requestModel.Amount=[NSString stringWithFormat:@"%.2f",totalPrice];
    requestModel.ClerkId=@"user1";
    requestModel.OrderNumber=@"12341231";
    requestModel.Dba=@"POS Demo";
    requestModel.SoftwareName=@"POS SOFTWARE";
    requestModel.SoftwareVersion=@"1.0.0.0";
    requestModel.Cardholder=@"";
    requestModel.TransactionId=@"";
    requestModel.ForceDuplicate=@"true";
    requestModel.CustomerCode=@"ABC1234";
    requestModel.PoNumber=@"ABC1234";
    requestModel.TaxAmount=@"0";
    requestModel.TerminalId=@"01";
    
    healthCareAmountDetailsModel *detailModel=[[healthCareAmountDetailsModel alloc]init];
    /*
     <HealthCareAmountDetails>
     <HealthCareTotalAmount>1.23</HealthCareTotalAmount>
     <ClinicalAmount>0.23</ClinicalAmount>
     <CopayAmount>0.25</CopayAmount>
     <DentalAmount>0.25</DentalAmount>
     <PrescriptionAmount>0.25</PrescriptionAmount>
     <VisionAmount>0.25</VisionAmount>
     </HealthCareAmountDetails>
     */
    detailModel.HealthCareTotalAmount=@"0";
    detailModel.ClinicalAmount=@"0";
    detailModel.CopayAmount=@"0";
    detailModel.DentalAmount=@"0";
    detailModel.PrescriptionAmount=@"0";
    detailModel.VisionAmount=@"0";
    
    requestModel.HealthCareAmountDetails=detailModel.keyValues;
    params.request=requestModel.keyValues;
    
    
    [PaymentGatewayHelper CreateTransaction:params success:^(NSString *result) {
        [IanAlert hideLoading];
        NSLog(@"result = %@",result);
        NSDictionary *dic = [self parsedDataFromString:result andNodeForXpath:@"//TransportKey"];
        
        NSDictionary *requestParams = @{
                                        @"Transportkey" :[dic objectForKey:@"TransportKey"],
                                        @"Format":@"XML",
                                        @"CallbackURL":@"POSAPP"
                                        };
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestParams
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        NSString *requestStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSString *requestEncodedString = [requestStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"Genius://v2/pos/?request=%@",requestEncodedString]]];
        
        
        
    } failure:^(NSError *error) {
        [IanAlert hideLoading];
        NSLog(@"error = %@",error);
    }];
    
}

-(NSDictionary *)parsedDataFromString:(NSString *)xmlStr andNodeForXpath:(NSString *)xpath{
    //hack to remove xmlns => avoid xpath search not works
    xmlStr = [xmlStr stringByReplacingOccurrencesOfString:@"xmlns" withString:@"noNSxml"];
    NSMutableDictionary* contents = [NSMutableDictionary dictionary];
    
    NSError* error = nil;
    DDXMLDocument* xmlDoc = [[DDXMLDocument alloc] initWithXMLString:xmlStr options:0 error:&error];
    
    if (error) {
        NSLog(@"%@",[error localizedDescription]);
        return contents;
    }
    
    NSArray* resultNodes = nil;
    
    resultNodes = [xmlDoc nodesForXPath:xpath error:&error];
    if (error) {
        NSLog(@"%@",[error localizedDescription]);
        return contents;
    }
    
    for(DDXMLElement* resultElement in resultNodes)
    {
        NSString* name = [resultElement name];
        //audio , text or other media type
        NSString* fileName = resultElement.stringValue;
        // 0.txt
        [contents setObject:fileName forKey:name];
    }
    return contents;
}

@end
