//
//  HSNetworkingClient.m
//  Goober
//
//  Created by Hikari Senju on 9/6/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import "HSNetworkingClient.h"
#import "HSNetworkingErrors.h"
//#import "BCInitialPageContainerController.h"
#import "Constants.h"
#import "HSAppDelegate.h"


@interface HSNetworkingClient()
{
    NSDate *lastNotReachableError;
}

@end


@implementation HSNetworkingClient

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        _internetReachability = [Reachability reachabilityForInternetConnection];
        [_internetReachability startNotifier];
    }
    return self;
}


#pragma mark - Utils

+ (NSDictionary*)dictionaryFromJSONString:(NSString*)JSON
{
    NSError* error;
    
    NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:[JSON dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    if (error || !dictionary)
    {
        return nil;
    }
    
    return dictionary;
}


#pragma mark - API Level Errors

- (NSError*)sanitizeError:(NSError*)error forOperation:(AFHTTPRequestOperation*)operation
{
    if (error.domain == AFURLResponseSerializationErrorDomain)
    {
        if (error.code == NSURLErrorBadServerResponse)
        {
            if ((operation.response.statusCode == 401) && !self.errorHandlerDisabled)
            {
                // not authorized -> process login again
                
                [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kBCURLSessionLocation];
                [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kBCXSessionToken];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
//                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                BCInitialPageContainerController *initialController = [storyboard instantiateViewControllerWithIdentifier:@"SBIDInitialPageContainerCOntroller"];
//                BCAppDelegate *appDelegate = (BCAppDelegate*)[[UIApplication sharedApplication] delegate];
//                [appDelegate loadMainController:initialController];
                
                NSLog(@"Server error: Not authorized");
                
                return [NSError errorWithDomain:kBCProcessedErrorDomain code:0 userInfo:nil];
            }
            else
            {
                if (operation.response.statusCode == 406)
                {
                    
                    [[[UIAlertView alloc] initWithTitle:@"Unsupported data format" message:@"Please update your app to the latest version" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    
                    return [NSError errorWithDomain:kBCProcessedErrorDomain code:0 userInfo:nil];
                }
            }
        }
    }
    else
    {
        if (error.code == NSURLErrorNotConnectedToInternet)
        {
            if (ABS((lastNotReachableError.timeIntervalSince1970 - [NSDate date].timeIntervalSince1970)) > 1)
            {
                lastNotReachableError = [NSDate date];
                
                [[[UIAlertView alloc] initWithTitle:@"Connection error" message:@"Internet connection not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                
            }
            
            return [NSError errorWithDomain:kBCProcessedErrorDomain code:0 userInfo:nil];
        }
    }
    
    return error;
}


#pragma mark - Making HTTP requests

- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    __weak typeof(self) weakSelf = self;
    
    return [super HTTPRequestOperationWithRequest:urlRequest success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSError *sanitizedError = [weakSelf sanitizeError: error forOperation: operation];
        
        if (failure)
        {
            failure(operation, sanitizedError);
        }
    }];
}

#pragma mark - Reachability

- (BOOL)isInternetReachable
{
	return ([_internetReachability currentReachabilityStatus] != NotReachable);
}

- (NetworkStatus)getInternetReachabilityStatus
{
	return [_internetReachability currentReachabilityStatus];
}



@end
