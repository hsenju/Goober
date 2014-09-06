//
//  HSNetworkingErrors.h
//  Goober
//
//  Created by Hikari Senju on 9/6/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString * const NetworkingErrorDomain;

extern NSInteger const InvalidAccessTokenError;
extern NSInteger const InvalidObjectError;


@interface HSNetworkingErrors : NSObject

+ (NSError*) errorWithType : (NSString*) type userInfo:(NSDictionary*)userInfo;

@end
