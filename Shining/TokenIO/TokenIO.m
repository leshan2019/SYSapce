//
//  TokenIO.m
//  SocketBed
//
//  Created by Zhang Qigang on 2019/9/27.
//  Copyright © 2019 Zhang Qigang. All rights reserved.
//

#import <SocketRocket/SRWebSocket.h>
#import "TokenIO.h"

#define ACTION_KEY @"action"
#define MESSAGE_KEY @"msg"
#define ROOM_KEY @"trid"
#define USER_KEY @"tuid"
#define MT_KEY @"mt"
#define CODE_KEY @"code"


@interface TokenCommand ()
@property (nonatomic, assign, readwrite) TokenCommandType type;
- (instancetype) initWithCommandType: (TokenCommandType) type;
- (NSString*) json;
- (NSDictionary*) toDict;
@end

@implementation TokenCommand
- (instancetype) initWithCommandType: (TokenCommandType) type {
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (NSDictionary*) toDict {
    return nil;
}

- (NSString*) toJson {
    return nil;
}

- (NSString*) json {
    NSDictionary* dict = [self toDict];
    if (dict) {
        NSData* data = [NSJSONSerialization dataWithJSONObject: dict options: 0 error: nil];
        return [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    } else {
        return nil;
    }
}
@end

@interface TokenJoinRoomCommand ()
@property (nonatomic, copy, readwrite) NSString* roomId;
@end

@implementation TokenJoinRoomCommand
- (instancetype) initWithRoomId: (NSString*) roomId {
    self = [super initWithCommandType: TokenCommandTypeJoinRoom];
    if (self) {
        self.roomId = roomId;
    }
    return self;
}


- (NSDictionary*) toDict {
    NSDictionary* dict = @{
        ACTION_KEY: @"2001",
        ROOM_KEY: [NSNumber numberWithInteger:[self.roomId integerValue]],
    };
    return dict;
}
@end

@interface TokenLeaveRoomCommand ()
@end

@implementation TokenLeaveRoomCommand
- (instancetype) init {
    self = [super initWithCommandType: TokenCommandTypeLeaveRoom];
    return self;
}

- (NSDictionary*) toDict {
    NSDictionary* dict = @{
        ACTION_KEY: @"2002",
    };
    return dict;
}
@end

@interface TokenUserCommand ()
@property (nonatomic, copy, readwrite) NSString* userId;
@property (nonatomic, copy, readwrite) NSString* message;

@end

@implementation TokenUserCommand
- (instancetype) initWithUserId: (NSString*) userId message: (NSString*) message {
    self = [super initWithCommandType: TokenCommandTypeUserMessage];
    if (self) {
        self.userId = userId;
        self.message = message;
    }
    
    return self;
}

- (NSDictionary*) toDict {
    NSDictionary* dict = @{
        ACTION_KEY: @"1001",
        USER_KEY: [NSNumber numberWithInteger:[self.userId integerValue]],
        MESSAGE_KEY: self.message,
    };
    
    return dict;
}
@end

@interface TokenRoomBroadcastCommand ()
@property (nonatomic, copy, readwrite) NSString* roomId;
@property (nonatomic, copy, readwrite) NSString* message;
@end

@implementation TokenRoomBroadcastCommand
- (instancetype) initWithRoomId: (NSString*) roomId message: (NSString*) message {
    self = [super initWithCommandType: TokenCommandTypeRoomBroadcast];
    if (self) {
        self.roomId = roomId;
        self.message = message;
    }
    
    return self;
}

- (NSDictionary*) toDict {
    NSDictionary* dict = @{
        ACTION_KEY: @"1002",
        ROOM_KEY: [NSNumber numberWithInteger:[self.roomId integerValue]],
        MESSAGE_KEY: self.message,
    };
    return dict;
}
@end

@interface TokenAllRoomBroadcastCommand ()
@property (nonatomic, copy, readwrite) NSString* message;
@end

@implementation TokenAllRoomBroadcastCommand
- (instancetype) initWithMessage: (NSString*) message {
    self = [super initWithCommandType: TokenCommandTypeAllRoomBroadcast];
    if (self) {
        self.message = message;
    }
    return self;
}

- (NSDictionary*) toDict {
    NSDictionary* dict = @{
        ACTION_KEY: @"1003",
        MESSAGE_KEY: self.message,
    };
    return dict;
}
@end

@interface TokenAllUserBroadcastCommand ()
@property (nonatomic, copy, readwrite) NSString* message;
@end

@implementation TokenAllUserBroadcastCommand
- (instancetype) initWithMessage: (NSString*) message {
    self = [super initWithCommandType: TokenCommandTypeAllUserBroadcast];
    if (self) {
        self.message = message;
    }
    return self;
}

- (NSDictionary*) toDict {
    NSDictionary* dict = @{
        ACTION_KEY: @"1004",
        MESSAGE_KEY: self.message,
    };
    
    return dict;
}
@end

@interface TokenIO () <SRWebSocketDelegate>
@property (nonatomic, strong) SRWebSocket* webSocket;
@property (nonatomic, strong) AFHTTPSessionManager* http;
@property (nonatomic, strong) NSString *baseURL;
@end

@implementation TokenIO
- (void) dealloc {
    [self disconnect];
}

- (instancetype) init {
    self = [super init];
    if (self) {
#ifdef UseSettingTestDevEnv
        if ([SYSettingManager syIsTestApi]) {
            _baseURL = @"test.ws.svoice.le.com";
        }else {
            _baseURL = @"ws.svoice.le.com";
        }
#else
        _baseURL = @"ws-svoice.le.com";
#endif
    }
    return self;
}

- (NSString*) getDelegatePcode {
    if (self.delegate && [self.delegate respondsToSelector: @selector(pcode)]) {
        return [self.delegate performSelector: @selector(pcode)];
    } else {
        return @"";
    }
}

- (NSString*) getDelegateVersion {
    if (self.delegate && [self.delegate respondsToSelector: @selector(version)]) {
        return [self.delegate performSelector: @selector(version)];
    } else {
        return @"";
    }
}

- (NSString*) getDelegateDid {
    if (self.delegate && [self.delegate respondsToSelector: @selector(did)]) {
        return [self.delegate performSelector: @selector(did)];
    } else {
        return @"";
    }
}

- (void) getWSTokenWithAccessToken: (NSString*) accessToken
                        orDeviceId: (NSString*) deviceId
                             pcode: (NSString*) pcode
                           version: (NSString*) version
                           success: (void (^)(NSString* token)) success
                           failure: (void (^)(NSError* error)) failure {
    NSString *did = [self getDelegateDid];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithDictionary: @{
        @"pcode": pcode,
        @"version": version,
        @"did":[NSString sy_safeString:did],
    }];
    if (accessToken) {
        dict[@"utype"] = @"1";
        dict[@"accesstoken"] = accessToken;
    } else if (deviceId) {
        dict[@"utype"] = @"0";
        dict[@"devid"] = deviceId;
    }
    
    [self.http GET: @"/login"
        parameters: dict
          progress: nil
           success: ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass: [NSDictionary class]]
            && [responseObject[@"data"] isKindOfClass: [NSDictionary class]]
            && [responseObject[@"data"][@"token"] isKindOfClass: [NSString class]]) {
            NSString* token = responseObject[@"data"][@"token"];
            if (success) {
                success(token);
            }
        } else {
            if (failure) {
                NSError* error = [NSError errorWithDomain: @"com.le" code: -1 userInfo: @{
                    NSLocalizedDescriptionKey: responseObject,
                }];
                failure(error);
            }
        }
    }
           failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void) connectWithAccessToken: (NSString*) accessToken {
    NSString* pcode = [self getDelegatePcode];
    NSString* version = [self getDelegateVersion];
    [self getWSTokenWithAccessToken: accessToken
                         orDeviceId: nil
                              pcode: pcode
                            version: version
                            success:^(NSString *token) {
        [self.webSocket close];
        self.webSocket.delegate = nil;
        NSString* url = nil;
        NSString *did = [self getDelegateDid];

#ifdef UseSettingTestDevEnv
        url = [NSString stringWithFormat: @"ws://%@/ws?token=%@&pcode=%@&version=%@&did=%@", self.baseURL, token, pcode, version,did];
#else
       url = [NSString stringWithFormat: @"wss://%@/ws?token=%@&pcode=%@&version=%@&did=%@", self.baseURL, token, pcode, version,did];
#endif
        NSURLRequest* req = [NSURLRequest requestWithURL: [NSURL URLWithString:url]];
        self.webSocket = [[SRWebSocket alloc] initWithURLRequest: req];
        self.webSocket.delegate = self;
        [self.webSocket open];
    }
                            failure:^(NSError *error) {
                                NSLog(@"error is %@",error);
    }];
}

- (void) connectWithDeviceId: (NSString*) deviceId {
    NSString* pcode = [self getDelegatePcode];
    NSString* version = [self getDelegateVersion];
    [self getWSTokenWithAccessToken: nil
                         orDeviceId: deviceId
                              pcode: pcode
                            version: version
                            success:^(NSString *token) {
        [self.webSocket close];
        self.webSocket.delegate = nil;
        NSString* url = nil;
        NSString *did = [self getDelegateDid];
#ifdef UseSettingTestDevEnv
        url = [NSString stringWithFormat: @"ws://%@/ws?token=%@&pcode=%@&version=%@&did=%@", self.baseURL, token, pcode, version, did];
#else
        url = [NSString stringWithFormat: @"wss://%@/ws?token=%@&pcode=%@&version=%@&did=%@", self.baseURL, token, pcode, version, did];
#endif
        NSURLRequest* req = [NSURLRequest requestWithURL: [NSURL URLWithString:url]];
        self.webSocket = [[SRWebSocket alloc] initWithURLRequest: req];
        self.webSocket.delegate = self;
        [self.webSocket open];
    } failure:^(NSError *error) {
        
    }];
}

- (void) disconnect {
    [self.webSocket close];
}

- (BOOL) isConnected {
    if (nil != self.webSocket) {
        return self.webSocket.readyState != SR_CLOSED;
    }else {
        return NO;
    }
}

- (void) sendCommand: (TokenCommand*) command {
    NSString* json = [command json];
    [self.webSocket send: json];
}
#pragma mark -
#pragma mark getter

- (AFHTTPSessionManager*) http {
    if (!_http) {
        NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSString *url = nil;
#ifdef UseSettingTestDevEnv
        url = [NSString stringWithFormat: @"http://%@", self.baseURL];
#else
        url = [NSString stringWithFormat: @"https://%@", self.baseURL];
#endif
        NSURL* base = [NSURL URLWithString: url];
        AFHTTPSessionManager* http = [[AFHTTPSessionManager alloc] initWithBaseURL: base sessionConfiguration: config];
        http.responseSerializer = [AFJSONResponseSerializer serializer];
        [http.requestSerializer setValue:[SYSettingManager accessToken]
        forHTTPHeaderField:@"ssotk"];
        _http = http;
    }
    
    return _http;
}
#pragma mark -
#pragma mark SRWebSocketDelegate
- (BOOL) webSocketShouldConvertTextFrameToString: (SRWebSocket*) webSocket {
    return NO;
}

- (void)webSocket: (SRWebSocket*) webSocket didReceiveMessage: (id) message {
    NSData *data = nil;
    if (![message isKindOfClass:[NSData class]]) {
        if ([message isKindOfClass:[NSString class]]) {
            data = [message dataUsingEncoding:NSUTF8StringEncoding];
        }else {
            data = message;
        }
    }else {
        data = message;
    }
    id json = [NSJSONSerialization JSONObjectWithData: data options: 0 error: nil];
    if ([json isKindOfClass: [NSDictionary class]]) {
        NSDictionary* dict = (NSDictionary*) json;
        NSString* action = dict[ACTION_KEY];
        NSNumber *mt = [dict objectForKey:MT_KEY];
        NSNumber *code = [dict objectForKey:CODE_KEY];
        TokenCommand* command = nil;
        if (action && action.length) {
            if ([action isEqualToString: @"2001"]) {
                NSString *rid = [NSString stringWithFormat:@"%@",[dict objectForKey:ROOM_KEY]];
                command = [[TokenJoinRoomCommand alloc] initWithRoomId: rid];
            } else if ([action isEqualToString: @"2002"]) {
                command = [[TokenLeaveRoomCommand alloc] init];
            } else if ([action isEqualToString: @"1001"]) {
                NSString *uid = [NSString stringWithFormat:@"%@",[dict objectForKey:USER_KEY]];
                command = [[TokenUserCommand alloc] initWithUserId: uid message: [dict objectForKey:MESSAGE_KEY]];
            } else if ([action isEqualToString: @"1002"]) {
                NSString *rid = [NSString stringWithFormat:@"%@",[dict objectForKey:ROOM_KEY]];
                command = [[TokenRoomBroadcastCommand alloc] initWithRoomId: rid message: [dict objectForKey:MESSAGE_KEY]];
            } else if ([action isEqualToString: @"1003"]) {
                command = [[TokenAllRoomBroadcastCommand alloc] initWithMessage: [dict objectForKey:MESSAGE_KEY]];
            } else if ([action isEqualToString: @"1004"]) {
                command = [[TokenAllUserBroadcastCommand alloc] initWithMessage: [dict objectForKey:MESSAGE_KEY]];
            } else if ([action isEqualToString: @"3000"]) {
                // 连接消息
                NSLog(@"收到 3000 消息");
            } else if ([action isEqualToString: @"4000"]) {
                // 未知消息
                NSLog(@"收到 4000 消息");
            }
            if (command) {
                command.mt = [mt integerValue];
                command.code = [code integerValue];
                if (self.delegate && [self.delegate respondsToSelector: @selector(tokenIO:didReceiveTokenCommand:)]) {
                    [self.delegate performSelector: @selector(tokenIO:didReceiveTokenCommand:)
                                        withObject: self
                                        withObject: command];
                }
            }
        } else {
            // ERROR
            NSLog(@"action 为空: %@", json);
        }
    } else {
        NSLog(@"json 不是 dict: %@", json);
        // error
    }
}

- (void) webSocketDidOpen: (SRWebSocket*) webSocket {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    if (self.delegate && [self.delegate respondsToSelector: @selector(tokenIOConnected:)]) {
        [self.delegate performSelector: @selector(tokenIOConnected:) withObject: self];
    }
}

- (void) webSocket: (SRWebSocket*) webSocket didFailWithError: (NSError*) error {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void) webSocket: (SRWebSocket*) webSocket didCloseWithCode: (NSInteger) code reason: (NSString*) reason wasClean:(BOOL) wasClean {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSError* error = [NSError errorWithDomain: @"com.le" code: -1 userInfo: @{
        NSLocalizedDescriptionKey: reason ? reason : @"",
    }];
    if (self.delegate && [self.delegate respondsToSelector: @selector(tokenIODisconnected:withError:)]) {
        [self.delegate performSelector: @selector(tokenIODisconnected:withError:) withObject: self withObject: error];
    }
}

- (void) webSocket: (SRWebSocket*) webSocket didReceivePong: (NSData*) pongPayload {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
}
@end
