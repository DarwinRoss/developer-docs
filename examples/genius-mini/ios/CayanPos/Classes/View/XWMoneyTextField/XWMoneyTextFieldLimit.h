

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol XWMoneyTextFieldLimitDelegate;

@interface XWMoneyTextFieldLimit : NSObject <UITextFieldDelegate>

@property (nonatomic, assign) id <XWMoneyTextFieldLimitDelegate> delegate;
@property (nonatomic, strong) NSString *max; // 默认99999.99

- (void)valueChange:(id)sender;

@end

@protocol XWMoneyTextFieldLimitDelegate <NSObject>

- (void)valueChange:(id)sender;

@end
