

#import "SYCategoryIndicatorCell.h"
#import "SYCategoryIndicatorCellModel.h"

@interface SYCategoryIndicatorCell ()
@property (nonatomic, strong) UIView *separatorLine;
@end

@implementation SYCategoryIndicatorCell

- (void)initializeViews
{
    [super initializeViews];

    self.separatorLine = [[UIView alloc] init];
    self.separatorLine.hidden = YES;
    [self.contentView addSubview:self.separatorLine];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    SYCategoryIndicatorCellModel *model = (SYCategoryIndicatorCellModel *)self.cellModel;
    CGFloat lineWidth = model.separatorLineSize.width;
    CGFloat lineHeight = model.separatorLineSize.height;

    self.separatorLine.frame = CGRectMake(self.bounds.size.width - lineWidth + self.cellModel.cellSpacing/2, (self.bounds.size.height - lineHeight)/2.0, lineWidth, lineHeight);
}

- (void)reloadData:(SYCategoryBaseCellModel *)cellModel {
    [super reloadData:cellModel];

    SYCategoryIndicatorCellModel *model = (SYCategoryIndicatorCellModel *)cellModel;
    self.separatorLine.backgroundColor = model.separatorLineColor;
    self.separatorLine.hidden = !model.isSepratorLineShowEnabled;

    if (model.isCellBackgroundColorGradientEnabled) {
        if (model.isSelected) {
            self.contentView.backgroundColor = model.cellBackgroundSelectedColor;
        }else {
            self.contentView.backgroundColor = model.cellBackgroundUnselectedColor;
        }
    }
}

@end
