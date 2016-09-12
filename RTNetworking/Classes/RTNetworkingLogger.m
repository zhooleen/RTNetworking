//
//  RTNetworkingLogger.m
//  RTNetworking
//
//  Created by lzhu on 9/12/16.
//  Copyright © 2016 redeight. All rights reserved.
//

#import "RTNetworkingLogger.h"

@implementation RTNetworkingLogger

- (NSSet*) supportedActions {
    return nil;
}

- (NSString*) name {
    return NSStringFromClass([self class]);
}

- (BOOL) interceptAction:(id<RTNetworkingAction>)action {
    NSMutableDictionary *desc = [NSMutableDictionary dictionary];
    desc[@"Action"] = action.name;
    desc[@"URL"] = action.url;
    if(action.parameters) {
        desc[@"Parameter"] = action.parameters;
    } else {
        desc[@"Parameter"] = [NSNull null];
    }
    NSLog(@"\n%@", desc);
    return NO;
}

@end
