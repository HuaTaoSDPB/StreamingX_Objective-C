//
//  StreamingXRtcTool.h
//  StreamingXRtcManager
//
//  Created by sportmoment on 2023/6/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StreamingXRtcTool : NSObject

/// 获取加密的请求头
/// @param access_key_secret access_key_secret
/// @param access_key_id access_key_id
/// @param access_key_token access_key_token
 + (NSDictionary *)streamingX_getEncodeHeaderWithAccess_key_secret:(NSString *)access_key_secret
                                                     access_key_id:(NSString *)access_key_id
                                                  access_key_token:(NSString *)access_key_token;

@end

NS_ASSUME_NONNULL_END
