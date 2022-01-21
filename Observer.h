#import <Foundation/Foundation.h>


@interface Observer : NSObject


- (instancetype)initWithCount:(NSNumber *)count;
- (void)subscribe;
- (void)storeDidUpdate;
+ (void)flush;

@end


