//
//  SYVoiceCardWordsListVC.m
//  Shining
//
//  Created by leeco on 2019/10/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYVoiceCardWordsListVC.h"
#import "SYVoiceCardWordModel.h"
@interface SYVoiceCardWordsListVC ()<SYNoNetworkViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) SYNoNetworkView *noNetworkView;
@property(nonatomic,strong)UIImageView*bgImageView;
@property(nonatomic,strong)UIButton*backBtn;
@property(nonatomic,strong)UILabel*titleLabel;
//
@property(nonatomic,strong)UITableView*mainTableView;
@property(nonatomic,strong)NSArray*dataArr;

@end

@implementation SYVoiceCardWordsListVC
- (instancetype)initWithState:(NSDictionary* )dic {
    self = [super init];
    if (self) {
        self.dataArr = dic[@"list"];
        self.titleLabel.text = dic[@"title"];
        [self.titleLabel sizeToFit];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.titleLabel];
    self.titleLabel.sy_centerX = self.view.sy_centerX;
    self.titleLabel.sy_centerY = self.backBtn.sy_centerY;
    [self.view addSubview:self.mainTableView];
    CGFloat bottom = iPhoneX ? 34:0;
    CGFloat y  =self.titleLabel.sy_bottom + 32*dp;
    self.mainTableView.frame=CGRectMake(0, y, __MainScreen_Width, __MainScreen_Height - y - bottom);
    
}

- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        UIImageView*img = [[UIImageView alloc]initWithFrame:self.view.bounds];
        img.image = [UIImage imageNamed_sy:@"voiceCard_bg"];
        _bgImageView = img;
    }
    return _bgImageView;
}
- (UIButton *)backBtn {
    if (!_backBtn) {
        CGFloat y = iPhoneX ? (24+20) : 20;
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(6, y, 36, 44)];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed_sy:@"voiceroom_back_w"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed_sy:@"voiceroom_back"] forState:UIControlStateHighlighted];
        _backBtn = btn;
    }
    return _backBtn;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel*lab = [[UILabel alloc]initWithFrame:CGRectZero];
        lab.backgroundColor = [UIColor clearColor];
        lab.font = [UIFont systemFontOfSize:17];
        lab.textColor = [UIColor whiteColor];
        [lab sizeToFit];
        _titleLabel = lab;
    }
    return _titleLabel;
}
- (UITableView *)mainTableView{
    if (!_mainTableView) {
        UITableView*tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.backgroundColor = [UIColor clearColor];
        if (@available(iOS 11.0, *)) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _mainTableView = tableView;
    }
    return _mainTableView;
}
////

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addNoNetworkView {
    [self removeNoNetworkView];
    
    self.noNetworkView = [[SYNoNetworkView alloc] initSYNoNetworkViewWithFrame:self.view.bounds
                                                                  withDelegate:self];
    [[UIApplication sharedApplication].keyWindow addSubview:self.noNetworkView];
}
- (void)SYNoNetworkViewClickRefreshBtn {
    [self removeNoNetworkView];
}
- (void)removeNoNetworkView {
    if (self.noNetworkView) {
        [self.noNetworkView removeFromSuperview];
    }
    self.noNetworkView = nil;
}
///
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SYVoiceCardWordModel*model = [self.dataArr objectAtIndex:indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(wordsListVC_selectNewWord:)]) {
        [self.delegate wordsListVC_selectNewWord:model];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SYVoiceCardWordModel*model = [self.dataArr objectAtIndex:indexPath.row];
    NSString*text = [model.word stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    CGFloat height = [self getCellHeightWithStr:text]+44*dp;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellind = @"cellind";

    SYVoiceCardWordsListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellind];
    if (!cell) {
        cell = [[SYVoiceCardWordsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellind];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    SYVoiceCardWordModel*model = [self.dataArr objectAtIndex:indexPath.row];
    NSString*text = [model.word stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    [cell setTitle:text];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(CGFloat)getCellHeightWithStr:(NSString*)str{
    UITextView*textview = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.mainTableView.sy_width-100*dp, 10)];
    textview.text = str;
    textview.font = [UIFont systemFontOfSize:20];
    CGSize size = [textview sizeThatFits:CGSizeMake(self.mainTableView.sy_width-100*dp, 200)];
    return size.height;
}

@end
@interface SYVoiceCardWordsListCell ()
@property(nonatomic,strong)UIVisualEffectView*effectView;
@property(nonatomic,strong)UILabel*titleLabel;
@end
@implementation SYVoiceCardWordsListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}
- (UIVisualEffectView *)effectView{
    if (!_effectView) {
        //毛玻璃
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effView.frame = CGRectZero;
        effView.layer.cornerRadius = 6;
        effView.layer.masksToBounds = YES;
        _effectView = effView;
    }
    return _effectView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel*lab = [[UILabel alloc]initWithFrame:CGRectZero];
        lab.backgroundColor = [UIColor clearColor];
        lab.font = [UIFont systemFontOfSize:20];
        lab.textColor = [UIColor whiteColor];
        lab.numberOfLines = 7;
        _titleLabel = lab;
    }
    return _titleLabel;
}
-(void)setupView{
    [self addSubview:self.effectView];
    [self addSubview:self.titleLabel];
}
-(void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.sy_left = 50*dp;
    self.titleLabel.sy_top = 25*dp;
    self.effectView.sy_left = 25*dp;
    self.effectView.sy_top = 6*dp;
    self.titleLabel.sy_width = self.sy_width - 100*dp;
    self.titleLabel.sy_height = self.sy_height - 50*dp;
    self.effectView.sy_width = self.sy_width - 50*dp;
    self.effectView.sy_height = self.sy_height - 12*dp;
    
}
@end
