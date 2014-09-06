//
//  HSNetworkingClient.h
//  Goober
//
//  Created by Hikari Senju on 9/6/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import <Reachability.h>

@interface HSNetworkingClient : AFHTTPRequestOperationManager

@property (nonatomic, strong) Reachability *internetReachability;
@property BOOL errorHandlerDisabled;

- (BOOL)isInternetReachable;
- (NetworkStatus)getInternetReachabilityStatus;

@end
