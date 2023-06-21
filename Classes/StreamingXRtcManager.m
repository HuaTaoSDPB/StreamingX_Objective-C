//
//  StreamingXRtcManager.m
//  StreamingXRtcManager
//
//  Created by sportmoment on 2023/6/12.
//

#define WSS_URL @"wss://api.hitradegate.com/v1/ws"
#define WSS_HEART_TIME 5

#import "StreamingXRtcManager.h"
#import <SRWebSocket.h>
#import "StreamingXRtcTool.h"

typedef void(^StreamingXRtcManagerGetMessageListBlock)(getDiffChannelMsgRecordAck * responseModel);
typedef void(^StreamingXRtcManagerSendMessageAckBlock)(channelMsgRecord * msg, channelMsgRecordAck * responseModel);

@interface StreamingXRtcManager () <SRWebSocketDelegate>
/// 授权秘钥
@property (nonatomic, copy) NSString * access_key_secret;
@property (nonatomic, copy) NSString * access_key_id;
@property (nonatomic, copy) NSString * access_key_token;
/// Wss
@property (nonatomic, strong) SRWebSocket * streamingXWebSocket;
/// 心跳计时器
@property (nonatomic, strong) NSTimer * streamingXHeartTimer;
/// 频道ID
@property (nonatomic, copy) NSString * streamingXChannelId;
/// Wss是否秘钥验证成功
@property (nonatomic, assign) BOOL streamingXIsConnectSuccess;
/// 收到rtc房间消息 （列表）
@property (nonatomic, copy) StreamingXRtcManagerGetMessageListBlock streamingXRtcManagerGetMessageListBlock;
/// 发送房间消息
@property (nonatomic, copy) StreamingXRtcManagerSendMessageAckBlock streamingXRtcManagerSendMessageAckBlock;
/// 当前正在发送的消息，发送完成后移除
@property (nonatomic, strong) NSMutableDictionary * streamingXSendingMsgDictionary;
@end

@implementation StreamingXRtcManager

#pragma mark - 生命周期
/// 单例初始化
+ (StreamingXRtcManager *)shareStreamingXRtcManager {
    static StreamingXRtcManager * streamingXRtcManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        streamingXRtcManager = [[StreamingXRtcManager alloc] init];
    });
    return streamingXRtcManager;
}

- (NSTimer *)streamingXHeartTimer {
    if (!_streamingXHeartTimer) {
        _streamingXHeartTimer = [NSTimer timerWithTimeInterval:WSS_HEART_TIME target:self selector:@selector(streamingXSendPing) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_streamingXHeartTimer forMode:NSDefaultRunLoopMode];
    }
    return _streamingXHeartTimer;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.agorartcManager = [StreamingXAgoraRtcEngineManager shareStreamingXRtcManager];
        [self streamingXAddAgorartcNotification];
    }
    return self;
}

- (NSMutableDictionary *)streamingXSendingMsgDictionary {
    if (!_streamingXSendingMsgDictionary) {
        _streamingXSendingMsgDictionary = [NSMutableDictionary new];
    }
    return _streamingXSendingMsgDictionary;
}

#pragma mark - 声网相关处理

- (void)streamingXAddAgorartcNotification {
    __weak typeof(self) weakSelf = self;
    [self.agorartcManager setStreamingXAgoraRtcEngineOfflineBlock:^(NSInteger uid, AgoraUserOfflineReason reason) {
        //离线处理
        weakSelf.streamingXChannelId = nil;
        [weakSelf.agorartcManager streamingX_leaveRtcChannel:^(AgoraChannelStats * _Nonnull stat) {
        }];
        if (weakSelf.streamingXIsLog) {
            NSLog(@"StreamingX log : 收到离线通知 reason = %@",@(reason));
            if (weakSelf.streamingXRtcManagerReceiveLogMsgBlock) {
                weakSelf.streamingXRtcManagerReceiveLogMsgBlock([NSString stringWithFormat:@"StreamingX log : 收到离线通知 reason = %@",@(reason)], nil);
            }
        }
        if (weakSelf.streamingXRtcManagerReceiveOfflineBlock) {
            weakSelf.streamingXRtcManagerReceiveOfflineBlock(uid, reason);
        }
    }];
    [self.agorartcManager setStreamingXAgoraRtcEngineTokenRefreshBlock:^(NSString * _Nonnull log, NSError * _Nullable error) {
        if (weakSelf.streamingXRtcManagerReceiveLogMsgBlock) {
            weakSelf.streamingXRtcManagerReceiveLogMsgBlock(log, error);
        }
    }];
}

#pragma mark - 初始化
/// 初始化
/// @param access_key_secret 秘钥
/// @param access_key_id ID
/// @param access_key_token Token
+ (StreamingXRtcManager *)initStreamingXRtcManagerWithAccess_key_secret:(NSString *)access_key_secret
                                        access_key_id:(NSString *)access_key_id
                                     access_key_token:(NSString *)access_key_token {
        
    [StreamingXRtcManager shareStreamingXRtcManager].access_key_secret = access_key_secret;
    [StreamingXRtcManager shareStreamingXRtcManager].access_key_id = access_key_id;
    [StreamingXRtcManager shareStreamingXRtcManager].access_key_token = access_key_token;
    
    if ([StreamingXRtcManager shareStreamingXRtcManager].streamingXWebSocket) {
        [StreamingXRtcManager shareStreamingXRtcManager].streamingXWebSocket.delegate = nil;
        [[StreamingXRtcManager shareStreamingXRtcManager].streamingXWebSocket close];
        [StreamingXRtcManager shareStreamingXRtcManager].streamingXWebSocket = nil;
    }
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:WSS_URL]];
    request.allHTTPHeaderFields = [StreamingXRtcTool streamingX_getEncodeHeaderWithAccess_key_secret:access_key_secret access_key_id:access_key_id access_key_token:access_key_token];
    [StreamingXRtcManager shareStreamingXRtcManager].streamingXWebSocket = [[SRWebSocket alloc] initWithURLRequest:request];
    [StreamingXRtcManager shareStreamingXRtcManager].streamingXWebSocket.delegate = [StreamingXRtcManager shareStreamingXRtcManager];
    [[StreamingXRtcManager shareStreamingXRtcManager].streamingXWebSocket open];
    return [StreamingXRtcManager shareStreamingXRtcManager];
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    [self.streamingXHeartTimer fire];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    if (self.streamingXIsLog) {
        NSLog(@"StreamingX log : Websocket Failed With Error %@", error);
        if (self.streamingXRtcManagerReceiveLogMsgBlock) {
            self.streamingXRtcManagerReceiveLogMsgBlock(@"StreamingX log : Websocket Failed With Error", error);
        }
    }
    self.streamingXIsConnectSuccess = NO;
    if (self.streamingXRtcManagerInitResultBlock) {
        self.streamingXRtcManagerInitResultBlock(NO, error);
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessageWithData:(NSData *)data {
    [self streamingXDealWithWwsData:data];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessageWithString:(nonnull NSString *)string {
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    if (self.streamingXIsLog) {
        NSLog(@"StreamingX log : WebSocket closed code:%@ reason:%@", @(code),reason);
        if (self.streamingXRtcManagerReceiveLogMsgBlock) {
            self.streamingXRtcManagerReceiveLogMsgBlock([NSString stringWithFormat:@"StreamingX log : WebSocket closed code:%@ reason:%@",@(code),reason], nil);
        }
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
}

#pragma mark - 收发消息

- (void)streamingXSendPing {
    ping * pingModel = [ping new];
    pingModel.channelId = self.streamingXChannelId;
    messageFrame * msgModel = [messageFrame new];
    msgModel.crc32 = crcPing;
    msgModel.data_p = pingModel.data;
    [self.streamingXWebSocket sendPing:msgModel.data error:nil];
    [self.streamingXWebSocket sendData:msgModel.data error:nil];
    if (self.streamingXIsLog) {
        NSLog(@"StreamingX log : send ping");
        if (self.streamingXRtcManagerReceiveLogMsgBlock) {
            self.streamingXRtcManagerReceiveLogMsgBlock(@"StreamingX log : send ping", nil);
        }
    }
}

- (void)streamingXSendGetDiffMessageRecordWithChannelId:(NSString *)channelId
                                                  msgId:(uint32_t)msgId {
    getDiffChannelMsgRecord * msgRecord = [getDiffChannelMsgRecord new];
    msgRecord.msgId = msgId;
    msgRecord.channelId = channelId;
    messageFrame * msgModel = [messageFrame new];
    msgModel.crc32 = crcGetDiffChannelMsgRecord;
    msgModel.data_p = msgRecord.data;
    [self.streamingXWebSocket sendData:msgModel.data error:nil];
    if (self.streamingXIsLog) {
        NSLog(@"StreamingX log : send 获取房间消息列表");
        if (self.streamingXRtcManagerReceiveLogMsgBlock) {
            self.streamingXRtcManagerReceiveLogMsgBlock(@"StreamingX log : send 获取房间消息列表", nil);
        }
    }
}

- (void)streamingXSendChannelMessageWithChannelId:(NSString *)channelId
                                              uid:(NSString *)uid
                                          content:(NSString *)content
                                             lang:(NSString *)lang {
    channelMsgRecord * msgRecord = [channelMsgRecord new];
    msgRecord.from = uid;
    msgRecord.channelId = channelId;
    msgRecord.msg = content;
    msgRecord.lang = lang;
    msgRecord.msgFp = [NSUUID new].UUIDString;
    msgRecord.sendTime = (int64_t)([NSDate new].timeIntervalSince1970*1000);
    messageFrame * msgModel = [messageFrame new];
    msgModel.crc32 = crcChannelMsgRecord;
    msgModel.data_p = msgRecord.data;
    [self.streamingXWebSocket sendData:msgModel.data error:nil];
    [self.streamingXSendingMsgDictionary setValue:msgRecord forKey:msgRecord.msgFp];
    if (self.streamingXIsLog) {
        NSLog(@"StreamingX log : 发送rtc房间消息:%@",content);
        if (self.streamingXRtcManagerReceiveLogMsgBlock) {
            self.streamingXRtcManagerReceiveLogMsgBlock([NSString stringWithFormat:@"StreamingX log : 发送rtc房间消息:%@",content], nil);
        }
    }
}

- (void)streamingXDealWithWwsData:(NSData *)wssData {
    messageFrame * receiveData = [messageFrame parseFromData:wssData error:nil];
    switch (receiveData.crc32) {
            //验证失败
        case crcError:
        {
            WssError * model = [WssError parseFromData:receiveData.data_p error:nil];
            if (model.code == 401) {
                self.streamingXIsConnectSuccess = NO;
                if (self.streamingXRtcManagerInitResultBlock) {
                    NSError * error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:401 userInfo:@{NSLocalizedDescriptionKey:model.message,NSLocalizedFailureReasonErrorKey:model.message}];
                    self.streamingXRtcManagerInitResultBlock(NO, error);
                    if (self.streamingXIsLog) {
                        NSLog(@"StreamingX log : 秘钥验证失败");
                        if (self.streamingXRtcManagerReceiveLogMsgBlock) {
                            self.streamingXRtcManagerReceiveLogMsgBlock(@"StreamingX log : 秘钥验证失败", error);
                        }
                    }
                }
            }else {
                // to do
            }
        }
            break;
            //心跳回执
        case crcPong:
            if (!self.streamingXIsConnectSuccess) {
                self.streamingXIsConnectSuccess = YES;
                if (self.streamingXRtcManagerInitResultBlock) {
                    self.streamingXRtcManagerInitResultBlock(YES, nil);
                }
            }
            if (self.streamingXIsLog) {
                NSLog(@"StreamingX log : received pong");
                if (self.streamingXRtcManagerReceiveLogMsgBlock) {
                    self.streamingXRtcManagerReceiveLogMsgBlock(@"StreamingX log : received pong", nil);
                }
            }
            break;
            //发送聊天消息回执
        case crcChannelMsgRecordAck:
        {
            channelMsgRecordAck * model = [channelMsgRecordAck parseFromData:receiveData.data_p error:nil];
            channelMsgRecord * record = self.streamingXSendingMsgDictionary[model.fp];
            if (self.streamingXRtcManagerSendMessageAckBlock) {
                record.msgId = model.msgId;
                self.streamingXRtcManagerSendMessageAckBlock(record,model);
            }
            [self.streamingXSendingMsgDictionary removeObjectForKey:model.fp];
            if (self.streamingXIsLog) {
                NSLog(@"StreamingX log : 聊天消息发送成功回执 %@",model.fp);
                if (self.streamingXRtcManagerReceiveLogMsgBlock) {
                    self.streamingXRtcManagerReceiveLogMsgBlock([NSString stringWithFormat:@"StreamingX log : 聊天消息发送成功回执 %@",model.fp], nil);
                }
            }
        }
            break;
            //收到聊天消息
        case crcRcvChannelMsgRecord:
        {
            rcvChannelMsgRecord * model = [rcvChannelMsgRecord parseFromData:receiveData.data_p error:nil];
            if (self.streamingXRtcManagerReceiveMessageBlock) {
                self.streamingXRtcManagerReceiveMessageBlock(model);
            }
            if (self.streamingXIsLog) {
                NSLog(@"StreamingX log : 收到聊天消息 %@",model.msg.msg);
                if (self.streamingXRtcManagerReceiveLogMsgBlock) {
                    self.streamingXRtcManagerReceiveLogMsgBlock([NSString stringWithFormat:@"StreamingX log : 收到聊天消息 %@",model.msg.msg], nil);
                }
            }
        }
            break;
            //获取频道聊天消息
        case crcGetDiffChannelMsgRecordAck:
        {
            getDiffChannelMsgRecordAck * model = [getDiffChannelMsgRecordAck parseFromData:receiveData.data_p error:nil];
            if (self.streamingXRtcManagerGetMessageListBlock) {
                self.streamingXRtcManagerGetMessageListBlock(model);
            }
            if (self.streamingXIsLog) {
                NSLog(@"StreamingX log : 拉取聊天记录成功（从某条消息开始拉取）");
                if (self.streamingXRtcManagerReceiveLogMsgBlock) {
                    self.streamingXRtcManagerReceiveLogMsgBlock(@"StreamingX log : 拉取聊天记录成功（从某条消息开始拉取）", nil);
                }
            }
        }
            break;
            //频道状态变更
        case crcChannelStateChange:
        {
            channelStateChange * model = [channelStateChange parseFromData:receiveData.data_p error:nil];
            if (self.streamingXRtcManagerReceiveChannelStateChangedBlock) {
                self.streamingXRtcManagerReceiveChannelStateChangedBlock(model);
            }
            self.streamingXChannelId = nil;
            [self.agorartcManager streamingX_leaveRtcChannel:^(AgoraChannelStats * _Nonnull stat) {
            }];
            if (self.streamingXIsLog) {
                NSLog(@"StreamingX log : 频道状态变更 %@",@(model.ch.state));
                if (self.streamingXRtcManagerReceiveLogMsgBlock) {
                    self.streamingXRtcManagerReceiveLogMsgBlock([NSString stringWithFormat:@"StreamingX log : 频道状态变更 %@",@(model.ch.state)], nil);
                }
            }
        }
            break;
            //频道用户状态变更
        case crcChannelUserStateChange:
        {
            channelUserStateChange * model = [channelUserStateChange parseFromData:receiveData.data_p error:nil];
            if (self.streamingXRtcManagerReceiveUserStateChangedBlock) {
                self.streamingXRtcManagerReceiveUserStateChangedBlock(model);
            }
            self.streamingXChannelId = nil;
            [self.agorartcManager streamingX_leaveRtcChannel:^(AgoraChannelStats * _Nonnull stat) {
            }];
            if (self.streamingXIsLog) {
                NSLog(@"StreamingX log : 用户状态变更 %@",@(model.chu.state));
                if (self.streamingXRtcManagerReceiveLogMsgBlock) {
                    self.streamingXRtcManagerReceiveLogMsgBlock([NSString stringWithFormat:@"StreamingX log : 用户状态变更 %@",@(model.chu.state)], nil);
                }
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - 网络请求

/// 获取主播列表
/// @param sort 排序 0.时间倒序 1.分数倒序
/// @param page 从第0页开始分页
/// @param limit 分页限制字段，默认10，最多50
/// @param block 成功回调
/// @param errorBlock 失败回调
+ (void)streamingX_getAnchorListWithSort:(NSInteger)sort
                                    page:(NSInteger)page
                                    limit:(NSInteger)limit
                                   block:(void(^)(StreamingXResponse_AnchorList * responseModel))block
                              errorBlock:(void(^)(NSError * error))errorBlock {
    [StreamingXHttpManager streamingX_getAnchorListWithSort:sort page:page limit:limit block:block errorBlock:errorBlock httpHeader:[StreamingXRtcTool streamingX_getEncodeHeaderWithAccess_key_secret:[StreamingXRtcManager shareStreamingXRtcManager].access_key_secret access_key_id:[StreamingXRtcManager shareStreamingXRtcManager].access_key_id access_key_token:[StreamingXRtcManager shareStreamingXRtcManager].access_key_token]];
}

/// 获取主播头像数组
/// @param anchorId 主播ID
/// @param block 成功回调
/// @param errorBlock 失败回调
+ (void)streamingX_getAnchorAvatarsWithAnchorId:(NSInteger)anchorId
                                           block:(void(^)(StreamingXResponse_AnchorAvatarList * responseModel))block
                                     errorBlock:(void(^)(NSError * error))errorBlock {
    [StreamingXHttpManager streamingX_getAnchorAvatarsWithAnchorId:anchorId block:block errorBlock:errorBlock httpHeader:[StreamingXRtcTool streamingX_getEncodeHeaderWithAccess_key_secret:[StreamingXRtcManager shareStreamingXRtcManager].access_key_secret access_key_id:[StreamingXRtcManager shareStreamingXRtcManager].access_key_id access_key_token:[StreamingXRtcManager shareStreamingXRtcManager].access_key_token]];
}

/// 刷新频道token
/// @param channelId 频道ID
/// @param block 成功回调
/// @param errorBlock 失败回调
+ (void)streamingX_refreshTokenWithChannelId:(NSString *)channelId
                                       block:(void(^)(StreamingXResponse_RefreshTokenResult * responseModel))block
                                  errorBlock:(void(^)(NSError * error))errorBlock {
    [StreamingXHttpManager streamingX_refreshTokenWithChannelId:channelId block:block errorBlock:errorBlock httpHeader:[StreamingXRtcTool streamingX_getEncodeHeaderWithAccess_key_secret:[StreamingXRtcManager shareStreamingXRtcManager].access_key_secret access_key_id:[StreamingXRtcManager shareStreamingXRtcManager].access_key_id access_key_token:[StreamingXRtcManager shareStreamingXRtcManager].access_key_token]];
}

/// 获取当前rtc房间消息列表
/// @param channelId 频道ID
/// @param msgId 最近一条消息id 不传就是获取所有消息
/// @param block 成功回调
/// @param errorBlock 失败回调
+ (void)streamingX_refreshTokenWithChannelId:(NSString *)channelId
                                       msgId:(uint32_t)msgId
                                       block:(void(^)(getDiffChannelMsgRecordAck * responseModel))block
                                  errorBlock:(void(^)(NSError * error))errorBlock {
    [[StreamingXRtcManager shareStreamingXRtcManager] streamingXSendGetDiffMessageRecordWithChannelId:channelId msgId:msgId];
    [StreamingXRtcManager shareStreamingXRtcManager].streamingXRtcManagerGetMessageListBlock = block;
}

/// rtc房间发送消息
/// @param channelId 频道ID
/// @param uid 用户id
/// @param content 消息内容
/// @param lang 语言（默认en）
/// @param block 成功回调
/// @param errorBlock 失败回调
+ (void)streamingX_sendMsgWithChannelId:(NSString *)channelId
                                    uid:(NSString *)uid
                                content:(NSString *)content
                                   lang:(NSString *)lang
                                       block:(void(^)(channelMsgRecord * msg, channelMsgRecordAck * responseModel))block
                             errorBlock:(void(^)(NSError * error))errorBlock {
    [[StreamingXRtcManager shareStreamingXRtcManager] streamingXSendChannelMessageWithChannelId:channelId uid:uid content:content lang:lang];
    [StreamingXRtcManager shareStreamingXRtcManager].streamingXRtcManagerSendMessageAckBlock = block;
}

/// 加入房间
/// @param token token
/// @param channelId 房间id
/// @param uid 用户id
/// @param joinSuccessBlock 回调
+ (void)streamingX_joinInChannelWithToken:(NSString* _Nullable)token channelId:(NSString* _Nonnull)channelId uid:(NSUInteger)uid joinSuccess:(void (^_Nullable)(NSString* _Nonnull channel, NSUInteger uid, NSInteger elapsed))joinSuccessBlock {
    [StreamingXRtcManager shareStreamingXRtcManager].streamingXChannelId = channelId;
    [[StreamingXRtcManager shareStreamingXRtcManager].agorartcManager streamingX_joinInChannelWithToken:token channelId:channelId uid:uid joinSuccess:joinSuccessBlock];
}

/// 离开房间
/// @param leaveChannelBlock 回调
+ (void)streamingX_leaveRtcChannel:(void(^ _Nullable)(AgoraChannelStats * _Nonnull stat))leaveChannelBlock {
    [StreamingXRtcManager shareStreamingXRtcManager].streamingXChannelId = nil;
    [[StreamingXRtcManager shareStreamingXRtcManager].agorartcManager streamingX_leaveRtcChannel:leaveChannelBlock];
}

@end
