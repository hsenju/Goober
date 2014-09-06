//
//  HSUberAuthorizationViewController.h
//  Goober
//
//  Created by Hikari Senju on 9/6/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSUberApplication.h"

typedef void(^HSAuthorizationCodeSuccessCallback)(NSString *code);
typedef void(^HSAuthorizationCodeCancelCallback)(void);
typedef void(^HSAuthorizationCodeFailureCallback)(NSError *errorReason);

@interface HSUberAuthorizationViewController : UIViewController

@property(nonatomic, strong) UIWebView *authenticationWebView;

- (id)initWithApplication:(HSUberApplication *)application success:(HSAuthorizationCodeSuccessCallback)success cancel:(HSAuthorizationCodeCancelCallback)cancel failure:(HSAuthorizationCodeFailureCallback)failure;
@end