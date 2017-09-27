//
//  BSTextFieldCell.m
//   
//
//
//
//


#import "BSTextFieldCell.h"

@implementation BSTextFieldCell


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
    _textField.font = [UIFont systemFontOfSize:14];
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
   
    CGFloat height = self.frame.size.height;
    
    _titleLabel.frame = CGRectMake(10, 0, 100, height);
    
    CGFloat tfX = 120;
    CGFloat tfY = 0;
    CGFloat tfW = width - 120 - 10;
    CGFloat tfH = height;
    
    if (_textField.frame.size.width < 60) {
        
        _textField.frame = CGRectMake(tfX, tfY, tfW, tfH);
        
    }
  
    self.detailTextLabel.frame = CGRectMake(tfX, tfY, tfW, tfH);
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    
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
