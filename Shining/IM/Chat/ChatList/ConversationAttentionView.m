//
//  ConversationAttentionView.m
//  Shining
//
//  Created by 杨玄 on 2019/3/16.
//  Copyright © 2019年 mengxiangjian. All rights reserved.
//

#import "ConversationAttentionView.h"
#import "ConversationAttentionCell.h"
//#import <Masonry.h>
#import "SYLetterIndexerView.h"

// 消息模块 - 关注列表CellID
#define ConversationAttentionCellID @"ConversationAttentionCellID"
#define ConversationAttentionHeaderViewID @"ConversationAttentionHeaderViewID"

#define ConversationAttentionCellHeight 72
#define ConversationAttentionHeaderViewHegiht 31

@interface ConversationAttentionView () <UITableViewDelegate, UITableViewDataSource, SYLetterIndexerViewDelegate, UIScrollViewDelegate, ConversationAttentionCellDelegate>

// VIEW
@property (nonatomic, strong) UITableView *attentionListView;      // 关注列表View
@property (nonatomic, strong) SYLetterIndexerView *letterView;     // 字母索引View

// DATA
@property (nonatomic, strong) NSMutableArray *listArr;             // 关注列表数据源
@property (nonatomic, strong) NSArray *indexArr;                   // 字母索引

// TAG
@property (nonatomic, assign) BOOL isScrollByLetterView;           // 滑动字母索引引起的滚动

@end

@implementation ConversationAttentionView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.attentionListView];
        [self addSubview:self.letterView];
        [self.attentionListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.letterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_equalTo(16);
            make.height.mas_equalTo(0);
        }];
    }
    return self;
}

#pragma mark - PublicMethod

- (void)reloadAttentionViewWithDataSource:(NSMutableArray *)listArr {
    self.listArr = listArr;
    [self.attentionListView reloadData];
    self.isScrollByLetterView = NO;
    [self updateLetterIndexerView];
}

#pragma mark - Setter

- (void)setListArr:(NSMutableArray *)listArr {
    _listArr = listArr;
    NSMutableArray *letterArr = [NSMutableArray array];
    for (int i = 0; i < listArr.count; i++) {
        NSDictionary *tempDic = [listArr objectAtIndex:i];
        [letterArr addObject:[tempDic.allKeys objectAtIndex:0]];
    }
    self.indexArr = [letterArr copy];
    [self.letterView updateIndexerViewWithLetters:self.indexArr];
    CGFloat height = CGRectGetHeight(self.letterView.frame);
    [self.letterView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

#pragma mark - PrivateMethod

- (UIVisualEffectView *)getGlassView {
//    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//    effectView.frame = CGRectMake(0, 0, __MainScreen_Width, ConversationAttentionHeaderViewHegiht);
//    return effectView;
    // Note: 这个不用毛玻璃了？等着UI看看再说，先屏蔽掉
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, ConversationAttentionHeaderViewHegiht)];
    view.backgroundColor = RGBACOLOR(245, 246, 247, 1);
    return view;
}

- (UIView *)getNormalView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, ConversationAttentionHeaderViewHegiht)];
    view.backgroundColor = RGBACOLOR(245, 246, 247, 1);
    return view;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ConversationAttentionCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return ConversationAttentionHeaderViewHegiht;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(conversationAttentionView:didSelectRowAtIndexPath:)]) {
        [self.delegate conversationAttentionView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView= [tableView dequeueReusableHeaderFooterViewWithIdentifier:ConversationAttentionHeaderViewID];
    if(!headerView){
        headerView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, ConversationAttentionHeaderViewHegiht)];
    }
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, __MainScreen_Width, ConversationAttentionHeaderViewHegiht)];
    title.backgroundColor = [UIColor clearColor];
    title.text = [self.indexArr objectAtIndex:section];
    title.font =  [UIFont fontWithName:@"PingFang-SC-Regular" size:11];
    title.textColor = RGBACOLOR(68, 68, 68, 1);
    title.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:title];
    return headerView;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    NSArray *indexPathsArr = [tableView indexPathsForVisibleRows];
    NSIndexPath *indexPath = [indexPathsArr objectAtIndex:0];
    if (indexPath && indexPath.section == section) {
        headerView.backgroundView = [self getGlassView];
        UITableViewHeaderFooterView *nextHeaderView = [tableView headerViewForSection:section+1];
        nextHeaderView.backgroundView = [self getNormalView];
    } else {
        headerView.backgroundView = [self getNormalView];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *nextHeaderView = [tableView headerViewForSection:section+1];
    nextHeaderView.backgroundView = [self getGlassView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.listArr) {
        return self.listArr.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.listArr) {
        NSDictionary *tempDic = [self.listArr objectAtIndex:section];
        NSMutableArray *subArr = [tempDic.allValues objectAtIndex:0];
        return subArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConversationAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:ConversationAttentionCellID];
    if (!cell) {
        cell = [[ConversationAttentionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ConversationAttentionCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    NSDictionary *tempDic = [self.listArr objectAtIndex:section];
    NSMutableArray *subArr = [tempDic.allValues objectAtIndex:0];
    UserProfileEntity *model = [subArr objectAtIndex:item];
    NSInteger age = [SYUtil ageWithBirthdayString:model.birthday];
    NSString *roomId = @"";
    if (model.is_streamer == 1 && model.streamer_roomid > 0) {
        roomId = [NSString stringWithFormat:@"%ld",model.streamer_roomid];
    }
    NSString *showId = [model.bestid integerValue] > 0 ? model.bestid : model.userid;
    [cell updateCellWithHeaderImage:model.avatar_imgurl withName:model.username withGender:model.gender withAge:age withId:showId withRoomId:roomId];
    cell.delegate = self;
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isScrollByLetterView = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.attentionListView) {
        [self updateLetterIndexerView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.attentionListView) {
        [self updateLetterIndexerView];
    }
}

// 更新字母索引默认值
- (void)updateLetterIndexerView {
    if (self.isScrollByLetterView) {
        return;
    }
    NSIndexPath *indexPath = nil;
    NSArray *visibleIndexs = [self.attentionListView indexPathsForVisibleRows];
    if (visibleIndexs && visibleIndexs.count > 0) {
        indexPath = [visibleIndexs objectAtIndex:0];
    }
    if (indexPath && indexPath.section >= 0) {
        [self.letterView updateSelectedIndexWithIndex:indexPath.section];
    }
}

#pragma mark - SYLetterIndexerViewDelegate

- (void)handleSYLetterIndexerScrollWithIndex:(NSUInteger)index {
    if (index < 0) return;
    if (index >= self.indexArr.count) return;
    self.isScrollByLetterView = YES;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    [self.attentionListView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark - ConversationAttentionCellDelegate

- (void)ConversationAttentionCellClickEnterChatRoomWithRoomId:(NSString *)roomId {
    if (self.delegate && [self.delegate respondsToSelector:@selector(conversationAttentionView:enterChatRoomWithRoomId:)]) {
        [self.delegate conversationAttentionView:self enterChatRoomWithRoomId:roomId];
    }
}

#pragma mark - LazyLoad

- (UITableView *)attentionListView {
    if (!_attentionListView) {
        _attentionListView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];;
        _attentionListView.delegate = self;
        _attentionListView.dataSource = self;
        _attentionListView.showsVerticalScrollIndicator = NO;
        _attentionListView.backgroundColor = RGBACOLOR(245, 246, 247, 1);
        _attentionListView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 索引设置
        _attentionListView.sectionIndexColor = RGBACOLOR(68, 68, 68, 1);
        _attentionListView.sectionIndexBackgroundColor = [UIColor clearColor];
    }
    return _attentionListView;
}

- (SYLetterIndexerView *)letterView {
    if (!_letterView) {
        _letterView = [[SYLetterIndexerView alloc] initWithFrame:CGRectZero];
        _letterView.delegate = self;
    }
    return _letterView;
}

@end
