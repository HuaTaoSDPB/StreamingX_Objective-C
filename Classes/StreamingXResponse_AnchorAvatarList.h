//
//  StreamingXResponse_AnchorList.h
//  StreamingXRtcManager
//
//  Created by sportmoment on 2023/6/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StreamingXResponse_AnchorAvatar : NSObject
/// 本张图片的唯一随机值
@property (nonatomic, copy) NSString * md5;
/// 主播模糊头像（小头像）
@property (nonatomic, copy) NSString * avatarThumb;
/// 主播标准头像
@property (nonatomic, copy) NSString * avatarStandard;
/// 主播清晰头像
@property (nonatomic, copy) NSString * avatarClear;
@end

@interface StreamingXResponse_AnchorAvatarList : NSObject
/// 默认头像
@property (nonatomic, strong) StreamingXResponse_AnchorAvatar * defaultAvatar;
/// 所有头像
@property (nonatomic, strong) NSArray <StreamingXResponse_AnchorAvatar *>* others;
@end

NS_ASSUME_NONNULL_END
