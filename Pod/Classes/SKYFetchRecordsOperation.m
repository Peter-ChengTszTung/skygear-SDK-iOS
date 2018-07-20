//
//  SKYFetchRecordsOperation.m
//  SKYKit
//
//  Copyright 2015 Oursky Ltd.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "SKYFetchRecordsOperation.h"
#import "SKYOperationSubclass.h"

#import "SKYDataSerialization.h"
#import "SKYError.h"
#import "SKYRecordDeserializer.h"
#import "SKYRecordResponseDeserializer.h"
#import "SKYRecordSerialization.h"

@implementation SKYFetchRecordsOperation

- (instancetype)initWithRecordIDs:(NSArray *)recordIDs
{
    self = [super init];
    if (self) {
        _recordIDs = recordIDs;
    }
    return self;
}

+ (instancetype)operationWithRecordIDs:(NSArray *)recordIDs
{
    return [[self alloc] initWithRecordIDs:recordIDs];
}

- (void)prepareForRequest
{
    NSMutableArray *stringIDs = [NSMutableArray array];
    [self.recordIDs enumerateObjectsUsingBlock:^(SKYRecordID *obj, NSUInteger idx, BOOL *stop) {
        [stringIDs addObject:[obj canonicalString]];
    }];
    NSMutableDictionary *payload = [@{
        @"ids" : stringIDs,
        @"database_id" : self.database.databaseID,
    } mutableCopy];
    if ([self.desiredKeys count]) {
        payload[@"desired_keys"] = self.desiredKeys;
    }
    self.request = [[SKYRequest alloc] initWithAction:@"record:fetch" payload:payload];
    self.request.APIKey = self.container.APIKey;
    self.request.accessToken = self.container.auth.currentAccessToken;
}

- (NSDictionary *)processResultArray:(NSArray *)result error:(NSError **)operationError
{
    NSMutableDictionary *errorsByID = [NSMutableDictionary dictionary];
    NSMutableDictionary *recordsByRecordID = [NSMutableDictionary dictionary];

    SKYRecordResponseDeserializer *deserializer = [[SKYRecordResponseDeserializer alloc] init];

    [result enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        [deserializer
            deserializeResponseDictionary:obj
                                    block:^(NSString *recordType, NSString *recordID,
                                            SKYRecord *record, NSError *error) {
                                        SKYRecordID *deprecatedRecordID =
                                            recordType && recordID
                                                ? [SKYRecordID recordIDWithRecordType:recordType
                                                                                 name:recordID]
                                                : nil;

                                        if (!deprecatedRecordID) {
                                            NSLog(@"Record does not conform with expected format.");
                                            return;
                                        }

                                        if (error) {
                                            [errorsByID setObject:error forKey:deprecatedRecordID];
                                        }

                                        if (record) {
                                            [recordsByRecordID setObject:record
                                                                  forKey:deprecatedRecordID];
                                        }

                                        if ((record || error) && self.perRecordCompletionBlock) {
                                            self.perRecordCompletionBlock(
                                                record, deprecatedRecordID, error);
                                        }
                                    }];
    }];

    if (operationError && [errorsByID count] > 0) {
        *operationError = [self.errorCreator partialErrorWithPerItemDictionary:errorsByID];
    } else if (operationError) {
        *operationError = nil;
    }

    return recordsByRecordID;
}

- (void)handleRequestError:(NSError *)error
{
    if (self.fetchRecordsCompletionBlock) {
        self.fetchRecordsCompletionBlock(nil, error);
    }
}

- (void)handleResponse:(SKYResponse *)responseObject
{
    NSDictionary *response = responseObject.responseDictionary;
    NSDictionary *resultDictionary = nil;
    NSError *error = nil;
    NSArray *responseArray = response[@"result"];
    if ([responseArray isKindOfClass:[NSArray class]]) {
        resultDictionary = [self processResultArray:responseArray error:&error];
    } else {
        error = [self.errorCreator errorWithCode:SKYErrorBadResponse
                                         message:@"Result is not an array or not exists."];
    }

    if (self.fetchRecordsCompletionBlock) {
        self.fetchRecordsCompletionBlock(resultDictionary, error);
    }
}

@end
