//
//  RTNetworkingAction.h
//  RTNetworking
//
//  Created by lzhu on 9/12/16.
//  Copyright © 2016 redeight. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTNetworkingAction <NSObject>

/**
 * @property name: the unique identity of action, used in errorHandler, interceptor & modelMapper
 */
@property (strong, nonatomic, readonly) NSString *name;

/**
 * @property url: the relative url to base url
 */
@property (strong, nonatomic, readonly) NSString *url;

/**
 * @property parameters: the http request parameters
 */
@property (strong, nonatomic, readonly) NSDictionary *parameters;

@end
