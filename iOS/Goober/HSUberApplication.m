//
//  HSUberApplication.m
//  Goober
//
//  Created by Hikari Senju on 9/6/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import "HSUberApplication.h"

@implementation HSUberApplication

- (id)initWithRedirectURL:(NSString *)redirectURL clientId:(NSString *)clientId clientSecret:(NSString *)clientSecret state:(NSString *)state grantedAccess:(NSArray *)grantedAccess {
    self = [super init];
    if (self) {
        self.redirectURL = redirectURL;
        self.clientId = clientId;
        self.clientSecret = clientSecret;
        self.state = state;
        self.grantedAccess = grantedAccess;
    }
    
    return self;
}

+ (id)applicationWithRedirectURL:(NSString *)redirectURL clientId:(NSString *)clientId clientSecret:(NSString *)clientSecret state:(NSString *)state grantedAccess:(NSArray *)grantedAccess {
    return [[self alloc] initWithRedirectURL:redirectURL clientId:clientId clientSecret:clientSecret state:state grantedAccess:grantedAccess];
}

- (NSString *)grantedAccessString {
    return [self.grantedAccess componentsJoinedByString: @"%20"];
}

@end
