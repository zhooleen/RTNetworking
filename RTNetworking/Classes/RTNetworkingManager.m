//
//  RTNetworkingManager.m
//  RTNetworking
//
//  Created by lzhu on 9/12/16.
//  Copyright © 2016 redeight. All rights reserved.
//

#import "RTNetworkingManager.h"

NSString * const kRTNetworkingBaseURL = @"your base url";

@interface RTNetworkingManager () {
    AFHTTPSessionManager *sessionManager;
    NSMutableArray *interceptors;
    NSMutableArray *handlers;
    NSMutableArray *mappers;
}
@end

@implementation RTNetworkingManager

@synthesize sessionManager = sessionManager;

- (instancetype) init {
    self = [super init];
    if(self) {
        interceptors = [NSMutableArray array];
        handlers = [NSMutableArray array];
        mappers = [NSMutableArray array];
        [self buildupSessionManager];
    }
    return self;
}

+ (instancetype) sharedManager {
    static dispatch_once_t once;
    static RTNetworkingManager *manager = nil;
    dispatch_once(&once, ^{
        manager = [[RTNetworkingManager alloc] init];
    });
    return manager;
}

#pragma mark - MIDWARES

- (id<RTNetworkingInterceptor>) interceptorWithName:(NSString*)name {
    return [self find:name inArray:[interceptors copy]];
}
- (id<RTNetworkingErrorHandler>) errorHandlerWithName:(NSString*)name {
    return [self find:name inArray:[handlers copy]];
}
- (id<RTNetworkingModelMapper>) modelMapperWithName:(NSString*)name {
    return [self find:name inArray:[mappers copy]];
}

- (void) addInterceptor:(id<RTNetworkingInterceptor>)interceptor {
    [interceptors addObject:interceptor];
}
- (void) addErrorHandler:(id<RTNetworkingErrorHandler>)handler {
    [handlers addObject:handler];
}
- (void) addModelMapper:(id<RTNetworkingModelMapper>)mapper {
    [mappers addObject:mapper];
}

- (void) removeInterceptor:(NSString*)name {
    [self remove:name inArray:interceptors];
}
- (void) removeErrorHandler:(NSString*)name {
    [self remove:name inArray:handlers];
}
- (void) removeModelMapper:(NSString*)name {
    [self remove:name inArray:mappers];
}

#pragma mark - HTTP REQUESTS

- (NSURLSessionDataTask*) POST:(id<RTNetworkingAction>)act completion:(RTNetworkingCompletionBlock)block {
    if([self intercept:act]) {
        return nil;
    }
    return [sessionManager POST:act.url parameters:act.parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(block) {
            block(YES, task, nil, [self map:responseObject action:act]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(block) {
            [self handleError:error action:act];
            block(NO, task, error, nil);
        }
    }];
}

- (NSURLSessionDataTask*) GET:(id<RTNetworkingAction>)act completion:(RTNetworkingCompletionBlock)block {
    if([self intercept:act]) {
        return nil;
    }
    return [sessionManager GET:act.url parameters:act.parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(block) {
            block(YES, task, nil, [self map:responseObject action:act]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(block) {
            [self handleError:error action:act];
            block(NO, task, error, nil);
        }
    }];
}

- (NSURLSessionDataTask*) DELETE:(id<RTNetworkingAction>)act completion:(RTNetworkingCompletionBlock)block {
    if([self intercept:act]) {
        return nil;
    }
    return [sessionManager DELETE:act.url parameters:act.parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(block) {
            block(YES, task, nil, [self map:responseObject action:act]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(block) {
            [self handleError:error action:act];
            block(NO, task, error, nil);
        }
    }];
}

- (NSURLSessionDataTask*) PUT:(id<RTNetworkingAction>)act completion:(RTNetworkingCompletionBlock)block {
    if([self intercept:act]) {
        return nil;
    }
    return [sessionManager PUT:act.url parameters:act.parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(block) {
            block(YES, task, nil, [self map:responseObject action:act]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(block) {
            [self handleError:error action:act];
            block(NO, task, error, nil);
        }
    }];
}

- (NSURLSessionDataTask*) PATCH:(id<RTNetworkingAction>)act completion:(RTNetworkingCompletionBlock)block {
    if([self intercept:act]) {
        return nil;
    }
    return [sessionManager PATCH:act.url parameters:act.parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(block) {
            block(YES, task, nil, [self map:responseObject action:act]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(block) {
            [self handleError:error action:act];
            block(NO, task, error, nil);
        }
    }];
}

- (NSURLSessionDataTask*) HEAD:(id<RTNetworkingAction>)act completion:(RTNetworkingCompletionBlock)block {
    if([self intercept:act]) {
        return nil;
    }
    return [sessionManager HEAD:act.url parameters:act.parameters success:^(NSURLSessionDataTask * _Nonnull task) {
        if(block) {
            block(YES, task, nil, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(block) {
            [self handleError:error action:act];
            block(NO, task, error, nil);
        }
    }];
}

#pragma mark - PRIVATE

- (void) buildupSessionManager {
    sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kRTNetworkingBaseURL]];
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    sessionManager.completionQueue = dispatch_queue_create("RTNetworking.Queue", DISPATCH_QUEUE_CONCURRENT);
}

- (BOOL) intercept:(id<RTNetworkingAction>)action {
    NSArray *array = [interceptors copy];
    for(id<RTNetworkingInterceptor> interceptor in array) {
        if([interceptor interceptAction:action]) {
            return YES;
        }
    }
    return NO;
}

- (void) handleError:(NSError*)error action:(id<RTNetworkingAction>)action {
    NSArray *array = [handlers copy];
    for(id<RTNetworkingErrorHandler> handler in array) {
        if([handler handleError:error withAction:action]) {
            break;
        }
    }
}

- (id) map:(NSDictionary*)json action:(id<RTNetworkingAction>)action {
    NSArray *array = [mappers copy];
    for(id<RTNetworkingModelMapper> mapper in array) {
        if([mapper shouldMap:action]) {
            return [mapper map:json];
        }
    }
    return json;
}

- (id) find:(NSString*)name inArray:(NSArray*)array {
    for(id obj in array) {
        if([name isEqualToString:[obj name]]) {
            return obj;
        }
    }
    return nil;
}

- (void) remove:(NSString*)name inArray:(NSMutableArray *)array {
    NSArray *copied = [array copy];
    for(id obj in copied) {
        if([name isEqualToString:[obj name]]) {
            [array removeObject:obj];
            break;
        }
    }
}

@end