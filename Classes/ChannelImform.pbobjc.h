// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: channelImform.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers.h>
#else
 #import "GPBProtocolBuffers.h"
#endif

#if GOOGLE_PROTOBUF_OBJC_VERSION < 30002
#error This file was generated by a newer version of protoc which is incompatible with your Protocol Buffer library sources.
#endif
#if 30002 < GOOGLE_PROTOBUF_OBJC_MIN_SUPPORTED_VERSION
#error This file was generated by an older version of protoc which is incompatible with your Protocol Buffer library sources.
#endif

// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

CF_EXTERN_C_BEGIN

@class channel;
@class channelUser;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ChannelImformRoot

/**
 * Exposes the extension registry for this file.
 *
 * The base class provides:
 * @code
 *   + (GPBExtensionRegistry *)extensionRegistry;
 * @endcode
 * which is a @c GPBExtensionRegistry that includes all the extensions defined by
 * this file and all files that it depends on.
 **/
@interface ChannelImformRoot : GPBRootObject
@end

#pragma mark - channelStateChange

typedef GPB_ENUM(channelStateChange_FieldNumber) {
  channelStateChange_FieldNumber_Ch = 1,
  channelStateChange_FieldNumber_Reason = 2,
};

@interface channelStateChange : GPBMessage

@property(nonatomic, readwrite, strong, null_resettable) channel *ch;
/** Test to see if @c ch has been set. */
@property(nonatomic, readwrite) BOOL hasCh;

@property(nonatomic, readwrite) uint32_t reason;

@end

#pragma mark - channelUserStateChange

typedef GPB_ENUM(channelUserStateChange_FieldNumber) {
  channelUserStateChange_FieldNumber_Chu = 1,
  channelUserStateChange_FieldNumber_Reason = 2,
};

@interface channelUserStateChange : GPBMessage

@property(nonatomic, readwrite, strong, null_resettable) channelUser *chu;
/** Test to see if @c chu has been set. */
@property(nonatomic, readwrite) BOOL hasChu;

@property(nonatomic, readwrite) uint32_t reason;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)