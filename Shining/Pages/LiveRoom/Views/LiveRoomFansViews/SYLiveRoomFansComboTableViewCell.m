//
//  SYLiveRoomFansComboTableViewCell.m
//  Shining
//
//  Created by leeco on 2019/11/15.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveRoomFansComboTableViewCell.h"
#import "SYLiveRoomFansFooterView.h"
#define spec 20.0
@interface SYLiveRoomFansComboTableViewCell()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView*comboCollectionView;
@property(nonatomic,strong)UIButton*actionBtn;
@property(nonatomic,strong)UILabel*dateLabel;
@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,strong)NSArray*comboArr;
@end
@implementation SYLiveRoomFansComboTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupSubViews];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setupSubViews{
    self.clipsToBounds = YES;
    [self.contentView addSubview:self.comboCollectionView];
    [self.contentView addSubview:self.actionBtn];
    [self.contentView addSubview:self.dateLabel];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self resetSubViewsFrames];
}
-(void)resetSubViewsFrames{
    self.comboCollectionView.sy_top = spec;
    self.comboCollectionView.sy_left = 0;
    self.comboCollectionView.sy_width = self.sy_width;
    self.actionBtn.sy_top = self.comboCollectionView.sy_bottom+spec;
    self.actionBtn.sy_width = self.sy_width - spec*2;
    self.dateLabel.sy_top = self.actionBtn.sy_bottom + 10;
    self.dateLabel.sy_centerX = self.actionBtn.sy_centerX;
}
-(void)resetFansLevelCellInfo:(NSArray*)arr andExpiredDate:(NSString*)date{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSDate *expiredTime = [dateFormatter dateFromString:date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
       [formatter setDateFormat:@"yyyy.MM.dd"];
    NSString*expiredDate = [formatter stringFromDate:expiredTime];
    self.dateLabel.text = [NSString stringWithFormat:@"%@到期",expiredDate];
    self.comboArr = arr;
    [self.comboCollectionView reloadData];
     [self resetSubViewsFrames];
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
- (UILabel *)dateLabel{
    if (!_dateLabel) {
        UILabel*lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 14)];
        lab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        lab.textColor = [UIColor sy_colorWithHexString:@"999999"];
        lab.textAlignment = NSTextAlignmentCenter;
        _dateLabel = lab;
    }
    return _dateLabel;
}
- (UIButton *)actionBtn{
    if (!_actionBtn) {
        UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(spec, 0, self.sy_width - spec*2, 38);
        btn.backgroundColor = [UIColor sy_colorWithHexString:@"7B40FF"];
        btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [btn setTitle:@"续费真爱团" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickActionBtn) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 38/2.f;
        _actionBtn = btn;
    }
    return _actionBtn;
}
-(void)clickActionBtn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(liveRoomFansComboTableViewCell_openFansRights:)]) {
        [self.delegate liveRoomFansComboTableViewCell_openFansRights: [NSString stringWithFormat:@"%ld",self.currentIndex+1]];
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
    return self.comboArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYLiveRoomFansComboCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tab"
                                                                              forIndexPath:indexPath];
    [cell showWithTitle:[self.comboArr objectAtIndex:indexPath.item]];
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
