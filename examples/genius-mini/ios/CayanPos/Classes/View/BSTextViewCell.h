//
//  BSTextFieldCell.h
//   KLBank
//
//  Created by Pactera on 15/12/11.
//  Copyright © 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BSTextViewCell : UITableViewCell

@property (nonatomic, strong) UITextField *textField;


@property (nonatomic, strong, readonly) UILabel *titleLabel;

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) UIFont *font;

@property(copy,nonatomic)NSString *placeHold;

-(void)setSubFrame;

@end
