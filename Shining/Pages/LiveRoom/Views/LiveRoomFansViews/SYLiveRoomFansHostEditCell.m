//
//  SYLiveRoomFansHostEditCell.m
//  Shining
//
//  Created by leeco on 2019/11/15.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYLiveRoomFansHostEditCell.h"
@interface SYLiveRoomFansHostEditCell()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField*textField;
@property(nonatomic,strong)UIView*line;
@end
@implementation SYLiveRoomFansHostEditCell
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
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.line];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self resetSubViewsFrames];
}
-(void)resetSubViewsFrames{
    self.textField.sy_left = 16;
    self.textField.sy_width = self.contentView.sy_width-24;
    self.textField.sy_height = self.contentView.sy_height;
    self.line.sy_bottom = self.contentView.sy_bottom;
    self.line.sy_width = self.contentView.sy_width;
}
-(void)setEditCellText:(NSString*)text{
    self.textField.text = text;
    [self resetSubViewsFrames];
}
- (NSString *)getEditCellText{
    return self.textField.text;
}
- (void)cellResignFirstResponder{
    [self.textField resignFirstResponder];
}
- (UITextField *)textField{
    if (!_textField) {
        UITextField*field = [[UITextField alloc]initWithFrame:self.bounds];
        field.backgroundColor = [UIColor clearColor];
        field.delegate = self;
        field.placeholder = @"仅限3个字符";
        field.textColor = [UIColor sy_colorWithHexString:@"444444"];
        field.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        field.clearButtonMode = UITextFieldViewModeUnlessEditing;
        _textField= field;
    }
    return _textField;
}
- (UIView *)line{
    if (!_line) {
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.sy_width, 0.5)];
        view.backgroundColor = [UIColor sy_colorWithHexString:@"E0E0E0"];
        _line=view;
    }
    return _line;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField*)textField{
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField*)textField{
}


@end
