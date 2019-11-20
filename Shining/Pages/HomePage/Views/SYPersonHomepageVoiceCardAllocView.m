//
//  SYPersonHomepageVoiceCardAllocView.m
//  Shining
//
//  Created by leeco on 2019/10/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYPersonHomepageVoiceCardAllocView.h"
#import "SYPersonHomeRecordControl.h"
#import "SYVoiceCardSoundResultModel.h"
@interface SYPersonHomepageVoiceCardAllocView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITextViewDelegate,SYPersonHomeRecordControlDelegate>
@property(nonatomic,strong)UIView*labelBg;
@property(nonatomic,strong)UITextView*textLabel;
@property(nonatomic,strong)UIButton*changeBtn;
@property(nonatomic,strong)UILabel*categoryLabel;
@property(nonatomic,strong)UICollectionView*categoryCollectionView;
@property(nonatomic,strong)NSArray*categoryArr;
@property(nonatomic,strong)MBProgressHUD*loadingView;
@property(nonatomic,strong)UIView*recodeControlBg;
@property(nonatomic,assign)BOOL analyzeSuccess;
//识别成功
@property(nonatomic,strong)SYAnalyzeResultVeiw*resultView;
//识别失败
@property(nonatomic,strong)UIImageView*failIcon;
@property(nonatomic,strong)UILabel*failLabel;
//
@property(nonatomic,strong)UIButton*finishBtn;
//
@property(nonatomic,strong)SYPersonHomeRecordControl*recodeControl;

@end
@implementation SYPersonHomepageVoiceCardAllocView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubViews];
    }
    return self;
}
-(void)setupSubViews{
    self.clipsToBounds = YES;
    [self addSubview:self.labelBg];
    [self.labelBg addSubview:self.textLabel];
    [self.labelBg addSubview:self.changeBtn];
    [self addSubview:self.categoryLabel];
    [self addSubview:self.categoryCollectionView];
    [self addSubview:self.recodeControlBg];
    [self addSubview:self.recodeControl];
    [self.recodeControlBg addSubview:self.resultView];
    [self.recodeControlBg addSubview:self.failIcon];
    [self.recodeControlBg addSubview:self.failLabel];
    [self.recodeControlBg addSubview:self.finishBtn];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.labelBg.sy_centerX = self.sy_centerX;
    self.textLabel.sy_top = 20*dp;
    self.textLabel.sy_left = 20*dp;
    self.changeBtn.sy_right = self.labelBg.sy_width - 15*dp;
    self.changeBtn.sy_bottom = self.labelBg.sy_height - 15*dp;
    self.categoryLabel.sy_top = self.labelBg.sy_bottom + 30*dp;
    self.categoryLabel.sy_left = self.labelBg.sy_left;
    self.categoryCollectionView.sy_top = self.categoryLabel.sy_bottom +12*dp;
    CGFloat bottom = iPhoneX?34:0;
    self.recodeControl.sy_top = self.categoryCollectionView.sy_bottom+ 40*dp;
    self.recodeControl.sy_height = self.sy_height -  (self.categoryCollectionView.sy_bottom+ 20) - bottom;
    self.recodeControlBg.sy_top = self.categoryCollectionView.sy_bottom+ 20;
    self.recodeControlBg.sy_height = self.sy_height -  (self.categoryCollectionView.sy_bottom+ 20) -bottom;
    self.failIcon.sy_centerX =self.recodeControlBg.sy_centerX;
    self.failIcon.sy_top = 20;
    self.failLabel.sy_top = self.failIcon.sy_bottom+5;
    self.failLabel.sy_centerX = self.recodeControlBg.sy_centerX;
    self.finishBtn.sy_top = self.failLabel.sy_bottom +25*dp;
    self.finishBtn.sy_centerX = self.recodeControlBg.sy_centerX;
    self.resultView.sy_height = self.recodeControlBg.sy_height;
    
}
- (void)resetAllocViewWithStatus:(SYVoiceCardAllocViewStatus)status{
    if (status == SYVoiceCardAllocViewStatus_prepare) {
        self.analyzeSuccess = NO;
        self.recodeControl.hidden = NO;
        [self resetAllocView_hideLoadingView];
        self.resultView.hidden = YES;
        [self resetAllocView_hideFailView];
    }
}
-(void)resetAllocView_showLoadingView{
    [self.loadingView show:YES];
    self.recodeControl.hidden = YES;
    self.changeBtn.hidden = YES;
}
-(void)resetAllocView_hideLoadingView{
    [self.loadingView hide:YES];
    self.loadingView = nil;
}
-(void)resetAllocView_showSuccessView:(id)result{
    self.analyzeSuccess = YES;
    self.resultView.hidden = NO;
    [self.resultView setResultInfo:result];
    [self.finishBtn setTitle:@"确认保存" forState:UIControlStateNormal];
    self.finishBtn.hidden = NO;
    
}
-(void)resetAllocView_showFailView{
    self.analyzeSuccess = NO;
    [self.finishBtn setTitle:@"重新录制" forState:UIControlStateNormal];
    
    self.finishBtn.hidden = NO;
    self.failLabel.hidden = NO;
    self.failIcon.hidden = NO;
}
-(void)resetAllocView_hideFailView{
    self.finishBtn.hidden = YES;
    self.failLabel.hidden = YES;
    self.failIcon.hidden = YES;
    //
    self.changeBtn.hidden = NO;
}
-(void)changeWord{
    if (self.recodeControl.recordType == SYRecordControlType_Prepare || self.recodeControl.hidden == YES) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(allocView_refreshWord)]) {
            [self.delegate allocView_refreshWord];
        }
    }
    
}
-(void)resetViewState:(BOOL)hidden{
    self.hidden = hidden;
}

- (void)resetAllocView_WordInfo:(NSString *)string{
    self.textLabel.text = string;
}
-(void)resetAllocView_categoryInfo:(NSArray *)array{
    self.categoryArr = array;
    [self.categoryCollectionView reloadData];
}
- (void)resetAllocView_recodeControl{
    [self.recodeControl updateRecordControlStateWithType:SYRecordControlType_Prepare];
}
-(void)finishAction{
    if (self.analyzeSuccess) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(allocView_clickFinish)]) {
            [self.delegate allocView_clickFinish];
        }
    }else{
        [self resetAllocView_hideFailView];
        [self resetAllocView_recodeControl];
        self.recodeControl.hidden = NO;
    }
    
}
#pragma mark ========lazy load =======
- (UIView *)labelBg{
    if (!_labelBg) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.sy_width - 40*dp, 237*dp)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 6;
        _labelBg = view;
    }
    return _labelBg;
}
- (UIView *)recodeControlBg{
    if (!_recodeControlBg) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.sy_width,0)];
        view.backgroundColor = [UIColor clearColor];
        _recodeControlBg = view;
    }
    return _recodeControlBg;
}
- (UITextView *)textLabel{
    if (!_textLabel) {
        UITextView *lab = [[UITextView alloc]initWithFrame:CGRectMake(20*dp, 20*dp, self.sy_width - 80*dp , 160*dp)];
        lab.delegate = self;
        lab.editable = NO;
        lab.font = [UIFont systemFontOfSize:20];
        lab.textColor = [UIColor sy_colorWithHexString:@"#444444"];
        _textLabel = lab;
    }
    return _textLabel;
}
- (SYAnalyzeResultVeiw *)resultView{
    if (!_resultView) {
        SYAnalyzeResultVeiw*view = [[SYAnalyzeResultVeiw alloc]initWithFrame:CGRectMake(0, 0, self.sy_width, 0)];
        view.backgroundColor = [UIColor clearColor];
        view.hidden = YES;
        _resultView = view;
    }
    return _resultView;
}
- (UIButton *)changeBtn{
    if (!_changeBtn) {
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 0, 72*dp, 30*dp)];
        [btn setImage:[UIImage imageNamed_sy:@"refresh"] forState:UIControlStateNormal];
        [btn setTitle:@"换一换" forState:UIControlStateNormal];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6*dp, 0, 0);
        btn.titleLabel.font = [UIFont systemFontOfSize:10];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.layer.borderColor = [UIColor sy_colorWithHexString:@"#979797"].CGColor;
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 15*dp;
        [btn addTarget:self action:@selector(changeWord) forControlEvents:UIControlEventTouchUpInside];
        _changeBtn = btn;
    }
    return _changeBtn;
}
- (UIButton *)finishBtn{
    if (!_finishBtn) {
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 0, 114*dp, 36*dp)];
        [btn setTitle:@"重新录制" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 36*dp/2.f;
        btn.layer.masksToBounds = YES;
        btn.hidden = YES;
        //
        CAGradientLayer*gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, btn.sy_width, btn.sy_height);
        gradientLayer.colors = @[(__bridge id)[UIColor sy_colorWithHexString:@"#FFA198"].CGColor, (__bridge id)[UIColor sy_colorWithHexString:@"#FE3D6C"].CGColor];
        gradientLayer.locations = @[@(0.1), @(1)];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
        [btn.layer addSublayer:gradientLayer];
        _finishBtn = btn;
    }
    return _finishBtn;
}
- (MBProgressHUD *)loadingView{
    if (!_loadingView) {
        MBProgressHUD *load = [[MBProgressHUD alloc]initWithView:self.recodeControlBg];
        load.backgroundColor = [UIColor clearColor];
        load.labelText = @"云端分析中";
        load.labelFont = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        load.labelColor = [UIColor whiteColor];
        load.detailsLabelFont = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        load.detailsLabelText = @"正在构建声音识别模型...\n正在进行性别分析...\n主音色结果分析中...\n尝试辅音色分析...";
        load.opacity = 0.0;
        load.removeFromSuperViewOnHide = YES;
        [self.recodeControlBg addSubview:load];
        _loadingView = load;
    }
    return _loadingView;
}
- (UIImageView *)failIcon{
    if (!_failIcon) {
        UIImageView*img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 92*dp, 92*dp)];
        img.image = [UIImage imageNamed_sy:@"analyze_failed"];
        img.backgroundColor = [UIColor clearColor];
        img.hidden = YES;
        _failIcon = img;
    }
    return _failIcon;
}
- (UILabel *)failLabel{
    if (!_failLabel) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.sy_width , 20)];
        lab.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:14];
        lab.text = @"您的声音暂时无法分析呢～";
        lab.backgroundColor = [UIColor clearColor];
        lab.textColor = [UIColor whiteColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.hidden = YES;
        _failLabel = lab;
    }
    return _failLabel;
}
- (SYPersonHomeRecordControl *)recodeControl{
    if (!_recodeControl) {
        SYPersonHomeRecordControl*control = [[SYPersonHomeRecordControl alloc]initWithFrame:CGRectMake(0, 0, self.sy_width, 100)];
        control.delegate = self;
        control.backgroundColor = [UIColor clearColor];
        [control updateRecordControlStateWithType:SYRecordControlType_Prepare];
        _recodeControl = control;
    }
    return _recodeControl;
}
- (void)SYPersonHomeRecordControlLeadUserToOpenRecordPermission {
    if (self.delegate && [self.delegate respondsToSelector:@selector(allocView_leadUserToOpenRecordPermission)]) {
        [self.delegate allocView_leadUserToOpenRecordPermission];
    }
}
// 删除录音
- (void)SYPersonHomeRecordControl:(UIView *)view deleteCurrentRecordAudioPath:(NSString *)audioPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(allocView_voiceViewDeleteLocalVoice:)]) {
        [self.delegate allocView_voiceViewDeleteLocalVoice:audioPath];
    }
}

// 保存录音
- (void)SYPersonHomeRecordControl:(UIView *)view saveCurrentRecordAudioPath:(NSString *)audioPath recordDuration:(NSInteger)duration{
    if (self.delegate && [self.delegate respondsToSelector:@selector(allocView_voiceViewSaveLocalVoice:voiceDuration:)]) {
        [self.delegate allocView_voiceViewSaveLocalVoice:audioPath voiceDuration:duration];
    }}

- (UILabel *)categoryLabel{
    if (!_categoryLabel) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(20*dp, 0, 60 , 15)];
        lab.font = [UIFont systemFontOfSize:14];
        lab.backgroundColor = [UIColor clearColor];
        lab.text = @"热门分类";
        lab.textColor = [UIColor whiteColor];
        _categoryLabel = lab;
    }
    return _categoryLabel;
}
- (UICollectionView *)categoryCollectionView {
    if (!_categoryCollectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 15*dp;
        layout.minimumInteritemSpacing = 15*dp;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _categoryCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.sy_width, 30*dp)
                                                     collectionViewLayout:layout];
        _categoryCollectionView.bounces = NO;
        _categoryCollectionView.delegate = self;
        _categoryCollectionView.dataSource = self;
        _categoryCollectionView.backgroundColor = [UIColor clearColor];
        [_categoryCollectionView registerClass:[SYVoiceCardCategoryCell class]
                    forCellWithReuseIdentifier:@"cell"];
        
        if (@available(iOS 11.0, *)) {
            _categoryCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _categoryCollectionView.showsVerticalScrollIndicator = NO;
    }
    return _categoryCollectionView;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categoryArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYVoiceCardCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                              forIndexPath:indexPath];
    [cell showWithTitle:[self.categoryArr objectAtIndex:indexPath.item]];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.recodeControl.recordType == SYRecordControlType_Prepare || self.recodeControl.hidden == YES) {
        NSString*title = [self.categoryArr objectAtIndex:indexPath.item];
        if (self.delegate && [self.delegate respondsToSelector:@selector(allocView_clickCategory:)]) {
            [self.delegate allocView_clickCategory:title];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString*title = [self.categoryArr objectAtIndex:indexPath.item];
    CGFloat width = title.length*18.f;
    return [SYVoiceCardCategoryCell cellSizeWithWordWidth:width];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 20*dp, 0,0);
}
@end

@interface SYVoiceCardCategoryCell ()
@property(nonatomic,strong)UILabel*textLabel;
@property(nonatomic,strong)UIVisualEffectView *effect;

@end
@implementation SYVoiceCardCategoryCell
+ (CGSize)cellSizeWithWordWidth:(CGFloat)width {
    CGFloat cellWidth = (width + 40) *dp;
    CGFloat cellHeight = 30*dp;
    return CGSizeMake(cellWidth, cellHeight);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        [self addSubview:self.effect];
        self.layer.cornerRadius = self.sy_height/2.f;
        [self addSubview:self.textLabel];
        
    }
    return self;
}

- (void)showWithTitle:(NSString *)title{
    self.textLabel.text = title;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.effect.frame = CGRectMake(0, 0, self.sy_width, self.sy_height);
    self.textLabel.frame = CGRectMake(20*dp, 6*dp, self.sy_width-40*dp, self.sy_height-12*dp);
}
//毛玻璃
- (UIVisualEffectView *)effect{
    if (!_effect) {
        UIBlurEffect *ef = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:ef];
        effectView.frame = CGRectMake(0, 0, self.sy_width, self.sy_height);
        _effect = effectView;
    }
    return _effect;
}
- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*dp, 6*dp, self.sy_width-40*dp, self.sy_height-12*dp)];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont systemFontOfSize:15.f];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.layer.cornerRadius = (self.sy_height-12*dp)/2.f;
        
    }
    return _textLabel;
}
@end

@interface SYAnalyzeResultVeiw ()
@property(strong,nonatomic)UILabel*titleLable;
@property(strong,nonatomic)UILabel*mainLable;
@property(strong,nonatomic)UILabel*secondLable;

@end
@implementation SYAnalyzeResultVeiw
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}
- (void)setResultInfo:(NSArray *)arr{
    NSInteger recScore = [SYSettingManager getSoundRecScore];
    NSMutableArray*tipArr= @[].mutableCopy;
    NSString*sex = @"男性";
    self.mainLable.text = @"";
    self.secondLable.text = @"";
    for (int i = 0;i<arr.count;i++) {
        SYVoiceCardSoundResultModel*model = arr[i];
        if ([model.sound_type isEqualToString:@"男性"]||[model.sound_type isEqualToString:@"女性"]) {
            sex = model.sound_type;
            continue;
        }
        if (arr.count>3) {
            if (tipArr.count==0) {
                [tipArr addObject:model];
                if (model.score>0) {
                    self.mainLable.text = [NSString stringWithFormat:@"主音色：%@音",model.sound_type];
                    
                }else{
                    self.mainLable.text = [NSString stringWithFormat:@"主音色：平平无奇%@音",sex];
                }
                
            }else if(tipArr.count>0 && model.score >recScore){
                [tipArr addObject:model];
                
                if (model.score < recScore) {
                    self.secondLable.text = [NSString stringWithFormat:@"辅音色：太纯正了没有辅音色"];
                }else {
                    self.secondLable.text = [NSString stringWithFormat:@"辅音色：%@音",model.sound_type];
                }
            }
            if (tipArr.count>=2) {
                break;
            }
        }else{
            SYVoiceCardSoundResultModel*model0= arr.firstObject;
            self.mainLable.text = [NSString stringWithFormat:@"主音色：%@音",model0.sound_type];
        }
        
    }
}
-(void)setupSubViews{
    [self addSubview:self.titleLable];
    [self addSubview:self.mainLable];
    [self addSubview:self.secondLable];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLable.sy_top = 0;
    self.titleLable.sy_left = 20*dp;
    self.mainLable.sy_top = self.titleLable.sy_bottom+12*dp;
    self.secondLable.sy_top = self.mainLable.sy_bottom+3;
}
- (UILabel *)titleLable{
    if (!_titleLable) {
        UILabel*lab = [[UILabel alloc]initWithFrame:CGRectZero];
        lab.text= @"分析结果";
        lab.backgroundColor = [UIColor clearColor];
        lab.textColor = [UIColor whiteColor];
        lab.font =[UIFont fontWithName:@"PingFangSC-Medium" size:14];
        [lab sizeToFit];
        _titleLable = lab;
    }
    return _titleLable;
}
- (UILabel *)mainLable{
    if (!_mainLable) {
        UILabel*lab = [[UILabel alloc]initWithFrame:CGRectMake(20*dp, 0, self.sy_width-40*dp, 16)];
        lab.backgroundColor = [UIColor clearColor];
        lab.textColor = [UIColor whiteColor];
        lab.font =[UIFont fontWithName:@"PingFangSC-Medium" size:15];
        _mainLable = lab;
    }
    return _mainLable;
}
- (UILabel *)secondLable{
    if (!_secondLable) {
        UILabel*lab = [[UILabel alloc]initWithFrame:CGRectMake(20*dp, 0, self.sy_width-40*dp, 16)];
        lab.backgroundColor = [UIColor clearColor];
        lab.textColor = [UIColor whiteColor];
        lab.font =[UIFont fontWithName:@"PingFangSC-Medium" size:15];
        _secondLable = lab;
    }
    return _secondLable;
}
@end
