//
//  SYVoiceRoomBoardView.m
//  Shining
//
//  Created by mengxiangjian on 2019/4/24.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomBoardView.h"
#import "SYLeaderBoardViewModel.h"

#define kSYVoiceRoomBoardImageViewTag 30302

@interface SYVoiceRoomBoardView ()

@property (nonatomic, strong) SYLeaderBoardViewModel *viewModel;
@property (nonatomic, strong) UIButton *entranceButton;
@property (nonatomic, assign) SYVoiceRoomBoardViewType type;

@end

@implementation SYVoiceRoomBoardView

- (instancetype)initWithFrame:(CGRect)frame
                    channelID:(NSString *)channelID {
    return [self initWithFrame:frame channelID:channelID
                          type:SYVoiceRoomBoardViewTypeVoiceRoom];
}

- (instancetype)initWithFrame:(CGRect)frame
                    channelID:(NSString *)channelID
                         type:(SYVoiceRoomBoardViewType)type {
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        _viewModel = [[SYLeaderBoardViewModel alloc] initWithViewChannelID:channelID
                                                                      type:SYLeaderBoardViewTypeOutcome];
        [self addSubview:self.entranceButton];
    }
    return self;
}

- (void)requestData {
    __weak typeof(self) weakSelf = self;
    [self.viewModel requestDataListWithTimeRange:SYGiftTimeRangeWeekly
                                           block:^(BOOL success) {
                                               if (success) {
                                                   [weakSelf drawLeaderBoard];
                                               }
                                           }];
}

- (void)drawLeaderBoard {
    NSInteger count = MIN([self.viewModel rowCount], 3);
    for (int i = 0; i < count; i ++) {
        UIView *view = [self avatarViewWithIndex:i totalCount:count];
        [self addSubview:view];
    }
}

- (UIView *)avatarViewWithIndex:(NSInteger)index
                     totalCount:(NSInteger)count {
    CGFloat space = 31.f;
    NSArray *imageNames = @[@"voiceroom_crown_gold_s",@"voiceroom_crown_silver_s",@"voiceroom_crown_bronze_s"];
    CGFloat base = (3 - count) * space;
    CGFloat x = base + space * index;
    CGFloat width = 28.f;
    CGFloat height = 32.f;
    CGFloat y = (self.sy_height - height) / 2.f;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    if (index >= 0 && index < 3) {
        imageView.image = [UIImage imageNamed_sy:imageNames[index]];
    }
    
    UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.sy_width - 1.f - 24.f, imageView.sy_height - 1.f - 24.f, 24.f, 24.f)];
    avatarView.layer.cornerRadius = 12.f;
    avatarView.clipsToBounds = YES;
    [avatarView sd_setImageWithURL:[NSURL URLWithString:[self.viewModel avatarAtIndex:index]]
                  placeholderImage:[UIImage imageNamed_sy:@"voiceroom_placeholder"]];
    [imageView addSubview:avatarView];
    imageView.userInteractionEnabled = YES;
    imageView.tag = kSYVoiceRoomBoardImageViewTag + index;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tap:)];
    [imageView addGestureRecognizer:tap];
    return imageView;
}

- (void)tap:(id)sender {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    UIView *view = [tap view];
    NSInteger index = view.tag - kSYVoiceRoomBoardImageViewTag;
    NSString *uid = [self.viewModel userIDAtIndex:index];
    if (uid && [self.delegate respondsToSelector:@selector(voiceRoomBoardViewDidTouchUserWithUid:)]) {
        [self.delegate voiceRoomBoardViewDidTouchUserWithUid:uid];
    }
}

- (UIButton *)entranceButton {
    if (!_entranceButton) {
        _entranceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat height = 30.f;
        CGFloat y = (self.sy_height - height) / 2.f + 3.f;
        _entranceButton.frame = CGRectMake(93.f, y, height, height);
        NSString *name = (self.type == SYVoiceRoomBoardViewTypeVoiceRoom) ? @"voiceroom_board_entrance" : @"voiceroom_board_entrance_live";
        [_entranceButton setImage:[UIImage imageNamed_sy:name]
                         forState:UIControlStateNormal];
        [_entranceButton addTarget:self
                            action:@selector(enter:)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    return _entranceButton;
}

- (void)enter:(id)sender {
    if ([self.delegate respondsToSelector:@selector(voiceRoomBoardViewDidEnterLeaderBoard)]) {
        [self.delegate voiceRoomBoardViewDidEnterLeaderBoard];
    }
}

+ (CGFloat)minimumWidth {
    return 117.f;
}

@end
