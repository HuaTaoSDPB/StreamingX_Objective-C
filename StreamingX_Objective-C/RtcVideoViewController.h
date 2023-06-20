//
//  RtcVideoViewController.h
//  StreamingXRtcManager
//
//  Created by sportmoment on 2023/6/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RtcVideoViewController : UIViewController
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, assign) NSInteger uid;
@end

NS_ASSUME_NONNULL_END
