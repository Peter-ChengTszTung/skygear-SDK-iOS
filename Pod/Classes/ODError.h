//
//  ODError.h
//  askq
//
//  Created by Kenji Pa on 21/1/15.
//  Copyright (c) 2015 RoODy Chan. All rights reserved.
//

typedef enum : NSInteger {
    ODErrorInternalError           = 1,
    ODErrorPartialFailure          = 2,
    ODErrorNetworkUnavailable      = 3,
    ODErrorNetworkFailure          = 4,
    ODErrorBadContainer            = 5,
    ODErrorServiceUnavailable      = 6,
    ODErrorRequestRateLimited      = 7,
    ODErrorMissingEntitlement      = 8,
    ODErrorNotAuthenticated        = 9,
    ODErrorPermissionFailure       = 10,
    ODErrorUnknownItem             = 11,
    ODErrorInvalidArguments        = 12,
    ODErrorResultsTruncated        = 13,
    ODErrorServerRecordChanged     = 14,
    ODErrorServerRejectedRequest   = 15,
    ODErrorAssetFileNotFound       = 16,
    ODErrorAssetFileModified       = 17,
    ODErrorIncompatibleVersion     = 18,
    ODErrorConstraintViolation     = 19,
    ODErrorOperationCancelled      = 20,
    ODErrorChangeTokenExpired      = 21,
    ODErrorBatchRequestFailed      = 22,
    ODErrorBadDatabase             = 24,
    ODErrorQuotaExceeded           = 25,
    ODErrorLimitExceeded           = 27,
} ODErrorCode;

extern const NSString * ODErrorMessageKey;
extern const NSString * ODErrorCodeKey;
extern const NSString * ODErrorTypeKey;
extern const NSString * ODErrorInfoKey;
extern NSString * const ODPartialErrorsByItemIDKey;