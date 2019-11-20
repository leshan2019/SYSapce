//
//  ViewController.h
//  Shining
//
//  Created by mengxiangjian on 2019/2/14.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    SYLaunchAdTypeWebUrl = 1, // url跳转
    SYLaunchAdTypeRoomID, // 房间跳转
} SYLaunchAdType;



@interface SYLaunchAdViewController : UIViewController


/// 初始化
/// @param adData 广告数据
-(instancetype)initWithLaunchAdData:(id)adData;

@end


@interface SYLaunchAdModel : NSObject <YYModel>
/*
"id": 2,
       "jump_type": 2,         // 跳转类型  1: 跳转url 2: 跳转房间ID
       "jump_link": "1004",    // url 或者房间 ID
       "image": "http://test.cdn.svoice.le.com/uploads/c7/09/c709de0d7fdeadcc7e1e44936588a969.png"     //
*/
@property (nonatomic, copy)NSString *id;
@property (nonatomic, strong)NSNumber *jump_type;
@property (nonatomic, copy)NSString *jump_link;
@property (nonatomic, copy)NSString *image;

@end

