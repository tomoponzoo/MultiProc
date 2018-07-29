//
//  ViewController.m
//  MultiProc
//
//  Created by tomoki.koga on 2018/07/29.
//  Copyright © 2018年 PLAID, inc. All rights reserved.
//

#import "ViewController.h"
#import "NSExtension.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (strong, nonatomic) NSExtension *extension;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"App PID: %i", getpid());
    
    NSError *error;
    self.extension = [NSExtension extensionWithIdentifier:@"jp.co.plaid.MultiProc.Extension" error:&error];
    
    [self.extension setRequestCancellationBlock:^(NSUUID *uuid, NSError *error) {
        NSLog(@"Request cancelled: %@ %@", uuid, error);
    }];
    
    [self.extension setRequestInterruptionBlock:^(NSUUID *uuid) {
        NSLog(@"Request interrupted: %@", uuid);
    }];

    __weak typeof(self) weakSelf = self;
    [self.extension setRequestCompletionBlock:^(NSUUID *uuid, NSArray *extensionItems) {
        // リクエスト完了
        NSLog(@"Request completed: %@", uuid);
        
        NSExtensionItem *outputItem = extensionItems.firstObject;
        NSString *outputValue = outputItem.attachments.firstObject;
        NSLog(@"Received response: %@", outputValue);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.label.text = outputValue;
        });
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapSendButton:(id)sender {
    NSString *value = self.textField.text;
    
    NSExtensionItem *item = [[NSExtensionItem alloc] init];
    [item setAttachments:@[value]];
    
    [self.extension beginExtensionRequestWithInputItems:@[item] completion:^(NSUUID *requestIdentifier) {
        int pid = [self.extension pidForRequestIdentifier:requestIdentifier];
        NSLog(@"Began extension request: %@. Extension PID: %i", requestIdentifier, pid);
    }];
}

@end
