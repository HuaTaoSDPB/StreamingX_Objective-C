//
//  StreamingXResponse_AnchorAvatarList.m
//  StreamingXRtcManager
//
//  Created by sportmoment on 2023/6/13.
//

#import "StreamingXResponse_AnchorAvatarList.h"

@implementation StreamingXResponse_AnchorAvatar

- (NSString *)avatarThumb {
    if (_avatarThumb) {
        return _avatarThumb;
    }else if (_thumb) {
        return _thumb;
    }
    return _avatarThumb;
}

- (NSString *)avatarStandard {
    if (_avatarStandard) {
        return _avatarStandard;
    }else if (_standard) {
        return _standard;
    }
    return _avatarStandard;
}

- (NSString *)avatarClear {
    if (_avatarClear) {
        return _avatarClear;
    }else if (_clear) {
        return _clear;
    }
    return _avatarClear;
}

@end

@implementation StreamingXResponse_AnchorAvatarList

+(NSDictionary *)mj_objectClassInArray {
    return @{@"others":[StreamingXResponse_AnchorAvatar class]};
}

@end
