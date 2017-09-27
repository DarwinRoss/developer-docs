//
//  SignatureViewController.m
//  CayanPos
//
//  Created by CongLi on 2/3/17.
//  Copyright © 2017 CongLi. All rights reserved.
//

#import "SignatureViewController.h"
#import "BSTextFieldCell.h"
#import "MBProgressHUD+MJ.h"
#import "DDXMLDocument.h"

@interface SignatureViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *table;

@end

@implementation SignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = HJColor(0xebebf0);
    
    self.title = @"Signature";
    
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
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section ==0 ){
        return 2;
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
        return 44;
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

        }
    }else if(indexPath.section ==1){
        UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"Send";
        cell.textLabel.textColor = HJColor(0x0b60fe);
        return cell;
        
    }
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(indexPath.section == 1){
        //charge
        NSIndexPath *row = [NSIndexPath indexPathForRow:0 inSection:0];
        NSIndexPath *row1 = [NSIndexPath indexPathForRow:1 inSection:0];
        
        BSTextFieldCell *cell =(BSTextFieldCell *) [tableView cellForRowAtIndexPath:row];
        NSString *requestID = cell.textField.text;
        
        BSTextFieldCell *cell1 =(BSTextFieldCell *) [tableView cellForRowAtIndexPath:row1];
        NSString *title = cell1.textField.text;
        
        if(requestID == nil || [requestID isEqualToString:@""]){
            [MBProgressHUD showError:@"RequestID can't be empty"];
            return;
        }
        
        if(title == nil || [title isEqualToString:@""]){
            [MBProgressHUD showError:@"Title can't be empty"];
            return;
        }
        
        NSDictionary *requestParams = @{
                                        @"Action" :@"GetSignature",
                                        @"Format":@"XML",
                                        @"CallbackURL":@"POSAPP",
                                        @"RequestID":requestID,
                                        @"Title":title
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
