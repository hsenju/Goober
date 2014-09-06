//
//  HSUberApplication.h
//  Goober
//
//  Created by Hikari Senju on 9/6/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HSUberApplication : NSObject

@property(nonatomic, copy) NSString *redirectURL;
@property(nonatomic, copy) NSString *clientId;
@property(nonatomic, copy) NSString *clientSecret;
@property(nonatomic, copy) NSString *state;

@property(nonatomic, strong) NSArray *grantedAccess;

- (id)initWithRedirectURL:(NSString *)redirectURL clientId:(NSString *)clientId clientSecret:(NSString *)clientSecret state:(NSString *)state grantedAccess:(NSArray *)grantedAccess;

+ (id)applicationWithRedirectURL:(NSString *)redirectURL clientId:(NSString *)clientId clientSecret:(NSString *)clientSecret state:(NSString *)state grantedAccess:(NSArray *)grantedAccess;

- (NSString *)grantedAccessString;


@end