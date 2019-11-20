//
//  SYVoiceRoomPKView.m
//  Shining
//
//  Created by mengxiangjian on 2019/7/2.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomExtView.h"
#import "SYLiveUserToolItemCell.h"
#import "SYUserServiceAPI.h"

@interface SYVoiceRoomExtView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) BOOL isPKing;
@property (nonatomic, assign) BOOL isAnimationOff;
@property (nonatomic, assign) BOOL isOpenChartHide; //是否开启榜单隐身
@property (nonatomic, assign) BOOL isShowClear;//是否显示清屏
@property (nonatomic, assign) BOOL isShowPK;//是否显示PK
@property (nonatomic, assign) BOOL isShowRedPackage;//是否显示红包
@property (nonatomic, assign) BOOL isShowChartHide; //是否显示榜单隐身
@property (nonatomic, assign) BOOL hasUnreadMsg;//是否有未读消息
@property (nonatomic, assign) BOOL isShowPrivateMsg;//是否显示私信

@property (nonatomic, weak) SYVoiceChatRoomViewModel *viewModel;


@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *containerView;
// =============PK==============
@property (nonatomic, strong) UIButton *pkButton;
@property (nonatomic, strong) UILabel *pkLabel;
@property (nonatomic, strong) UILabel *pkIndicator;

@property(strong,nonatomic)UICollectionView*topToolCollectionView;
@property(strong,nonatomic)UICollectionView*bottomToolCollectionView;
@property (nonatomic, strong) UILabel *lineLabel;
@property(strong,nonatomic)NSArray*viewInfoArr;

@end

@implementation SYVoiceRoomExtView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _isPKing = NO;
        self.isAnimationOff = [SYSettingManager isAnimationOff];
        self.isOpenChartHide = [SYSettingManager isChartHide];
        [self setPKing:NO];
        self.isShowPK = NO;
        self.isShowClear = NO;
        self.isShowPrivateMsg = NO;
        self.isShowChartHide = NO;
        if ([SYSettingManager getGroupredSwitch]) {
            self.isShowRedPackage = YES;
        }else {
            self.isShowRedPackage = NO;
        }
        [self updateDataSource];
        [self addSubview:self.maskView];
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.topToolCollectionView];
        [self.containerView addSubview:self.lineLabel];
        [self.containerView addSubview:self.bottomToolCollectionView];

    }
    return self;
}


- (void)setVoiceViewModel:(SYVoiceChatRoomViewModel *)voiceViewModel roomType:(BOOL)isLive {
    self.viewModel = voiceViewModel;
    self.isShowPrivateMsg = isLive;
    if (self.viewModel.initialRole >= SYChatRoomUserRoleAdminister) {
        self.isShowPK = YES;
        self.isShowClear = YES;
        [self setPKing:voiceViewModel.isPKing];
    }else {
        self.isShowPK = NO;
        self.isShowClear = NO;
        [self setPKing:YES];
    }
    if ([SYSettingManager getGroupredSwitch]) {
        self.isShowRedPackage = YES;
    }else {
        self.isShowRedPackage = NO;
    }
    if(self.viewModel.myself.level >= [SYSettingManager getChartHideLevel]) {
        self.isShowChartHide = YES;
    }else{
        self.isShowChartHide = NO;
    }
    [self updateDataSource];
    [self.topToolCollectionView reloadData];
    [self.bottomToolCollectionView reloadData];
    
    [self checkChartHideisOpen];
}

- (void)setVoiceViewModel:(SYVoiceChatRoomViewModel *)voiceViewModel {
    [self setVoiceViewModel:voiceViewModel roomType:NO];
}


- (void)setHasUnreadMessage:(BOOL)hasUnread {
    if (_hasUnreadMsg != hasUnread) {
        _hasUnreadMsg = hasUnread;
        [self.topToolCollectionView reloadData];
    }

}

- (void)setPKing:(BOOL)pking {
    self.isPKing = pking;
    [self.bottomToolCollectionView reloadData];
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tap:)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

- (UIView *)containerView {
    if (!_containerView) {
        CGFloat height = 224.f*dp;
        if (iPhoneX) {
            height += 34.f;
        }
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.sy_height - height, self.sy_width, height)];
        _containerView.backgroundColor = [UIColor sy_colorWithHexString:@"#FFFFFF"];
        _containerView.layer.cornerRadius = 10.f;
        _containerView.clipsToBounds = YES;
    }
    return _containerView;
}


- (void)buttonAction:(id)sender {
    if (self.isPKing) {
        if ([self.delegate respondsToSelector:@selector(voiceRoomExtViewDidStopPK)]) {
            [self.delegate voiceRoomExtViewDidStopPK];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(voiceRoomExtViewDidStartPK)]) {
            [self.delegate voiceRoomExtViewDidStartPK];
        }
    }
}

- (void)clearAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(voiceRoomExtViewDidClearPublicScreen)]) {
        [self.delegate voiceRoomExtViewDidClearPublicScreen];
    }
}


- (void)redPctAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(voiceRoomExtViewDidRedPct)]) {
        [self.delegate voiceRoomExtViewDidRedPct];
    }
}


- (void)tap:(id)sender {
    [self removeFromSuperview];
}

- (void)animationSwitchAction:(id)sender {
    self.isAnimationOff = !self.isAnimationOff;
    if ([self.delegate respondsToSelector:@selector(animationSwitchAction:)]) {
        [self.delegate animationSwitchAction:self.isAnimationOff];
    }
}

- (void)chartHideSwitchAction:(id)sender {
    self.isOpenChartHide = !self.isOpenChartHide;
    if ([self.delegate respondsToSelector:@selector(voiceRoomExtViewDidChartHideAction:)]) {
        [self.delegate voiceRoomExtViewDidChartHideAction:self.isOpenChartHide];
    }
}

- (UICollectionView *)topToolCollectionView {
    if (!_topToolCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _topToolCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, self.containerView.sy_width,  90*dp) collectionViewLayout:layout];
        _topToolCollectionView.delegate = self;
        _topToolCollectionView.dataSource = self;
        [_topToolCollectionView registerClass:[SYLiveUserToolItemCell class]
                forCellWithReuseIdentifier:@"cell"];
        _topToolCollectionView.backgroundColor = [UIColor clearColor];
        _topToolCollectionView.showsHorizontalScrollIndicator = NO;
        _topToolCollectionView.bounces = NO;
    }
    return _topToolCollectionView;
}


- (UILabel *)lineLabel {
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.topToolCollectionView.sy_bottom+2*dp, self.sy_width,  0.5*dp)];
        _lineLabel.backgroundColor = [UIColor sy_colorWithHexString:@"#000000" alpha:0.1];
    }
    return _lineLabel;
}

- (UICollectionView *)bottomToolCollectionView {
    if (!_bottomToolCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _bottomToolCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.lineLabel.sy_bottom, self.sy_width,  90*dp) collectionViewLayout:layout];
        _bottomToolCollectionView.delegate = self;
        _bottomToolCollectionView.dataSource = self;
        [_bottomToolCollectionView registerClass:[SYLiveUserToolItemCell class]
                forCellWithReuseIdentifier:@"cell"];
        _bottomToolCollectionView.backgroundColor = [UIColor clearColor];
        _bottomToolCollectionView.showsHorizontalScrollIndicator = NO;
        _bottomToolCollectionView.bounces = NO;
    }
    return _bottomToolCollectionView;
}



#pragma mark - collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSDictionary*dic = nil;
    if (collectionView == self.topToolCollectionView) {
         dic = [self.viewInfoArr objectAtIndex:0];
    }else if(collectionView == self.bottomToolCollectionView) {
        dic = [self.viewInfoArr objectAtIndex:1];
    }
    NSArray*arr = dic[@"icons"];
    if (arr) {
        return arr.count;
    }else {
        return 0;
    }

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.sy_width/5.f, 90*dp);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SYLiveUserToolItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                           forIndexPath:indexPath];
    NSInteger index = 0;
    if (collectionView == self.bottomToolCollectionView) {
        index = 1;
    }
    NSString*iconName = [[[self.viewInfoArr objectAtIndex:index] objectForKey:@"icons"] objectAtIndex:indexPath.item];

    NSString*title = [[[self.viewInfoArr objectAtIndex:index] objectForKey:@"names"] objectAtIndex:indexPath.item];
    UIImage*icon = [UIImage imageNamed_sy:iconName];
    SYLiveRoomUserActionType type = [[[[self.viewInfoArr objectAtIndex:index] objectForKey:@"types"] objectAtIndex:indexPath.item] integerValue];
    if (type == SYLiveRoomUserActionType_PK) {
        [cell setIcon:icon andTitle:title];
        [cell setPKing:self.isPKing];
    }else if(type == SYLiveRoomUserActionType_privateMsg) {
        [cell setIcon:icon andTitle:title showRedIcon:self.hasUnreadMsg];
        [cell setPKing:YES];
    }else {
        [cell setIcon:icon andTitle:title];
        [cell setPKing:YES];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath:%@",indexPath);
    NSInteger index = 0;
    if (collectionView == self.bottomToolCollectionView) {
        index = 1;
    }
    SYLiveRoomUserActionType type = [[[[self.viewInfoArr objectAtIndex:index] objectForKey:@"types"] objectAtIndex:indexPath.item] integerValue];
    if (type == SYLiveRoomUserActionType_closeAnimation) {
        [self animationSwitchAction:nil];
        SYLiveUserToolItemCell*item = (SYLiveUserToolItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
        NSString*iconName = self.isAnimationOff?@"SYLiveRoomUserTool_openAnimation":@"SYLiveRoomUserTool_closeAnimation";
        NSString*title = self.isAnimationOff ? @"打开动效": @"关闭动效";
        UIImage*icon = [UIImage imageNamed_sy:iconName];
        [item setIcon:icon andTitle:title];
    }else if (type == SYLiveRoomUserActionType_clear) {
        [self clearAction:nil];
    }else if (type == SYLiveRoomUserActionType_redpackage) {
        [self redPctAction:nil];
    }else if (type == SYLiveRoomUserActionType_privateMsg) {
        SYLiveUserToolItemCell*item = (SYLiveUserToolItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
        self.hasUnreadMsg = NO;
        [item updateRedState:NO];
        if ([self.delegate respondsToSelector:@selector(voiceRoomExtViewDidPrivateMsg)]) {
            [self.delegate voiceRoomExtViewDidPrivateMsg];
        }
    }else if (type == SYLiveRoomUserActionType_PK) {
        [self buttonAction:nil];
    }else if (type == SYLiveRoomUserActionType_hide) {
        [self chartHideSwitchAction:nil];
        SYLiveUserToolItemCell*item = (SYLiveUserToolItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
        NSString*iconName = self.isOpenChartHide?@"SYLiveRoomUserTool_chartHide_cancel":@"SYLiveRoomUserTool_chartHide";
        NSString*title = self.isOpenChartHide ? @"榜单显示": @"榜单隐身";
        UIImage*icon = [UIImage imageNamed_sy:iconName];
        [item setIcon:icon andTitle:title];
    }
}


- (void)updateDataSource {

    NSMutableDictionary *bottomDict = [NSMutableDictionary new];
    NSMutableArray *icons = [NSMutableArray new];
    NSMutableArray *names = [NSMutableArray new];
    NSMutableArray *types = [NSMutableArray new];
    if (self.isShowPK) {
        [icons addObject:@"voiceroom_pk_icon"];
        [names addObject:@"PK"];
        [types addObject:@(SYLiveRoomUserActionType_PK)];
    }
    if(self.isShowRedPackage) {
        [icons addObject:@"voiceroom_redPacket_icon"];
        [names addObject:@"红包"];
        [types addObject:@(SYLiveRoomUserActionType_redpackage)];
    }
    if(self.isShowClear) {
        [icons addObject:@"voiceroom_clear_icon"];
        [names addObject:@"清屏"];
        [types addObject:@(SYLiveRoomUserActionType_clear)];
    }
    if(icons && icons.count > 0) {
        [bottomDict setObject:icons forKey:@"icons"];
        [bottomDict setObject:names forKey:@"names"];
        [bottomDict setObject:types forKey:@"types"];
    }

    NSMutableDictionary *topDict = [NSMutableDictionary new];
    NSMutableArray *topIcons = [NSMutableArray new];
    NSMutableArray *topNames = [NSMutableArray new];
    NSMutableArray *topTypes = [NSMutableArray new];
    if (self.isShowPrivateMsg) {
        [topIcons addObject:@"SYLiveRoomUserTool_PrivateMsg"];
        [topNames addObject:@"私信"];
        [topTypes addObject:@(SYLiveRoomUserActionType_privateMsg)];
    }
    [topIcons addObject:self.isAnimationOff?@"SYLiveRoomUserTool_openAnimation":@"SYLiveRoomUserTool_closeAnimation"];
   
    [topNames addObject:self.isAnimationOff?@"打开动效":@"关闭动效"];
    [topTypes addObject:@(SYLiveRoomUserActionType_closeAnimation)];
    
    if(self.isShowChartHide){
         [topIcons addObject:self.isOpenChartHide?@"SYLiveRoomUserTool_chartHide_cancel":@"SYLiveRoomUserTool_chartHide"];
        [topNames addObject:self.isOpenChartHide?@"榜单显示":@"榜单隐身"];
        [topTypes addObject:@(SYLiveRoomUserActionType_hide)];

    }
    if(topIcons && topIcons.count > 0) {
        [topDict setObject:topIcons forKey:@"icons"];
        [topDict setObject:topNames forKey:@"names"];
        [topDict setObject:topTypes forKey:@"types"];
    }
    self.viewInfoArr = @[topDict,bottomDict];
}

- (void)checkChartHideisOpen
{
    [[SYUserServiceAPI sharedInstance]requestUserPropertyValue:@"toplist_invisible" sucess:^(BOOL isOpen) {
        self.isOpenChartHide = isOpen;
        [self updateDataSource];
        [self.topToolCollectionView reloadData];
    } failure:^(NSError * _Nullable error) {
        
    }];
}

@end
