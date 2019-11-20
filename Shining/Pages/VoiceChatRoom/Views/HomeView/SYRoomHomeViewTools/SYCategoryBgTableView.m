//
//  MyBgTableView.m
//  MyCollectionView
//
//  Created by leeco on 2019/10/21.
//  Copyright © 2019 letv. All rights reserved.
//

#import "SYCategoryBgTableView.h"
@interface SYCategoryBgTableView ()<UIGestureRecognizerDelegate>
@end
@implementation SYCategoryBgTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    BOOL result = [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
    return result;
}

@end
