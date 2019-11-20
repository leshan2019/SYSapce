//
//  SYSocketEngine.m
//  Shining
//
//  Created by mengxiangjian on 2019/2/24.
//  Copyright © 2019 mengxiangjian. All rights reserved.
//

#import "SYSocketEngine.h"
#import "SRWebSocket.h"

@interface SYSocketEngine () <SRWebSocketDelegate>

@property (nonatomic, weak) id <SYSocketEngineDelegate> delegate;
@property (nonatomic, strong) NSString *roomId;
@property (nonatomic, strong) SRWebSocket *socket;

@end

@implementation SYSocketEngine

- (void)openWithRoomId:(NSString *)roomId
              delegate:(id <SYSocketEngineDelegate>) delegate {
    self.delegate = delegate;
    self.roomId = roomId;
    if (roomId) {
        self.socket = [[SRWebSocket alloc] initWithURL:nil];
        self.socket.delegate = self;
        [self.socket open];
    }
}

- (void)close {
    [self.socket close];
}

#pragma mark - delegate method

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code
           reason:(NSString *)reason wasClean:(BOOL)wasClean {
    
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    
}

@end
