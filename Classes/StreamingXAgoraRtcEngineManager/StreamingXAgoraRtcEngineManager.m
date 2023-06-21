//
//  StreamingXAgoraRtcEngineManager.m
//  StreamingXRtcManager
//
//  Created by sportmoment on 2023/6/15.
//

#import "StreamingXAgoraRtcEngineManager.h"
#define AgoraRtcID @"d204e16e727048b08a1d8e1ae10bb238"
#import "StreamingXRtcManager.h"

@interface StreamingXAgoraRtcEngineManager () <AgoraRtcEngineDelegate>
@property (nonatomic, copy) NSString *channelId;
@end

@implementation StreamingXAgoraRtcEngineManager

#pragma mark - 生命周期
/// 单例初始化
+ (StreamingXAgoraRtcEngineManager *)shareStreamingXRtcManager {
    static StreamingXAgoraRtcEngineManager * streamingXAgoraRtcEngineManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        streamingXAgoraRtcEngineManager = [[StreamingXAgoraRtcEngineManager alloc] init];
    });
    return streamingXAgoraRtcEngineManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.agoraRtcEngineKit = [AgoraRtcEngineKit sharedEngineWithAppId:AgoraRtcID delegate:self];
        [self.agoraRtcEngineKit setChannelProfile:AgoraChannelProfileLiveBroadcasting];
        [self.agoraRtcEngineKit setClientRole:AgoraClientRoleBroadcaster];
        [self.agoraRtcEngineKit enableVideo];
        [self.agoraRtcEngineKit enableAudio];
        [self.agoraRtcEngineKit enableLocalVideo:YES];
        [self.agoraRtcEngineKit enableLocalAudio:YES];
        [self.agoraRtcEngineKit setEnableSpeakerphone:YES];
        [self streamingX_openBeautyOption];
        [self streamingX_setAgoraVideoEncoderConfiguration];
        [self streamingX_configLocalAgoraRtcVideoCanvas];
        [self streamingX_configRemoteAgoraRtcVideoCanvas];
    }
    return self;
}

/// 加入房间
- (void)streamingX_joinInChannelWithToken:(NSString* _Nullable)token channelId:(NSString* _Nonnull)channelId uid:(NSUInteger)uid joinSuccess:(void (^_Nullable)(NSString* _Nonnull channel, NSUInteger uid, NSInteger elapsed))joinSuccessBlock {
    self.channelId = channelId;
    [self.agoraRtcEngineKit joinChannelByToken:token channelId:channelId info:nil uid:uid joinSuccess:joinSuccessBlock];
}

/// 开启美颜信息
- (void)streamingX_openBeautyOption {
    AgoraBeautyOptions * agoraBeautyOptions = [[AgoraBeautyOptions alloc] init];
    agoraBeautyOptions.lighteningLevel = 0.7;
    agoraBeautyOptions.lighteningContrastLevel = AgoraLighteningContrastHigh;
    agoraBeautyOptions.rednessLevel = 0.1;
    agoraBeautyOptions.smoothnessLevel = 0.5;
    [self.agoraRtcEngineKit setBeautyEffectOptions:YES options:agoraBeautyOptions];
}

/// video encoder configuration
- (void)streamingX_setAgoraVideoEncoderConfiguration {
    AgoraVideoEncoderConfiguration *agoraVideoEncoderConfiguration = [[AgoraVideoEncoderConfiguration alloc] initWithSize:AgoraVideoDimension640x360 frameRate:AgoraVideoFrameRateFps15 bitrate:900 orientationMode:AgoraVideoOutputOrientationModeAdaptative mirrorMode:AgoraVideoMirrorModeAuto];
    [self.agoraRtcEngineKit setVideoEncoderConfiguration:agoraVideoEncoderConfiguration];
}

/// local video canvas
- (void)streamingX_configLocalAgoraRtcVideoCanvas {
    _localAgoraRtcVideoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    _localAgoraRtcVideoCanvas.renderMode = AgoraVideoRenderModeHidden;
    _localAgoraRtcVideoCanvas.uid = 0;
}

/// remote video canvas
- (void)streamingX_configRemoteAgoraRtcVideoCanvas {
    _remoteAgoraRtcVideoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    _remoteAgoraRtcVideoCanvas.renderMode = AgoraVideoRenderModeHidden;
}

/// 更新远程视频流view
- (void)streamingX_updateRemoteView:(UIView * __nullable)view {
    if (view) {
        if (!_remoteAgoraRtcVideoCanvas) {
            [self streamingX_configRemoteAgoraRtcVideoCanvas];
        }
        _remoteAgoraRtcVideoCanvas.view = view;
        [self.agoraRtcEngineKit setupRemoteVideo:_remoteAgoraRtcVideoCanvas];
    }else{
        _remoteAgoraRtcVideoCanvas.view = view;
        [self.agoraRtcEngineKit setupRemoteVideo:_remoteAgoraRtcVideoCanvas];
    }
}

/// 更新本地视频流view
- (void)streamingX_updateLocalView:(UIView * __nullable)view {
    if (view) {
        if (!_localAgoraRtcVideoCanvas) {
            [self streamingX_configLocalAgoraRtcVideoCanvas];
        }
        _localAgoraRtcVideoCanvas.view = view;
        [self.agoraRtcEngineKit setupLocalVideo:_localAgoraRtcVideoCanvas];
    }else{
        if (_localAgoraRtcVideoCanvas) {
            _localAgoraRtcVideoCanvas = nil;
            [self.agoraRtcEngineKit setupLocalVideo:nil];
        }
    }
}

/// 开启本地预览
- (void)streamingX_startpPreView {
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself.agoraRtcEngineKit startPreview];
    });
}

/// 停止本地预览
- (void)streamingX_stopPreView {
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself.agoraRtcEngineKit stopPreview];
    });
}

/// 离开房间
- (void)streamingX_leaveRtcChannel:(void(^ _Nullable)(AgoraChannelStats * _Nonnull stat))leaveChannelBlock {
    [self.agoraRtcEngineKit leaveChannel:leaveChannelBlock];
    [self streamingX_updateLocalView:nil];
    [self streamingX_updateRemoteView:nil];
}

#pragma mark - AgoraRtcEngineDelegate

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didJoinChannel:(NSString * _Nonnull)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    if (self.delegate && [self.delegate respondsToSelector:@selector(streamingX_rtcEngine:didJoinChannel:withUid:elapsed:)]) {
        [self.delegate streamingX_rtcEngine:engine didJoinChannel:channel withUid:uid elapsed:elapsed];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didRejoinChannel:(NSString * _Nonnull)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    if (self.delegate && [self.delegate respondsToSelector:@selector(streamingX_rtcEngine:didRejoinChannel:withUid:elapsed:)]) {
        [self.delegate streamingX_rtcEngine:engine didRejoinChannel:channel withUid:uid elapsed:elapsed];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didClientRoleChanged:(AgoraClientRole)oldRole newRole:(AgoraClientRole)newRole newRoleOptions:(AgoraClientRoleOptions * _Nullable)newRoleOptions {
    if (self.delegate && [self.delegate respondsToSelector:@selector(streamingX_rtcEngine:didClientRoleChanged:newRole:newRoleOptions:)]) {
        [self.delegate streamingX_rtcEngine:engine didClientRoleChanged:oldRole newRole:newRole newRoleOptions:newRoleOptions];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didClientRoleChangeFailed:(AgoraClientRoleChangeFailedReason)reason currentRole:(AgoraClientRole)currentRole {
    if (self.delegate && [self.delegate respondsToSelector:@selector(streamingX_rtcEngine:didClientRoleChangeFailed:currentRole:)]) {
        [self.delegate streamingX_rtcEngine:engine didClientRoleChangeFailed:reason currentRole:currentRole];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didLeaveChannelWithStats:(AgoraChannelStats * _Nonnull)stats {
    if (self.delegate && [self.delegate respondsToSelector:@selector(streamingX_rtcEngine:didLeaveChannelWithStats:)]) {
        [self.delegate streamingX_rtcEngine:engine didLeaveChannelWithStats:stats];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    _remoteAgoraRtcVideoCanvas.uid = uid;
    [self.agoraRtcEngineKit setupRemoteVideo:_remoteAgoraRtcVideoCanvas];
    if (self.delegate && [self.delegate respondsToSelector:@selector(streamingX_rtcEngine:didJoinedOfUid:elapsed:)]) {
        [self.delegate streamingX_rtcEngine:engine didJoinedOfUid:uid elapsed:elapsed];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason {
    if (self.streamingXAgoraRtcEngineOfflineBlock) {
        self.streamingXAgoraRtcEngineOfflineBlock(uid, reason);
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(streamingX_rtcEngine:didOfflineOfUid:reason:)]) {
        [self.delegate streamingX_rtcEngine:engine didOfflineOfUid:uid reason:reason];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine networkTypeChanged:(AgoraNetworkType)type {
    if (self.delegate && [self.delegate respondsToSelector:@selector(streamingX_rtcEngine:networkTypeChanged:)]) {
        [self.delegate streamingX_rtcEngine:engine networkTypeChanged:type];
    }
}

- (void)rtcEngineConnectionDidLost:(AgoraRtcEngineKit * _Nonnull)engine {
    if (self.delegate && [self.delegate respondsToSelector:@selector(streamingX_rtcEngineConnectionDidLost:)]) {
        [self.delegate streamingX_rtcEngineConnectionDidLost:engine];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine connectionStateChanged:(AgoraConnectionState)state reason:(AgoraConnectionChangedReason)reason {
    if (self.delegate && [self.delegate respondsToSelector:@selector(streamingX_rtcEngine:connectionStateChanged:reason:)]) {
        [self.delegate streamingX_rtcEngine:engine connectionStateChanged:state reason:reason];
    }
}

- (void)rtcEngineRequestToken:(AgoraRtcEngineKit * _Nonnull)engine {
    if (self.delegate && [self.delegate respondsToSelector:@selector(streamingX_rtcEngineRequestToken:)]) {
        [self.delegate streamingX_rtcEngineRequestToken:engine];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine tokenPrivilegeWillExpire:(NSString *_Nonnull)token {
    //token到期提醒，需要刷新token
    [StreamingXRtcManager streamingX_refreshTokenWithChannelId:self.channelId block:^(StreamingXResponse_RefreshTokenResult * _Nonnull responseModel) {
        [self.agoraRtcEngineKit renewToken:responseModel.token];
        if (self.streamingXAgoraRtcEngineTokenRefreshBlock) {
            self.streamingXAgoraRtcEngineTokenRefreshBlock([NSString stringWithFormat:@"StreamingX log : 刷新房间token成功 token %@",responseModel.token], nil);
        }
        if ([StreamingXRtcManager shareStreamingXRtcManager].streamingXIsLog) {
            NSLog(@"StreamingX log : 刷新房间token成功 token %@", responseModel.token);
        }
    } errorBlock:^(NSError * _Nonnull error) {
        if (self.streamingXAgoraRtcEngineTokenRefreshBlock) {
            self.streamingXAgoraRtcEngineTokenRefreshBlock([NSString stringWithFormat:@"StreamingX log : 刷新房间失败"], error);
        }
        if ([StreamingXRtcManager shareStreamingXRtcManager].streamingXIsLog) {
            NSLog(@"StreamingX log : 刷新房间token失败 Error %@，请联系管理员", error);
        }
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(streamingX_rtcEngine:tokenPrivilegeWillExpire:)]) {
        [self.delegate streamingX_rtcEngine:engine tokenPrivilegeWillExpire:token];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didOccurError:(AgoraErrorCode)errorCode {
    if (self.delegate && [self.delegate respondsToSelector:@selector(streamingX_rtcEngine:didOccurError:)]) {
        [self.delegate streamingX_rtcEngine:engine didOccurError:errorCode];
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit * _Nonnull)engine didOccurWarning:(AgoraWarningCode)warningCode {
    if (self.delegate && [self.delegate respondsToSelector:@selector(streamingX_rtcEngine:didOccurWarning:)]) {
        [self.delegate streamingX_rtcEngine:engine didOccurWarning:warningCode];
    }
}

@end
