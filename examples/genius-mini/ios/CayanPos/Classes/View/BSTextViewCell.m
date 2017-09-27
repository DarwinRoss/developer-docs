//
//  BSTextFieldCell.m
//   KLBank
//
//  Created by Pactera on 15/12/11.
//  Copyright © 2015 pactera. All rights reserved.
//


#import "BSTextViewCell.h"

@implementation BSTextViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _textField = [[UITextField alloc] init];
    _textField.backgroundColor = [UIColor clearColor];
    
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font=[UIFont systemFontOfSize:14];
    _titleLabel.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.titleLabel];
}




-(void)layoutSubviews{
    [super layoutSubviews];
    [self setSubFrame];
}

-(void) setSubFrame{
    CGFloat width = self.frame.size.width;
    
    _titleLabel.frame = CGRectMake(20, 20, width -40, 20);
    
    _textField.frame = CGRectMake(20, 50, 150, 40);
    
    [self bringSubviewToFront:_textField];
    
    
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.textField.text = text;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.titleLabel.text = title;
}

-(void)setPlaceHold:(NSString *)placeHold{
    _placeHold = placeHold;
    self.textField.placeholder = placeHold;
}

-(void)setFont:(UIFont *)font{
    if (!font) {
//        font = Font_CN(15);
    }
    _font = font;
    _titleLabel.font = font;
    _textField.font = font;
    self.textLabel.font = font;
    self.detailTextLabel.font = font;
}

@end
