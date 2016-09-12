//
//  RTNetworkingNormalAction.h
//  RTNetworking
//
//  Created by lzhu on 9/12/16.
//  Copyright © 2016 redeight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTNetworkingAction.h"

@interface RTNetworkingNormalAction : NSObject <RTNetworkingAction>

@property (strong, nonatomic, readonly) NSString *name;

@property (strong, nonatomic, readonly) NSString *url;

@property (strong, nonatomic) NSDictionary *parameters;

- (instancetype) initWithName:(NSString *)name url:(NSString *)url;


@end
