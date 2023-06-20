//
//  StreamingXEnumHeader.h
//  StreamingXRtcManager
//
//  Created by sportmoment on 2023/6/13.
//

#ifndef StreamingXEnumHeader_h
#define StreamingXEnumHeader_h

/// 0.离线 1.在线空闲 2.在线忙碌 3.在线但不可用
typedef NS_ENUM(NSUInteger, StreamingX_AnchorState) {
    StreamingX_AnchorOfflineState = 0,
    StreamingX_AnchorOnlineAndFreeState,
    StreamingX_AnchorOnlineAndBusyState,
    StreamingX_AnchorOnlineButCannotUseState
};

/// 频道状态 0.未知 1.空闲 2.繁忙 3.已关闭 999.余额不足
typedef NS_ENUM(NSUInteger, StreamingX_ChannelState) {
    StreamingX_ChannelUnknownState = 0,
    StreamingX_ChannelFreeState,
    StreamingX_ChannelBusyState,
    StreamingX_ChannelClosedState,
    StreamingX_ChannelInsufficientBalanceState
};


#endif /* StreamingXEnumHeader_h */
