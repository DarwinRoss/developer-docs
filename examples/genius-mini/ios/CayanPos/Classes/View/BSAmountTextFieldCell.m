


#import "BSAmountTextFieldCell.h"
#import "XWMoneyTextField.h"

@interface BSAmountTextFieldCell()

@property(weak,nonatomic)UILabel *lblLeftView;

@end

@implementation BSAmountTextFieldCell

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
    
    _textField = [[XWMoneyTextField alloc] init];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.keyboardType = UIKeyboardTypeDecimalPad;
    _textField.font =[UIFont systemFontOfSize:16 weight:1.5];
    _textField.textColor = [UIColor blackColor];
    _textField.limit.max = @"9999999.99";
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    
   
    UILabel *lblLeftView = [[UILabel alloc]init];
    lblLeftView.textAlignment = NSTextAlignmentRight;
    lblLeftView.text = @"$";
    lblLeftView.font = [UIFont systemFontOfSize:16 weight:1.5];
    lblLeftView.textColor = [UIColor blackColor];
    self.lblLeftView = lblLeftView;
    
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:lblLeftView];
}




-(void)layoutSubviews{
    [super layoutSubviews];
    [self setSubFrame];
}

-(void) setSubFrame{
    CGFloat width = self.frame.size.width;
    
    _titleLabel.frame = CGRectMake(20, 20, width -40, 20);
    _lblLeftView.frame = CGRectMake(20, 50, 10, 40);
    _textField.frame = CGRectMake(CGRectGetMaxX(self.lblLeftView.frame)+10, 50, 150, 40);
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
