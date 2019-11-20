//
//  LTPageControl.m
//  LetvIphoneMusic
//
//  Created by zhaochunyan on 11-10-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SYPageControl.h"


#ifndef LT_IPAD_CLIENT
@implementation SYPageControl
-(id) initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        activeImage = [SYUtil imageFromColor:[UIColor whiteColor] size:CGSizeMake(4, 1)];
        inactiveImage = [SYUtil imageFromColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.4]
                                          size:CGSizeMake(4, 1)];
        [self setCurrentPage:0];
      
//        if (LTAPI_IS_ALLOWED(7.0)){
            if ([self respondsToSelector:@selector(setCurrentPageIndicatorTintColor:)] && [self respondsToSelector:@selector(setPageIndicatorTintColor:)]) {
                [self setCurrentPageIndicatorTintColor:[UIColor clearColor]];
                [self setPageIndicatorTintColor:[UIColor clearColor]];
              
               if ([[[UIDevice currentDevice]systemVersion]floatValue] <7.0) {
                   for (UIView *su in self.subviews) {
                       [su removeFromSuperview];
                   }
               }
                
                self.contentMode=UIViewContentModeRedraw;
            }
     
        
//        }
    }
    
    return self;
    
}

- (void)refreshPageControlActiveImage:(UIImage *)active inactiveImage:(UIImage *)inactive
{
    activeImage = active;
    inactiveImage = inactive;
    [self setNeedsDisplay];
}

-(void) updateDots{
    
    for (int i = 0; i < [self.subviews count]; i++) {   
        
        UIImageView* dot = [self.subviews objectAtIndex:i];
        
        if (![dot isKindOfClass:[UIImageView class]]) {
            continue;
        }

        if (i == self.currentPage){
            dot.image = activeImage;
        }
        else {
            dot.image = inactiveImage;
        }
        
    }
    
    return;
}

-(void) setCurrentPage:(NSInteger)page{
    
    [super setCurrentPage:page];
    if ([[[UIDevice currentDevice]systemVersion]floatValue] <6.0) {
//        [self updateDots];
        for (UIView *su in self.subviews) {
            [su removeFromSuperview];
        }
    }
     [self setNeedsDisplay];
    
    return;
    
}

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    [super setNumberOfPages:numberOfPages];
//    if ([[[UIDevice currentDevice]systemVersion]floatValue] <7.0) {
//        [self updateDots];
//    }
    
    [self setNeedsDisplay];
    
}

- (void)drawRect:(CGRect)iRect
{
//    if (LTAPI_IS_ALLOWED(6.0)) {
        int i;
        CGRect rect;
        UIImage *image;
        
        iRect = self.bounds;
        
        if (self.opaque) {
            [self.backgroundColor set];
            UIRectFill(iRect);
        }
        
        UIImage *_activeImage = activeImage;
        UIImage *_inactiveImage = inactiveImage;
    
        CGFloat _kSpacing = self.space;
        if (self.space == 0) {
#ifndef LT_MERGE_FROM_IPAD_CLIENT
        _kSpacing = 2.0f;
#else
        _kSpacing = 8.0f;
#endif
        }
    
        if (self.hidesForSinglePage && self.numberOfPages == 1) {
            return;
        }
        
        rect.size.height = _activeImage.size.height;
        rect.size.width = self.numberOfPages * _activeImage.size.width + (self.numberOfPages - 1) * _kSpacing;
        rect.origin.x = floorf((iRect.size.width - rect.size.width) / 2.0);
        rect.origin.y = floorf((iRect.size.height - rect.size.height) / 2.0);
        rect.size.width = _activeImage.size.width;
        
        for (i = 0; i < self.numberOfPages; ++i) {
            image = (i == self.currentPage) ? _activeImage : _inactiveImage;
            [image drawInRect:rect];
            rect.origin.x += _activeImage.size.width + _kSpacing;
        }

//    }
}

@end

#else
@implementation LTPageControl
-(id) initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        activeImage = [UIImage GUIBundleKitImageName:@"index_dot_active"];
        inactiveImage = [UIImage GUIBundleKitImageName:@"index_dot_inactive"];
        [self setCurrentPage:0];
        
        //        if (LTAPI_IS_ALLOWED(7.0)){
        if ([self respondsToSelector:@selector(setCurrentPageIndicatorTintColor:)] && [self respondsToSelector:@selector(setPageIndicatorTintColor:)]) {
            [self setCurrentPageIndicatorTintColor:[UIColor clearColor]];
            [self setPageIndicatorTintColor:[UIColor clearColor]];
            
            if ([[[UIDevice currentDevice]systemVersion]floatValue] <7.0) {
                for (UIView *su in self.subviews) {
                    [su removeFromSuperview];
                }
            }
            
            self.contentMode=UIViewContentModeRedraw;
        }
        
        
        //        }
    }
    
    return self;
    
}

- (void)refreshPageControlActiveImage:(UIImage *)active inactiveImage:(UIImage *)inactive
{
    activeImage = active;
    inactiveImage = inactive;
    [self setNeedsDisplay];
}

-(void) updateDots{
    
    for (int i = 0; i < [self.subviews count]; i++) {
        
        UIImageView* dot = [self.subviews objectAtIndex:i];
        
        if (![dot isKindOfClass:[UIImageView class]]) {
            continue;
        }
        
        if (i == self.currentPage){
            dot.image = activeImage;
        }
        else {
            dot.image = inactiveImage;
        }
        
    }
    
    return;
    
}

-(void) setCurrentPage:(NSInteger)page{
    
    [super setCurrentPage:page];
    if ([[[UIDevice currentDevice]systemVersion]floatValue] <6.0) {
        //        [self updateDots];
        for (UIView *su in self.subviews) {
            [su removeFromSuperview];
        }
    }
    [self setNeedsDisplay];
    
    return;
    
}

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    [super setNumberOfPages:numberOfPages];
    //    if ([[[UIDevice currentDevice]systemVersion]floatValue] <7.0) {
    //        [self updateDots];
    //    }
    
    [self setNeedsDisplay];
    
}

- (void)drawRect:(CGRect)iRect
{
    //    if (LTAPI_IS_ALLOWED(6.0)) {
    int i;
    CGRect rect;
    UIImage *image;
    
    iRect = self.bounds;
    
    if (self.opaque) {
        [self.backgroundColor set];
        UIRectFill(iRect);
    }
    
    UIImage *_activeImage = activeImage;
    UIImage *_inactiveImage = inactiveImage;
    
    CGFloat _kSpacing = self.space;
    if (self.space == 0) {
#ifndef LT_MERGE_FROM_IPAD_CLIENT
        _kSpacing = 5.0f;
#else
        _kSpacing = 8.0f;
#endif
    }
    
    if (self.hidesForSinglePage && self.numberOfPages == 1) {
        return;
    }
    
    rect.size.height = _activeImage.size.height;
    rect.size.width = self.numberOfPages * _activeImage.size.width + (self.numberOfPages - 1) * _kSpacing;
    rect.origin.x = floorf((iRect.size.width - rect.size.width) / 2.0);
    rect.origin.y = floorf((iRect.size.height - rect.size.height) / 2.0);
    rect.size.width = _activeImage.size.width;
    
    for (i = 0; i < self.numberOfPages; ++i) {
        image = (i == self.currentPage) ? _activeImage : _inactiveImage;
        [image drawInRect:rect];
        rect.origin.x += _activeImage.size.width + _kSpacing;
    }
    
    //    }
}
@end

#endif

