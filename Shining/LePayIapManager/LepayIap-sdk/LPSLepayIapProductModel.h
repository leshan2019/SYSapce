//
//  LPSLepayIapProductModel.h
//  LepaySDK
//
//  Created by xuliang on 16/4/11.
//  Copyright © 2016年 letv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPSLepayBaseModel.h"

@interface LPSLepayIapProductInfoModel : LPSLepayBaseModel

@property(copy, nonatomic)NSString  *name;
@property(nonatomic,copy) NSString  *end;           //类型（由各业务线自己定义）
@property(copy, nonatomic)NSString  *productId;
@property(copy, nonatomic)NSString  *expire;  //几个月
@property(copy, nonatomic)NSString  *pid;
@property(copy, nonatomic)NSString  *mobileImg; //图片
@property(copy, nonatomic)NSString  *vipDesc;  //描述
@property(copy, nonatomic)NSString  *validatePrice;//用于后台验证   --  从app store中获取
@property(strong, nonatomic)NSLocale *priceLocale;//价格本地化     --    从app store中获取

/*
 * @brief   构造方法
 * @param   dic:输入字典
 * @return  返回对象
 */
- (instancetype)initWithDictionary:(NSDictionary*)dic;

//! 使用字典初始化对象
- (void)setParamDictionary:(NSDictionary*)dic;

@end



@interface LPSLepayIapProductListModel : LPSLepayBaseModel

@property (nonatomic, strong) NSMutableArray<LPSLepayIapProductInfoModel*>      *packageList;
@property (copy, nonatomic) NSString                                            *appKey;
@property (readonly, nonatomic, getter=getIapProductIdArray) NSArray<NSString*>  *allProductId;    //通过已有属性构造
@property (readonly, nonatomic, getter=getAllIapProducts) NSArray<LPSLepayIapProductInfoModel*> *allProducts; //同上

/*
 * @brief   构造方法
 * @param   dic:输入字典
 * @return  返回对象
 */
- (instancetype)initWithDictionary:(NSDictionary*)dic;

/*
 * @brief 获取productId数组
 * @return 产品id数组
 */
- (NSArray*)getIapProductIdArray;

/**
 *  @brief 根据productId获取产品信息
 *  @param productId 产品id
 *  @return 产品对象
 */
- (LPSLepayIapProductInfoModel *)getIapProductInfoByProductId:(NSString *)productId;

/*
 * @breief  获取所有产品列表
 *
 *  @return NSArray* 产品列表
 */
- (NSArray *)getAllIapProducts;

/*
 * @brief   从vip或svip或live数组中移除指定产品对象
 * @param   待移除的对象
 * @return  void
 */
- (void)removeIapProductByProductInfo:(LPSLepayIapProductInfoModel *)productInfo;


//! 从packagelist中过滤出allProducts
- (void)filterAllProducts;

@end


@interface LPSLepayIapProductInfoPreModel : LPSLepayBaseModel

@property (nonatomic, copy) NSString    *name;
@property (nonatomic, copy) NSString    *subscript;
@property (nonatomic, copy) NSString    *subscriptText;
@property (nonatomic, copy) NSString    *sort;
@property (nonatomic, copy) NSString    *days;
@property (nonatomic, copy) NSString    *productId;
@property (nonatomic, copy) NSString    *preSortValue;
@property(copy, nonatomic)  NSString    *validatePrice;     //价格 -- 从全量接口中同步过来（业务方可自己根据Locale去更新）
@property(strong, nonatomic)NSLocale    *priceLocale;       //价格本地化 -- 从全量接口中同步过来
@property(copy, nonatomic) NSString     *subPrice;          //用于计算每月价格  --  业务方自己去计算


/*
 * @brief   构造方法
 * @param   dic:输入字典
 * @return  返回对象
 */
- (instancetype)initWithDictionary:(NSDictionary*)dic;

@end

@interface LPSLepayIapProductListPreModel : LPSLepayBaseModel

@property (nonatomic,readonly, strong) NSMutableArray<LPSLepayIapProductInfoPreModel*> *packageList;

/*
 * @brief   构造方法
 * @param   dic:输入字典
 * @return  返回对象
 */
- (instancetype)initWithDictionary:(NSDictionary*)dic;
@end
