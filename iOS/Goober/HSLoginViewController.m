//
//  HSLoginViewController.m
//  Goober
//
//  Created by Hikari Senju on 9/6/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import "HSLoginViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "HSAppDelegate.h"
#import "Constants.h"



@interface HSLoginViewController () <UIWebViewDelegate, UIAlertViewDelegate>


@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) NSOperation *runningApiRequest;

@end


@implementation HSLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *access = @[@"profile"];
    self.application = [HSUberApplication applicationWithRedirectURL:kUberRedirectUrl
                                                                 clientId:kUberClientId
                                                             clientSecret:kUberClientSecret
                                                                    state:kUberState
                                                            grantedAccess:access];
    
    self.client = [HSUberHttpClient clientForApplication:self.application];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (IBAction)loginButtonPressed:(id)sender {
    [self processUberLogin];
}

- (void)processUberLogin
{
    [self.client getAuthorizationCode:^(NSString * code)
     {
         
         [self.client getAccessToken:code success:^(NSDictionary *accessTokenData)
          {
              NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
              
              int seconds = [[accessTokenData objectForKey:@"expires"] intValue];
              NSDate* expiryDate = [[NSDate date] dateByAddingTimeInterval:seconds];
              
              [[NSUserDefaults standardUserDefaults] synchronize];
              
              [blockSelf processLoginWithKind:LOGIN_KIND_LINKEDIN accessToken:accessToken expiryDate:expiryDate];
          }
                             failure:^(NSError *error)
          {
          }];
     }
                               cancel:^
     {
     }
                              failure:^(NSError *error)
     {
     }];
    

}


@end
