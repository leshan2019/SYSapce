//
//  SYSystemMsgTableViewCell.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/4/25.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYSystemMsgTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *avatarView;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *linkBtn;
@property (strong, nonatomic) UIView *lineLabel;

- (void)reloadTitleLabelSize:(BOOL)isLinkBtnHidden;
@end

NS_ASSUME_NONNULL_END
