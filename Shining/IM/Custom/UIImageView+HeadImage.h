//
//  UIImageView+HeadImage.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/2/22.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (HeadImage)

- (void)imageWithUsername:(NSString*)username placeholderImage:(UIImage*)placeholderImage;

@end

@interface UILabel (Prase)

- (void)setTextWithUsername:(NSString *)username;

@end
