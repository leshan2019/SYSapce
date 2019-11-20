//
//  SYLiveRoomFansOperationCell.m
//  Shining
//
//  Created by leeco on 2019/11/12.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveRoomFansOperationCell.h"
@interface SYLiveRoomFansOperationCell()
@property(nonatomic,strong)UIImageView*operationImageView;
@end
@implementation SYLiveRoomFansOperationCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.operationImageView];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)loadCellData:(NSString *)imgName{
    self.operationImageView.image = [UIImage imageNamed_sy:imgName];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.operationImageView.frame = CGRectMake(20, 10, self.sy_width - 2*20, (self.sy_width - 2*20)*77/335.0);
}
- (UIImageView *)operationImageView{
    if (!_operationImageView) {
        UIImageView*img = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, self.sy_width - 2*20, (self.sy_width - 2*20)*77/335.0)];
        img.backgroundColor = [UIColor sy_colorWithHexString:@"ECECEC"];
        img.layer.cornerRadius = 10;
        _operationImageView = img;
    }
    return _operationImageView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
