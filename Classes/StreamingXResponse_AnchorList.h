//
//  StreamingXResponse_AnchorList.h
//  StreamingXRtcManager
//
//  Created by sportmoment on 2023/6/13.
//

#import <Foundation/Foundation.h>
#import "StreamingXResponse_AnchorAvatarList.h"
#import "StreamingXEnumHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface StreamingXResponse_AnchorState : NSObject
/// 主播状态: 0.离线 1.在线空闲 2.在线忙碌 3.在线但不可用
@property (nonatomic, assign) StreamingX_AnchorState state;
/// 主播目前处在的频道
@property (nonatomic, copy) NSString * channelId;
@end

@interface StreamingXResponse_Anchor : NSObject
/// 主播id
@property (nonatomic, assign) NSInteger uid;
/// 主播名字
@property (nonatomic, copy) NSString * name;
/// 主播名字 (兼容服务端，请勿用此字段)
@property (nonatomic, copy) NSString * nick;
/// 主播生日sssss
@property (nonatomic, assign) NSInteger birthDay;
/// 主播认证状态 0.主播未审核 1.主播 2.被封禁 3.注销
@property (nonatomic, assign) StreamingX_AnchorAccountState state;
/// 主播状态: 0.离线 1.在线空闲 2.在线忙碌 3.在线但不可用
@property (nonatomic, assign) StreamingX_AnchorState onlineState;
/// 主播默认头像
@property (nonatomic, strong) StreamingXResponse_AnchorAvatar * defaultAvatar;
/// 主播目前处在的频道
@property (nonatomic, copy) NSString * currentChannel;
/// 主播位置编码
@property (nonatomic, copy) NSString * country;
/// 主播性别
@property (nonatomic, assign) NSInteger gender;
/// 主播语言
@property (nonatomic, copy) NSString * language;
@end

@interface StreamingXResponse_AnchorList : NSObject
/// 主播信息数组
@property (nonatomic, strong) NSArray <StreamingXResponse_Anchor *>* array;
@end

NS_ASSUME_NONNULL_END
