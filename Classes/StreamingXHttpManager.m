//
//  HttpManager.m
//  StreamingXRtcManager
//
//  Created by sportmoment on 2023/6/12.
//

#define StreamingX_baseUrl @"https://api.hitradegate.com/v1"
#define StreamingX_getAnchorListUrl @"/broadcaster/broadcaster"
#define StreamingX_getAnchorAvatarsUrl @"/broadcaster/broadcaster/%@/avatar"
#define StreamingX_refreshTokenUrl @"/channel/channel/%@/token"
#define StreamingX_requstMatchUrl @"/channel/channel/match"
#define StreamingX_requstSkipMatchUrl @"/channel/channel/match/skip"
#define StreamingX_getAnchorInfoUrl @"/broadcaster/broadcaster"
#define StreamingX_getAnchorStateUrl @"/broadcaster/broadcaster"
#define StreamingX_getSingleFreeAnchorUrl @"/broadcaster/broadcaster/free/one"

#import "StreamingXHttpManager.h"
#import <MJExtension/MJExtension.h>

@implementation StreamingXHttpManager

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
                              httpHeader:(NSDictionary *)httpHeader {
    [self streamingX_requestWithType:@"GET" dictionary:nil url:[NSString stringWithFormat:@"%@?sort=%@&page=%@&limit=%@",StreamingX_getAnchorListUrl,@(sort),@(page),@(limit)] httpHeader:httpHeader block:^(NSDictionary *dataDictionary) {
        StreamingXResponse_AnchorList * responseModel = [StreamingXResponse_AnchorList new];
        NSMutableArray * arr = [NSMutableArray array];
        NSArray * userList = dataDictionary[@"list"];
        NSDictionary * defaultAvatarMap = dataDictionary[@"defaultCoverMap"];
        NSDictionary * currentChannelMap = dataDictionary[@"currentChannel"];
        NSDictionary * stateMap = dataDictionary[@"stateMap"];
        for (NSInteger i = 0; i < userList.count; i ++) {
            NSDictionary * userDic = userList[i];
            StreamingXResponse_Anchor * model = [StreamingXResponse_Anchor mj_objectWithKeyValues:userDic];
            if (model) {
                NSDictionary * defaultAvatarDic = defaultAvatarMap[[NSString stringWithFormat:@"%@",@(model.uid)]];
                StreamingXResponse_AnchorAvatar * defaultAvatarModel = [StreamingXResponse_AnchorAvatar mj_objectWithKeyValues:defaultAvatarDic];
                model.defaultAvatar = defaultAvatarModel;
                model.currentChannel = currentChannelMap[[NSString stringWithFormat:@"%@",@(model.uid)]];
                model.state = [stateMap[[NSString stringWithFormat:@"%@",@(model.uid)]] integerValue];
                [arr addObject:model];
            }
        }
        responseModel.array = arr;
        block(responseModel);
    } errorBlock:^(NSError *error) {
        errorBlock(error);
    }];
}

/// 获取主播个人信息
/// @param uid  主播ID
/// @param block 成功回调
/// @param errorBlock 失败回调
/// @param httpHeader 请求头信息
+ (void)streamingX_getAnchorInfoWithUid:(NSInteger)uid
                                   block:(void(^)(StreamingXResponse_Anchor * responseModel))block
                               errorBlock:(void(^)(NSError * error))errorBlock
                              httpHeader:(NSDictionary *)httpHeader {
    [self streamingX_requestWithType:@"GET" dictionary:nil url:[NSString stringWithFormat:@"%@/%@/uid",StreamingX_getAnchorInfoUrl,@(uid)] httpHeader:httpHeader block:^(NSDictionary *dataDictionary) {
        StreamingXResponse_Anchor * responseModel = [StreamingXResponse_Anchor mj_objectWithKeyValues:dataDictionary];
        block(responseModel);
    } errorBlock:^(NSError *error) {
        errorBlock(error);
    }];
}

/// 获取主播实时状态
/// @param uid  主播ID
/// @param block 成功回调
/// @param errorBlock 失败回调
/// @param httpHeader 请求头信息
+ (void)streamingX_getAnchorStateWithUid:(NSInteger)uid
                                   block:(void(^)(StreamingXResponse_AnchorState * responseModel))block
                               errorBlock:(void(^)(NSError * error))errorBlock
                              httpHeader:(NSDictionary *)httpHeader {
    [self streamingX_requestWithType:@"GET" dictionary:nil url:[NSString stringWithFormat:@"%@/%@/state",StreamingX_getAnchorInfoUrl,@(uid)] httpHeader:httpHeader block:^(NSDictionary *dataDictionary) {
        StreamingXResponse_AnchorState * responseModel = [StreamingXResponse_AnchorState mj_objectWithKeyValues:dataDictionary];
        block(responseModel);
    } errorBlock:^(NSError *error) {
        errorBlock(error);
    }];
}

/// 获取主播头像数组
/// @param anchorId 主播ID
/// @param block 成功回调
/// @param errorBlock 失败回调
/// @param httpHeader 请求头信息
+ (void)streamingX_getAnchorAvatarsWithAnchorId:(NSInteger)anchorId
                                           block:(void(^)(StreamingXResponse_AnchorAvatarList * responseModel))block
                                  errorBlock:(void(^)(NSError * error))errorBlock
                                     httpHeader:(NSDictionary *)httpHeader {
    [self streamingX_requestWithType:@"GET" dictionary:nil url:[NSString stringWithFormat:StreamingX_getAnchorAvatarsUrl,@(anchorId)] httpHeader:httpHeader block:^(NSDictionary *dataDictionary) {
        StreamingXResponse_AnchorAvatarList * responseModel = [StreamingXResponse_AnchorAvatarList mj_objectWithKeyValues:dataDictionary];
        block(responseModel);
    } errorBlock:^(NSError *error) {
        errorBlock(error);
    }];
}

/// 刷新token
/// @param channelId 频道ID
/// @param block 成功回调
/// @param errorBlock 失败回调
/// @param httpHeader 请求头信息
+ (void)streamingX_refreshTokenWithChannelId:(NSString *)channelId
                                       block:(void(^)(StreamingXResponse_RefreshTokenResult * responseModel))block
                                  errorBlock:(void(^)(NSError * error))errorBlock
                                  httpHeader:(NSDictionary *)httpHeader {
    [self streamingX_requestWithType:@"GET" dictionary:nil url:[NSString stringWithFormat:StreamingX_refreshTokenUrl,channelId] httpHeader:httpHeader block:^(NSDictionary *dataDictionary) {
        block(nil);
    } errorBlock:^(NSError *error) {
        errorBlock(error);
    }];
}

/// 匹配请求
/// @param dictionaryData 请求体
/// @param block 成功回调
/// @param errorBlock 失败回调
/// @param httpHeader 请求头信息
+ (void)streamingX_matchRequestWithDictionaryData:(NSDictionary *)dictionaryData
                                            block:(void(^)(void))block
                                       errorBlock:(void(^)(NSError * error))errorBlock
                                       httpHeader:(NSDictionary *)httpHeader {
    [self streamingX_requestWithType:@"POST" dictionary:dictionaryData url:StreamingX_requstMatchUrl httpHeader:httpHeader block:^(NSDictionary *dataDictionary) {
        block();
    } errorBlock:^(NSError *error) {
        errorBlock(error);
    }];
}


/// 跳过匹配请求
/// @param block 成功回调
/// @param errorBlock 失败回调
/// @param httpHeader 请求头信息
+ (void)streamingX_skipMatchRequestWithBlock:(void(^)(void))block
                                       errorBlock:(void(^)(NSError * error))errorBlock
                                  httpHeader:(NSDictionary *)httpHeader {
    [self streamingX_requestWithType:@"POST" dictionary:nil url:StreamingX_requstMatchUrl httpHeader:httpHeader block:^(NSDictionary *dataDictionary) {
        block();
    } errorBlock:^(NSError *error) {
        errorBlock(error);
    }];
}

/// 获取单个空闲主播
/// @param block 成功回调
/// @param errorBlock 失败回调
/// @param httpHeader 请求头信息
+ (void)streamingX_getSingleOnlineFreeAnchorRequestWithBlock:(void(^)(StreamingXResponse_Anchor * responseModel))block
                                                  errorBlock:(void(^)(NSError * error))errorBlock
                                                  httpHeader:(NSDictionary *)httpHeader {
    [self streamingX_requestWithType:@"GET" dictionary:nil url:StreamingX_getSingleFreeAnchorUrl httpHeader:httpHeader block:^(NSDictionary *dataDictionary) {
        NSArray * list = dataDictionary[@"list"];
        if (list.count > 0) {
            StreamingXResponse_Anchor * responseModel = [StreamingXResponse_Anchor mj_objectWithKeyValues:list[0]];
            NSDictionary * dic = dataDictionary[@"defaultCoverMap"];
            if (dic) {
                if (dic.allValues.count > 0) {
                    NSDictionary * dicc = dic.allValues[0];
                    responseModel.defaultAvatar = [StreamingXResponse_AnchorAvatar mj_objectWithKeyValues:dicc];
                }
            }
            block(responseModel);
        }else {
            block(nil);
        }
    } errorBlock:^(NSError *error) {
        errorBlock(error);
    }];
}

/// 网络请求
/// @param type 请求类型
/// @param dictionary 请求体
/// @param url 请求地址
/// @param httpHeader 请求头信息
/// @param block 成功回调
/// @param errorBlock 失败回调
+ (void)streamingX_requestWithType:(NSString *)type
                        dictionary:(NSDictionary *)dictionary
                               url:(NSString *)url
                        httpHeader:(NSDictionary *)httpHeader
                             block:(void(^)(NSDictionary * dataDictionary))block
                        errorBlock:(void(^)(NSError * error))errorBlock {
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",StreamingX_baseUrl,url]]
       cachePolicy:NSURLRequestUseProtocolCachePolicy
       timeoutInterval:10.0];
    NSDictionary *headers = httpHeader;
    [request setAllHTTPHeaderFields:headers];
    if (dictionary) {
        NSData *postData = [[NSData alloc] initWithData:[[self streamingX_convertToJsonData:dictionary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:postData];
    }
    [request setHTTPMethod:type];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
       if (error) {
           dispatch_async(dispatch_get_main_queue(), ^{
               errorBlock(error);
           });
          dispatch_semaphore_signal(sema);
       } else {
          NSError *parseError = nil;
          NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
           dispatch_async(dispatch_get_main_queue(), ^{
               if ([responseDictionary[@"code"] integerValue] == 0) {
                   block(responseDictionary);
               }else {
                   NSError * error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:[responseDictionary[@"code"] integerValue] userInfo:@{NSLocalizedDescriptionKey:responseDictionary[@"message"]?responseDictionary[@"message"]:@"error",NSLocalizedFailureReasonErrorKey:responseDictionary[@"message"]?responseDictionary[@"message"]:@"error"}];
                   errorBlock(error);
               }
           });
          dispatch_semaphore_signal(sema);
       }
    }];
    [dataTask resume];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

/// 字典转数据
/// @param dict 需要转换的字典
+ (NSString *)streamingX_convertToJsonData:(NSDictionary *)dict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if(!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range2 = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

@end
