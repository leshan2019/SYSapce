//
//  UIImageView+HeadImage.m
//  Shining
//
//  Created by 鹏飞 季 on 2019/2/22.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "UIImageView+HeadImage.h"

#import "UserProfileManager.h"

@implementation UIImageView (HeadImage)

- (void)imageWithUsername:(NSString *)username placeholderImage:(UIImage*)placeholderImage
{
    if (placeholderImage == nil) {
        placeholderImage = [UIImage imageNamed_sy:@"chatListCellHead"];
    }
    UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:username];
    if (profileEntity) {
        [self sd_setImageWithURL:[NSURL URLWithString:profileEntity.imageUrl] placeholderImage:placeholderImage];
    } else {
        [self sd_setImageWithURL:nil placeholderImage:placeholderImage];
    }
}

@end

@implementation UILabel (Prase)

- (void)setTextWithUsername:(NSString *)username
{
    UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:username];
    if (profileEntity) {
        if (profileEntity.nickname && profileEntity.nickname.length > 0) {
            [self setText:profileEntity.nickname];
            [self setNeedsLayout];
        } else {
            [self setText:username];
        }
    } else {
        [self setText:username];
    }
    
}

@end
