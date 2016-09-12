//
//  RTNetworkingNormalAction.m
//  RTNetworking
//
//  Created by lzhu on 9/12/16.
//  Copyright © 2016 redeight. All rights reserved.
//

#import "RTNetworkingNormalAction.h"

@implementation RTNetworkingNormalAction

- (instancetype) initWithName:(NSString *)name url:(NSString *)url {
    if(self = [super init]) {
        _name = name;
        _url = url;
    }
    return self;
}

@end
