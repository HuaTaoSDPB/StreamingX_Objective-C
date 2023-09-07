//
//  StreamingXProtobufHeader.h
//  StreamingXRtcManager
//
//  Created by sportmoment on 2023/6/12.
//

#ifndef StreamingXProtobufHeader_h
#define StreamingXProtobufHeader_h

#define crcPing 0x85e792c3
#define crcPong 0x816aee71
#define crcChannelMsgRecord 0xc60f6256
#define crcChannelMsgRecordAck 0xb5ecf821
#define crcRcvChannelMsgRecord 0x148f5df6
#define crcGetDiffChannelMsgRecord 0xebb76c1e
#define crcGetDiffChannelMsgRecordAck 0x905c3244
#define crcChannelStateChange 0xb108048f
#define crcChannelUserStateChange 0xed6e3161
#define crcError 0x9c1c9375
#define crcChannelMatched 0x807c0cc4
#define crcChannelSkipped 0xdeef91bb

#import "Api.pbobjc.h"
#import "Base.pbobjc.h"
#import "Consts.pbobjc.h"
#import "ChannelIm.pbobjc.h"
#import "ChannelBase.pbobjc.h"
#import "ChannelImform.pbobjc.h"
#import "HTTPError.pbobjc.h"

#endif /* StreamingXProtobufHeader_h */
