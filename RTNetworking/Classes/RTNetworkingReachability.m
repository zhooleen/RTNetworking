//
//  RTNetworkingReachability.m
//  RTNetworking
//
//  Created by lzhu on 9/12/16.
//  Copyright © 2016 redeight. All rights reserved.
//

#import "RTNetworkingReachability.h"

#import <AFNetworking/AFNetworking.h>
#import <UIKit/UIKit.h>

@interface RTNetworkingReachability() {
    AFNetworkReachabilityManager *reachability;
}
@end

@implementation RTNetworkingReachability

- (instancetype) init {
    if(self = [super init]) {
        reachability = [AFNetworkReachabilityManager sharedManager];
        [reachability startMonitoring];
    }
    return self;
}

- (NSSet*) supportedActions {
    return nil;
}

- (NSString*) name {
    return NSStringFromClass([self class]);
}

- (BOOL) interceptAction:(id<RTNetworkingAction>)action {
    if(!reachability.reachable) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Networking Not reachable"
                                                                       message:nil
                                                                preferredStyle:(UIAlertControllerStyleAlert)];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:nil]];
        UIViewController *root = [UIApplication sharedApplication].delegate.window.rootViewController;
        [root presentViewController:alert animated:YES completion:nil];
        return YES;
    }
    return NO;
}

@end