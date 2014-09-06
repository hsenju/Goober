//
//  HSUberHttpClient.h
//  Goober
//
//  Created by Hikari Senju on 9/6/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import <AFNetworking/AFHTTPRequestOperationManager.h>

@class HSUberApplication;

@interface HSUberHttpClient : AFHTTPRequestOperationManager

+ (HSUberHttpClient *)clientForApplication:(HSUberApplication *)application;

+ (HSUberHttpClient *)clientForApplication:(HSUberApplication *)application presentingViewController:viewController;

- (void)getAccessToken:(NSString *)authorizationCode success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;

- (void)getAuthorizationCode:(void (^)(NSString *))success cancel:(void (^)(void))cancel failure:(void (^)(NSError *))failure;
@end

