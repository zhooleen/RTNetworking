//
//  RTNetworkingManager.h
//  RTNetworking
//
//  Created by lzhu on 9/12/16.
//  Copyright © 2016 redeight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

#import "RTNetworkingAction.h"
#import "RTNetworkingInterceptor.h"
#import "RTNetworkingErrorHandler.h"
#import "RTNetworkingModelMapper.h"

typedef void(^RTNetworkingCompletionBlock)(BOOL done, NSURLSessionDataTask* task, NSError* err, id result);

FOUNDATION_EXTERN NSString * const kRTNetworkingBaseURL;

@interface RTNetworkingManager : NSObject

@property (strong, nonatomic, readonly) AFHTTPSessionManager *sessionManager;

+ (instancetype) sharedManager;

/**
 * Midwares chain : Interceptors & ErrorHandlers & modelMapper
 */

- (id<RTNetworkingInterceptor>) interceptorWithName:(NSString*)name;
- (id<RTNetworkingErrorHandler>) errorHandlerWithName:(NSString*)name;
- (id<RTNetworkingModelMapper>) modelMapperWithName:(NSString*)name;

- (void) addInterceptor:(id<RTNetworkingInterceptor>)interceptor;
- (void) addErrorHandler:(id<RTNetworkingErrorHandler>)handler;
- (void) addModelMapper:(id<RTNetworkingModelMapper>)mapper;

- (void) removeInterceptor:(NSString*)name;
- (void) removeErrorHandler:(NSString*)name;
- (void) removeModelMapper:(NSString*)name;

/**
 * HTTP Request
 */

- (NSURLSessionDataTask*) POST:(id<RTNetworkingAction>)act completion:(RTNetworkingCompletionBlock)block;
- (NSURLSessionDataTask*) GET:(id<RTNetworkingAction>)act completion:(RTNetworkingCompletionBlock)block;
- (NSURLSessionDataTask*) DELETE:(id<RTNetworkingAction>)act completion:(RTNetworkingCompletionBlock)block;
- (NSURLSessionDataTask*) PUT:(id<RTNetworkingAction>)act completion:(RTNetworkingCompletionBlock)block;
- (NSURLSessionDataTask*) PATCH:(id<RTNetworkingAction>)act completion:(RTNetworkingCompletionBlock)block;
- (NSURLSessionDataTask*) HEAD:(id<RTNetworkingAction>)act completion:(RTNetworkingCompletionBlock)block;

@end