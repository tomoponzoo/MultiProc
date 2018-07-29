//
//  NSExtension.h
//  MultiProc
//
//  Created by tomoki.koga on 2018/07/29.
//  Copyright © 2018年 PLAID, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSExtension : NSObject
+ (instancetype)extensionWithIdentifier:(NSString *)identifier error:(NSError **)error;

- (void)beginExtensionRequestWithInputItems:(NSArray *)inputItems completion:(void (^)(NSUUID *requestIdentifier))completion;

- (int)pidForRequestIdentifier:(NSUUID *)requestIdentifier;
- (void)cancelExtensionRequestWithIdentifier:(NSUUID *)requestIdentifier;

- (void)setRequestCancellationBlock:(void (^)(NSUUID *uuid, NSError *error))cancellationBlock;
- (void)setRequestCompletionBlock:(void (^)(NSUUID *uuid, NSArray *extensionItems))completionBlock;
- (void)setRequestInterruptionBlock:(void (^)(NSUUID *uuid))interruptionBlock;
@end
