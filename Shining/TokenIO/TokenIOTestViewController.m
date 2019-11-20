//
//  TokenIOTestViewController.m
//  Shining
//
//  Created by Zhang Qigang on 2019/9/27.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "TokenIO.h"
#import "TokenIOTestViewController.h"

@interface TokenActionCell : UITableViewCell
@end

@implementation TokenActionCell
@end

@interface TokenIOTestViewController () <UITableViewDelegate, UITableViewDataSource, TokenIODelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSArray* actions;

@property (nonatomic, strong) TokenIO* tokenIO;
@end

@implementation TokenIOTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark -
#pragma mark getter

- (UITableView*) tableView {
    if (!_tableView) {
        UITableView* tableView = [[UITableView alloc] initWithFrame: CGRectZero style: UITableViewStylePlain];
        [tableView registerClass: [TokenActionCell class] forCellReuseIdentifier: @"action"];
        tableView.dataSource = self;
        tableView.delegate = self;
        _tableView = tableView;
    }
    
    return _tableView;
}

- (TokenIO*) tokenIO {
    if (!_tokenIO) {
        TokenIO* io = [[TokenIO alloc] init];
        io.delegate = self;
        _tokenIO = io;
    }
    return _tokenIO;
}

- (NSArray*) actions {
    __weak typeof(self) weakSelf = self;
    if (!_actions) {
        _actions = @[
            @{
                @"title": @"连接用户",
                @"action": ^{
                    __strong typeof(weakSelf) self = weakSelf;
                    NSString* accessToken = [SYSettingManager accessToken];
                    [self.tokenIO connectWithAccessToken: accessToken];
                },
            },
            @{
                @"title": @"连接设备",
                @"action": ^{
                    __strong typeof(weakSelf) self = weakSelf;
                    NSString* deviceId = [SYSettingManager deviceUUID];
                    [self.tokenIO connectWithDeviceId: deviceId];
                },
            },
            @{
                @"title": @"进入房间",
                @"action": ^{
                    __strong typeof(weakSelf) self = weakSelf;
                },
            },
            @{
                @"title": @"离开房间",
                @"action": ^{
                    __strong typeof(weakSelf) self = weakSelf;
                    
                },
            },
            @{
                @"title": @"发送消息给用户",
                @"action": ^{
                    __strong typeof(weakSelf) self = weakSelf;
                    
                },
            },
            @{
                @"title": @"广播房间消息",
                @"action": ^{
                    __strong typeof(weakSelf) self = weakSelf;
                    
                },
            },
            @{
                @"title": @"广播所有房间消息",
                @"action": ^{
                    __strong typeof(weakSelf) self = weakSelf;
                    
                },
            },
            @{
                @"title": @"广播所有用户消息",
                @"action": ^{
                    __strong typeof(weakSelf) self = weakSelf;
                    
                },
            },
        ];
    }
    return _actions;
}

#pragma mark -
#pragma mark UITableViewDataSources

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.actions.count;
}

#pragma mark UITableViewDelegate
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"action"];
    NSString* title = [self.actions objectAtIndex: indexPath.row][@"title"];
    cell.textLabel.text = title;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    void (^action)(void) = [self.actions objectAtIndex: indexPath.row][@"action"];
    if (action) {
        action();
    }
}

#pragma mark TokenIODelegate
- (NSString*) pcode {
    return SHANYIN_PCODE;
}

- (NSString*) version {
    return SHANYIN_VERSION;
}

- (void) tokenIOConnected: (TokenIO*) io {
    NSLog(@"socket io connected");
}

- (void) tokenIODisconnected: (TokenIO*) io withError: (NSError * _Nullable) error {
    
    NSLog(@"socket io disconnected with error: %@", error);
}

- (void) tokenIO: (TokenIO*) io didRecieveTokenCommand: (TokenCommand*) command {
    NSLog(@"socket io received command: %@", NSStringFromClass([command class]));
}
@end
