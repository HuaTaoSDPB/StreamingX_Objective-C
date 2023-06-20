//
//  AnchListTableViewCell.m
//  StreamingXRtcManager
//
//  Created by sportmoment on 2023/6/14.
//

#import "AnchListTableViewCell.h"

@implementation AnchListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.callButton addTarget:self action:@selector(callButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.lookUpHeadersButton addTarget:self action:@selector(lookUpHeadersButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)callButtonClick {
    if (self.callButtonClickBlock) {
        self.callButtonClickBlock();
    }
}

- (void)lookUpHeadersButtonClick {
    if (self.lookUpButtonClickBlock) {
        self.lookUpButtonClickBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
