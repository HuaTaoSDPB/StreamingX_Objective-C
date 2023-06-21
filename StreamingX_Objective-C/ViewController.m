//
//  ViewController.m
//  StreamingXRtcManager
//
//  Created by sportmoment on 2023/6/12.
//

#import "ViewController.h"
#import "StreamingXRtcManager.h"
#import "AnchListTableViewCell.h"
#import <SDWebImage/SDWebImage.h>
#import "LookUpImagesViewController.h"
#import "RtcVideoViewController.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *getTokenButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *accessKeyId;
@property (copy, nonatomic) NSString *accessKeySecret;
@property (copy, nonatomic) NSString *sessionToken;
@property (copy, nonatomic) NSString *expiredAt;
@property (strong, nonatomic) StreamingXRtcManager *rtcManager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) StreamingXResponse_AnchorList *anchList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"AnchListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"AnchListTableViewCell"];
}

#pragma mark - 初始化sdk

- (IBAction)initManagerSdk:(id)sender {
    if (self.accessKeyId.length > 0 && self.accessKeySecret.length > 0 && self.sessionToken.length > 0 && self.expiredAt.length > 0) {
        [self addTextToTextView:@"开始初始化sdk..."];
        self.rtcManager = [StreamingXRtcManager initStreamingXRtcManagerWithAccess_key_secret:self.accessKeySecret access_key_id:self.accessKeyId access_key_token:self.sessionToken];
        self.rtcManager.streamingXIsLog = true;
        __weak typeof(self) weakSelf = self;
        [self.rtcManager setStreamingXRtcManagerInitResultBlock:^(BOOL isSuccess, NSError * _Nullable error) {
            if (isSuccess) {
                [weakSelf addTextToTextView:@"初始化sdk成功！"];
                //50分钟后重新获取token并初始化sdk
                [weakSelf performSelector:@selector(getTokenAction:) withObject:nil afterDelay:50*60];
            }else {
                [weakSelf addTextToTextView:@"初始化sdk失败，参数错误！"];
            }
        }];
        [self.rtcManager setStreamingXRtcManagerReceiveUserStateChangedBlock:^(channelUserStateChange * _Nonnull stateChangeModel) {
            //用户状态变更
            [weakSelf addTextToTextView:[NSString stringWithFormat:@"用户状态变更:%@",@(stateChangeModel.reason)]];
        }];
        [self.rtcManager setStreamingXRtcManagerReceiveChannelStateChangedBlock:^(channelStateChange * _Nonnull stateChangeModel) {
            //房间状态变更
            [weakSelf addTextToTextView:[NSString stringWithFormat:@"房间状态变更:%@",@(stateChangeModel.reason)]];
        }];
        [self.rtcManager setStreamingXRtcManagerReceiveOfflineBlock:^(NSInteger uid, AgoraUserOfflineReason reason) {
            //离线通知
            [weakSelf addTextToTextView:[NSString stringWithFormat:@"离线通知:%@ %@",@(uid),@(reason)]];
        }];
    }else {
        [self addTextToTextView:@"初始化sdk失败，请先获取必要的参数！"];
    }
}

#pragma mark - 模拟获取token (有效期一个小时，一个小时候后请重新获取秘钥并初始化sdk)

- (IBAction)getTokenAction:(id)sender {
    [self addTextToTextView:@"正在获取token..."];
    NSData * data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://192.168.2.134:3000/login"]];
    if (data.length == 0) {
        [self addTextToTextView:@"获取token为nil，请允许网络链接或者调用自己服务器接口获取token..."];
        return;
    }
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSString * token = responseDictionary[@"token"];
    if (token.length > 0) {
        [self addTextToTextView:[NSString stringWithFormat:@"获取token成功:%@",token]];
        self.token = token;
        [self addTextToTextView:@"开始获取需要的参数..."];
        [self requestSecrects];
    }else {
        [self addTextToTextView:[NSString stringWithFormat:@"获取token失败:%@",token]];
    }
}

#pragma mark - 模拟获取秘钥参数

- (void)requestSecrects {
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.2.134:3000/sts"]
       cachePolicy:NSURLRequestUseProtocolCachePolicy
       timeoutInterval:10.0];
    NSDictionary *headers = @{
        @"Authorization" : self.token,
       @"X-Uyj-Timestamp": [NSString stringWithFormat:@"%@",@([NSDate.new timeIntervalSince1970])],
    };
    [request setAllHTTPHeaderFields:headers];
    [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
       if (error) {
          NSLog(@"%@", error);
           dispatch_async(dispatch_get_main_queue(), ^{
               [self addTextToTextView:[NSString stringWithFormat:@"获取需要的参数失败:%@",error.description]];
           });
          dispatch_semaphore_signal(sema);
       } else {
          NSError *parseError = nil;
          NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
          NSLog(@"%@",responseDictionary);
           dispatch_async(dispatch_get_main_queue(), ^{
               [self addTextToTextView:[NSString stringWithFormat:@"获取需要的参数成功:accessKeyId=%@,accessKeySecret=%@,sessionToken=%@,expiredAt=%@",responseDictionary[@"accessKeyId"],responseDictionary[@"accessKeySecret"],responseDictionary[@"sessionToken"],responseDictionary[@"expiredAt"]]];
               self.accessKeyId = responseDictionary[@"accessKeyId"];
               self.accessKeySecret = responseDictionary[@"accessKeySecret"];
               self.sessionToken = responseDictionary[@"sessionToken"];
               self.expiredAt = responseDictionary[@"expiredAt"];
           });
          dispatch_semaphore_signal(sema);
       }
    }];
    [dataTask resume];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

#pragma mark - 模拟申请加入房间

- (void)requestJoinChannelWithBroadcaster:(NSString *)broadcaster channelId:(NSString *)channelId block:(void(^)(NSDictionary * responseModel))block errorBlock:(void(^)(NSError * error))errorBlock {
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.2.134:3000/join_channel"]
       cachePolicy:NSURLRequestUseProtocolCachePolicy
       timeoutInterval:10.0];
    NSDictionary *headers = @{
        @"Authorization" : self.token,
       @"X-Uyj-Timestamp": [NSString stringWithFormat:@"%@",@([NSDate.new timeIntervalSince1970])],
    };
    [request setAllHTTPHeaderFields:headers];
    NSData *postData = [[NSData alloc] initWithData:[[self streamingX_convertToJsonData:@{@"broadcaster":broadcaster,@"channelId":channelId}] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postData];
    [request setHTTPMethod:@"POST"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
       if (error) {
          NSLog(@"%@", error);
           dispatch_async(dispatch_get_main_queue(), ^{
               [self addTextToTextView:[NSString stringWithFormat:@"申请加入房间失败:%@",error.description]];
               errorBlock(error);
           });
          dispatch_semaphore_signal(sema);
       } else {
          NSError *parseError = nil;
          NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
          NSLog(@"%@",responseDictionary);
           dispatch_async(dispatch_get_main_queue(), ^{
               block(responseDictionary);
           });
          dispatch_semaphore_signal(sema);
       }
    }];
    [dataTask resume];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

#pragma mark - 获取主播列表

- (IBAction)getAnchListAction:(id)sender {
    [self addTextToTextView:@"开始获取主播列表"];
    [StreamingXRtcManager streamingX_getAnchorListWithSort:0 page:0 limit:40 block:^(StreamingXResponse_AnchorList * _Nonnull responseModel) {
        self.anchList = responseModel;
        [self.tableView reloadData];
        [self addTextToTextView:@"获取主播列表成功"];
    } errorBlock:^(NSError * _Nonnull error) {
        [self addTextToTextView:[NSString stringWithFormat:@"获取主播列表失败，errorCode=%@，errorDes=%@",@(error.code),error.description]];
    }];
}

#pragma mark - 添加显示文本

- (void)addTextToTextView:(NSString *)text {
    self.textView.text = [NSString stringWithFormat:@"%@%@\n\n",self.textView.text,text];
    [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 0)];
}

#pragma mark - tableView delegate

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    StreamingXResponse_Anchor * anchM = self.anchList.array[indexPath.row];
    AnchListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AnchListTableViewCell"];
    [cell.headerImageV sd_setImageWithURL:[NSURL URLWithString:anchM.defaultAvatar.avatarStandard]];
    cell.nameLabel.text = anchM.name;
    cell.yearoldLabel.text = anchM.birthday;
    cell.stateView.backgroundColor = anchM.state == 0 ? [UIColor lightGrayColor] : anchM.state == 1 ? [UIColor greenColor] : [UIColor orangeColor];
//    cell.backgroundColor = anchM.currentChannel.length > 0 ? [UIColor yellowColor] : [UIColor clearColor];
    [cell setCallButtonClickBlock:^{
        //打电话
        if (anchM.currentChannel.length > 0) {
            [weakSelf callButtonClick:anchM];
        }else {
            anchM.state == 0 ? [weakSelf addTextToTextView:@"主播离线了"] : anchM.state == 2 ? [weakSelf addTextToTextView:@"主播正在忙"] : anchM.state == 3 ? [weakSelf addTextToTextView:@"主播正在忙"] : [weakSelf addTextToTextView:@"未知错误"];
        }
    }];
    [cell setLookUpButtonClickBlock:^{
        //查看头像
        [weakSelf lookUpButtonClick:anchM];
    }];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.anchList.array.count;
}

#pragma mark - 打电话(申请进入频道)

- (void)callButtonClick:(StreamingXResponse_Anchor *)model {
    [self addTextToTextView:@"申请进入房间"];
    [self requestJoinChannelWithBroadcaster:[NSString stringWithFormat:@"%@",@(model.uid)] channelId:model.currentChannel block:^(NSDictionary *responseModel) {
        [self addTextToTextView:@"申请进入房间成功"];
        //进入房间
        RtcVideoViewController * vc = [RtcVideoViewController new];
        vc.token = responseModel[@"token"];
        vc.uid = [responseModel[@"uniqId"] integerValue];
        vc.channelId = responseModel[@"ch"][@"id"];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    } errorBlock:^(NSError *error) {
        [self addTextToTextView:[NSString stringWithFormat:@"申请进入房间失败,errorCode=%@，errorDes=%@",@(error.code),error.description]];
    }];
}

#pragma mark - 查看头像(查看头像)

- (void)lookUpButtonClick:(StreamingXResponse_Anchor *)model {
    [self addTextToTextView:@"开始获取主播头像列表"];
    [StreamingXRtcManager streamingX_getAnchorAvatarsWithAnchorId:model.uid block:^(StreamingXResponse_AnchorAvatarList * _Nonnull responseModel) {
        [self addTextToTextView:@"获取主播头像列表成功"];
        // 显示头像
        LookUpImagesViewController * vc = [LookUpImagesViewController new];
        vc.model = responseModel;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    } errorBlock:^(NSError * _Nonnull error) {
        [self addTextToTextView:[NSString stringWithFormat:@"获取主播头像列表失败，errorCode=%@，errorDes=%@",@(error.code),error.description]];
    }];
}

#pragma mark - 转换json
- (NSString *)streamingX_convertToJsonData:(NSDictionary *)dict {
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
