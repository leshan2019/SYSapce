//
//  CommonUIDefine.h
//  Shining
//
//  Created by 鹏飞 季 on 2019/2/21.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#ifndef CommonUIDefine_h
#define CommonUIDefine_h

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"
#define KNOTIFICATIONNAME_DELETEALLMESSAGE @"RemoveAllMessages"

#define CHATVIEWBACKGROUNDCOLOR [UIColor colorWithRed:0.936 green:0.932 blue:0.907 alpha:1]
#define DEFAULT_THEME_COLOR [UIColor colorWithRed:123/255.0 green:64/255.0 blue:255/255.0 alpha:1]
#define DEFAULT_THEME_BG_COLOR [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1]

#define  WEIXIN_APPID @"wx50f36497defb7b8e"

#define SVGA_TEXTNAME  @"banner"
#define SVGA_DRIVER_IMAGENAME @"avatar"
#define SVGA_GIFT_SENDER @"avatar_sender"
#define SVGA_GIFT_RECIEVER @"avatar_reciever"

#define SY_TEST_DOMAIN @"http://test.api.svoice.le.com/"
#define SY_TEST_ONLINE_DOMAIN @"http://api.svoice.le.com/"
#define SY_DOMAIN @"https://api-svoice.le.com/";

#define MAXLENGTH_OF_DRIVER_USERNAME 7

#endif /* CommonUIDefine_h */

#import "SYCustomPostView.h"
#import "SYCustomActionSheet.h"
#import "SYToastView.h"
#import "SYPasswordInputView.h"
