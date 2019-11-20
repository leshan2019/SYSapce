//
//  SYDynamicToolView.m
//  Shining
//
//  Created by yangxuan on 2019/10/21.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYDynamicToolView.h"

@interface SYDynamicToolView ()

@property (nonatomic, strong) UIButton *likeImageBtn;       // ❤
@property (nonatomic, strong) UIButton *likeNumBtn;         // ❤234
@property (nonatomic, strong) UIButton *commentImageBtn;    // ✉️
@property (nonatomic, strong) UIButton *commentNumBtn;      // ✉️78
@property (nonatomic, strong) UIButton *greetBtn;           // “打招呼”

@property (nonatomic, copy) ClickLikeBlock likeBlock;
@property (nonatomic, copy) ClickCommentBlock commentBlock;
@property (nonatomic, copy) ClickGreetBlock greetBlock;

@property (nonatomic, assign) BOOL hasClickLike;           // 已经赞过了

@end

@implementation SYDynamicToolView

- (instancetype)initSYDynamicToolViewWithFrame:(CGRect)frame likeBlock:(ClickLikeBlock)likeBlock commentBlock:(ClickCommentBlock)commentBlock greentBlock:(ClickGreetBlock)greetBlock {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        self.likeBlock = likeBlock;
        self.commentBlock = commentBlock;
        self.greetBlock = greetBlock;
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.likeImageBtn];
    [self addSubview:self.likeNumBtn];
    [self addSubview:self.commentImageBtn];
    [self addSubview:self.commentNumBtn];
    [self addSubview:self.greetBtn];
    [self mas_makeConstraints];
}

- (void)mas_makeConstraints {
    [self.likeImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(20);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(16, 14));
    }];
    [self.likeNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.likeImageBtn.mas_right).with.offset(6);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(18, 14));
    }];
    [self.commentImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.likeNumBtn.mas_right).with.offset(26);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(16, 14));
    }];
    [self.commentNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentImageBtn.mas_right).with.offset(6);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(12, 14));
    }];
    [self.greetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-14);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(66, 26));
    }];
}

#pragma mark - Public

- (void)updateIfHasClickLikeBtn:(BOOL)hasLike {
    self.hasClickLike = hasLike;
    self.likeImageBtn.selected = hasLike;
}

- (void)updateLikeNum:(NSInteger)likeNum {
    NSString *likeStr = [NSString stringWithFormat:@"%ld",likeNum];
    [self.likeNumBtn setTitle: likeStr forState:UIControlStateNormal];
    CGRect rect = [likeStr boundingRectWithSize:CGSizeMake(999, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.likeNumBtn.titleLabel.font} context:nil];
    [self.likeNumBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(rect.size.width + 1);
    }];
}

- (void)updateCommentNum:(NSInteger)commentNum {
    NSString *commentStr = [NSString stringWithFormat:@"%ld",commentNum];
    [self.commentNumBtn setTitle: commentStr forState:UIControlStateNormal];
    CGRect rect = [commentStr boundingRectWithSize:CGSizeMake(999, 14) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.commentNumBtn.titleLabel.font} context:nil];
    [self.commentNumBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(rect.size.width + 1);
    }];
}

- (void)showGreetBtn:(BOOL)show {
    self.greetBtn.hidden = !show;
}

#pragma mark - BtnClick

// 点赞+取消
- (void)handleLikeBtnClick {
    if (self.likeBlock) {
        self.likeBlock(!self.hasClickLike);
    }
}

// 评论
- (void)handleCommentBtnClick {
    if (self.commentBlock) {
        self.commentBlock();
    }
}

// 打招呼
- (void)handleGreetBtnClick {
    if (self.greetBlock) {
        self.greetBlock();
    }
}

#pragma mark - Lazyload

- (UIButton *)likeImageBtn {
    if (!_likeImageBtn) {
        _likeImageBtn = [UIButton new];
        [_likeImageBtn setImage:[UIImage imageNamed_sy:@"homepage_dynamic_like_no"] forState:UIControlStateNormal];
        [_likeImageBtn setImage:[UIImage imageNamed_sy:@"homepage_dynamic_like"] forState:UIControlStateSelected];
        [_likeImageBtn addTarget:self action:@selector(handleLikeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeImageBtn;
}

- (UIButton *)likeNumBtn {
    if (!_likeNumBtn) {
        _likeNumBtn = [UIButton new];
        _likeNumBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [_likeNumBtn setTitle:@"345" forState:UIControlStateNormal];
        [_likeNumBtn setTitleColor:RGBACOLOR(144,144,144,1) forState:UIControlStateNormal];
        [_likeNumBtn addTarget:self action:@selector(handleLikeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeNumBtn;
}

- (UIButton *)commentImageBtn {
    if (!_commentImageBtn) {
        _commentImageBtn = [UIButton new];
        [_commentImageBtn setImage:[UIImage imageNamed_sy:@"homepage_dynamic_comment"] forState:UIControlStateNormal];
        [_commentImageBtn addTarget:self action:@selector(handleCommentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentImageBtn;
}

- (UIButton *)commentNumBtn {
    if (!_commentNumBtn) {
        _commentNumBtn = [UIButton new];
        _commentNumBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [_commentNumBtn setTitle:@"78" forState:UIControlStateNormal];
        [_commentNumBtn setTitleColor:RGBACOLOR(144,144,144,1) forState:UIControlStateNormal];
        [_commentNumBtn addTarget:self action:@selector(handleCommentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentNumBtn;
}

- (UIButton *)greetBtn {
    if (!_greetBtn) {
        _greetBtn = [UIButton new];
        _greetBtn.backgroundColor = RGBACOLOR(240, 240, 240, 1);
        _greetBtn.clipsToBounds = YES;
        _greetBtn.layer.cornerRadius = 13;
        _greetBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
        [_greetBtn setTitle:@"打招呼" forState:UIControlStateNormal];
        [_greetBtn setTitleColor:RGBACOLOR(48,48,48,1) forState:UIControlStateNormal];
        [_greetBtn addTarget:self action:@selector(handleGreetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _greetBtn;
}

@end
