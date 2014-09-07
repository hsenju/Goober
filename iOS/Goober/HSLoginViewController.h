//
//  HSLoginViewController.h
//  Goober
//
//  Created by Hikari Senju on 9/6/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import "HSUberApplication.h"
#import "HSUberHttpClient.h"


#define NOTIFY_LINKEDIN_SUCCESS @"NOTIFY_LINKEDIN_SUCCESS"
#define NOTIFY_LINKEDIN_FAILED @"NOTIFY_LINKEDIN_FAILED"


@interface HSLoginViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, strong) HSUberApplication *application;
@property (nonatomic, strong) HSUberHttpClient  *client;

@end
