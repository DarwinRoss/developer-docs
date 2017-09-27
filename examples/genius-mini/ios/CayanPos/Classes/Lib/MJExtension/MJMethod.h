

#import "MJMember.h"



@interface MJMethod : MJMember

@property (nonatomic, assign) Method method;

@property (nonatomic, assign, readonly) SEL selector;

@property (nonatomic, strong, readonly) NSArray *arguments;

@property (nonatomic, copy, readonly) NSString *returnType;


- (instancetype)initWithMethod:(Method)method srcObject:(id)srcObject;
@end


typedef void (^MJMethodsBlock)(MJMethod *method, BOOL *stop);
