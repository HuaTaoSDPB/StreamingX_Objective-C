//
//  StreamingXResponse_RefreshTokenResult.h
//  StreamingXRtcManager
//
//  Created by sportmoment on 2023/6/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StreamingXResponse_RefreshTokenResult : NSObject
/// 频道ID
@property (nonatomic, copy) NSString * channelId;
/// 频道token
@property (nonatomic, copy) NSString * token;
/// token过期时间
@property (nonatomic, copy) NSString * expiration;
/// 进入频道时唯一ID
@property (nonatomic, copy) NSString * uniqId;
@end

NS_ASSUME_NONNULL_END
