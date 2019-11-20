//
//  UIImage+SYBunldeImg.h
//  ShiningSdk
//
//  Created by letv_lzb on 2019/4/10.
//  Copyright © 2019 leshan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (SYBunldeImg)

+ (UIImage *)imageNamed_sy:(NSString *)name;
+ (UIImage *)gifImageNamed_sy:(NSString *)name;
+ (CGSize)getImageSizeWithURL:(id)URL;
@end

NS_ASSUME_NONNULL_END
