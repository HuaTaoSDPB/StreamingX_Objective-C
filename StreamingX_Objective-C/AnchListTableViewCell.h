//
//  AnchListTableViewCell.h
//  StreamingXRtcManager
//
//  Created by sportmoment on 2023/6/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnchListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearoldLabel;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *lookUpHeadersButton;
@property (weak, nonatomic) IBOutlet UILabel *stateView;
@property (nonatomic, copy) void (^callButtonClickBlock)(void);
@property (nonatomic, copy) void (^lookUpButtonClickBlock)(void);
@end

NS_ASSUME_NONNULL_END
