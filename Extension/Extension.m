//
//  Extension.m
//  Extension
//
//  Created by tomoki.koga on 2018/07/29.
//  Copyright © 2018年 PLAID, inc. All rights reserved.
//

#import "Extension.h"

@implementation Extension

- (void)beginRequestWithExtensionContext:(NSExtensionContext *)context {
    NSExtensionItem *inputItem = context.inputItems.firstObject;
    NSString *inputValue = inputItem.attachments.firstObject;
    
    NSString *outputValue = [NSString stringWithFormat:@"文字数：%lu", inputValue.length];
    NSExtensionItem *outputItem = [[NSExtensionItem alloc] init];
    outputItem.attachments = @[outputValue];
    
    [context completeRequestReturningItems:@[outputItem] completionHandler:^(BOOL expired) {
        NSLog(@"Completed request.");
    }];
}

@end
