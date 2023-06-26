//
//  StreamingXResponse_JoinChannelResult.h
//  StreamingXRtcManager
//
//  Created by sportmoment on 2023/6/13.
//

#import <Foundation/Foundation.h>
#import "StreamingXEnumHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface StreamingXResponse_Channel : NSObject
/// 频道ID
@property (nonatomic, copy) NSString * ID;
/// 频道类型
@property (nonatomic, assign) NSInteger category;
/// 频道状态 0.未知 1.空闲 2.繁忙 3.已关闭 999.余额不足
@property (nonatomic, assign) StreamingX_ChannelState state;
/// 频道开始时间
@property (nonatomic, copy) NSString * startTs;
/// 频道结束时间
@property (nonatomic, copy) NSString * endTs;
@end

@interface StreamingXResponse_JoinChannelResult : NSObject
/// 频道信息
@property (nonatomic, strong) StreamingXResponse_Channel * ch;
/// 频道token
@property (nonatomic, copy) NSString * token;
/// 进入频道的唯一ID
@property (nonatomic, copy) NSString * uniqId;
/// 主播状态: 0.离线 1.在线空闲 2.在线忙碌 3.在线但不可用
@property (nonatomic, assign) StreamingX_AnchorState broadcasterState;
@end

NS_ASSUME_NONNULL_END
