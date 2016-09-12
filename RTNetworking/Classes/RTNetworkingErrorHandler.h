//
//  RTNetworkingErrorHandler.h
//  RTNetworking
//
//  Created by lzhu on 9/12/16.
//  Copyright © 2016 redeight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTNetworkingAction.h"


@protocol RTNetworkingErrorHandler <NSObject>

/**
 * return nil if support all actions
 */
- (NSSet*) supportedActions;

/**
 * the unique identity of this error handler
 */
- (NSString*) name;

/**
 * Return value :
 * YES, accept the action & handle the error, not pass the error to next handler
 * NO , pass the error to next handler
 */
- (BOOL) handleError:(NSError*)error withAction:(id<RTNetworkingAction>)action;

@end
