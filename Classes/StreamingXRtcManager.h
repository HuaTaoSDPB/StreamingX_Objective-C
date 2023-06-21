//
//  StreamingXRtcManager.h
//  StreamingXRtcManager
//
//  Created by sportmoment on 2023/6/12.
//

#import <Foundation/Foundation.h>
#import "Http/StreamingXHttpManager.h"
#import "StreamingXAgoraRtcEngineManager.h"
#import "StreamingXProtobufHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface StreamingXRtcManager : NSObject
/// Wss是否秘钥验证成功
@property (nonatomic, assign, readonly) BOOL streamingXIsConnectSuccess;
/// rtc管理者
@property (nonatomic, strong) StreamingXAgoraRtcEngineManager *agorartcManager;
/// 初始化StreamingXRtcManager结果回调
@property (nonatomic, copy) void (^streamingXRtcManagerInitResultBlock)(BOOL isSuccess, NSError * _Nullable error);
/// 收到rtc房间消息
@property (nonatomic, copy) void (^streamingXRtcManagerReceiveMessageBlock)(rcvChannelMsgRecord *receivedMsg);
/// 收到房间状态变更消息 1.被系统提出房间 2.其他错误
@property (nonatomic, copy) void (^streamingXRtcManagerReceiveChannelStateChangedBlock)(channelStateChange *stateChangeModel);
/// 收到用户状态变更消息 1.房间正常停止 2.系统关闭房间 3.其他错误
@property (nonatomic, copy) void (^streamingXRtcManagerReceiveUserStateChangedBlock)(channelUserStateChange *stateChangeModel);
/// 离线通知
@property (nonatomic, copy) void (^streamingXRtcManagerReceiveOfflineBlock)(NSInteger uid, AgoraUserOfflineReason reason);
/// 是否打印日志，默认为FALSE
@property (nonatomic, assign) BOOL streamingXIsLog;
/// 日志信息 streamingXIsLog 为 TRUE 时，会调用(由于sdk比较简单，且为了减少本地储存空间占用，日志不会存储，如果需要，请自行存储)
@property (nonatomic, copy) void (^streamingXRtcManagerReceiveLogMsgBlock)(NSString *log,NSError * _Nullable error);

/// 初始化-每次更新秘钥，需要重新初始化一次，每次初始化都会断开链接重连，请慎重调用
/// @param access_key_secret 秘钥
/// @param access_key_id ID
/// @param access_key_token Token
+ (StreamingXRtcManager *)initStreamingXRtcManagerWithAccess_key_secret:(NSString *)access_key_secret
                                        access_key_id:(NSString *)access_key_id
                                     access_key_token:(NSString *)access_key_token;

/// 单例
+ (StreamingXRtcManager *)shareStreamingXRtcManager;

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
                              errorBlock:(void(^)(NSError * error))errorBlock;

/// 获取主播头像数组
/// @param anchorId 主播ID
/// @param block 成功回调
/// @param errorBlock 失败回调
+ (void)streamingX_getAnchorAvatarsWithAnchorId:(NSInteger)anchorId
                                           block:(void(^)(StreamingXResponse_AnchorAvatarList * responseModel))block
                                     errorBlock:(void(^)(NSError * error))errorBlock;

/// 刷新频道token
/// @param channelId 频道ID
/// @param block 成功回调
/// @param errorBlock 失败回调
+ (void)streamingX_refreshTokenWithChannelId:(NSString *)channelId
                                       block:(void(^)(StreamingXResponse_RefreshTokenResult * responseModel))block
                                  errorBlock:(void(^)(NSError * error))errorBlock;

/// 获取当前rtc房间消息列表(目前无用)
/// @param channelId 频道ID
/// @param msgId 最近一条消息id 不传就是获取所有消息
/// @param block 成功回调
/// @param errorBlock 失败回调
+ (void)streamingX_refreshTokenWithChannelId:(NSString *)channelId
                                       msgId:(uint32_t)msgId
                                       block:(void(^)(getDiffChannelMsgRecordAck * responseModel))block
                                  errorBlock:(void(^)(NSError * error))errorBlock;

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
                                  errorBlock:(void(^)(NSError * error))errorBlock;

/// 加入房间
/// @param token token
/// @param channelId 房间id
/// @param uid 用户id
/// @param joinSuccessBlock 回调
/// @param errorBlock 失败回调
+ (void)streamingX_joinInChannelWithToken:(NSString* _Nullable)token channelId:(NSString* _Nonnull)channelId uid:(NSUInteger)uid joinSuccess:(void (^_Nullable)(NSString* _Nonnull channel, NSUInteger uid, NSInteger elapsed))joinSuccessBlock errorBlock:(void(^)(NSError * error))errorBlock;

/// 离开房间
/// @param leaveChannelBlock 回调
+ (void)streamingX_leaveRtcChannel:(void(^ _Nullable)(AgoraChannelStats * _Nonnull stat))leaveChannelBlock;

@end

NS_ASSUME_NONNULL_END
