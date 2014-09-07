//
//  Constants.h
//  Goober
//
//  Created by Hikari Senju on 9/6/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#define kUberRedirectUrl            @"https://GVHlANVgkCCANB6RdW8InlAMtU6FqG86EZC6gxel:javascript-key=tZr9rIEilQDb6od8Lyr8lYjqahRqhFZoC9114P68@api.parse.com/1/classes/HTTPResponse/4iB4KqxDDo"
#define kUberClientId               @"POmzuZX8VKE5slSJBOgYMJFaIQktVLrG"
#define kUberClientSecret           @"R9ILwsaso0ZB2IpC7RgpqwYnwxx_sqz45pA4LCG1"
#define kUberState                  @"DCEEFWF45453sdffef424"


static NSUInteger const kHSMaximumCharacterCount = 140;

static double const kHSFeetToMeters = 0.3048; // this is an exact value.
static double const kHSFeetToMiles = 5280.0; // this is an exact value.
static double const kHSSearchDistance = 20.0;
static double const kHSMetersInAKilometer = 1000.0; // this is an exact value.

static NSUInteger const kHSSearch = 5; // query limit for pins and tableviewcells

static NSString * const kHSLocationKey = @"location";
static NSString * const kHSParseVenueClassKey = @"Venue";
static NSString * const defaultsLocationKey = @"currentLocation";
static NSString * const kHSLocationChangeNotification = @"kHSLocationChangeNotification";
static NSString * const kHSParseUserKey = @"user";
static NSString * const kHSParseUsernameKey = @"username";
static NSString * const kHSParseTextKey = @"text";
static NSString * const kHSParseLocationKey = @"location";
static NSString * const kHSParseAddressKey = @"addr";
static NSString * const kHSParseNameKey = @"name";