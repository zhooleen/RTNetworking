//
//  RTNetworkingInterceptor.h
//  RTNetworking
//
//  Created by lzhu on 9/12/16.
//  Copyright © 2016 redeight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTNetworkingAction.h"

@protocol RTNetworkingInterceptor <NSObject>

/**
 * return nil if support all actions
 */
- (NSSet*) supportedActions;

/**
 * the unique identity of this interceptor
 */
- (NSString*) name;

/**
 * Return value :
 * YES, intercept & do some operations, not to post the action
 * NO , pass action to next interceptor or continue the http request
 */
- (BOOL) interceptAction:(id<RTNetworkingAction>)action;


@end
