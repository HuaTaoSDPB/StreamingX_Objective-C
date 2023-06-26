//
//  StreamingXAgoraRtcEngineManager.h
//  StreamingXRtcManager
//
//  Created by sportmoment on 2023/6/15.
//

#import <Foundation/Foundation.h>
#import <AgoraRtcKit/AgoraRtcEngineKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol StreamingXAgoraRtcEngineDelegate <NSObject>
@optional
- (void)streamingX_rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didJoinChannel:(NSString * _Nonnull)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed;
- (void)streamingX_rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didRejoinChannel:(NSString * _Nonnull)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed;
- (void)streamingX_rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didClientRoleChanged:(AgoraClientRole)oldRole newRole:(AgoraClientRole)newRole newRoleOptions:(AgoraClientRoleOptions * _Nullable)newRoleOptions;
- (void)streamingX_rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didClientRoleChangeFailed:(AgoraClientRoleChangeFailedReason)reason currentRole:(AgoraClientRole)currentRole;
- (void)streamingX_rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didLeaveChannelWithStats:(AgoraChannelStats * _Nonnull)stats;
- (void)streamingX_rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed;
- (void)streamingX_rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason;
- (void)streamingX_rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine networkTypeChanged:(AgoraNetworkType)type;
- (void)streamingX_rtcEngineConnectionDidLost:(AgoraRtcEngineKit * _Nonnull)engine;
- (void)streamingX_rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine connectionStateChanged:(AgoraConnectionState)state reason:(AgoraConnectionChangedReason)reason;
- (void)streamingX_rtcEngineRequestToken:(AgoraRtcEngineKit * _Nonnull)engine;
- (void)streamingX_rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine tokenPrivilegeWillExpire:(NSString *_Nonnull)token;
- (void)streamingX_rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didOccurError:(AgoraErrorCode)errorCode;
- (void)streamingX_rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didOccurWarning:(AgoraWarningCode)warningCode;
@end

@interface StreamingXAgoraRtcEngineManager : NSObject
/// 代理
@property (nonatomic, weak) id<StreamingXAgoraRtcEngineDelegate> _Nullable delegate;
/// 声网rtc管理
@property (nonatomic, strong) AgoraRtcEngineKit *agoraRtcEngineKit;
/// 远端canvas
@property (nonatomic, strong) AgoraRtcVideoCanvas *remoteAgoraRtcVideoCanvas;
/// 本地canvas
@property (nonatomic, strong) AgoraRtcVideoCanvas *localAgoraRtcVideoCanvas;
/// 主播掉线等信息回调
@property (nonatomic, copy) void (^streamingXAgoraRtcEngineOfflineBlock)(NSInteger uid,AgoraUserOfflineReason reason);
/// 房间token过期刷新结果
@property (nonatomic, copy) void (^streamingXAgoraRtcEngineTokenRefreshBlock)(NSString *log,NSError * _Nullable error);
/// 单例初始化
+ (StreamingXAgoraRtcEngineManager *)shareStreamingXRtcManager;
/// 加入房间-不要直接调用，请使用StreamingXRtcManager调用
/// @param token token
/// @param channelId 频道id
/// @param uid 用户id
/// @param joinSuccessBlock 回调
- (void)streamingX_joinInChannelWithToken:(NSString* _Nullable)token channelId:(NSString* _Nonnull)channelId uid:(NSUInteger)uid joinSuccess:(void (^_Nullable)(NSString* _Nonnull channel, NSUInteger uid, NSInteger elapsed))joinSuccessBlock;
/// 离开房间-不要直接调用，请使用StreamingXRtcManager调用
/// @param leaveChannelBlock 回调
- (void)streamingX_leaveRtcChannel:(void(^ _Nullable)(AgoraChannelStats * _Nonnull stat))leaveChannelBlock;
/// 更新远程视频流view
- (void)streamingX_updateRemoteView:(UIView * __nullable)view;
/// 更新本地视频流view
- (void)streamingX_updateLocalView:(UIView * __nullable)view;
/// 开启本地预览
- (void)streamingX_startpPreView;
/// 停止本地预览
- (void)streamingX_stopPreView;
@end

NS_ASSUME_NONNULL_END
