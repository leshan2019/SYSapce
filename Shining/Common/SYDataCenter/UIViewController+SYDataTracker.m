//
//  UIViewController+SYDataTracker.m
//  Shining
//
//  Created by letv_lzb on 2019/5/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "UIViewController+SYDataTracker.h"
#import <objc/runtime.h>

static void * ddInfoDictionaryPropertyKey = &ddInfoDictionaryPropertyKey;

@implementation UIViewController (SYDataTracker)

+ (void)load {
    Method originalSelector = class_getInstanceMethod(self, @selector(viewWillAppear:));
    Method swizzledSelector = class_getInstanceMethod(self, @selector(sy_swiz_viewWillAppear:));
    method_exchangeImplementations(originalSelector, swizzledSelector);
    Method originalSelector2 = class_getInstanceMethod(self, @selector(viewWillDisappear:));
    Method swizzledSelector2 = class_getInstanceMethod(self, @selector(sy_swiz_viewWillDisappear:));
    method_exchangeImplementations(originalSelector2, swizzledSelector2);
}


- (void)sy_swiz_viewWillAppear:(BOOL)animated {
    //在这里填写需要插入的代码
    [self sy_sendPageBeginTrackerData];

    //执行原来的代码，不影响代码逻辑
    [self sy_swiz_viewWillAppear:animated];
}

- (void)sy_sendPageBeginTrackerData {
    if (self.syDataInfoDictionary && self.syDataInfoDictionary.allValues.count > 0) {
        NSString *name = [self.syDataInfoDictionary objectForKey:@"pageName"];
        if (name && name.length > 0) {
//            [MobClick beginLogPageView:name];
        }
    }
}


- (void)sy_swiz_viewWillDisappear:(BOOL)animated {
    [self sy_sendPageEndTrackerData];

    [self sy_swiz_viewWillDisappear:animated];
}

- (void)sy_sendPageEndTrackerData {
    if (self.syDataInfoDictionary && self.syDataInfoDictionary.allValues.count > 0) {
        NSString *name = [self.syDataInfoDictionary objectForKey:@"pageName"];
        if (name && name.length > 0) {
//            [MobClick endLogPageView:name];
        }
    }
}


- (NSDictionary *)syDataInfoDictionary {
    return objc_getAssociatedObject(self, ddInfoDictionaryPropertyKey);
}

- (void)setSyDataInfoDictionary:(NSDictionary *)syDataInfoDictionary {
    if (syDataInfoDictionary) {
        objc_setAssociatedObject(self, ddInfoDictionaryPropertyKey, syDataInfoDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}


- (void)sy_configDataInfoPageName:(SYPageNameType)pageType {
    if (SYPageNameType_Unknown == pageType) {
        return;
    }
    NSString *name = [self getPageName:pageType];
    if (nil == name) {
        return;
    }
    if (nil == self.syDataInfoDictionary) {
        self.syDataInfoDictionary = [NSMutableDictionary dictionaryWithObject:name forKey:@"pageName"];
    }else {
        [self.syDataInfoDictionary setValue:name forKey:@"pageName"];
    }
}


- (NSString *)getPageName:(SYPageNameType)pageType {
    NSString *name = nil;
    switch (pageType) {
        case SYPageNameType_Mine:
            name = @"sy_p_mine";
            break;
        case SYPageNameType_Login:
            name = @"sy_p_login";
            break;
        case SYPageNameType_Register:
            name = @"sy_p_register";
            break;
        case SYPageNameType_Wallet:
            name = @"sy_p_wallet";
            break;
        case SYPageNameType_Wallet_Recharge:
            name = @"sy_p_wallet_recharge";
            break;
        case SYPageNameType_Wallet_Detailed:
            name = @"sy_p_wallet_detailed";
            break;
        case SYPageNameType_MyLevel:
            name = @"sy_p_mine_mylevel";
            break;
        case SYPageNameType_Shining:
            name = @"sy_p_shining";
            break;
        case SYPageNameType_Shining_Detailed:
            name = @"sy_p_shining_detailed";
            break;
        case SYPageNameType_Setting:
            name = @"sy_p_mine_setting";
            break;
        case SYPageNameType_About_us:
            name = @"sy_p_mine_setting_about";
            break;
        case SYPageNameType_Feedback:
            name = @"sy_p_mine_setting_feedback";
            break;
        case SYPageNameType_Authentication:
            name = @"sy_p_mine_setting_auth";
            break;
        case SYPageNameType_Disguised:
            name = @"sy_p_mine_disguised";
            break;
        case SYPageNameType_VoiceRoom_Home:
            name = @"sy_p_voiceroomhome";
            break;
        case SYPageNameType_VoiceRoom:
            name = @"sy_p_voiceroom";
            break;
        case SYPageNameType_VoiceRoom_LeaderBoard:
            name = @"sy_p_voiceroomleaderboard";
            break;
        case SYPageNameType_CreateRoom:
            name = @"sy_p_voiceroomcreateroom";
            break;
        case SYPageNameType_MyRoomList:
            name = @"sy_p_voiceroommyroomlist";
            break;
        case SYPageNameType_IM_ConversationList:
            name = @"sy_p_im_list";
            break;
        case SYPageNameType_IM_Contact:
            name = @"sy_p_im_contact";
            break;
        case SYPageNameType_IM_Chat:
            name = @"sy_p_im_chat";
            break;
        case SYPageNameType_HomePage:
            name = @"sy_p_homepage";
            break;
        case SYPageNameType_HomePageEdit:
            name = @"sy_p_homepageedit";
            break;
        default:
            break;
    }
    return name;
}

@end
