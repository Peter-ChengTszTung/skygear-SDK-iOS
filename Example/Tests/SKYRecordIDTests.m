//
//  SKYRecordIDTests.m
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

#import <Foundation/Foundation.h>
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <SKYKit/SKYKit.h>

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

SpecBegin(SKYRecordID)

    describe(@"SKYRecordID", ^{
        it(@"init", ^{
            SKYRecordID *recordID = [SKYRecordID recordIDWithRecordType:@"book"];
            expect(recordID.recordType).to.equal(@"book");
            expect(recordID.recordName).toNot.beNil();
            expect([recordID.recordName class]).to.beSubclassOf([NSString class]);
            expect([recordID.description class]).to.beSubclassOf([NSString class]);
        });

        it(@"canonical string", ^{
            SKYRecordID *recordID = [SKYRecordID recordIDWithCanonicalString:@"book/book1"];
            expect(recordID.recordType).to.equal(@"book");
            expect(recordID.recordName).to.equal(@"book1");
            expect(recordID.canonicalString).to.equal(@"book/book1");
        });
    });

SpecEnd

#pragma GCC diagnostic pop
