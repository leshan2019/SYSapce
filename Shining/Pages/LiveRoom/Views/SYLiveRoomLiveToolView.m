//
//  SYLiveRoomLiveToolView.m
//  Shining
//
//  Created by leeco on 2019/9/26.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveRoomLiveToolView.h"
#import "SYLiveRoomLiveToolCell.h"
@interface SYLiveRoomLiveToolView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(strong,nonatomic)UIView*bgView;
@property(strong,nonatomic)UICollectionView*toolCollectionView;
@property(strong,nonatomic)NSArray*viewInfoArr;
@property(assign,nonatomic)BOOL isHost;
@end
@implementation SYLiveRoomLiveToolView

- (instancetype)initWithFrame:(CGRect)frame mirroOpen:(BOOL)isOpen {
    self = [super initWithFrame:frame];
    if (self) {
        self.animationClose = [SYSettingManager isAnimationOff];
        self.mirrorOpen = isOpen;
        self.chartHide = [SYSettingManager isChartHide];
        self.isHost = YES;
        [self addSubview:self.bgView];
        //毛玻璃
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *_effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _effectView.frame = CGRectMake(0, self.sy_height- 355*dp, self.sy_width,  355*dp);
        [self.bgView addSubview:_effectView];
        [self updateDataSource];
        [self addSubview:self.toolCollectionView];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame isHost:(BOOL)isHost {
    self = [super initWithFrame:frame];
    if (self) {
        self.animationClose = [SYSettingManager isAnimationOff];
        self.isHost = isHost;
        self.chartHide = [SYSettingManager isChartHide];
        [self addSubview:self.bgView];
        //毛玻璃
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *_effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _effectView.frame = CGRectMake(0, self.sy_height- 355*dp, self.sy_width,  355*dp);
        [self.bgView addSubview:_effectView];
        [self updateDataSource];
        [self addSubview:self.toolCollectionView];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.animationClose = [SYSettingManager isAnimationOff];
        self.chartHide = [SYSettingManager isChartHide];
        [self updateDataSource];
        [self addSubview:self.bgView];
        //毛玻璃
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *_effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _effectView.frame = CGRectMake(0, self.sy_height- 355*dp, self.sy_width,  355*dp);
        [self.bgView addSubview:_effectView];
        [self addSubview:self.toolCollectionView];
        
    }
    return self;
}


- (void)updateHostState:(BOOL)isHost {
    if (_isHost != isHost) {
        self.isHost = isHost;
        [self updateDataSource];
        [_toolCollectionView reloadData];
    }

}


- (void)updateDataSource {
    BOOL isShowRedPacket = [SYSettingManager getGroupredSwitch];
    if (self.isHost) {
        if (isShowRedPacket) {
            self.viewInfoArr = @[
            @{@"title":@"直播工具",
              @"icons":@[@"roomTool_rollback",@"roomTool_clear",@"roomTool_mirror",@"roomTool_biggerFont",@"roomTool_beauty",self.animationClose?@"liveroomToolBar_openAnimation":@"liveroomToolBar_closeAnimation",@"liveroomToolBar_redpacket",self.chartHide?@"liveroomToolBar_chartHide_cancel":@"liveroomToolBar_chartHide"],
              @"names":@[@"反转",@"清屏",self.mirrorOpen?@"镜像开": @"镜像关",@"大字幕",@"美颜",self.animationClose?@"打开动效":@"关闭动效",@"发红包",self.chartHide?@"榜单显示":@"榜单隐身"],
              @"types":@[
                      @(SYLiveRoomLiveToolViewActionType_rollback),
                      @(SYLiveRoomLiveToolViewActionType_clear),
                      @(SYLiveRoomLiveToolViewActionType_mirror),
                      @(SYLiveRoomLiveToolViewActionType_biggerFont),
                      @(SYLiveRoomLiveToolViewActionType_beauty),
                      @(SYLiveRoomLiveToolViewActionType_closeAnimation),
                      @(SYLiveRoomLiveToolViewActionType_redpackage),
                      @(SYLiveRoomLiveToolViewActionType_hide),
                      ]
              },
            @{@"title":@"房间设置",
              @"icons":@[@"roomTool_roomInfo"],
              @"names":@[@"房间信息管理"],
              @"types":@[@(SYLiveRoomLiveToolViewActionType_roomInfo)]
              }
            ];
        }else {
            self.viewInfoArr = @[
            @{@"title":@"直播工具",
              @"icons":@[@"roomTool_rollback",@"roomTool_clear",@"roomTool_mirror",@"roomTool_biggerFont",@"roomTool_beauty",self.animationClose?@"liveroomToolBar_openAnimation":@"liveroomToolBar_closeAnimation",self.chartHide?@"liveroomToolBar_chartHide_cancel":@"liveroomToolBar_chartHide"],
              @"names":@[@"反转",@"清屏",self.mirrorOpen?@"镜像开": @"镜像关",@"大字幕",@"美颜",self.animationClose?@"打开动效":@"关闭动效",self.chartHide?@"榜单显示":@"榜单隐身"],
              @"types":@[
                      @(SYLiveRoomLiveToolViewActionType_rollback),
                      @(SYLiveRoomLiveToolViewActionType_clear),
                      @(SYLiveRoomLiveToolViewActionType_mirror),
                      @(SYLiveRoomLiveToolViewActionType_biggerFont),
                      @(SYLiveRoomLiveToolViewActionType_beauty),
                      @(SYLiveRoomLiveToolViewActionType_closeAnimation),
                      @(SYLiveRoomLiveToolViewActionType_hide)
                      ]
              },
            @{@"title":@"房间设置",
              @"icons":@[@"roomTool_roomInfo"],
              @"names":@[@"房间信息管理"],
              @"types":@[@(SYLiveRoomLiveToolViewActionType_roomInfo)]
              }
            ];
        }
    }else {
        if (isShowRedPacket) {
            self.viewInfoArr = @[
                   @{@"title":@"直播工具",
                     @"icons":@[@"voiceroom_private_msg",self.animationClose?@"liveroomToolBar_openAnimation":@"liveroomToolBar_closeAnimation",@"liveroomToolBar_redpacket",self.chartHide?@"liveroomToolBar_chartHide_cancel":@"liveroomToolBar_chartHide"],
                     @"names":@[@"私信",self.animationClose?@"打开动效":@"关闭动效",@"发红包",self.chartHide?@"榜单显示":@"榜单隐身"],
                     @"types":@[
                             @(SYLiveRoomLiveToolViewActionType_privateMsg),
                             @(SYLiveRoomLiveToolViewActionType_closeAnimation),
                             @(SYLiveRoomLiveToolViewActionType_redpackage),
                             @(SYLiveRoomLiveToolViewActionType_hide)
                             ]
                     }
                   ];
        }else {
            self.viewInfoArr = @[
                   @{@"title":@"直播工具",
                     @"icons":@[@"voiceroom_private_msg",self.animationClose?@"liveroomToolBar_openAnimation":@"liveroomToolBar_closeAnimation",self.chartHide?@"liveroomToolBar_chartHide_cancel":@"liveroomToolBar_chartHide"],
                     @"names":@[@"私信",self.animationClose?@"打开动效":@"关闭动效",self.chartHide?@"榜单显示":@"榜单隐身"],
                     @"types":@[
                             @(SYLiveRoomLiveToolViewActionType_privateMsg),
                             @(SYLiveRoomLiveToolViewActionType_closeAnimation),
                             @(SYLiveRoomLiveToolViewActionType_hide)
                             ]
                     }
                   ];
        }
    }
}

- (UICollectionView *)toolCollectionView {
    if (!_toolCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _toolCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.sy_height- 355*dp+1, self.sy_width,  355*dp) collectionViewLayout:layout];
        _toolCollectionView.delegate = self;
        _toolCollectionView.dataSource = self;
        [_toolCollectionView registerClass:[SYLiveRoomLiveToolCell class]
                forCellWithReuseIdentifier:@"cell"];

        [_toolCollectionView registerClass:[SYLiveRoomLiveToolHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        
        _toolCollectionView.backgroundColor = [UIColor clearColor];
        _toolCollectionView.showsHorizontalScrollIndicator = NO;
        _toolCollectionView.bounces = NO;
    }
    return _toolCollectionView;
}
- (UIView *)bgView{
    if (!_bgView) {
        UIView*bg = [[UIView alloc]initWithFrame:self.bounds];
        bg.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tap:)];
        [bg addGestureRecognizer:tap];
        _bgView = bg;
    }
    return _bgView;
}
-(void)tap:(id)sender{
    NSLog(@"SYLiveRoomLiveToolView tap");
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(liveRoomToolView_userCancel)]) {
        [self.delegate liveRoomToolView_userCancel];
    }

}
#pragma mark - collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.viewInfoArr.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSDictionary*dic = self.viewInfoArr[section];
    NSArray*arr = dic[@"icons"];
    return arr.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.sy_width/4.f, 75*dp);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SYLiveRoomLiveToolCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                           forIndexPath:indexPath];
    NSString*iconName = self.viewInfoArr[indexPath.section][@"icons"][indexPath.item];
    NSString*title = self.viewInfoArr[indexPath.section][@"names"][indexPath.item];
    UIImage*icon = [UIImage imageNamed_sy:iconName];
    [cell setIcon:icon andTitle:title];
    return cell;
}
- (SYLiveRoomLiveToolViewActionType)extracted:(NSIndexPath * _Nonnull)indexPath {
    SYLiveRoomLiveToolViewActionType type = [self.viewInfoArr[indexPath.section][@"types"][indexPath.item] integerValue];
    return type;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath:%@",indexPath);

    SYLiveRoomLiveToolViewActionType type = [self extracted:indexPath];
    
    if (type == SYLiveRoomLiveToolViewActionType_mirror) {
        SYLiveRoomLiveToolCell*item = (SYLiveRoomLiveToolCell *)[collectionView cellForItemAtIndexPath:indexPath];
        self.mirrorOpen = !self.mirrorOpen;
        NSString*iconName = self.viewInfoArr[indexPath.section][@"icons"][indexPath.item];
        NSString*title = self.mirrorOpen ? @"镜像开": @"镜像关";
        UIImage*icon = [UIImage imageNamed_sy:iconName];
        [item setIcon:icon andTitle:title];

    }else if (type == SYLiveRoomLiveToolViewActionType_closeAnimation) {
            SYLiveRoomLiveToolCell*item = (SYLiveRoomLiveToolCell *)[collectionView cellForItemAtIndexPath:indexPath];
            self.animationClose = !self.animationClose;
        NSString*iconName = self.animationClose?@"liveroomToolBar_openAnimation":@"liveroomToolBar_closeAnimation";
            NSString*title = self.animationClose ? @"打开动效": @"关闭动效";
            UIImage*icon = [UIImage imageNamed_sy:iconName];
            [item setIcon:icon andTitle:title];
    }else if (type == SYLiveRoomLiveToolViewActionType_hide) {
            SYLiveRoomLiveToolCell*item = (SYLiveRoomLiveToolCell *)[collectionView cellForItemAtIndexPath:indexPath];
            self.chartHide = !self.chartHide;
        NSString*iconName = self.chartHide?@"liveroomToolBar_chartHide_cancel":@"liveroomToolBar_chartHide";
            NSString*title = self.chartHide ? @"榜单显示": @"榜单隐身";
            UIImage*icon = [UIImage imageNamed_sy:iconName];
            [item setIcon:icon andTitle:title];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(liveRoomToolView_clickBtn:other:)]) {
        NSNumber *other = nil;
        if (type == SYLiveRoomLiveToolViewActionType_closeAnimation) {
            other = [NSNumber numberWithBool:self.animationClose];
        }else if(type == SYLiveRoomLiveToolViewActionType_mirror) {
            other = [NSNumber numberWithBool:self.mirrorOpen];
        }else if(type == SYLiveRoomLiveToolViewActionType_hide) {
            other = [NSNumber numberWithBool:self.chartHide];
        }
        [self.delegate liveRoomToolView_clickBtn:type other:other];
    }
    
//    [self removeFromSuperview];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.sy_width, 52*dp);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    SYLiveRoomLiveToolHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    NSString*title = self.viewInfoArr[indexPath.section][@"title"];
    headerView.headerTitleLabel.text = title;
    return headerView;
}
- (void)showToast:(NSString *)toast {
//    MBProgressHUD *hud0 = [MBProgressHUD showHUDAddedTo:self.toolCollectionView animated:YES];
//    hud0.labelText = toast;
//    hud0.mode = MBProgressHUDModeText;
//    [hud0 hide:YES afterDelay:30.f];
    [SYToastView sy_showToast:toast onView:self.toolCollectionView];

}



- (void)setMirrorOpen:(BOOL)mirrorOpen {
    if (mirrorOpen != _mirrorOpen) {
        _mirrorOpen = mirrorOpen;
        [self updateDataSource];
        [_toolCollectionView reloadData];
    }else if(!self.viewInfoArr){
        [self updateDataSource];
    }
}


@end

@implementation SYLiveRoomLiveToolHeader

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self createBasicView];
    }
    return self;
    
}

-(void)createBasicView{
    
    _headerTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0,self.frame.size.width-32, 20)];
    _headerTitleLabel.textColor = [UIColor whiteColor];
    _headerTitleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_headerTitleLabel];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.headerTitleLabel.sy_top = (self.sy_height-20)/2.f;
}

@end
