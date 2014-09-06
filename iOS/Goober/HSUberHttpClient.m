//
//  HSUberHttpClient.m
//  Goober
//
//  Created by Hikari Senju on 9/6/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import "HSUberHttpClient.h"
#import <AFNetworking/AFURLResponseSerialization.h>
#import "HSUberAuthorizationViewController.h"
#import "NSString+HSEncode.h"

@interface HSUberHttpClient ()
@property(nonatomic, strong) HSUberApplication *application;
@property(nonatomic, weak) UIViewController *presentingViewController;
@end

@implementation HSUberHttpClient

+ (HSUberHttpClient *)clientForApplication:(HSUberApplication *)application {
    return [self clientForApplication:application presentingViewController:nil];
}

+ (HSUberHttpClient *)clientForApplication:(HSUberApplication *)application presentingViewController:viewController {
    HSUberHttpClient *client = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.uber.com/v1/products"]];
    client.application = application;
    client.presentingViewController = viewController;
    return client;
}


- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self setResponseSerializer:[AFJSONResponseSerializer serializer]];
    }
    return self;
}

- (void)getAccessToken:(NSString *)authorizationCode success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    NSString *accessTokenUrl = @"/uas/oauth2/accessToken?grant_type=authorization_code&code=%@&redirect_uri=%@&client_id=%@&client_secret=%@";
    NSString *url = [NSString stringWithFormat:accessTokenUrl, authorizationCode, [self.application.redirectURL HSEncode], self.application.clientId, self.application.clientSecret];
    
    [self POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
}

- (void)getAuthorizationCode:(void (^)(NSString *))success cancel:(void (^)(void))cancel failure:(void (^)(NSError *))failure {
    HSUberAuthorizationViewController *authorizationViewController = [[HSUberAuthorizationViewController alloc]
                                                                           initWithApplication:
                                                                           self.application
                                                                           success:^(NSString *code) {
                                                                               [self hideAuthenticateView];
                                                                               if (success) {
                                                                                   success(code);
                                                                               }
                                                                           }
                                                                           cancel:^{
                                                                               [self hideAuthenticateView];
                                                                               if (cancel) {
                                                                                   cancel();
                                                                               }
                                                                           } failure:^(NSError *error) {
                                                                               [self hideAuthenticateView];
                                                                               if (failure) {
                                                                                   failure(error);
                                                                               }
                                                                           }];
    [self showAuthorizationView:authorizationViewController];
}

- (void)showAuthorizationView:(HSUberAuthorizationViewController *)authorizationViewController {
    if (self.presentingViewController == nil)
        self.presentingViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    [self.presentingViewController presentViewController:authorizationViewController animated:YES completion:nil];
}

- (void)hideAuthenticateView {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
