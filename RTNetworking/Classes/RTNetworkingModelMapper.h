//
//  RTNetworkingModelMapper.h
//  RTNetworking
//
//  Created by lzhu on 9/12/16.
//  Copyright © 2016 redeight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTNetworkingAction.h"

@protocol RTNetworkingModelMapper <NSObject>

/**
 * the unique identity of this mapper
 */
- (NSString*) name;

/**
 * Predicate welther to map json to model
 */
- (BOOL) shouldMap:(id<RTNetworkingAction>)action;

/**
 * map json to model
 */
- (id) map:(NSDictionary*)json;

@end
