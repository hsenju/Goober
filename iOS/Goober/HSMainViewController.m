//
//  HSMainViewController.m
//  Goober
//
//  Created by Hikari Senju on 9/6/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import "HSMainViewController.h"
#import "HSAppDelegate.h"
#import "HSVenue.h"
#import <CoreLocation/CoreLocation.h>

@interface HSMainViewController ()

@property (nonatomic, strong) CLLocationManager *_locationManager;
@property (nonatomic, assign) BOOL mapPinsPlaced;
@property (nonatomic, assign) BOOL mapPannedSinceLocationUpdate;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, copy) NSString *className;
@property (nonatomic, strong) NSMutableArray *allVenues;

- (void)startStandardUpdates;

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;


- (void)queryForAllVenuesNearLocation:(CLLocation *)currentLocation withNearbyDistance:(CLLocationAccuracy)nearbyDistance;
- (void)locationDidChange:(NSNotification *)note;
@end

@implementation HSMainViewController

@synthesize mapView;
@synthesize _locationManager = locationManager;
@synthesize annotations;
@synthesize className;
@synthesize allVenues;
@synthesize mapPinsPlaced;
@synthesize mapPannedSinceLocationUpdate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.className = kHSParseVenueClassKey;
		annotations = [[NSMutableArray alloc] initWithCapacity:10];
		allVenues = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationDidChange:) name:kHSLocationChangeNotification object:nil];
    
    HSAppDelegate *appDelegate = (HSAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self queryForAllVenuesNearLocation:appDelegate.currentLocation withNearbyDistance:kHSSearchDistance];
    
    [mapView setShowsUserLocation:YES];
    
	[self startStandardUpdates];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    HSAppDelegate *appDelegate = (HSAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self queryForAllVenuesNearLocation:appDelegate.currentLocation withNearbyDistance:kHSSearchDistance];
    self.mapPannedSinceLocationUpdate = NO;
}


- (void)viewWillAppear:(BOOL)animated {
    HSAppDelegate *appDelegate = (HSAppDelegate *)[[UIApplication sharedApplication] delegate];
    MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(appDelegate.currentLocation.coordinate, kHSSearchDistance * 500, kHSSearchDistance * 500);
    [self queryForAllVenuesNearLocation:appDelegate.currentLocation withNearbyDistance:kHSSearchDistance];
    
    [self.mapView setRegion:newRegion animated:YES];
    self.mapPannedSinceLocationUpdate = NO;

	[locationManager startUpdatingLocation];
	[super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[locationManager stopUpdatingLocation];
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
	[locationManager stopUpdatingLocation];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kHSLocationChangeNotification object:nil];
	self.mapPinsPlaced = NO;
}

- (void)locationDidChange:(NSNotification *)note {
	HSAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
	if (!self.mapPannedSinceLocationUpdate) {
		MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(appDelegate.currentLocation.coordinate, kHSSearchDistance * 500.0f, kHSSearchDistance * 500.0f);
        
		BOOL oldMapPannedValue = self.mapPannedSinceLocationUpdate;
		[mapView setRegion:newRegion animated:YES];
		self.mapPannedSinceLocationUpdate = oldMapPannedValue;
	}
}


#pragma mark - CLLocationManagerDelegate methods and helpers

- (void)startStandardUpdates {
	if (nil == locationManager) {
		locationManager = [[CLLocationManager alloc] init];
	}
    
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
	locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
    
	[locationManager startUpdatingLocation];
    
	CLLocation *currentLocation = locationManager.location;
	if (currentLocation) {
		HSAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
		appDelegate.currentLocation = currentLocation;
	}
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
	HSAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	appDelegate.currentLocation = newLocation;
    [self queryForAllVenuesNearLocation:appDelegate.currentLocation withNearbyDistance:kHSSearchDistance];
}

- (void) startShowingUserHeading:(id)sender{
    HSAppDelegate *appDelegate = (HSAppDelegate *)[[UIApplication sharedApplication] delegate];
    MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(appDelegate.currentLocation.coordinate, kHSSearchDistance * 500, kHSSearchDistance * 500);
    [self queryForAllVenuesNearLocation:appDelegate.currentLocation withNearbyDistance:kHSSearchDistance];
    
    [self.mapView setRegion:newRegion animated:YES];
    self.mapPannedSinceLocationUpdate = NO;
}

#pragma mark - MKMapViewDelegate methods


- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id<MKAnnotation>)annotation {
	if ([annotation isKindOfClass:[MKUserLocation class]]) {
		return nil;
	}
    
	static NSString *pinIdentifier = @"CustomPinAnnotation";
    
	if ([annotation isKindOfClass:[HSVenue class]])
	{
		MKPinAnnotationView *pinView = (MKPinAnnotationView*)[aMapView dequeueReusableAnnotationViewWithIdentifier:pinIdentifier];
        
		if (!pinView)
		{
			pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
			                                          reuseIdentifier:pinIdentifier];
		}
		else {
			pinView.annotation = annotation;
		}
		pinView.animatesDrop = NO;
		pinView.canShowCallout = NO;
        
		return pinView;
	}
    
	return nil;
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
	self.mapPannedSinceLocationUpdate = YES;
}

#pragma mark - Fetch map pins

- (void)queryForAllVenuesNearLocation:(CLLocation *)currentLocation withNearbyDistance:(CLLocationAccuracy)nearbyDistance {
	PFQuery *query = [PFQuery queryWithClassName:@"Venue"];
    
	if ([self.allVenues count] == 0) {
		query.cachePolicy = kPFCachePolicyCacheThenNetwork;
	}
    
	PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
	[query whereKey:kHSParseLocationKey nearGeoPoint:point withinKilometers:kHSSearchDistance];
	query.limit = 5;
    
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (error) {
			NSLog(@"error in geo query!");
		} else {

			NSMutableArray *newVenues = [[NSMutableArray alloc] initWithCapacity:kHSSearch];
			NSMutableArray *allNewVenues = [[NSMutableArray alloc] initWithCapacity:kHSSearch];
			for (PFObject *object in objects) {
				HSVenue *newVenue = [[HSVenue alloc] initWithPFObject:object];
				[allNewVenues addObject:newVenue];
				BOOL found = NO;
				for (HSVenue *currentVenue in allVenues) {
					if ([newVenue equalToPost:currentVenue
                         ]) {
						found = YES;
					}
				}
				if (!found) {
					[newVenues addObject:newVenue];
				}
			}
			NSMutableArray *venuesToRemove = [[NSMutableArray alloc] initWithCapacity:kHSSearch];
			for (HSVenue *currentVenue in allVenues) {
				BOOL found = NO;
				for (HSVenue *allNewVenue in allNewVenues) {
					if ([currentVenue equalToPost:allNewVenue]) {
						found = YES;
					}
				}
				if (!found) {
					[venuesToRemove addObject:currentVenue];
				}
			}
			for (HSVenue *newVenue in newVenues) {
				CLLocation *objectLocation = [[CLLocation alloc] initWithLatitude:newVenue.coordinate.latitude longitude:newVenue.coordinate.longitude];
				CLLocationDistance distanceFromCurrent = [currentLocation distanceFromLocation:objectLocation];
				newVenue.animatesDrop = NO;
			}
            
			[mapView removeAnnotations:venuesToRemove];
			[mapView addAnnotations:newVenues];
			[allVenues addObjectsFromArray:newVenues];
			[allVenues removeObjectsInArray:venuesToRemove];
            
			self.mapPinsPlaced = YES;
		}
	}];
}


@end
