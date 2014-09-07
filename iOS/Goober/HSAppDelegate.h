//
//  HSAppDelegate.h
//  Goober
//
//  Created by Hikari Senju on 9/6/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#define HSLocationAccuracy double

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "HSMainViewController.h"



@class HSMainViewController;

@interface HSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UIViewController *viewController;

@property (nonatomic, strong) CLLocation *currentLocation;

- (void)presentWelcomeViewController;

@end