# StreamingX_Objective-C
<p>
  <img src="https://spark.apache.org/docs/latest/img/streaming-arch.png" width="500" alt="Banner" />
</p>
基于声网rtc的私有服务。

官网：[http://streamingX.com](http://streamingX.com)

[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](http://opensource.org/licenses/MIT "Feel free to contribute.")

## 使用方法

使用CocoaPods安装：
```ruby
pod 'StreamingX_Objective-C', '~> 1.0.0'
```

初始化SDK（请注意秘钥的过期时间，请在过期前重新获取秘钥并初始化SDK）：
```objective-c
StreamingXRtcManager * rtcManager = [StreamingXRtcManager initStreamingXRtcManagerWithAccess_key_secret:accessKeySecret access_key_id:accessKeyId access_key_token:sessionToken];
rtcManager.streamingXIsLog = true;
[rtcManager setStreamingXRtcManagerInitResultBlock:^(BOOL isSuccess, NSError * _Nullable error) {
    if (isSuccess) {
        NSLog(@"初始化sdk成功！");
    }else {
        NSLog(@"初始化sdk失败，参数错误！");
    }
}];
```

## 代码示例

请下载 StreamingX_Objective-C Demo：[https://github.com/HuaTaoSDPB/StreamingX_Objective-C](https://github.com/HuaTaoSDPB/StreamingX_Objective-C)。


