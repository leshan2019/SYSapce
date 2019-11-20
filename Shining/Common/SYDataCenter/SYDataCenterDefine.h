//
//  SYDataCenterDefine.h
//  Shining
//
//  Created by letv_lzb on 2019/5/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#ifndef SYDataCenterDefine_h
#define SYDataCenterDefine_h

typedef NS_ENUM(NSInteger, SYPageNameType) {
    SYPageNameType_Unknown = -1,            //未知
    SYPageNameType_Login = 1,               //登陆
    SYPageNameType_Register,                //注册
    SYPageNameType_Mine,                    //我的
    SYPageNameType_HomePageEdit,            //个人主页编辑界面
    SYPageNameType_HomePage,                //个人主页
    SYPageNameType_Wallet,                  //我的钱包
    SYPageNameType_Wallet_Recharge,         //充值界面
    SYPageNameType_Wallet_Detailed,         //充值明细
    SYPageNameType_Shining,                 //蜜糖界面
    SYPageNameType_Shining_Detailed,        //蜜糖明细
    SYPageNameType_Disguised,               //我的装扮
    SYPageNameType_MyLevel,                 //我的等级
    SYPageNameType_Setting,                 //设置界面
    SYPageNameType_Authentication,          //身份认证
    SYPageNameType_Feedback,                //用户反馈
    SYPageNameType_About_us,                //关于我们
    SYPageNameType_VoiceRoom_Home,          //聊天室首页
    SYPageNameType_VoiceRoom,               //聊天室
    SYPageNameType_VoiceRoom_LeaderBoard,   //聊天室排行榜
    SYPageNameType_MyRoomList,              //我的房间列表
    SYPageNameType_CreateRoom,              //创建房间
    SYPageNameType_IM_ConversationList,     //IM会话列表
    SYPageNameType_IM_Contact,              //IM通讯录
    SYPageNameType_IM_Chat,                 //IM会话页
};


#endif /* SYDataCenterDefine_h */
