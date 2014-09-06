//
//  HSUberAuthorizationViewController.m
//  Goober
//
//  Created by Hikari Senju on 9/6/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import "HSUberAuthorizationViewController.h"
#import "NSString+HSEncode.h"
#import "Macros.h"
#import <MBProgressHUD/MBProgressHUD.h>

NSString *kUberErrorDomain = @"HSUberERROR";
NSString *kUberDeniedByUser = @"the+user+denied+your+request";

@interface HSUberAuthorizationViewController ()
@property(nonatomic, copy) HSAuthorizationCodeFailureCallback failureCallback;
@property(nonatomic, copy) HSAuthorizationCodeSuccessCallback successCallback;
@property(nonatomic, copy) HSAuthorizationCodeCancelCallback cancelCallback;
@property(nonatomic, strong) HSUberApplication *application;
@end

@interface HSUberAuthorizationViewController (UIWebViewDelegate) <UIWebViewDelegate, UIAlertViewDelegate>

@end

//todo: handle no network
@implementation HSUberAuthorizationViewController

BOOL handlingRedirectURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithApplication:(HSUberApplication *)application success:(HSAuthorizationCodeSuccessCallback)success cancel:(HSAuthorizationCodeCancelCallback)cancel failure:(HSAuthorizationCodeFailureCallback)failure {
    self = [super init];
    if (self) {
        self.application = application;
        self.successCallback = success;
        self.cancelCallback = cancel;
        self.failureCallback = failure;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.authenticationWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.authenticationWebView.delegate = self;
    self.authenticationWebView.hidden = YES;
    self.authenticationWebView.backgroundColor = UIColorWithRGBValues(222, 222, 222);
    self.authenticationWebView.alpha = 0;
    [self.view addSubview:self.authenticationWebView];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //NSString *uber = [NSString stringWithFormat:@"https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=%@&scope=%@&state=%@&redirect_uri=%@", self.application.clientId, self.application.grantedAccessString, self.application.state, [self.application.redirectURL HSEncode]];
     NSString *uber = [NSString stringWithFormat:@"https://login.uber.com/oauth/authorize?response_type=code&client_id=%@&scope=%@&state=%@&redirect_uri=%@", self.application.clientId, self.application.grantedAccessString, self.application.state, [self.application.redirectURL HSEncode]];
    [self.authenticationWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:uber]]];
}

@end

@implementation HSUberAuthorizationViewController (UIWebViewDelegate)

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = [[request URL] absoluteString];
    
    if (([url rangeOfString:@"?report-failure"].location != NSNotFound) || ([url rangeOfString:@"?report%2Efailure"].location != NSNotFound))
    {
        // LinkedIn error
        NSError *error = [[NSError alloc] initWithDomain:kUberErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey:@"There was an unexpected error communicating with LinkedIn."}];
        self.failureCallback(error);
        return FALSE;
    }
    
    //prevent loading URL if it is the redirectURL
    handlingRedirectURL = [url hasPrefix:self.application.redirectURL];
    
    if (handlingRedirectURL) {
        if ([url rangeOfString:@"error"].location != NSNotFound) {
            BOOL accessDenied = [url rangeOfString:kUberDeniedByUser].location != NSNotFound;
            if (accessDenied) {
                self.cancelCallback();
            } else {
                NSError *error = [[NSError alloc] initWithDomain:kUberErrorDomain code:1 userInfo:[[NSMutableDictionary alloc] init]];
                self.failureCallback(error);
            }
        } else {
            NSString *receivedState = [self extractGetParameter:@"state" fromURLString: url];
            //assert that the state is as we expected it to be
            if ([self.application.state isEqualToString:receivedState]) {
                //extract the code from the url
                NSString *authorizationCode = [self extractGetParameter:@"code" fromURLString: url];
                self.successCallback(authorizationCode);
            } else {
                NSError *error = [[NSError alloc] initWithDomain:kUberErrorDomain code:2 userInfo:[[NSMutableDictionary alloc] init]];
                self.failureCallback(error);
            }
        }
    }
    return !handlingRedirectURL;
}

- (NSString *)extractGetParameter: (NSString *) parameterName fromURLString:(NSString *)urlString {
    NSMutableDictionary *mdQueryStrings = [[NSMutableDictionary alloc] init];
    urlString = [[urlString componentsSeparatedByString:@"?"] objectAtIndex:1];
    for (NSString *qs in [urlString componentsSeparatedByString:@"&"]) {
        [mdQueryStrings setValue:[[[[qs componentsSeparatedByString:@"="] objectAtIndex:1]
                                   stringByReplacingOccurrencesOfString:@"+" withString:@" "]
                                  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                          forKey:[[qs componentsSeparatedByString:@"="] objectAtIndex:0]];
    }
    return [mdQueryStrings objectForKey:parameterName];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (!handlingRedirectURL)
        self.failureCallback(error);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.authenticationWebView.hidden = NO;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.authenticationWebView.alpha = 1;
    }];
    
    NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    if (([html rangeOfString:@"Request denied" options:NSCaseInsensitiveSearch].location != NSNotFound) || ([html rangeOfString:@"Reason codes:" options:NSCaseInsensitiveSearch].location != NSNotFound))
    {
        [[[UIAlertView alloc] initWithTitle:@"Login failed" message:@"LinkedIn did not accept this login try, please try again later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}


@end
