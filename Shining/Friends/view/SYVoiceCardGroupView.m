//
//  SYVoiceCardGroupView.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/10/23.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "SYVoiceCardGroupView.h"

#define ImageScale 0.1 //每张图片初始化缩小尺寸
#define ImageSpace 10 //每张图片底部距离
#define GestureRemoveWidth 150 //手势移除卡片的距离

@interface SYVoiceCardGroupView () <SYVoiceCardViewDelegate>
@property(nonatomic,assign)NSInteger itemViewCount;
@end

@implementation SYVoiceCardGroupView

- (void)deleteTheTopItemViewWithLeft:(BOOL)left {
    SYVoiceCardView *itemView = (SYVoiceCardView *)self.subviews.lastObject;
    [itemView removeWithLeft:left];
}

- (void)reloadData {
    
    if (_dataSource == nil) {
        return ;
    }
    
    // 1. 移除
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 2. 创建
    _itemViewCount = [self numberOfItemViews];
    for (int i = 0; i < _itemViewCount; i++) {
        
        CGSize size = [self itemViewSizeAtIndex:i];
        
        SYVoiceCardView *itemView = [self itemViewAtIndex:i];
        [self addSubview:itemView];
        [self sendSubviewToBack:itemView];
        itemView.delegate = self;
        
        itemView.frame = CGRectMake(self.frame.size.width / 2.0 - size.width / 2.0, self.frame.size.height / 2.0 - size.height / 2.0, size.width, size.height);
        itemView.tag = i + 1;
        
        int index = i;
        if (index>1) {
            index = 1;
        }

        itemView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 +(self.frame.size.height*ImageScale*index/2)+ ImageSpace*index);
        itemView.transform = CGAffineTransformMakeScale(1-ImageScale*index, 1-ImageScale*index);
        if (i==1) {
            itemView.alpha = 0.6;
        }else if(i>1){
            itemView.alpha = 0;
        }

        itemView.userInteractionEnabled = YES;
        [itemView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestHandle:)]];
    }
    
    SYVoiceCardView *itemView = (SYVoiceCardView *)self.subviews.lastObject;
    if (itemView) {
        if ([self.dataSource respondsToSelector:@selector(showCurrentCardItem:index:)]) {
            [self.dataSource showCurrentCardItem:itemView index:itemView.tag-1];
        }
    }
}

- (CGSize)itemViewSizeAtIndex:(NSInteger)index {
    
    if ([self.dataSource respondsToSelector:@selector(cardView:sizeForItemViewAtIndex:)] && index < [self numberOfItemViews]) {
        CGSize size = [self.dataSource cardView:self sizeForItemViewAtIndex:index];
        if (size.width > self.frame.size.width || size.width == 0) {
            size.width = self.frame.size.width;
        } else if (size.height > self.frame.size.height || size.height == 0) {
            size.height = self.frame.size.height;
        }
        return size;
    }
    return self.frame.size;
}

- (SYVoiceCardView *)itemViewAtIndex:(NSInteger)index {
    if ([self.dataSource respondsToSelector:@selector(cardView:itemViewAtIndex:)]) {
        SYVoiceCardView *itemView = [self.dataSource cardView:self itemViewAtIndex:index];
        if (itemView == nil) {
            return [SYVoiceCardView new];
        } else {
            return itemView;
        }
    }
    return [SYVoiceCardView new];
}

- (NSInteger)numberOfItemViews {
    if ([self.dataSource respondsToSelector:@selector(numberOfItemViewsInCardView:)]) {
        return [self.dataSource numberOfItemViewsInCardView:self];
    }
    return 0;
}

- (void)tapGestHandle:(UITapGestureRecognizer *)tapGest {
    if ([self.delegate respondsToSelector:@selector(cardView:didClickItemAtIndex:)]) {
        [self.delegate cardView:self didClickItemAtIndex:tapGest.view.tag - 1];
    }
}

#pragma  mark SYVoiceCardViewDelegate
- (void)cardItemViewDidRemoveFromSuperView:(SYVoiceCardView *)cardItemView {
    if (_itemViewCount > 0) {
        _itemViewCount -= 1;
        SYVoiceCardView *itemView = (SYVoiceCardView *)self.subviews.lastObject;

        itemView.center = CGPointMake(self.sy_width/2, self.sy_height/2 + (self.frame.size.height*ImageScale*0/2) + ImageSpace*0);
        itemView.transform = CGAffineTransformMakeScale(1-ImageScale*0, 1-ImageScale*0);
        itemView.alpha = 1;
        
        NSInteger nextIndex = self.subviews.count - 2;
        if (nextIndex>=0) {
            SYVoiceCardView *itemView_next = (SYVoiceCardView *)self.subviews[nextIndex];
            if (itemView_next) {
                itemView_next.alpha = 0.6;
            }
        }
        
       
        if (self.subviews.count>=3){
            for (int i=0; i<self.subviews.count-2; i++) {
                SYVoiceCardView *itemView = (SYVoiceCardView *)self.subviews[i];
                if (itemView) {
                    itemView.alpha = 0;
                }
            }
            
        }

        if (_itemViewCount == 0) {
            if ([self.dataSource respondsToSelector:@selector(cardViewNeedMoreData:)]) {
                [self.dataSource cardViewNeedMoreData:self];
            }
        }else{
            if (_itemViewCount <= 2) {
                if ([self.dataSource respondsToSelector:@selector(cardViewNeedMoreData:)]) {
                    [self.dataSource cardViewNeedMoreData:self];
                }
            }
            if (itemView) {
                if ([self.dataSource respondsToSelector:@selector(showCurrentCardItem:index:)]) {
                    [self.dataSource showCurrentCardItem:itemView index:itemView.tag-1];
                }
            }
        }
    }
}

- (void)cardItemViewPanGestureStateChanged:(SYVoiceCardView *)cardItemView withMoveWidth:(CGFloat)moveWidth
{
    NSInteger nextIndex = self.subviews.count - 2;
    if (moveWidth>GestureRemoveWidth) {
        moveWidth = GestureRemoveWidth;
    }
    CGFloat initialAlpha =  0.6;
    if (self.subviews.count>=2 && moveWidth>0) {
        SYVoiceCardView *itemView = (SYVoiceCardView *)self.subviews[nextIndex];
        if (itemView) {
            CGFloat alpha = initialAlpha+ 0.4*moveWidth/GestureRemoveWidth;
            if (alpha >1) {
                alpha = 1 ;
            }
            itemView.alpha = alpha;
            CGFloat scale = 1- moveWidth/GestureRemoveWidth;
            itemView.center = CGPointMake(self.sy_width/2, self.sy_height/2 + (self.frame.size.height*ImageScale*scale/2) + ImageSpace*scale);
            itemView.transform = CGAffineTransformMakeScale(1-ImageScale*scale, 1-ImageScale*scale);

        }
        
    }
    if (self.subviews.count>=3 && moveWidth>0) {
        SYVoiceCardView *itemView = (SYVoiceCardView *)self.subviews[self.subviews.count-3];
        if (itemView) {
            CGFloat alpha = 0 + 0.4*moveWidth/GestureRemoveWidth;
            if (alpha >0.6) {
                alpha = 0.6 ;
            }
            itemView.alpha = alpha;
        }
        
    }
}

- (void)cardItemViewPanGestureStateEnd:(SYVoiceCardView *)cardItemView
{
    NSInteger nextIndex = self.subviews.count - 2;
    if (self.subviews.count>=2){
        SYVoiceCardView *itemView = (SYVoiceCardView *)self.subviews[nextIndex];
        if (itemView) {
            itemView.center = CGPointMake(self.sy_width/2, self.sy_height/2 + (self.frame.size.height*ImageScale*1/2) + ImageSpace*1);
            itemView.transform = CGAffineTransformMakeScale(1-ImageScale*1, 1-ImageScale*1);
            itemView.alpha = 0.6;
        }
    }
    
    if (self.subviews.count>=3){
        for (int i=0; i<self.subviews.count-2; i++) {
            SYVoiceCardView *itemView = (SYVoiceCardView *)self.subviews[i];
            if (itemView) {
                itemView.alpha = 0;
            }
        }
        
    }
    
}

- (void)attentionUser:(SYVoiceCardView *)cardItemView
{
    if ([self.delegate respondsToSelector:@selector(attentionUser:)]) {
        [self.delegate attentionUser:cardItemView];
    }
}

- (void)contact:(SYVoiceCardView *)cardItemView
{
    if ([self.delegate respondsToSelector:@selector(contact:)]) {
        [self.delegate contact:cardItemView];
    }
}

- (void)gotoUserinfo:(SYVoiceCardView *)cardItemView
{
    if ([self.delegate respondsToSelector:@selector(gotoUserinfo:)]) {
        [self.delegate gotoUserinfo:cardItemView];
    }
}
@end
