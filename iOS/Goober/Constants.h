//
//  Constants.h
//  Goober
//
//  Created by Hikari Senju on 9/6/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#define DEVELOP_BASE_URL            @"9bs8j3aj.bettercompany.co/"

#define STAGING_BASE_URL            @"qtu79k2o.bettercompany.co/"

#define PRODUCTION_BASE_URL         @"qtu79k2o.bettercompany.co/"

#define ADMIN_STAGING_BASE_URL      @"9bs8j3aj.bettercompany.co/admin/"

#define ADMIN_PRODUCTION_BASE_URL   @"qtu79k2o.bettercompany.co/admin/"




#ifdef NO_SSL
#define URL_TYPE @"http://"
#else
#define URL_TYPE @"https://"
#endif

#define FULL_URL(a, b) [NSString stringWithFormat:@"%@%@", a, b]

#ifdef ADMIN
#ifdef DEVELOP
#define FULL_API_URL                FULL_URL(URL_TYPE, ADMIN_STAGING_BASE_URL)
#else
#define FULL_API_URL                FULL_URL(URL_TYPE, ADMIN_PRODUCTION_BASE_URL)
#endif
#else
#ifdef DEVELOP
#define FULL_API_URL                FULL_URL(URL_TYPE, DEVELOP_BASE_URL)
#else
#ifdef STAGING
#define FULL_API_URL            FULL_URL(URL_TYPE, STAGING_BASE_URL)
#else
#define FULL_API_URL            FULL_URL(URL_TYPE, PRODUCTION_BASE_URL)
#endif
#endif
#endif

#define kAFBetterCoAPIBaseURLString         FULL_API_URL




#define kUberRedirectUrl            @"https://GVHlANVgkCCANB6RdW8InlAMtU6FqG86EZC6gxel:javascript-key=tZr9rIEilQDb6od8Lyr8lYjqahRqhFZoC9114P68@api.parse.com/1/classes/HTTPResponse"
#define kUberClientId               @"POmzuZX8VKE5slSJBOgYMJFaIQktVLrG"
#define kUberClientSecret           @"R9ILwsaso0ZB2IpC7RgpqwYnwxx_sqz45pA4LCG1"
#define kUberState                  @"DCEEFWF45453sdffef424"

#define kBCSchemeRoot                   @"root"
#define kBCSchemeRootVersion            @(0)
#define kBCSchemeSession                @"session"
#define kBCSchemeSessionVersion         @(1)
#define kBCSchemeAuthorization          @"authorization"
#define kBCSchemeAuthorizationVersion   @(0)
#define kBCSchemeUberAuthorization  @"linked-in-authorization"
#define kBCSchemeUberAuthorizationVersion   @(0)
#define kBCSchemeFacebookAuthorization  @"facebook-authorization"
#define kBCSchemeFacebookAuthorizationVersion   @(0)
#define kBCSchemeAuthentication         @"authentication"
#define kBCSchemeAuthenticationVersion  @(0)
#define kBCSchemeAccount                @"account"
#define kBCSchemeAccountVersion         @(0)
#define kBCSchemeTerms                  @"terms"
#define kBCSchemeTermsVersion           @(0)
#define kBCSchemeCompanies              @"companies"
#define kBCSchemeCompaniesVersion       @(0)
#define kBCSchemeManager                @"manager"
#define kBCSchemeManagerVersion         @(0)
#define kBCSchemeMessages               @"messages"
#define kBCSchemeMessagesVersion        @(0)
#define kBCSchemeMessageContent         @"message-content"
#define kBCSchemeMessageContentVersion  @(0)
#define kBCSchemeCommentContent         @"comment-content"
#define kBCSchemeCommentContentVersion  @(0)
#define kBCSchemeNotice                 @"notice"
#define kBCSchemeNoticeVersion          @(0)
#define kBCSchemeVote                   @"vote"
#define kBCSchemeVoteVersion            @(0)
#define kBCSchemeFlag                   @"flag"
#define kBCSchemeFlagVersion            @(0)
#define kBCSchemeMessagePatch           @"message-patch"
#define kBCSchemeMessagePatchVersion    @(0)
#define kBCSchemeMark                   @"mark"
#define kBCSchemeMarkVersion            @(0)
#define kBCSchemeComments               @"comments"
#define kBCSchemeCommentsVersion        @(0)
#define kBCSchemeProfile                @"profile"
#define kBCSchemeProfileVersion         @(0)
#define kBCSchemeCompanyName            @"company"
#define kBCSchemeCompanyNameVersion     @(0)
#define kBCSchemeApnsToken              @"apns-token"
#define kBCSchemeApnsTokenVersion       @(0)
#define kBCSchemePrompt                 @"prompt"
#define kBCSchemePromptVersion          @(0)
#define kBCSchemeSignup                 @"signup"
#define kBCSchemeSignupVersion          @(0)

#define kBCURLSessionLocation           @"kBCURLSessionLocation"
#define kBCXSessionToken                @"kBCXSessionToken"

#define kBCProcessedErrorDomain         @"ProcessedErrorDomain"

