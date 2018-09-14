/*
 Copyright 2017-2018 FUJITSU CLOUD TECHNOLOGIES LIMITED All Rights Reserved.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "Mbaas.h"
#import "NCMBQuery.h"
#import "Utils.h"

@implementation Mbaas

/***** demo1：保存 *****/
+ (void) saveData:(NSString*)name email:(NSString*)email age:(NSNumber*)age prefecture:(NSString*)prefecture title:(NSString*)title contents:(NSString*)contents errorCallback:(void (^)( NSError *error)) errorCallback {
    // [demo1_1]保存先クラスの作成
    NCMBObject *object = [NCMBObject objectWithClassName:@"Inquiry"];
    // [demo1_2]データの設定
    [object setObject:name forKey:@"name"];
    [object setObject:email forKey:@"emailAddress"];
    [object setObject:age forKey:@"age"];
    [object setObject:prefecture forKey:@"prefecture"];
    [object setObject:title forKey:@"title"];
    [object setObject:contents forKey:@"contents"];
    // [demo1_3]データの保存処理の実行
    [object saveInBackgroundWithBlock:^(NSError *error) {
        //保存成功or失敗の処理
        errorCallback(error);
    }];
}

/***** demo2：全件検索 *****/
+ (void) getAllData: (void (^)(NSArray *objects)) successCallback errorCallback:(void (^)( NSError *error)) errorCallback {
    // [demo2_1]保存先クラスのクエリを生成
    NCMBQuery *query = [NCMBQuery queryWithClassName:@"Inquiry"];
    // [demo2_2]検索条件の設定（保存日時の降順）
    [query orderByDescending:@"createDate"];
    // [demo2_3]全件検索処理の実行
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            // 検索失敗時の処理
            errorCallback(error);
        } else {
             // 検索成功時の処理
            successCallback(objects);
        }
    }];
}

/***** demo3-1：条件検索 *****/
+ (void) getSearchData:(NSString*)q searchBy:(SearchByEnum)searchBy successCallback:(void (^)(NSArray *objects)) successCallback errorCallback:(void (^)( NSError *error)) errorCallback {
    // [demo3-1_1]保存先クラスのクエリを生成
    NCMBQuery *query = [NCMBQuery queryWithClassName:@"Inquiry"];
    // [demo3-1_2]検索条件の設定（保存日時の降順）
    [query orderByDescending:@"createDate"];
    
    if (SearchByEmail == searchBy) {
        // [demo3-1_3]検索条件（メールアドレス）の設定
        [query whereKey:@"emailAddress" equalTo:q];
    } else {
        // [demo3-1_4]検索条件（都道府県）の設定
        [query whereKey:@"prefecture" equalTo:q];
    }
    // [demo3-1_5]全件検索処理の実行
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            // 検索失敗時の処理
            errorCallback(error);
        } else {
            // 検索成功時の処理
            successCallback(objects);
        }
    }];
}

/***** demo3-2：条件検索（範囲指定） *****/
+ (void) getRangeSearchData:(NSNumber*)ageGreaterThan ageLessThan:(NSNumber*)ageLessThan successCallback:(void (^)(NSArray *objects)) successCallback errorCallback:(void (^)( NSError *error)) errorCallback {
    // [demo3-2_1]保存先クラスのクエリを生成
    NCMBQuery *query = [NCMBQuery queryWithClassName:@"Inquiry"];
    // [demo3-2_2]検索条件の設定（保存日時の降順）
    [query orderByDescending:@"createDate"];
    // [demo3-2_3]検索条件（年齢）の設定（○○歳以上）
    [query whereKey:@"age" greaterThanOrEqualTo:ageGreaterThan];
    // [demo3-2_4]検索条件（年齢）の設定（○○歳未満）
    [query whereKey:@"age" lessThan:ageLessThan];
    // [demo3-2_5]全件検索処理の実行
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            // 検索失敗時の処理
            errorCallback(error);
        } else {
            // 検索成功時の処理
            successCallback(objects);
        }
    }];
}
@end
