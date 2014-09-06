//
//  UIViewController+NSString_HSEncode.m
//  Goober
//
//  Created by Hikari Senju on 9/6/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import "NSString+HSEncode.h"

@implementation NSString (HSEncode)

-(NSString *) HSEncode {
	return (NSString *)CFBridgingRelease(
         CFURLCreateStringByAddingPercentEscapes(
             NULL,
             (__bridge CFStringRef) self,
             NULL,
             CFSTR("!*'();:@&=+$,/?%#[]"),
             kCFStringEncodingUTF8
             )
         );
}

@end
