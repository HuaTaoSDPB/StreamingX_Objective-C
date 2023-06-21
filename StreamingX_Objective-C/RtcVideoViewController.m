//
//  RtcVideoViewController.m
//  StreamingXRtcManager
//
//  Created by sportmoment on 2023/6/15.
//

#import "RtcVideoViewController.h"
#import "StreamingXRtcManager.h"
#import "RtcVideoMsgTableViewCell.h"

@interface RtcVideoViewController () <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *localView;
@property (weak, nonatomic) IBOutlet UIView *remoteView;
@property (weak, nonatomic) IBOutlet UITextField *inputTf;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray * msgArray;
@end

@implementation RtcVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[StreamingXRtcManager shareStreamingXRtcManager].agorartcManager streamingX_startpPreView];
    [[StreamingXRtcManager shareStreamingXRtcManager].agorartcManager streamingX_updateRemoteView:self.remoteView];
    [[StreamingXRtcManager shareStreamingXRtcManager].agorartcManager streamingX_updateLocalView:self.localView];
    [StreamingXRtcManager streamingX_joinInChannelWithToken:self.token channelId:self.channelId uid:self.uid joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
        //成功之后开始计时
    }];
    [[StreamingXRtcManager shareStreamingXRtcManager] setStreamingXRtcManagerReceiveMessageBlock:^(rcvChannelMsgRecord * _Nonnull receivedMsg) {
        [self.msgArray addObject:receivedMsg.msg];
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.msgArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }];
    [[StreamingXRtcManager shareStreamingXRtcManager] setStreamingXRtcManagerReceiveUserStateChangedBlock:^(channelUserStateChange * _Nonnull stateChangeModel) {
        //用户状态变更
        
    }];
    [[StreamingXRtcManager shareStreamingXRtcManager] setStreamingXRtcManagerReceiveChannelStateChangedBlock:^(channelStateChange * _Nonnull stateChangeModel) {
        //房间状态变更
        
    }];
    self.inputTf.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"RtcVideoMsgTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"RtcVideoMsgTableViewCell"];
}

- (IBAction)backAction:(id)sender {
    [StreamingXRtcManager streamingX_leaveRtcChannel:^(AgoraChannelStats * _Nonnull stat) {
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)videoFlipAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [[StreamingXRtcManager shareStreamingXRtcManager].agorartcManager.agoraRtcEngineKit switchCamera];
}

- (IBAction)micMuteAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [[StreamingXRtcManager shareStreamingXRtcManager].agorartcManager.agoraRtcEngineKit setEnableSpeakerphone:!sender.selected];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //发送消息
    [StreamingXRtcManager streamingX_sendMsgWithChannelId:self.channelId uid:[NSString stringWithFormat:@"%@",@(self.uid)] content:textField.text lang:@"" block:^(channelMsgRecord * msg, channelMsgRecordAck * responseModel) {
        [self.msgArray addObject:msg];
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.msgArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        textField.text = @"";
    } errorBlock:^(NSError * _Nonnull error) {
    }];
    return YES;
}

- (NSMutableArray *)msgArray {
    if (!_msgArray) {
        _msgArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _msgArray;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    RtcVideoMsgTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RtcVideoMsgTableViewCell"];
    channelMsgRecord * model = self.msgArray[indexPath.row];
    cell.msgLabel.text = model.msg;
    cell.msgLabel.textColor = [model.from integerValue] == self.uid ? [UIColor greenColor] : [UIColor whiteColor];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.msgArray.count;
}

@end
