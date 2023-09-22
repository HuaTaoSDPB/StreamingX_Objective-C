//
//  StreamingXHttpManager.h
//  StreamingXRtcManager
//
//  Created by sportmoment on 2023/6/12.
//

#import <Foundation/Foundation.h>
#import "StreamingXModelHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface StreamingXHttpManager : NSObject

/// 获取主播列表
/// @param sort 排序 0.时间倒序 1.分数倒序
/// @param page 从第0页开始分页
/// @param limit 分页限制字段，默认10，最多50
/// @param block 成功回调
/// @param errorBlock 失败回调
/// @param httpHeader 请求头信息
+ (void)streamingX_getAnchorListWithSort:(NSInteger)sort
                                    page:(NSInteger)page
                                    limit:(NSInteger)limit
                                   block:(void(^)(StreamingXResponse_AnchorList * responseModel))block
                               errorBlock:(void(^)(NSError * error))errorBlock
                               httpHeader:(NSDictionary *)httpHeader;

/// 获取主播个人信息
/// @param uid  主播ID
/// @param block 成功回调
/// @param errorBlock 失败回调
/// @param httpHeader 请求头信息
+ (void)streamingX_getAnchorInfoWithUid:(NSInteger)uid
                                   block:(void(^)(StreamingXResponse_Anchor * responseModel))block
                               errorBlock:(void(^)(NSError * error))errorBlock
                             httpHeader:(NSDictionary *)httpHeader;

/// 获取主播实时状态
/// @param uid  主播ID
/// @param block 成功回调
/// @param errorBlock 失败回调
/// @param httpHeader 请求头信息
+ (void)streamingX_getAnchorStateWithUid:(NSInteger)uid
                                   block:(void(^)(StreamingXResponse_AnchorState * responseModel))block
                               errorBlock:(void(^)(NSError * error))errorBlock
                             httpHeader:(NSDictionary *)httpHeader;

/// 获取主播头像数组
/// @param anchorId 主播ID
/// @param block 成功回调
/// @param errorBlock 失败回调
/// @param httpHeader 请求头信息
+ (void)streamingX_getAnchorAvatarsWithAnchorId:(NSInteger)anchorId
                                           block:(void(^)(StreamingXResponse_AnchorAvatarList * responseModel))block
                                     errorBlock:(void(^)(NSError * error))errorBlock
                                     httpHeader:(NSDictionary *)httpHeader;

/// 刷新频道token
/// @param channelId 频道ID
/// @param block 成功回调
/// @param errorBlock 失败回调
/// @param httpHeader 请求头信息
+ (void)streamingX_refreshTokenWithChannelId:(NSString *)channelId
                                       block:(void(^)(StreamingXResponse_RefreshTokenResult * responseModel))block
                                  errorBlock:(void(^)(NSError * error))errorBlock
                                  httpHeader:(NSDictionary *)httpHeader;

/// 匹配请求
/// @param dictionaryData 请求体
/// @param block 成功回调
/// @param errorBlock 失败回调
/// @param httpHeader 请求头信息
+ (void)streamingX_matchRequestWithDictionaryData:(NSDictionary *)dictionaryData
                                            block:(void(^)(void))block
                                       errorBlock:(void(^)(NSError * error))errorBlock
                                       httpHeader:(NSDictionary *)httpHeader;

/// 跳过匹配请求
/// @param block 成功回调
/// @param errorBlock 失败回调
/// @param httpHeader 请求头信息
+ (void)streamingX_skipMatchRequestWithBlock:(void(^)(void))block
                                       errorBlock:(void(^)(NSError * error))errorBlock
                                       httpHeader:(NSDictionary *)httpHeader;

/// 获取单个空闲主播
/// @param block 成功回调
/// @param errorBlock 失败回调
/// @param httpHeader 请求头信息
+ (void)streamingX_getSingleOnlineFreeAnchorRequestWithBlock:(void(^)(StreamingXResponse_Anchor * responseModel))block
                                       errorBlock:(void(^)(NSError * error))errorBlock
                                       httpHeader:(NSDictionary *)httpHeader;

@end

NS_ASSUME_NONNULL_END
