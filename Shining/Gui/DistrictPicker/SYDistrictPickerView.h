//
//  SYDistrictPickerView.h
//  Shining
//
//  Created by 杨玄 on 2019/4/2.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYDistrictPickerViewDelegate <NSObject>

- (void)handleSYDistrictPicerViewCancelBtn;
- (void)handleSYDistrictPickerViewEnsureBtnwithDistrictId:(NSInteger)districtId;

@end

NS_ASSUME_NONNULL_BEGIN

/**
 *  行政区域选择器
 */
@interface SYDistrictPickerView : UIView

@property (nonatomic, weak) id<SYDistrictPickerViewDelegate> delegate;

// 行政区对应的id - 必填
@property (nonatomic, assign) NSInteger district_id;

@end

NS_ASSUME_NONNULL_END
