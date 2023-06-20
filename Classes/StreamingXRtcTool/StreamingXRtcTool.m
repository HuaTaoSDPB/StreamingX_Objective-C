//
//  StreamingXRtcTool.m
//  StreamingXRtcManager
//
//  Created by sportmoment on 2023/6/14.
//

#import "StreamingXRtcTool.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation StreamingXRtcTool

/// 获取加密的请求头
/// @param access_key_secret access_key_secret
/// @param access_key_id access_key_id
/// @param access_key_token access_key_token
+ (NSDictionary *)streamingX_getEncodeHeaderWithAccess_key_secret:(NSString *)access_key_secret
                                                    access_key_id:(NSString *)access_key_id
                                                 access_key_token:(NSString *)access_key_token {
    //获取时间戳
    NSString * timeStamp = [NSString stringWithFormat:@"%@",@([NSDate new].timeIntervalSince1970*1000)];
    //类型
    NSString * contentType = @"application/json";
    //需要加密的字符串
    NSString * dataString = [NSString stringWithFormat:@"%@%@",timeStamp,contentType];
    //加密完的字符串
    NSString * signDataString = [self hmacSHA256WithSecret:access_key_secret content:dataString];
    //header
    NSDictionary * header = @{
        @"Authorization":[NSString stringWithFormat:@"UYJ-HMAC-SHA256 %@, X-Uyj-Timestamp;Content-Type, %@",access_key_id,signDataString],
        @"Session-Token":access_key_token,
        @"X-Uyj-Timestamp":timeStamp,
        @"Content-Type":contentType
    };
    return header;
}

/// MAC算法: HmacSHA256
/// @param secret 秘钥
/// @param content 待加密文本
+ (NSString *)hmacSHA256WithSecret:(NSString *)secret content:(NSString *)content {
    //密钥转换成 const char
    const char * cKey = [secret cStringUsingEncoding:NSASCIIStringEncoding];
      //加密的内容有可能有中文 所以用NSUTF8StringEncoding
    const char * cData = [content cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    //SHA256加密
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSMutableString * hexString = [NSMutableString string];
    //转换成字符串
    for (int i = 0; i < sizeof(cHMAC); i++) {
        [hexString appendFormat:@"%02x", cHMAC[i]];
    }
    return hexString;
}

@end
