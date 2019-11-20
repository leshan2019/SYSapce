

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface SYCategoryViewAnimator : NSObject
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, copy) void(^progressCallback)(CGFloat percent);
@property (nonatomic, copy) void(^completeCallback)(void);
@property (readonly, getter=isExecuting) BOOL executing;

- (void)start;
- (void)stop;
- (void)invalid;
@end

