//
//  SettingViewController.m
//  CayanPos
//
//  Created by CongLi on 2/3/17.
//  Copyright © 2017 CongLi. All rights reserved.
//

#import "SettingViewController.h"
#import "BSTextFieldCell.h"
#import "MBProgressHUD+MJ.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *table;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = HJColor(0xebebf0);
    
    self.title = @"Settings";
    
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
        return 3;
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
    NSUserDefaults *userDefault =  [NSUserDefaults standardUserDefaults];
    
    if(indexPath.section ==0){
        if(indexPath.row == 0){
            BSTextFieldCell *cell = [[BSTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.placeHold = @"Input";
            cell.title = @"Name";
            cell.text = [userDefault objectForKey:@"KName"];
            cell.titleLabel.textColor = HJColor(0x505050);
            return cell;
            
        }else if(indexPath.row ==1){
            BSTextFieldCell *cell = [[BSTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.placeHold = @"Input";
            cell.title = @"SiteID";
            cell.text = [userDefault objectForKey:@"KSiteID"];
//            cell.textField.secureTextEntry = YES;
            cell.titleLabel.textColor = HJColor(0x505050);
            return cell;
            
        }else if(indexPath.row ==2){
            BSTextFieldCell *cell = [[BSTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.placeHold = @"Input";
            cell.title = @"Key";
            cell.text = [userDefault objectForKey:@"KKey"];
//            cell.textField.secureTextEntry = YES;
            cell.titleLabel.textColor = HJColor(0x505050);
            return cell;
            
        }
    }else if(indexPath.section ==1){
        UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"Save";
        cell.textLabel.textColor = HJColor(0x0b60fe);
        return cell;
        
    }
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section ==1){
        NSIndexPath *row = [NSIndexPath indexPathForRow:0 inSection:0];
        NSIndexPath *row1 = [NSIndexPath indexPathForRow:1 inSection:0];
        NSIndexPath *row2 = [NSIndexPath indexPathForRow:2 inSection:0];
        
        BSTextFieldCell *cell =(BSTextFieldCell *) [tableView cellForRowAtIndexPath:row];
        NSString *name = cell.textField.text;
        
        BSTextFieldCell *cell1 =(BSTextFieldCell *) [tableView cellForRowAtIndexPath:row1];
        NSString *siteID = cell1.textField.text;
        
        BSTextFieldCell *cell2 =(BSTextFieldCell *) [tableView cellForRowAtIndexPath:row2];
        NSString *key = cell2.textField.text;
        
        if(name == nil || [name isEqualToString:@""]){
            [MBProgressHUD showError:@"Name can't be empty"];
            return;
        }
        
        if(siteID == nil || [siteID isEqualToString:@""]){
            [MBProgressHUD showError:@"SiteID can't be empty"];
            return;
        }
        
        if(key == nil || [key isEqualToString:@""]){
            [MBProgressHUD showError:@"Key can't be empty"];
            return;
        }
        
        NSUserDefaults *userDefault =  [NSUserDefaults standardUserDefaults];
        
        [userDefault setObject:name forKey:@"KName"];
        [userDefault synchronize];
    
        [userDefault setObject:siteID forKey:@"KSiteID"];
        [userDefault synchronize];
    
        [userDefault setObject:key forKey:@"KKey"];
        [userDefault synchronize];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}


@end
