// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: consts.proto

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

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Enum channelState

typedef GPB_ENUM(channelState) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  channelState_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  channelState_ChannelStateClosed = 0,
  channelState_ChannelStateFree = 1,
  channelState_ChannelStateBusy = 2,
  channelState_ChannelStateInsufficientBalance = 999,
};

GPBEnumDescriptor *channelState_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL channelState_IsValidValue(int32_t value);

#pragma mark - Enum channelStopReason

typedef GPB_ENUM(channelStopReason) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  channelStopReason_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  channelStopReason_ChannelStopReasonUnknown = 0,

  /** 房间正常停止 */
  channelStopReason_ChannelStopReasonNormal = 1,
  channelStopReason_ChannelStopReasonClosedBySystem = 2,
  channelStopReason_ChannelStopReasonError = 3,
};

GPBEnumDescriptor *channelStopReason_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL channelStopReason_IsValidValue(int32_t value);

#pragma mark - Enum channelUserKickReason

typedef GPB_ENUM(channelUserKickReason) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  channelUserKickReason_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  /** 没有被踢 */
  channelUserKickReason_ChannelUserKickReasonNormal = 0,
  channelUserKickReason_ChannelUserKickReasonKickBySystem = 1,
  channelUserKickReason_ChannelUserKickReasonError = 2,
};

GPBEnumDescriptor *channelUserKickReason_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL channelUserKickReason_IsValidValue(int32_t value);

#pragma mark - Enum channelCategory

typedef GPB_ENUM(channelCategory) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  channelCategory_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  channelCategory_ChannelCategoryUnknown = 0,
  channelCategory_ChannelCategorySingle = 1,
  channelCategory_ChannelCategoryMultiple = 2,
};

GPBEnumDescriptor *channelCategory_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL channelCategory_IsValidValue(int32_t value);

#pragma mark - ConstsRoot

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
@interface ConstsRoot : GPBRootObject
@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
