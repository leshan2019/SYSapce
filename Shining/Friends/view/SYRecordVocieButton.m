//
//  SYRecordVocieButton.m
//  Shining
//
//  Created by letv_lzb on 2019/3/14.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYRecordVocieButton.h"
#import "SYAudioRecordManager.h"
#import "SYAudioFileTools.h"

@interface SYRecordVocieButton ()

/**
 录音存放路径
 */
@property (nonatomic, copy) NSString *audioLocalPath;

@end

@implementation SYRecordVocieButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType
{
    return [[SYRecordVocieButton alloc] init];
}

- (instancetype)init
{
    if (self = [super init]) {
        [self sy_setupView];
        [self sy_addGesture];
    }
    return self;
}


/**
 视图创建
 */
- (void)sy_setupView
{
    self.backgroundColor = [UIColor sy_colorWithHexString:@"FFFFFF"];
    [self setTitle:@"按住 说话" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

    self.layer.cornerRadius = self.sy_width/2;
//    self.layer.borderWidth = 0.5;
//    self.layer.borderColor = [UIColor colorWithWhite:0.6 alpha:1.0].CGColor;
    self.titleLabel.font = [UIFont systemFontOfSize:16];
}


/**
 手势创建
 */
- (void)sy_addGesture
{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self addGestureRecognizer:longPress];
}


/**
 手势事件处理

 @param gr GestureRecognizer
 */
- (void)longPress:(UILongPressGestureRecognizer *)gr
{
    CGPoint point = [gr locationInView:self];
    [[SYAudioRecordManager shareSYAudioRecordManager] setLongTimerHander:^(BOOL ret, NSTimeInterval recordTime) {
        gr.enabled = NO;
    }];
    if (gr.state == UIGestureRecognizerStateBegan) {//长按开始
        NSLog(@"---开始录音");
        [self sy_setButtonStateWithRecording];
        if (self.delegate && [self.delegate respondsToSelector:@selector(sy_didBeginRecordWithButton:)]) {
            [self.delegate sy_didBeginRecordWithButton:self];
        }
    }else if (gr.state == UIGestureRecognizerStateChanged) {//长按改变位置
        if (point.y < 0 || point.y > self.sy_height) {//超出范围提示松开手指取消发送
            NSLog(@"---松开取消");
            [self sy_setButtonStateWithCancel];
            if (self.delegate && [self.delegate respondsToSelector:@selector(sy_willCancelRecordWithButton:)]) {
                [self.delegate sy_willCancelRecordWithButton:self];
            }

        } else {//在范围内，提示上滑取消发送
            NSLog(@"---松开结束");
            [self sy_setButtonStateWithRecording];
            if (self.delegate && [self.delegate respondsToSelector:@selector(sy_continueRecordingWithButton:)]) {
                [self.delegate sy_continueRecordingWithButton:self];
            }

        }

    } else if (gr.state == UIGestureRecognizerStateEnded) {//松开手指
        [self sy_cancelOrEndRecordWithPoint:point];

    } else if (gr.state == UIGestureRecognizerStateCancelled) {//手势不可用走

        [self sy_cancelOrEndRecordWithPoint:point];

        gr.enabled = YES;

    } else if (gr.state == UIGestureRecognizerStateFailed) {
        NSLog(@"UIGestureRecognizerStateFailed---");
    } else if (gr.state == UIGestureRecognizerStatePossible) {
        NSLog(@"UIGestureRecognizerStatePossible---");
    }
}


- (void)sy_cancelOrEndRecordWithPoint:(CGPoint)point {
    [self sy_setButtonStateWithNormal];
    if (point.y < 0 || point.y > self.sy_height) {//超出范围不发送
        if (self.delegate && [self.delegate respondsToSelector:@selector(sy_didCancelRecordWithButton:)]) {
            [self.delegate sy_didCancelRecordWithButton:self];
        }
    } else {//在范围内，直接发送
        if (self.delegate && [self.delegate respondsToSelector:@selector(sy_didFinishedRecordWithButton:audioLocalPath:)]) {
            [self.delegate sy_didFinishedRecordWithButton:self audioLocalPath:self.audioLocalPath];
        }
    }
}


- (void)sy_setButtonStateWithRecording
{
    self.backgroundColor = [UIColor sy_colorWithHexString:@"cccccc"]; //
    [self setTitle:@"松开 结束" forState:UIControlStateNormal];
}

- (void)sy_setButtonStateWithCancel
{
    self.backgroundColor =  [UIColor sy_colorWithHexString:@"cccccc"]; //
    [self setTitle:@"松开 取消" forState:UIControlStateNormal];
}

- (void)sy_setButtonStateWithNormal
{
    self.backgroundColor =  [UIColor sy_colorWithHexString:@"f2f2f2"];
    [self setTitle:@"按住 说话" forState:UIControlStateNormal];
}


@end
