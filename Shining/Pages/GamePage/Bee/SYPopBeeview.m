//
//  SYPopBeeview.m
//  Shining
//
//  Created by leeco on 2019/8/15.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYPopBeeview.h"
#import "SYGameGiftItemCell.h"
#import "SYDataEmptyView.h"

@implementation PopBeeExplainview

- (void)dealloc
{
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:24.0f/255.0f green:5.0f/255.0f blue:62.0f/255.0f alpha:1];
        [self buildUI];
    }
    return self;
}

- (void)buildUI{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc ]init];
    [tap addTarget:self action:@selector(closebee)];
    [self addGestureRecognizer:tap];
    
    UILabel *label = [[UILabel alloc ]initWithFrame:CGRectMake(0,0, self.sy_width, 50)];
    label.text = @"采蜜说明";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    label.textColor = RGBACOLOR(194, 167, 255, 1);;
    label.backgroundColor = [UIColor clearColor];
    [self addSubview:label];
    
    UIView *view = [[UIView alloc ] initWithFrame:CGRectMake(20, 49, self.sy_width - 40, 1)];
    view.backgroundColor = RGBACOLOR(255, 255, 255, 0.1f);
    [self addSubview:view];
    
    UITextView *textView = [[UITextView alloc ] initWithFrame:CGRectMake(30, 60, self.sy_width - 60, self.sy_height - 60)];
    textView.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    textView.textColor = [UIColor whiteColor];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 12;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:14],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    textView.typingAttributes = attributes;
    textView.backgroundColor = [UIColor clearColor];
    textView.delegate = self;
    textView.text = @"1.10蜜豆可以对一朵花采蜜\n2.每次采蜜100%获得礼物\n3.采蜜获得的礼物将放入礼物背包，点开【礼物】面盘切换至【背包】查看\n4.本活动最终解释权归Bee语音所有";
    textView.textColor = [UIColor whiteColor];
    [textView setEditable:NO];
    textView.showsVerticalScrollIndicator = NO;
    textView.showsHorizontalScrollIndicator = NO;
    [self addSubview:textView];
}

- (void)closebee{}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

@end

@interface PopBeeCurrentGiftview()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@end

@implementation PopBeeCurrentGiftview

- (void)dealloc
{
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBACOLOR(24, 5, 62, 1);
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        [self buildUI];
    }
    return self;
}

- (void)buildUI{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc ]init];
    [tap addTarget:self action:@selector(closebee)];
    [self addGestureRecognizer:tap];
    
    UILabel *label = [[UILabel alloc ]initWithFrame:CGRectMake(0,0, self.sy_width, 40)];
    label.text = @"恭喜您收获果实";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    label.textColor = RGBACOLOR(194, 167, 255, 1);
    label.backgroundColor = RGBACOLOR(67, 15, 185, 1);
    [self addSubview:label];
    
    self.layout = [[UICollectionViewFlowLayout alloc]init];
    _layout.minimumInteritemSpacing = 0;
    _layout.minimumLineSpacing = 0;
    _layout.itemSize = CGSizeMake(80, 80);
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _layout.sectionInset = UIEdgeInsetsMake(28, 20, 35, 20);
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, self.sy_width, 142) collectionViewLayout:self.layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[SYGameGiftItemCell class] forCellWithReuseIdentifier:@"SYGameGiftItemCell"];
}
- (void)closebee{}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.giftListModel.list.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SYGameGiftItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SYGameGiftItemCell" forIndexPath:indexPath];
    SYGiftModel *giftModel = [self.giftListModel.list objectAtIndex:indexPath.row];
    cell.giftModel = giftModel;
    return cell;
}

- (void)setGiftListModel:(SYGiftListModel *)giftListModel
{
    _giftListModel = giftListModel;
    [self.collectionView reloadData];
}

@end






