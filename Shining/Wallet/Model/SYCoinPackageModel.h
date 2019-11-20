//
//  SYCoinPackageModel.h
//  Shining
//
//  Created by letv_lzb on 2019/3/29.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <YYModel/YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYCoinPackageModel : NSObject<YYModel>
/*
 id: 12, //充值套餐id
 name: "常规充值0.01", //套餐名称
 price: 0.01, //金额 人民币
 coin: 100, //金币数量
 first_give_coin: 30, //首次充值赠送 暂时无用
 normal_give_coin: 15, //非首充(日常)充值赠送
 picture_url: "//i2.letvimg.com/lc06_img/201812/11/16/19/shop_diamond_01.png", //套餐对应图片地址
 apple_id: "com.letv.iphone.lepay.50" //苹果虚拟商品id
 */

@property(nonatomic, copy)NSString *cid;
@property(nonatomic, copy)NSString *apple_id;

@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *coin;
@property(nonatomic, copy)NSString *picture_url;

// 首冲 + 日常充值
@property(nonatomic, assign)NSInteger first_give_coin;
@property(nonatomic, assign)NSInteger normal_give_coin;

@property(nonatomic, copy)NSString *price;
@property(nonatomic, copy)NSString *validatePrice;
@property(nonatomic, copy)NSString *priceLocale;

@end

NS_ASSUME_NONNULL_END
