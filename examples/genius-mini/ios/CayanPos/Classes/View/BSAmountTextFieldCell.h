


#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height
#define kPadding 0
#define TitleLabelWidth 80*W/375
#define TitleLeftOrgin 15


#import <UIKit/UIKit.h>
@class XWMoneyTextField;


@interface BSAmountTextFieldCell : UITableViewCell

@property (nonatomic, strong) XWMoneyTextField *textField;


@property (nonatomic, strong, readonly) UILabel *titleLabel;

@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) UIFont *font;

@property(copy,nonatomic)NSString *placeHold;

-(void)setSubFrame;

@end
