//
//  SYinGamebeeViewController.m
//  DemobeeOC
//
//  Created by leeco on 2019/8/14.
//  Copyright © 2019 JiangYue. All rights reserved.
//

#import "SYGameBeeViewController.h"
#import "SYMyCoinViewController.h"
#import "SYGiftNetManager.h"
#import "SYWalletNetWorkManager.h"

#import "SYGameBeeView.h"
#import "SYPopBeeview.h"
#import "PopBeeGiftListview.h"
#import "PopBeeGiftListview.h"
#import "ShiningSdkManager.h"
#import "SYSettingManager.h"

@interface SYGameBeeViewController ()<SYGameBeeViewDelegate>
@property (nonatomic, strong) SYGiftNetManager *netManager;
@property (nonatomic, strong) SYGameBeeView *beeView;
@property (nonatomic, strong) PopBeeCurrentGiftview *beeCurrentGiftview;
@property (nonatomic, strong) PopBeeGiftListview *beeGiftListview;
@property (nonatomic, strong) PopBeeExplainview *beeExplainview;

// 待换方式
@property (nonatomic, strong) UIView *bgview;


@end

@implementation SYGameBeeViewController

- (void)dealloc
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getcoin];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(userInfoReady:)
//                                                 name:KNOTIFICATION_USERINFOREADY
//                                               object:nil];
    
    self.view.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc ]init];
    [tap addTarget:self action:@selector(closebee)];
    [self.view addGestureRecognizer:tap];
    
    // 320/372 = 0.86
    CGSize size = [UIScreen mainScreen].bounds.size;
    NSInteger width = 320;
    NSInteger height = 372;
    if(size.width == 320){
        width = 320 - 14*2;
        height = 372/320*width;
    }
    CGRect rect = CGRectMake((size.width - width)/2, (size.height - height)/2, width, height);
    _beeView = [[SYGameBeeView alloc ]initWithFrame:rect delegate:self];
    [self.view addSubview:_beeView];
    _beeView.delegate = self;
    
    
}

/**
 * 采蜜游戏关闭
 */
- (void)closebee{
    // 游戏中时是不可以关闭游戏
    if (_beeView.beeStatus) {
        return;
    }
    for (UIView *view in [self.bgview subviews]) {
        [view removeFromSuperview];
    }
    [_beeView removeFromSuperview];
    [self.view removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(completeGameBee)]) {
        [self.delegate completeGameBee];
    }
}

/**
 * 弹出界面关闭时移除子视图
 */
- (void)closbg{
    for (UIView *view in [self.bgview subviews]) {
        [view removeFromSuperview];
        if(view.tag == 201){
            _beeCurrentGiftview = nil;
        }else if (view.tag == 202){
            _beeGiftListview = nil;
        }else if (view.tag == 203){
            _beeExplainview = nil;
        }
    }
    [self.bgview removeFromSuperview];
}

/**
 * 开始采蜜
 */
- (void)startBee:(BeeBucketType)beeBucketType{
    
    if ([self userHasLogin]) {
        return ;
    }
    
    __weak typeof(self) weakSelf = self;
    NSInteger num = 10;
    if (beeBucketType == BeeBucketType_small) {
        num = 1;
    }else if (beeBucketType == BeeBucketType_middle){
        num = 10;
    }else if (beeBucketType == BeeBucketType_big){
        num = 30;
    }
    NSInteger curretnBucketId = [self.beeView getCurrentBucketid];
    [self.netManager requestBeeWithRoomId:self.channelID smashnum:num bucketid:curretnBucketId success:^(id  _Nullable response) {
        [weakSelf getcoin];
        if ([response isKindOfClass:[SYGiftListModel class]]) {
            // 当次获得礼物横滑
            SYGiftListModel *giftListModel = (SYGiftListModel *)response;
            [self gameBeeCurrentGift:giftListModel];
            // 停止采蜜动画 r
            [weakSelf.beeView stopBeeAnimation];
        }
        
    } failure:^(NSError * _Nullable error) {
        [weakSelf getcoin];
        // 失败时停止采蜜
        [weakSelf.beeView stopBeeAnimation];
        if (error.code == 4003) {
            //  // 余额不足
            [self voiceRoomInputViewLackOfBalance];
        }else
        {
            [SYToastView showToast:@"采蜜失败，请稍后再试!"];
        }
    }];
}

- (BOOL)userHasLogin{
    __weak typeof(self) weakSelf = self;
    if(![SYSettingManager userHasLogin]){
        self.view.hidden = YES;
        [weakSelf.beeView stopBeeAnimation];
        if ([self.delegate respondsToSelector:@selector(popGameBeeLogin)]) {
            [self.delegate popGameBeeLogin];
            [self closebee];
        }
        return YES;
    }
    return NO;
}

/**
 * 展示当次游戏获得的礼物列表
 */
- (void)gameBeeCurrentGift:(SYGiftListModel *)giftListModel{
    [self.bgview removeFromSuperview];
    [self.view addSubview:self.bgview];
    PopBeeCurrentGiftview *beeCurrentGiftview = [[PopBeeCurrentGiftview alloc] initWithFrame:CGRectMake(0, 0, 280, 182)];
    CGPoint center = self.view.center;
    beeCurrentGiftview.tag  = 201;
    center.y += 20;
     beeCurrentGiftview.center = center;
    beeCurrentGiftview.giftListModel = giftListModel;
    _beeCurrentGiftview = beeCurrentGiftview;
    [self.bgview addSubview:beeCurrentGiftview];
    
    SYGiftModel *gift = nil;
    for (SYGiftModel *_gift in giftListModel.list) {
        if (_gift.price > gift.price) {
            gift = _gift;
        }
    }
    if ([self.delegate respondsToSelector:@selector(gameBeeDidGetGiftWithName:price:giftId:giftIcon:gameName:)]) {
        [self.delegate gameBeeDidGetGiftWithName:gift.name
                                           price:gift.price
                                          giftId:gift.giftid
                                        giftIcon:gift.icon
                                        gameName:@"采蜜游戏"];
    }
    
    
    if (giftListModel.list.count <= 0) {
        return ;
    }
    // 最大礼物价值
    NSInteger price = 0;
    for (int i = 0; i< giftListModel.list.count; i++ ) {
        SYGiftModel *giftModel = [giftListModel.list objectAtIndex:i];
        if (price < giftModel.price) {
            price = giftModel.price;
        }
        
    }
    BeeBucketType beeBucketType = _beeView.beeBucketType;
    NSInteger num = 0;
    if (beeBucketType == BeeBucketType_small) {
        num = 1;
    }else if (beeBucketType == BeeBucketType_middle){
        num = 10;
    }else if (beeBucketType == BeeBucketType_big){
        num = 30;
    }
    
    // 数据上报
    NSDictionary *pubParam = @{@"roomID":[NSString sy_safeString:self.channelID],@"userID":[NSString sy_safeString:[UserProfileEntity getUserProfileEntity].userid],@"bee": [NSNumber numberWithInteger:_beeView.beeBucketType],@"count":[NSNumber numberWithInteger:num],@"result":[NSNumber numberWithInteger:price]};
//    [MobClick event:@"honeyBee" attributes:pubParam];
}

#pragma mark - Delegate
/**
 * 礼物列表
 */
- (void)gameBeeGiftList{
    if ([self userHasLogin]) {
        return ;
    }
    [self.bgview removeFromSuperview];
    [self.view addSubview:self.bgview];
    PopBeeGiftListview *beeGiftListview = [[PopBeeGiftListview alloc ] initWithFrame:CGRectMake(0, __MainScreen_Height - 316, self.view.sy_width, 316)];
    beeGiftListview.tag = 202;
    _beeGiftListview = beeGiftListview;
    _beeGiftListview.channelID = self.channelID;
    [self.bgview addSubview:beeGiftListview];
}

/**
 * 玩法说明
 */
- (void)gameBeeExplain{
    // 待优化
    self.view.tag = 100;
    
    [self.bgview removeFromSuperview];
    [self.view addSubview:self.bgview];
    
    PopBeeExplainview *beeExplainview = [[PopBeeExplainview alloc ] initWithFrame:CGRectMake(0, __MainScreen_Height - 316 , __MainScreen_Width, 316)];
    beeExplainview.tag = 203;
    _beeExplainview = beeExplainview;
    [self.bgview addSubview:beeExplainview];
}

/**
 * 进入收银台
 */
- (void)gameBeeInCashierDesk{

    if ([self userHasLogin]) {
        return ;
    }
    self.view.hidden = YES;
    __weak typeof(self) weakSelf = self;
    SYMyCoinViewController *coinVC = [[SYMyCoinViewController alloc] init];
    coinVC.roomId = weakSelf.channelID;
    [coinVC requestMyCoin];
    coinVC.resultBlock = ^{
        weakSelf.view.hidden = NO;
        [weakSelf getcoin];
    };
    [weakSelf.vc.navigationController pushViewController:coinVC animated:YES];
}

/**
 * 遮罩
 */
- (UIView *)bgview
{
    if(!_bgview){
        _bgview = [[UIView alloc ] initWithFrame:self.view.bounds];
        _bgview.backgroundColor = [UIColor colorWithRed:1.0f/255.0f green:1.0f/255.0f blue:1.0f/255.0f alpha:0.6f];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc ]init];
        [tap addTarget:self action:@selector(closbg)];
        [_bgview addGestureRecognizer:tap];
    }
    return _bgview;
}

- (SYGiftNetManager *)netManager {
    if (!_netManager) {
        _netManager = [[SYGiftNetManager alloc] init];
    }
    return _netManager;
}

/**
 * 余额不足
 */
- (void)voiceRoomInputViewLackOfBalance{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"余额不足" message:@"请前往充值"   preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                   }];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"去充值" style:UIAlertActionStyleDestructive
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        SYMyCoinViewController *coinVC = [[SYMyCoinViewController alloc] init];
                                                        coinVC.roomId = weakSelf.channelID;
                                                        [coinVC requestMyCoin];
                                                        coinVC.resultBlock = ^{
                                                            weakSelf.view.hidden = NO;
                                                            [weakSelf getcoin];
                                                        };
                                                        [weakSelf.vc.navigationController pushViewController:coinVC animated:YES];
                                                    }];
    weakSelf.view.hidden = YES;
    [alert addAction:action];
    [alert addAction:action1];
    [self.vc presentViewController:alert
                          animated:YES
                        completion:nil];
}

- (void)getcoin{
    __weak typeof(self) weakSelf = self;
    SYWalletNetWorkManager *newWork = [[SYWalletNetWorkManager alloc] init];
    [newWork requestWallet:^(id  _Nullable response) {
        if ([response isKindOfClass:[NSNumber class]]) {
            NSInteger num = [(NSNumber *)response integerValue];
            [weakSelf.beeView updateBeeCoin:num];
        }
    } failure:^(NSError * _Nullable error) {
    }];
}

@end
