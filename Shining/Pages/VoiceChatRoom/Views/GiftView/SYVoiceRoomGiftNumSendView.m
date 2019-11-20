//
//  SYVoiceRoomGiftNumSendView.m
//  Shining
//
//  Created by mengxiangjian on 2019/8/22.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceRoomGiftNumSendView.h"
#import "SYVoiceRoomGiftNumCell.h"

#define kGiftNumber @"num"
#define kGiftNumberName @"name"
#define GiftNumCellHeight 32.f

@interface SYVoiceRoomGiftNumSendView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, assign) NSInteger giftNum; // 礼物数量

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UIView *listBackView; // 选择数量view的背景view，用于点击取消
@property (nonatomic, strong) UICollectionView *collectionView; // 选择数量view
@property (nonatomic, strong) UIImageView *triangleView;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UIButton *numButton;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UILabel *numLabel;
//@property ()

@property (nonatomic, assign) BOOL viewEnabled;

@end

@implementation SYVoiceRoomGiftNumSendView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _giftNum = 0;
        NSString *json = [SYSettingManager mutiSendJson];
        if (!json) {
            json = @"[{\"num\":1,\"name\":\"一心一意\"},{\"num\":10,\"name\":\"十全十美\"},{\"num\":66,\"name\":\"好运连连\"},{\"num\":188,\"name\":\"要抱抱\"},{\"num\":520,\"name\":\"我爱你\"},{\"num\":999,\"name\":\"长长久久\"},{\"num\":1314,\"name\":\"一生一世\"}]";
        }
        NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
        _dataSource = [NSJSONSerialization JSONObjectWithData:data
                                                      options:NSJSONReadingAllowFragments
                                                        error:nil];
        
        self.clipsToBounds = YES;
        self.layer.borderWidth = 1.f;
        self.layer.cornerRadius = self.sy_height / 2.f;
        
        [self addSubview:self.numButton];
        [self addSubview:self.sendButton];
        [self addSubview:self.arrowView];
        [self addSubview:self.numLabel];
    }
    return self;
}

- (void)setEnabled:(BOOL)enabled {
    self.viewEnabled = enabled;
    if (enabled) {
        self.layer.borderColor = [UIColor sam_colorWithHex:@"#FF4CBE"].CGColor;
    } else {
        self.layer.borderColor = [UIColor sam_colorWithHex:@"#3B2E37"].CGColor;
        self.sendButton.backgroundColor = [UIColor sam_colorWithHex:@"#3B2E37"];
    }
//    self.sendButton.enabled = enabled;
//    self.numButton.enabled = enabled;
    self.gradientLayer.hidden = !enabled;
}

- (void)resetGiftNum {
    if ([self.dataSource count] > 0) {
        self.giftNum = [[self.dataSource[0] objectForKey:kGiftNumber] integerValue];
    } else {
        self.giftNum = 1;
    }
    self.numLabel.text = [NSString stringWithFormat:@"%ld", self.giftNum];
    [self adjustNumAndArrow];
}

- (void)destroy {
    [self.listBackView removeFromSuperview];
}

#pragma mark - UI

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = CGRectMake(0, 0, self.sy_width / 2.f, self.sy_height);
        _gradientLayer.colors = @[(__bridge id)[UIColor sam_colorWithHex:@"#FF74D1"].CGColor, (__bridge id)[UIColor sam_colorWithHex:@"#FF40A5"].CGColor];
        _gradientLayer.startPoint = CGPointMake(0, 1);
        _gradientLayer.endPoint = CGPointMake(1, 0);
    }
    return _gradientLayer;
}

- (UIButton *)numButton {
    if (!_numButton) {
        _numButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _numButton.frame = CGRectMake(0, 0, self.sy_width / 2.f, self.sy_height);
        [_numButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _numButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [_numButton addTarget:self action:@selector(showList:)
             forControlEvents:UIControlEventTouchUpInside];
        _numButton.backgroundColor = [UIColor blackColor];
    }
    return _numButton;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.frame = CGRectMake(self.sy_width / 2.f, 0, self.sy_width / 2.f, self.sy_height);
        [_sendButton.layer addSublayer:self.gradientLayer];
        [_sendButton setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.f];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(send:)
              forControlEvents:UIControlEventTouchUpInside];
        _sendButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    }
    return _sendButton;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.arrowView.sy_left, self.sy_height)];
        _numLabel.textColor = [UIColor whiteColor];
        _numLabel.textAlignment = NSTextAlignmentRight;
        _numLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
        _numLabel.text = [NSString stringWithFormat:@"%ld", self.giftNum];
    }
    return _numLabel;
}

- (UIImageView *)arrowView {
    if (!_arrowView) {
        CGFloat width = 12.f;
        CGFloat height = 10.f;
        CGFloat x = self.sy_width / 2.f - 4.f - width;
        _arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(x, (self.sy_height - height) / 2.f, width, height)];
        _arrowView.image = [UIImage imageNamed_sy:@"voiceroom_gift_arrow"];
    }
    return _arrowView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        CGFloat width = 126.f;
        layout.itemSize = CGSizeMake(width, 32.f);
        CGFloat height = [self.dataSource count] * GiftNumCellHeight;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.listBackView.sy_width - 16.f - width, self.listBackView.sy_height - 51 - height, width, height)
                                             collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[SYVoiceRoomGiftNumCell class]
            forCellWithReuseIdentifier:@"cell"];
        _collectionView.layer.cornerRadius = 7.f;
    }
    return _collectionView;
}

- (UIImageView *)triangleView {
    if (!_triangleView) {
        CGFloat width = 15.f;
        CGFloat height = 7.f;
        _triangleView = [[UIImageView alloc] initWithFrame:CGRectMake(self.collectionView.sy_centerX - width / 2.f - 2.f, self.collectionView.sy_bottom - 1.f, width, height)];
        _triangleView.image = [UIImage imageNamed_sy:@"voiceroom_gift_triangle"];
    }
    return _triangleView;
}

#pragma mark - private method

- (void)showList:(id)sender {
    if (!self.viewEnabled) {
        if ([self.delegate respondsToSelector:@selector(voiceRoomGiftNumSendViewTouchWhenDisable)]) {
            [self.delegate voiceRoomGiftNumSendViewTouchWhenDisable];
        }
        return;
    }
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window) {
        UIView *view = [[UIView alloc] initWithFrame:window.bounds];
        view.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tap:)];
        [view addGestureRecognizer:tap];
        self.listBackView = view;
        [window addSubview:view];
        
        [window addSubview:self.collectionView];
        [window addSubview:self.triangleView];
        
        self.arrowView.transform = CGAffineTransformMakeRotation(M_PI);
    }
}

- (void)send:(id)sender {
    if (!self.viewEnabled) {
        if ([self.delegate respondsToSelector:@selector(voiceRoomGiftNumSendViewTouchWhenDisable)]) {
            [self.delegate voiceRoomGiftNumSendViewTouchWhenDisable];
        }
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(voiceRoomGiftNumSendViewDidSendGiftWithNum:)]) {
        [self.delegate voiceRoomGiftNumSendViewDidSendGiftWithNum:self.giftNum];
    }
}

- (void)tap:(id)sender {
    [self.listBackView removeFromSuperview];
    self.listBackView = nil;
    
    [self.collectionView removeFromSuperview];
    [self.triangleView removeFromSuperview];
    self.arrowView.transform = CGAffineTransformIdentity;
}

- (void)adjustNumAndArrow {
    CGRect rect = [self.numLabel.text boundingRectWithSize:CGSizeMake(999, self.numLabel.sy_height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.numLabel.font} context:nil];
    self.numLabel.sy_width = rect.size.width;
    CGFloat width = self.numLabel.sy_width + self.arrowView.sy_width;
    CGFloat padding = 2.f;
    self.numLabel.sy_left = (self.numButton.sy_width - width - padding) / 2.f;
    self.arrowView.sy_left = self.numLabel.sy_right + padding;
}

#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYVoiceRoomGiftNumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                             forIndexPath:indexPath];
    NSDictionary *model = [self.dataSource objectAtIndex:indexPath.item];
    [cell showWithNumer:[model[kGiftNumber] integerValue]
                   name:model[kGiftNumberName]];
    cell.line.hidden = (indexPath.item == [self.dataSource count] - 1);
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *model = [self.dataSource objectAtIndex:indexPath.item];
    self.giftNum = [model[kGiftNumber] integerValue];
    self.numLabel.text = [NSString stringWithFormat:@"%ld", self.giftNum];
    
    [self tap:nil];
    [self adjustNumAndArrow];
}

@end
