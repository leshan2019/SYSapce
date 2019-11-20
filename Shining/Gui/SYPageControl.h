//
//  LTPageControl.h
//  LetvIphoneMusic
//
//  Created by zhaochunyan on 11-10-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYPageControl : UIPageControl{
    
 @private
    
    UIImage* activeImage;
    UIImage* inactiveImage;
    
}

@property (nonatomic, assign) CGFloat space;

-(void) updateDots;
- (void)refreshPageControlActiveImage:(UIImage *)active inactiveImage:(UIImage *)inactive;
@end
