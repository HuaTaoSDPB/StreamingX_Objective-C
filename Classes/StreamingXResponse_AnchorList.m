//
//  StreamingXResponse_AnchorList.m
//  StreamingXRtcManager
//
//  Created by sportmoment on 2023/6/13.
//

#import "StreamingXResponse_AnchorList.h"

@implementation StreamingXResponse_AnchorState

@end

@implementation StreamingXResponse_Anchor

- (NSString *)name {
    if (_nick) {
        return _nick;
    }
    return _name;
}

@end

@implementation StreamingXResponse_AnchorList

@end
