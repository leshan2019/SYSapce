//
//  SYLiveRoomFansFooterView.m
//  Shining
//
//  Created by leeco on 2019/11/12.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveRoomFansFooterView.h"
#define spec 20.0
@interface SYLiveRoomFansFooterView()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView*comboCollectionView;
@property(nonatomic,strong)UIButton*actionBtn;
@property(nonatomic,strong)UIView*bgView;
@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,strong)NSArray*titleArr;
@end
@implementation SYLiveRoomFansFooterView
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
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.comboCollectionView];
    [self.bgView addSubview:self.actionBtn];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self resetSubViewsFrames];
}
-(void)resetSubViewsFrames{
    self.bgView.frame = CGRectMake(0, 5, self.sy_width, self.sy_height - 5);
    self.comboCollectionView.sy_top = 14;
    self.comboCollectionView.sy_left = 0;
    self.actionBtn.sy_top = self.comboCollectionView.sy_bottom+spec;
}
-(void)resetFooterInfo:(NSArray*)titles{
    self.titleArr = titles;
    [self.comboCollectionView reloadData];
    [self resetSubViewsFrames];
}
#pragma mark --------lazy load ----------
- (UIView *)bgView{
    if (!_bgView ) {
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 2, self.sy_width, self.sy_height - 2)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.masksToBounds = NO;
        // 阴影
        view.layer.shadowColor = [UIColor blackColor].CGColor;
        view.layer.shadowOffset = CGSizeMake(0,-2);
        view.layer.shadowOpacity = 0.1;
        _bgView = view;
    }
    return _bgView;
}
- (UICollectionView *)comboCollectionView{
    if (!_comboCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = spec;
        layout.minimumInteritemSpacing = spec;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView*collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 14, self.sy_width, 32)
                                                             collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[SYLiveRoomFansComboCell class]
           forCellWithReuseIdentifier:@"tab"];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.showsHorizontalScrollIndicator = NO;
        _comboCollectionView = collectionView;
    }
    return _comboCollectionView;
}
- (UIButton *)actionBtn{
    if (!_actionBtn) {
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(spec, 0, self.sy_width - spec*2, 38);
        btn.backgroundColor = [UIColor sy_colorWithHexString:@"7B40FF"];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [btn setTitle:@"开通真爱团" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickActionBtn) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 38/2.f;
        _actionBtn = btn;
    }
    return _actionBtn;
}
-(void)clickActionBtn{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(liveRoomFansFooterView_openFansRights:)]) {
        [self.delegate liveRoomFansFooterView_openFansRights:[NSString stringWithFormat:@"%ld",self.currentIndex+1]];
    }
}
- (void)changeTabCollectionCellSelectedStateWithOldIndex:(NSInteger)oldIndex
                                                newIndex:(NSInteger)newIndex
                                   needHighlightNewIndex:(BOOL)needHighlightNewIndex {
    SYLiveRoomFansComboCell *cell = (SYLiveRoomFansComboCell *)[self.comboCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:oldIndex inSection:0]];
    cell.selected = NO;
    if (needHighlightNewIndex) {
        cell = (SYLiveRoomFansComboCell *)[self.comboCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:newIndex inSection:0]];
        cell.selected = YES;
    }
}
#pragma mark --------collectionView delegate ----------

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.titleArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYLiveRoomFansComboCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tab"
                                                                              forIndexPath:indexPath];
    [cell showWithTitle:[self.titleArr objectAtIndex:indexPath.item]];
    if (indexPath.item == self.currentIndex) {
        cell.selected = YES;
    }
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self changeTabCollectionCellSelectedStateWithOldIndex:self.currentIndex newIndex:-1 needHighlightNewIndex:NO];
    self.currentIndex = indexPath.item;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (self.sy_width-spec*4)/3.f;
    return CGSizeMake(width, 32);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0.f, spec, 0, spec);
    
}
@end
@interface SYLiveRoomFansComboCell ()
@property(nonatomic,strong)UIImageView*iconView;
@property(nonatomic,strong)UILabel*titleLabel;
@property(nonatomic,strong)UIImageView*cornerView;

@end
@implementation SYLiveRoomFansComboCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 4.f;
        self.layer.borderWidth = 1.f;
        self.layer.borderColor = [UIColor sy_colorWithHexString:@"#999999"].CGColor;
        [self setupSubViews];
    }
    return self;
}
-(void)setupSubViews{
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.cornerView];
}
- (UIImageView *)iconView {
    if (!_iconView) {
        UIImageView*img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        img.contentMode = UIViewContentModeScaleAspectFit;
        [img setImage:[UIImage imageNamed_sy:@"transgerBeeCoin"]];
        _iconView = img;
    }
    return _iconView;
}
- (UIImageView *)cornerView{
    if (!_cornerView) {
        UIImageView*img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        img.contentMode = UIViewContentModeScaleAspectFit;
        [img setImage:[UIImage imageNamed_sy:@"coin_arrow"]];
        img.hidden = YES;
        _cornerView = img;
    }
    return _cornerView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        _titleLabel.textColor = [UIColor sy_colorWithHexString:@"#999999"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.titleLabel.textColor = [UIColor sy_colorWithHexString:@"7B40FF"];
        self.layer.borderColor = [UIColor sy_colorWithHexString:@"7B40FF"].CGColor;
        self.cornerView.hidden = NO;
    } else {
        self.titleLabel.textColor = [UIColor sy_colorWithHexString:@"#999999"];
        self.layer.borderColor = [UIColor sy_colorWithHexString:@"999999"].CGColor;
        self.cornerView.hidden = YES;
    }
}
- (void)showWithTitle:(NSString *)title {
    
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
    [self resetSubViewsFrames];
    
}
-(void)resetSubViewsFrames{
    CGFloat labelWidth = self.titleLabel.sy_width;
    CGFloat totalWidth = self.iconView.sy_width+4+labelWidth;
    CGFloat x = (self.sy_width - totalWidth)/2.f;
    self.iconView.sy_left = x;
    self.iconView.sy_centerY = self.contentView.sy_centerY;
    self.titleLabel.sy_left = self.iconView.sy_right +4;
    self.titleLabel.sy_centerY = self.contentView.sy_centerY;
    self.cornerView.sy_right = self.contentView.sy_right-2;
    self.cornerView.sy_bottom = self.contentView.sy_bottom - 2;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self resetSubViewsFrames];
}

@end
