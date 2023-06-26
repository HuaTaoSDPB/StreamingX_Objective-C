// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: code.proto

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

#pragma mark - Enum RPCCode

/**
 * The canonical error codes for gRPC APIs.
 *
 *
 * Sometimes multiple error codes may apply.  Services should return
 * the most specific error code that applies.  For example, prefer
 * `OUT_OF_RANGE` over `FAILED_PRECONDITION` if both codes apply.
 * Similarly prefer `NOT_FOUND` or `ALREADY_EXISTS` over `FAILED_PRECONDITION`.
 **/
typedef GPB_ENUM(RPCCode) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  RPCCode_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  /**
   * Not an error; returned on success.
   *
   * HTTP Mapping: 200 OK
   **/
  RPCCode_Ok = 0,

  /**
   * The operation was cancelled, typically by the caller.
   *
   * HTTP Mapping: 499 Client Closed Request
   **/
  RPCCode_Cancelled = 1,

  /**
   * Unknown error.  For example, this error may be returned when
   * a `Status` value received from another address space belongs to
   * an error space that is not known in this address space.  Also
   * errors raised by APIs that do not return enough error information
   * may be converted to this error.
   *
   * HTTP Mapping: 500 Internal Server Error
   **/
  RPCCode_Unknown = 2,

  /**
   * The client specified an invalid argument.  Note that this differs
   * from `FAILED_PRECONDITION`.  `INVALID_ARGUMENT` indicates arguments
   * that are problematic regardless of the state of the system
   * (e.g., a malformed file name).
   *
   * HTTP Mapping: 400 Bad Request
   **/
  RPCCode_InvalidArgument = 3,

  /**
   * The deadline expired before the operation could complete. For operations
   * that change the state of the system, this error may be returned
   * even if the operation has completed successfully.  For example, a
   * successful response from a server could have been delayed long
   * enough for the deadline to expire.
   *
   * HTTP Mapping: 504 Gateway Timeout
   **/
  RPCCode_DeadlineExceeded = 4,

  /**
   * Some requested entity (e.g., file or directory) was not found.
   *
   * Note to server developers: if a request is denied for an entire class
   * of users, such as gradual feature rollout or undocumented allowlist,
   * `NOT_FOUND` may be used. If a request is denied for some users within
   * a class of users, such as user-based access control, `PERMISSION_DENIED`
   * must be used.
   *
   * HTTP Mapping: 404 Not Found
   **/
  RPCCode_NotFound = 5,

  /**
   * The entity that a client attempted to create (e.g., file or directory)
   * already exists.
   *
   * HTTP Mapping: 409 Conflict
   **/
  RPCCode_AlreadyExists = 6,

  /**
   * The caller does not have permission to execute the specified
   * operation. `PERMISSION_DENIED` must not be used for rejections
   * caused by exhausting some resource (use `RESOURCE_EXHAUSTED`
   * instead for those errors). `PERMISSION_DENIED` must not be
   * used if the caller can not be identified (use `UNAUTHENTICATED`
   * instead for those errors). This error code does not imply the
   * request is valid or the requested entity exists or satisfies
   * other pre-conditions.
   *
   * HTTP Mapping: 403 Forbidden
   **/
  RPCCode_PermissionDenied = 7,

  /**
   * The request does not have valid authentication credentials for the
   * operation.
   *
   * HTTP Mapping: 401 Unauthorized
   **/
  RPCCode_Unauthenticated = 16,

  /**
   * Some resource has been exhausted, perhaps a per-user quota, or
   * perhaps the entire file system is out of space.
   *
   * HTTP Mapping: 429 Too Many Requests
   **/
  RPCCode_ResourceExhausted = 8,

  /**
   * The operation was rejected because the system is not in a state
   * required for the operation's execution.  For example, the directory
   * to be deleted is non-empty, an rmdir operation is applied to
   * a non-directory, etc.
   *
   * Service implementors can use the following guidelines to decide
   * between `FAILED_PRECONDITION`, `ABORTED`, and `UNAVAILABLE`:
   *  (a) Use `UNAVAILABLE` if the client can retry just the failing call.
   *  (b) Use `ABORTED` if the client should retry at a higher level. For
   *      example, when a client-specified test-and-set fails, indicating the
   *      client should restart a read-modify-write sequence.
   *  (c) Use `FAILED_PRECONDITION` if the client should not retry until
   *      the system state has been explicitly fixed. For example, if an "rmdir"
   *      fails because the directory is non-empty, `FAILED_PRECONDITION`
   *      should be returned since the client should not retry unless
   *      the files are deleted from the directory.
   *
   * HTTP Mapping: 400 Bad Request
   **/
  RPCCode_FailedPrecondition = 9,

  /**
   * The operation was aborted, typically due to a concurrency issue such as
   * a sequencer check failure or transaction abort.
   *
   * See the guidelines above for deciding between `FAILED_PRECONDITION`,
   * `ABORTED`, and `UNAVAILABLE`.
   *
   * HTTP Mapping: 409 Conflict
   **/
  RPCCode_Aborted = 10,

  /**
   * The operation was attempted past the valid range.  E.g., seeking or
   * reading past end-of-file.
   *
   * Unlike `INVALID_ARGUMENT`, this error indicates a problem that may
   * be fixed if the system state changes. For example, a 32-bit file
   * system will generate `INVALID_ARGUMENT` if asked to read at an
   * offset that is not in the range [0,2^32-1], but it will generate
   * `OUT_OF_RANGE` if asked to read from an offset past the current
   * file size.
   *
   * There is a fair bit of overlap between `FAILED_PRECONDITION` and
   * `OUT_OF_RANGE`.  We recommend using `OUT_OF_RANGE` (the more specific
   * error) when it applies so that callers who are iterating through
   * a space can easily look for an `OUT_OF_RANGE` error to detect when
   * they are done.
   *
   * HTTP Mapping: 400 Bad Request
   **/
  RPCCode_OutOfRange = 11,

  /**
   * The operation is not implemented or is not supported/enabled in this
   * service.
   *
   * HTTP Mapping: 501 Not Implemented
   **/
  RPCCode_Unimplemented = 12,

  /**
   * Internal errors.  This means that some invariants expected by the
   * underlying system have been broken.  This error code is reserved
   * for serious errors.
   *
   * HTTP Mapping: 500 Internal Server Error
   **/
  RPCCode_Internal = 13,

  /**
   * The service is currently unavailable.  This is most likely a
   * transient condition, which can be corrected by retrying with
   * a backoff. Note that it is not always safe to retry
   * non-idempotent operations.
   *
   * See the guidelines above for deciding between `FAILED_PRECONDITION`,
   * `ABORTED`, and `UNAVAILABLE`.
   *
   * HTTP Mapping: 503 Service Unavailable
   **/
  RPCCode_Unavailable = 14,

  /**
   * Unrecoverable data loss or corruption.
   *
   * HTTP Mapping: 500 Internal Server Error
   **/
  RPCCode_DataLoss = 15,
};

GPBEnumDescriptor *RPCCode_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL RPCCode_IsValidValue(int32_t value);

#pragma mark - RPCCodeRoot

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
@interface RPCCodeRoot : GPBRootObject
@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)