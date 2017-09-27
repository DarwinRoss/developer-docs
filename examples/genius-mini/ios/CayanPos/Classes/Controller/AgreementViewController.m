//
//  AgreementViewController.m
//  CayanPos
//
//  Created by CongLi on 2/3/17.
//  Copyright © 2017 CongLi. All rights reserved.
//

#import "AgreementViewController.h"
#import "BSTextFieldCell.h"
#import "BSAmountTextFieldCell.h"
#import "BSTextViewCell.h"
#import "DDXMLDocument.h"
#import "MBProgressHUD+MJ.h"

@interface AgreementViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *table;

@end

@implementation AgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HJColor(0xebebf0);
    
    self.title = @"Get Agreement";
    
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
    if(section ==0 ){
        return 4;
    }else if(section ==1 ){
        return 1;
    }else{
        return 1;
    }
    
}


- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==0){
        return 44;
    }else if(indexPath.section ==1){
        return 100;
    }else if(indexPath.section ==2){
        return 44;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==0){
        if(indexPath.row == 0){
            BSTextFieldCell *cell = [[BSTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.placeHold = @"Input";
            cell.title = @"RequestID";
            cell.titleLabel.textColor = HJColor(0x505050);
            return cell;
            
        }else if(indexPath.row ==1){
            BSTextFieldCell *cell = [[BSTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.placeHold = @"Input";
            cell.title = @"Title";
            cell.titleLabel.textColor = HJColor(0x505050);
            return cell;
            
        }else if(indexPath.row ==2){
            BSTextFieldCell *cell = [[BSTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.placeHold = @"Input";
            cell.title = @"Accept Label";
            cell.titleLabel.textColor = HJColor(0x505050);
            return cell;
            
        }else if(indexPath.row ==3){
            BSTextFieldCell *cell = [[BSTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.placeHold = @"Input";
            cell.title = @"Decline Label";
            cell.titleLabel.textColor = HJColor(0x505050);
            return cell;
            
        }
    }else if(indexPath.section ==1){
        BSTextViewCell *cell = [[BSTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.placeHold = @"Agreement Text";
        cell.title = @"Text";
        cell.titleLabel.textColor = HJColor(0x505050);
        return cell;
        
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
        NSIndexPath *row1 = [NSIndexPath indexPathForRow:1 inSection:0];
        NSIndexPath *row2 = [NSIndexPath indexPathForRow:2 inSection:0];
        NSIndexPath *row3 = [NSIndexPath indexPathForRow:3 inSection:0];
        NSIndexPath *row4 = [NSIndexPath indexPathForRow:0 inSection:1];
        
        BSTextFieldCell *cell =(BSTextFieldCell *) [tableView cellForRowAtIndexPath:row];
        NSString *requestID = cell.textField.text;
        
        BSTextFieldCell *cell1 =(BSTextFieldCell *) [tableView cellForRowAtIndexPath:row1];
        NSString *title = cell1.textField.text;
        
        BSTextFieldCell *cell2 =(BSTextFieldCell *) [tableView cellForRowAtIndexPath:row2];
        NSString *acceptLabel = cell2.textField.text;

        
        BSTextFieldCell *cell3 =(BSTextFieldCell *) [tableView cellForRowAtIndexPath:row3];
        NSString *declineLabel = cell3.textField.text;
        
        BSTextViewCell *cell4 =(BSTextViewCell *) [tableView cellForRowAtIndexPath:row4];
        NSString *agreementText = cell4.textField.text;

        
        if(requestID == nil || [requestID isEqualToString:@""]){
            [MBProgressHUD showError:@"RequestID can't be empty"];
            return;
        }
        
        if(title == nil || [title isEqualToString:@""]){
            [MBProgressHUD showError:@"Title can't be empty"];
            return;
        }
        
        if(acceptLabel == nil || [acceptLabel isEqualToString:@""]){
            [MBProgressHUD showError:@"AcceptLabel can't be empty"];
            return;
        }
        
        if(declineLabel == nil || [declineLabel isEqualToString:@""]){
            [MBProgressHUD showError:@"DeclineLabel can't be empty"];
            return;
        }
        
        if(agreementText == nil || [agreementText isEqualToString:@""]){
            [MBProgressHUD showError:@"AgreementText can't be empty"];
            return;
        }
        
        NSDictionary *requestParams = @{
                                        @"Action" :@"GetAgreement",
                                        @"Format":@"XML",
                                        @"CallbackURL":@"POSAPP",
                                        @"RequestID":requestID,
                                        @"Title":title,
                                        @"AgreementText":agreementText,
                                        @"AcceptLabel":acceptLabel,
                                        @"DeclineLabel":declineLabel
                                        };
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestParams
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        NSString *requestStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSString *requestEncodedString = [requestStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"Genius://v2/pos/?request=%@",requestEncodedString]]];
        
    }
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

@end
