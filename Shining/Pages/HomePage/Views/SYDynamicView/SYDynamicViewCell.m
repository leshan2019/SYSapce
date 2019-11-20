//
//  SYDynamicViewCell.m
//  Shining
//
//  Created by yangxuan on 2019/10/21.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYDynamicViewCell.h"
#import "SYDynamicPhotoView.h"
#import "SYDynamicVideoView.h"
#import "SYDynamicToolView.h"
#import "SYVoiceRoomSexView.h"
#import "SYDynamicLocationView.h"

@interface SYDynamicViewCell ()

@property (nonatomic, strong) UIImageView *avatarView;          // 头像
@property (nonatomic, strong) UILabel *nameLabel;               // 姓名
@property (nonatomic, strong) UIButton *isLivingBtn;            // 直播中
@property (nonatomic, strong) UIButton *deleteBtn;              // 删除
@property (nonatomic, strong) SYVoiceRoomSexView *sexView;      // 性别
@property (nonatomic, strong) UIButton *attentionBtn;           // 关注
@property (nonatomic, strong) UILabel *titleLabel;              // 主题
@property (nonatomic, strong) SYDynamicPhotoView *photoView;    // 图片
@property (nonatomic, strong) SYDynamicVideoView *videoView;    // 视频
@property (nonatomic, strong) SYDynamicLocationView *locationView;             // 定位
@property (nonatomic, strong) UILabel *timeLabel;               // 时间
@property (nonatomic, strong) SYDynamicToolView *toolView;      // 点赞,评论,打招呼
@property (nonatomic, strong) UIView *bottomLine;               // 分割线

@property (nonatomic, strong) NSString *momentId;               // 动态id
@property (nonatomic, strong) NSString *roomId;                 // 房间id
@property (nonatomic, strong) NSString *userId;                 // 用户id
@property (nonatomic, strong) UserProfileEntity *userModel;     // 用户model

@property (nonatomic, assign) NSInteger commentNum;

@end

@implementation SYDynamicViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

#pragma mark - Public

- (void)configueHomepageDynamicCell:(NSString *)momentId userId:(NSString *)userId avatar:(NSString *)avatarUrl name:(NSString *)name gender:(NSString *)gender age:(NSInteger)age showDeleteBtn:(BOOL)showDelete title:(NSString *)title photoArr:(NSArray *)photoArr videoDic:(NSDictionary *)videoDic location:(NSString *)location time:(NSString *)time hasClickLike:(BOOL)like likeNum:(NSInteger)likeNum commentNum:(NSInteger)commentNum {
    self.momentId = momentId;
    self.userId = userId;
    // avatar
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed_sy:@"mine_head_default"]];
    // name
    self.nameLabel.text = name;
    CGFloat maxWidth = __MainScreen_Width - 64 - 20;
    if (showDelete) {
        maxWidth -= (15+25);
    }
    CGFloat titleWidth = [name sizeWithAttributes:@{NSFontAttributeName: self.nameLabel.font}].width;
    if (titleWidth >= maxWidth) {
        titleWidth = maxWidth;
    }
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(titleWidth+1);
    }];
    // living
    self.isLivingBtn.hidden = YES;
    // gender
    [self.sexView setSex:gender andAge:age];
    CGFloat sexWidth = self.sexView.frame.size.width;
    [self.sexView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(sexWidth);
    }];
    // attention
    self.attentionBtn.hidden = YES;
    // delete
    self.deleteBtn.hidden = !showDelete;
    // title
    self.titleLabel.text = title;
    if (title.length == 0) {
        self.titleLabel.hidden = YES;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarView.mas_bottom).with.offset(0);
            make.height.mas_equalTo(0);
        }];
    } else {
        CGFloat width = self.contentView.sy_width - 2 * 20;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarView.mas_bottom).with.offset(8);
            make.height.mas_equalTo([SYDynamicViewCell heightForTitle:title withWidht:width font:self.titleLabel.font]);
        }];
        self.titleLabel.hidden = NO;
    }
    // photoView && videoView
    CGFloat verticalSpace = 0;
    CGFloat tempHeight = 0;
    if (videoDic) {
        self.photoView.hidden = YES;
        self.videoView.hidden = NO;
        tempHeight = [SYDynamicVideoView calculateVideoViewHeight:videoDic];
        [self.videoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(tempHeight);
        }];
        [self.videoView configueVideoView:videoDic];
        verticalSpace += (6 + tempHeight);
    } else {
        self.videoView.hidden = YES;
        if (photoArr && photoArr.count > 0) {
            self.photoView.hidden = NO;
            tempHeight = [SYDynamicPhotoView calculatePhotoViewHeight:photoArr.count];
            [self.photoView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(tempHeight);
            }];
            [self.photoView configuePhotoView:photoArr];
            verticalSpace = (6 + tempHeight);
        } else {
            self.photoView.hidden = YES;
        }
    }
    // location
    if (location.length == 0) {
        self.locationView.hidden = YES;
        [self.locationView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(verticalSpace);
            make.height.mas_equalTo(0);
        }];
    } else {
        verticalSpace += 6;
        [self.locationView updateLocation:location];
        CGFloat locationWidth = self.locationView.frame.size.width;
        [self.locationView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(verticalSpace);
            make.width.mas_equalTo(locationWidth);
            make.height.mas_equalTo(22);
        }];
        self.locationView.hidden = NO;
    }
    // time
    self.timeLabel.text = time;
    // like+comment
    [self.toolView updateIfHasClickLikeBtn:like];
    [self.toolView updateLikeNum:likeNum];
    [self.toolView updateCommentNum:commentNum];
    [self.toolView showGreetBtn:NO];
    self.commentNum = commentNum;
}

- (void)configueSquareDynamicCell:(NSString *)momentId userId:(NSString *)userId avatar:(NSString *)avatarUrl name:(NSString *)name gender:(NSString *)gender age:(NSInteger)age roomId:(NSString *)roomId hasAttention:(BOOL)attention title:(NSString *)title photoArr:(NSArray *)photoArr videoDic:(NSDictionary *)videoDic location:(NSString *)location time:(NSString *)time hasClickLike:(BOOL)like likeNum:(NSInteger)likeNum commentNum:(NSInteger)commentNum userModel:(UserProfileEntity *)usermodel showGreetBtn:(BOOL)show isUserSelf:(BOOL)isSelf{
    self.momentId = momentId;
    self.userId = userId;
    // avatar
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed_sy:@"mine_head_default"]];
    // editBtn
    self.deleteBtn.hidden = !isSelf;
    if (isSelf) {
        // 如果是自己的动态，直接隐藏关注按钮，只显示删除动态按钮
        attention = YES;
    }
    // attention
    self.attentionBtn.hidden = attention;
    // living
    self.roomId = roomId;
    BOOL isLiving = NO;
    if ([roomId integerValue] > 0) {
        isLiving = YES;
    }
    self.isLivingBtn.hidden = !isLiving;
    // name
    self.nameLabel.text = name;
    CGFloat maxWidth = __MainScreen_Width - 64 - 20;
    if (!attention && isLiving) {
        maxWidth -= (54 + 14 + 10) + (40 + 6);
    } else {
        if (!attention) {
            maxWidth -= (54 + 14 + 10);
        } else if (isLiving) {
            maxWidth -= (20 + 40 + 6);
        }
    }
    CGFloat titleWidth = [name sizeWithAttributes:@{NSFontAttributeName: self.nameLabel.font}].width;
    if (titleWidth >= maxWidth) {
        titleWidth = maxWidth;
    }
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(titleWidth+1);
    }];
    // gender
    [self.sexView setSex:gender andAge:age];
    CGFloat sexWidth = self.sexView.frame.size.width;
    [self.sexView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(sexWidth);
    }];
    // title
    self.titleLabel.text = title;
    if (title.length == 0) {
        self.titleLabel.hidden = YES;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarView.mas_bottom).with.offset(0);
            make.height.mas_equalTo(0);
        }];
    } else {
        self.titleLabel.hidden = NO;
        CGFloat width = self.contentView.sy_width - 2 * 20;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarView.mas_bottom).with.offset(8);
            make.height.mas_equalTo([SYDynamicViewCell heightForTitle:title withWidht:width font:self.titleLabel.font]);
        }];
    }
    // photoView && videoView
    CGFloat verticalSpace = 0;
    CGFloat tempHeight = 0;
    if (videoDic) {
        self.photoView.hidden = YES;
        self.videoView.hidden = NO;
        tempHeight = [SYDynamicVideoView calculateVideoViewHeight:videoDic];
        [self.videoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(tempHeight);
        }];
        [self.videoView configueVideoView:videoDic];
        verticalSpace += (6 + tempHeight);
    } else {
        self.videoView.hidden = YES;
        if (photoArr && photoArr.count > 0) {
            self.photoView.hidden = NO;
            tempHeight = [SYDynamicPhotoView calculatePhotoViewHeight:photoArr.count];
            [self.photoView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(tempHeight);
            }];
            [self.photoView configuePhotoView:photoArr];
            verticalSpace = (6 + tempHeight);
        } else {
            self.photoView.hidden = YES;
        }
    }
    // location
    if (location.length == 0) {
        self.locationView.hidden = YES;
        [self.locationView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(verticalSpace);
            make.height.mas_equalTo(0);
        }];
    } else {
        verticalSpace += 6;
        [self.locationView updateLocation:location];
        CGFloat locationWidth = self.locationView.frame.size.width;
        [self.locationView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).with.offset(verticalSpace);
            make.width.mas_equalTo(locationWidth);
            make.height.mas_equalTo(22);
        }];
        self.locationView.hidden = NO;
    }
    // time
    self.timeLabel.text = time;
    // like+comment
    [self.toolView updateIfHasClickLikeBtn:like];
    [self.toolView updateLikeNum:likeNum];
    [self.toolView updateCommentNum:commentNum];
    [self.toolView showGreetBtn:show];
    self.commentNum = commentNum;
    // userModel
    self.userModel = usermodel;
}

+ (CGFloat)calculateDynamicViewCellHeightByCellWidth:(CGFloat)width title:(NSString *)title photoArr:(NSArray *)photoArr videoDic:(NSDictionary *)videoDic location:(NSString *)location{
    CGFloat cellHeight = 50;
    if (title.length > 0) {
        cellHeight += 8;
        cellHeight += [SYDynamicViewCell heightForTitle:title withWidht:width font:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
    }
    if (videoDic) {
        cellHeight += 6;
        cellHeight += [SYDynamicVideoView calculateVideoViewHeight:videoDic];
    } else if (photoArr && photoArr.count > 0) {
        cellHeight += 6;
        cellHeight += [SYDynamicPhotoView calculatePhotoViewHeight:photoArr.count];
    }
    if (location.length > 0) {
        cellHeight += 6;
        cellHeight += 22;
    }
    cellHeight += (6 + 17 + 26 + 15 + 1);
    return cellHeight;
}

- (void)initSubViews {
    self.contentView.backgroundColor = RGBACOLOR(247,247,247,1);
    [self.contentView addSubview:self.avatarView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.isLivingBtn];
    [self.contentView addSubview:self.sexView];
    [self.contentView addSubview:self.deleteBtn];
    [self.contentView addSubview:self.attentionBtn];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.photoView];
    [self.contentView addSubview:self.videoView];
    [self.contentView addSubview:self.locationView];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.toolView];
    [self.contentView addSubview:self.bottomLine];
    [self mas_makeConstraints];
}

- (void)mas_makeConstraints {
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(20);
        make.top.equalTo(self.contentView).with.offset(16);
        make.size.mas_equalTo(CGSizeMake(34, 34));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarView.mas_right).with.offset(10);
        make.top.equalTo(self.avatarView);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(18);
    }];
    [self.isLivingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).with.offset(6);
        make.centerY.equalTo(self.nameLabel);
        make.size.mas_equalTo(CGSizeMake(40, 14));
    }];
    [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(2);
        make.size.mas_equalTo(CGSizeMake(34, 14));
    }];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-25);
        make.top.equalTo(self.contentView).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    [self.attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-14);
        make.top.equalTo(self.contentView).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(54, 26));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(20);
        make.top.equalTo(self.avatarView.mas_bottom).with.offset(8);
        make.right.equalTo(self.contentView).with.offset(-20);
        make.height.mas_equalTo(0);
    }];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(20);
        make.right.equalTo(self.contentView).with.offset(-20);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(6);
        make.height.mas_equalTo(0);
    }];
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(20);
        make.right.equalTo(self.contentView).with.offset(-20);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(6);
        make.height.mas_equalTo(0);
    }];
    [self.locationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(20);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(0);
        make.width.mas_equalTo(113);
        make.height.mas_equalTo(22);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(20);
        make.top.equalTo(self.locationView.mas_bottom).with.offset(6);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(17);
    }];
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(26);
        make.top.equalTo(self.timeLabel.mas_bottom);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(20);
        make.right.equalTo(self.contentView).with.offset(-20);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.contentView).with.offset(-1);
    }];
}

#pragma mark - Private

+ (CGFloat)heightForTitle:(NSString *)title withWidht:(CGFloat)width font:(UIFont *)font{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    NSAttributedString *string = [[NSAttributedString alloc]initWithString:title attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:style}];
    CGSize size =  [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    // 取整+1
    CGFloat height = ceil(size.height) + 1;
    return height;
}

- (BOOL)checkIfUserHasLogin {
    // 评论
    if (![SYSettingManager userHasLogin]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(SYDynamicViewClickLogin)]) {
            [self.delegate SYDynamicViewClickLogin];
        }
        return NO;
    }
    return YES;
}

// 点击头像
- (void)handleAvatarClick {
    if ([self checkIfUserHasLogin]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(SYDynamicViewClickAvatar:)]) {
            [self.delegate SYDynamicViewClickAvatar:self.userId];
        }
    }
}

// 关注此人
- (void)handleAttentionBtnClick {
    if ([self checkIfUserHasLogin]) {
        __weak typeof(self) weakSelf = self;
        if (self.delegate && [self.delegate respondsToSelector:@selector(SYDynamicViewClickAttentionUser:momentId:block:)]) {
            [self.delegate SYDynamicViewClickAttentionUser:self.userId momentId:self.momentId block:^(BOOL sucess) {
                if (sucess) {
                    weakSelf.attentionBtn.hidden = YES;
                } else {
                    weakSelf.attentionBtn.hidden = NO;
                }
            }];
        }
    }
}

// 删除自己动态
- (void)handleDeleteBtnClick {
    if ([self checkIfUserHasLogin]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(SYDynamicViewClickDelete:)]) {
            [self.delegate SYDynamicViewClickDelete:self.momentId];
        }
    }
}

// 进入直播间
- (void)handleLivingBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(SYDynamicViewClickEnterLivingRoom:)]) {
        [self.delegate SYDynamicViewClickEnterLivingRoom:self.roomId];
    }
}

#pragma mark - Lazyload

- (UIImageView *)avatarView {
    if (!_avatarView) {
        _avatarView = [UIImageView new];
        _avatarView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarView.layer.cornerRadius = 17;
        _avatarView.clipsToBounds = YES;
        _avatarView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAvatarClick)];
        [_avatarView addGestureRecognizer:tapGesture];
    }
    return _avatarView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = RGBACOLOR(228,33,18,1);
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _nameLabel;
}

- (UIButton *)isLivingBtn {
    if (!_isLivingBtn) {
        _isLivingBtn = [UIButton new];
        [_isLivingBtn setImage:[UIImage imageNamed_sy:@"homepage_dynamic_living"] forState:UIControlStateNormal];
        [_isLivingBtn setImage:[UIImage imageNamed_sy:@"homepage_dynamic_living"] forState:UIControlStateHighlighted];
        [_isLivingBtn addTarget:self action:@selector(handleLivingBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _isLivingBtn.hidden = YES;
    }
    return _isLivingBtn;
}

- (SYVoiceRoomSexView *)sexView {
    if (!_sexView) {
        _sexView = [[SYVoiceRoomSexView alloc]initWithFrame:CGRectZero];
    }
    return _sexView;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton new];
        [_deleteBtn setImage:[UIImage imageNamed_sy:@"homepage_dynamic_delete"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(handleDeleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (UIButton *)attentionBtn {
    if (!_attentionBtn) {
        _attentionBtn = [UIButton new];
        _attentionBtn.backgroundColor = RGBACOLOR(240,240,240,1);
        _attentionBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
        _attentionBtn.layer.cornerRadius = 13;
        _attentionBtn.clipsToBounds = YES;
        [_attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_attentionBtn setTitleColor:RGBACOLOR(97,42,224,1) forState:UIControlStateNormal];
        [_attentionBtn setImage:[UIImage imageNamed_sy:@"homepage_dynamic_attention_plus"] forState:UIControlStateNormal];
        [_attentionBtn addTarget:self action:@selector(handleAttentionBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _attentionBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = RGBACOLOR(96,96,96,1);
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (SYDynamicPhotoView *)photoView {
    if (!_photoView) {
        __weak typeof(self) weakSelf = self;
        _photoView = [[SYDynamicPhotoView alloc] initWithFrame:CGRectMake(0, 0, self.sy_width - 20*2, 0) clickPhoto:nil];
    }
    return _photoView;
}

- (SYDynamicVideoView *)videoView {
    if (!_videoView) {
        __weak typeof(self) weakSelf = self;
        _videoView = [[SYDynamicVideoView alloc] initWithFrame:CGRectZero clickVideo:^(NSString * _Nonnull videoUrl) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(SYDynamicViewClickPlayVideo:)]) {
                [weakSelf.delegate SYDynamicViewClickPlayVideo:videoUrl];
            }
        }];
    }
    return _videoView;
}

- (SYDynamicLocationView *)locationView {
    if (!_locationView) {
        _locationView = [[SYDynamicLocationView alloc] initWithFrame:CGRectMake(0, 0, 113, 22)];
    }
    return _locationView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.textColor = RGBACOLOR(187,187,187,1);
        _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}

- (SYDynamicToolView *)toolView {
    if (!_toolView) {
        __weak typeof(self)weakSelf = self;
        _toolView = [[SYDynamicToolView alloc] initSYDynamicToolViewWithFrame:CGRectZero likeBlock:^(BOOL like) {
            if ([weakSelf checkIfUserHasLogin]) {
                // yes:点赞  no:取消点赞
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(SYDynamicViewClickLike:momentId:userId:)]) {
                    [weakSelf.delegate SYDynamicViewClickLike:like momentId:weakSelf.momentId userId:weakSelf.userId];
                }
            }
        } commentBlock:^{
            if ([weakSelf checkIfUserHasLogin]) {
                // 评论
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(SYDynamicViewClickComment:userId:onlyShowKeyboard:)]) {
                    [weakSelf.delegate SYDynamicViewClickComment:weakSelf.momentId userId:weakSelf.userId onlyShowKeyboard:(weakSelf.commentNum == 0)];
                }
            }
        } greentBlock:^{
            if ([weakSelf checkIfUserHasLogin]) {
                // 打招呼
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(SYDynamicViewClickGreet:)]) {
                    [weakSelf.delegate SYDynamicViewClickGreet:weakSelf.userModel];
                }
            }
        }];
    }
    return _toolView;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = RGBACOLOR(238,238,238,1);
    }
    return _bottomLine;
}

@end
