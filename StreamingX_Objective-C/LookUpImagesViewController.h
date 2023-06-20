//
//  LookUpImagesViewController.h
//  StreamingXRtcManager
//
//  Created by sportmoment on 2023/6/14.
//

#import <UIKit/UIKit.h>
#import "StreamingXRtcManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface LookUpImagesViewController : UIViewController
@property (nonatomic, strong) StreamingXResponse_AnchorAvatarList * model;
@end

NS_ASSUME_NONNULL_END
