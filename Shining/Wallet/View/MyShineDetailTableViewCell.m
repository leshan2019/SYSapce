//
//  MyShineDetailTableViewCell.m
//  Shining
//
//  Created by letv_lzb on 2019/3/28.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "MyShineDetailTableViewCell.h"
#import "SYShineDetailIncomeModel.h"


@interface MyShineDetailTableViewCell ()

@property (nonatomic, strong)id model;

@property (nonatomic, strong)UILabel *fromLbl;
@property (nonatomic, strong)UILabel *dateLbl;
@property (nonatomic, strong)UILabel *nameLbl;
@property (nonatomic, strong)UILabel *idLbl;
@property (nonatomic, strong)UILabel *shineLbl;
@property (nonatomic, strong)UIImageView *bottomLine;

@end

@implementation MyShineDetailTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView
{
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    if (!self.fromLbl) {
    }
    if (!self.dateLbl) {
    }
    if (!self.nameLbl) {
    }
    if (!self.idLbl) {
    }
    if (!self.shineLbl) {
    }
    if (!self.bottomLine) {
    }
}

- (UILabel *)fromLbl
{
    if (!_fromLbl) {
        _fromLbl = [UILabel new];
        _fromLbl.backgroundColor = [UIColor clearColor];
        _fromLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _fromLbl.textColor = [UIColor sy_colorWithHexString:@"#0B0B0B"];
        _fromLbl.textAlignment = NSTextAlignmentLeft;
    }
    if (!_fromLbl.superview) {
        [self.contentView addSubview:_fromLbl];
        [_fromLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(15);
            make.top.equalTo(self.contentView).with.offset(25);
            make.size.mas_equalTo(CGSizeMake(115, 21));
        }];
    }
    return _fromLbl;
}

- (UILabel *)dateLbl
{
    if (!_dateLbl) {
        _dateLbl = [UILabel new];
        _dateLbl.backgroundColor = [UIColor clearColor];
        _dateLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        _dateLbl.textColor = [UIColor sy_colorWithHexString:@"#999999"];
        _dateLbl.textAlignment = NSTextAlignmentLeft;
    }
    if (!_dateLbl.superview) {
        [self.contentView addSubview:_dateLbl];
        [_dateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(15);
            make.top.mas_equalTo(self.fromLbl.mas_bottom).with.offset(4);
            make.size.mas_equalTo(CGSizeMake(115, 16));
        }];
    }
    return _dateLbl;
}

- (UILabel *)nameLbl
{
    if (!_nameLbl) {
        _nameLbl = [UILabel new];
        _nameLbl.backgroundColor = [UIColor clearColor];
        _nameLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _nameLbl.textColor = [UIColor sy_colorWithHexString:@"#444444"];
        _nameLbl.textAlignment = NSTextAlignmentLeft;
    }
    if (!_nameLbl.superview) {
        [self.contentView addSubview:_nameLbl];
        [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.dateLbl.mas_right).with.offset(30);
            make.top.equalTo(self.contentView).with.offset(25);
            make.size.mas_equalTo(CGSizeMake(100, 20));
        }];
    }
    return _nameLbl;
}

- (UILabel *)idLbl
{
    if (!_idLbl) {
        _idLbl = [UILabel new];
        _idLbl.backgroundColor = [UIColor clearColor];
        _idLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _idLbl.textColor = [UIColor sy_colorWithHexString:@"#000000"];
        _idLbl.textAlignment = NSTextAlignmentLeft;
    }
    if (!_idLbl.superview) {
        [self.contentView addSubview:_idLbl];
        [_idLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.dateLbl.mas_right).with.offset(30);
            make.top.mas_equalTo(self.nameLbl.mas_bottom).with.offset(4);
            make.size.mas_equalTo(CGSizeMake(100, 13));
        }];
    }
    return _idLbl;
}

- (UILabel *)shineLbl
{
    if (!_shineLbl) {
        _shineLbl = [UILabel new];
        _shineLbl.backgroundColor = [UIColor clearColor];
        _shineLbl.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _shineLbl.textColor = [UIColor sy_colorWithHexString:@"#E42112"];
        _shineLbl.textAlignment = NSTextAlignmentRight;
    }
    if (!_shineLbl.superview) {
        [self.contentView addSubview:_shineLbl];
        [_shineLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(-18);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(80, 18));
        }];
    }
    return _shineLbl;
}


- (UIImageView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [UIImageView new];
        _bottomLine.backgroundColor = [UIColor sy_colorWithHexString:@"#000000" alpha:0.08/1.0];
    }
    if (!_bottomLine.superview) {
        [self.contentView addSubview:_bottomLine];
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(0.5f);
        }];
    }
    return _bottomLine;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{

}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{

}

- (void)bindData:(id)item
{
    if (item == self.model) {
        return;
    }
    self.model = item;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (!self.model) {
        return;
    }
    SYShineDetailIncomeModel *item = self.model;
    self.fromLbl.text = item.stype_name;
    self.dateLbl.text = item.create_time;
    self.nameLbl.text = item.relate_username;

    NSMutableAttributedString *idTextAttrStr = [[NSMutableAttributedString alloc] init];

    NSMutableAttributedString * attrIdStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",item.relate_userid]];
    NSRange idRange = NSMakeRange(0, attrIdStr.length);
    // 设置字体大小
    [attrIdStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size:13] range:idRange];
    // 设置颜色
    [attrIdStr addAttribute:NSForegroundColorAttributeName value:[UIColor sy_colorWithHexString:@"#000000"] range:idRange];
    // 文字中加图片
    NSTextAttachment *attachmentID=[[NSTextAttachment alloc] init];
    UIImage *idImg=[UIImage imageNamed_sy:@"shine_id"];
    attachmentID.image = idImg;
    attachmentID.bounds=CGRectMake(0, -2, idImg.size.width, idImg.size.height);
    NSAttributedString *idImgStr = [NSAttributedString attributedStringWithAttachment:attachmentID];

    [idTextAttrStr appendAttributedString:idImgStr];
    [idTextAttrStr appendAttributedString:attrIdStr];

    self.idLbl.attributedText = idTextAttrStr;


    NSMutableAttributedString *textAttrStr = [[NSMutableAttributedString alloc] init];

    //第一张图
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:item.shines];
    NSRange range = NSMakeRange(0, attrStr.length);
    // 设置字体大小
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size:16] range:range];
    // 设置颜色
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor sy_colorWithHexString:@"#E42112"] range:range];

    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    UIImage* iimg = [UIImage imageNamed_sy:@"shine_num"];
    attach.image = iimg;
    attach.bounds = CGRectMake(0, -2 , iimg.size.width, iimg.size.height);
    NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attach];
    [textAttrStr appendAttributedString:attrStr];
    [textAttrStr appendAttributedString:imgStr];
    [textAttrStr addAttribute:NSKernAttributeName value:@(4)
                        range:NSMakeRange(attrStr.length-1, 2)];
    self.shineLbl.attributedText = textAttrStr;
}

@end
