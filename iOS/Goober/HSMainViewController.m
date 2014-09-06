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

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;

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
        // Custom initialization
        self.className = kHSParseVenueClassKey;
		annotations = [[NSMutableArray alloc] initWithCapacity:10];
		allVenues = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationDidChange:) name:kHSLocationChangeNotification object:nil];
    
    //self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.332495f, -122.029095f), MKCoordinateSpanMake(0.008516f, 0.021801f));
	//self.mapPannedSinceLocationUpdate = NO;
    
    HSAppDelegate *appDelegate = (HSAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self queryForAllVenuesNearLocation:appDelegate.currentLocation withNearbyDistance:appDelegate.filterDistance];
    
    [mapView setShowsUserLocation:YES];
    
	[self startStandardUpdates];
    // Do any additional setup after loading the view.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    HSAppDelegate *appDelegate = (HSAppDelegate *)[[UIApplication sharedApplication] delegate];
    //MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(appDelegate.currentLocation.coordinate, appDelegate.filterDistance * 2, appDelegate.filterDistance * 2);
    [self queryForAllVenuesNearLocation:appDelegate.currentLocation withNearbyDistance:appDelegate.filterDistance];
    
    //[self.mapView setRegion:newRegion animated:YES];
    self.mapPannedSinceLocationUpdate = NO;
}


- (void)viewWillAppear:(BOOL)animated {
    HSAppDelegate *appDelegate = (HSAppDelegate *)[[UIApplication sharedApplication] delegate];
    MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(appDelegate.currentLocation.coordinate, appDelegate.filterDistance * 2, appDelegate.filterDistance * 2);
    [self queryForAllVenuesNearLocation:appDelegate.currentLocation withNearbyDistance:appDelegate.filterDistance];
    
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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
	[locationManager stopUpdatingLocation];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kHSLocationChangeNotification object:nil];
	self.mapPinsPlaced = NO; // reset this for the next time we show the map.
}

- (void)locationDidChange:(NSNotification *)note {
	HSAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
	// If they panned the map since our last location update, don't recenter it.
	if (!self.mapPannedSinceLocationUpdate) {
		// Set the map's region centered on their new location at 2x filterDistance
		MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(appDelegate.currentLocation.coordinate, appDelegate.filterDistance * 2.0f, appDelegate.filterDistance * 2.0f);
        
		BOOL oldMapPannedValue = self.mapPannedSinceLocationUpdate;
		[mapView setRegion:newRegion animated:YES];
		self.mapPannedSinceLocationUpdate = oldMapPannedValue;
	} // else do nothing.

    
	// Update the map with new pins:
	//[self queryForAllVenuesNearLocation:appDelegate.currentLocation withNearbyDistance:appDelegate.filterDistance];
	// And update the existing pins to reflect any changes in filter distance:
    
}


#pragma mark - CLLocationManagerDelegate methods and helpers

- (void)startStandardUpdates {
	if (nil == locationManager) {
		locationManager = [[CLLocationManager alloc] init];
	}
    
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
	// Set a movement threshold for new events.
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
    [self queryForAllVenuesNearLocation:appDelegate.currentLocation withNearbyDistance:appDelegate.filterDistance];
}

- (void) startShowingUserHeading:(id)sender{
    HSAppDelegate *appDelegate = (HSAppDelegate *)[[UIApplication sharedApplication] delegate];
    MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(appDelegate.currentLocation.coordinate, appDelegate.filterDistance * 2, appDelegate.filterDistance * 2);
    [self queryForAllVenuesNearLocation:appDelegate.currentLocation withNearbyDistance:appDelegate.filterDistance];
    
    [self.mapView setRegion:newRegion animated:YES];
    self.mapPannedSinceLocationUpdate = NO;
}

#pragma mark - MKMapViewDelegate methods


- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id<MKAnnotation>)annotation {
	// Let the system handle user location annotations.
	if ([annotation isKindOfClass:[MKUserLocation class]]) {
		return nil;
	}
    
	static NSString *pinIdentifier = @"CustomPinAnnotation";
    
	// Handle any custom annotations.
	if ([annotation isKindOfClass:[HSVenue class]])
	{
		// Try to dequeue an existing pin view first.
		MKPinAnnotationView *pinView = (MKPinAnnotationView*)[aMapView dequeueReusableAnnotationViewWithIdentifier:pinIdentifier];
        
		if (!pinView)
		{
			// If an existing pin view was not available, create one.
			pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
			                                          reuseIdentifier:pinIdentifier];
		}
		else {
			pinView.annotation = annotation;
		}
		pinView.animatesDrop = [((HSVenue *)annotation) animatesDrop];
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
    
    
	// If no objects are loaded in memory, we look to the cache first to fill the table
	// and then subsequently do a query against the network.
	if ([self.allVenues count] == 0) {
		query.cachePolicy = kPFCachePolicyCacheThenNetwork;
	}
    
	// Query for posts sort of kind of near our current location.
	PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
	[query whereKey:kHSParseLocationKey nearGeoPoint:point withinKilometers:kHSMaximumSearchDistance];
	query.limit = 5;//kHSSearch;
    
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (error) {
			NSLog(@"error in geo query!"); // todo why is this ever happening?
		} else {
			// We need to make new post objects from objects,
			// and update allPosts and the map to reflect this new array.
			// But we don't want to remove all annotations from the mapview blindly,
			// so let's do some work to figure out what's new and what needs removing.
            
			// 1. Find genuinely new posts:
			NSMutableArray *newVenues = [[NSMutableArray alloc] initWithCapacity:kHSSearch];
			// (Cache the objects we make for the search in step 2:)
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
			// newPosts now contains our new objects.
            
			// 2. Find posts in allPosts that didn't make the cut.
			NSMutableArray *venuesToRemove = [[NSMutableArray alloc] initWithCapacity:kHSSearch];
			for (HSVenue *currentVenue in allVenues) {
				BOOL found = NO;
				// Use our object cache from the first loop to save some work.
				for (HSVenue *allNewVenue in allNewVenues) {
					if ([currentVenue equalToPost:allNewVenue]) {
						found = YES;
					}
				}
				if (!found) {
					[venuesToRemove addObject:currentVenue];
				}
			}
			// postsToRemove has objects that didn't come in with our new results.
            
			// 3. Configure our new posts; these are about to go onto the map.
			for (HSVenue *newVenue in newVenues) {
				CLLocation *objectLocation = [[CLLocation alloc] initWithLatitude:newVenue.coordinate.latitude longitude:newVenue.coordinate.longitude];
				// if this post is outside the filter distance, don't show the regular callout.
				CLLocationDistance distanceFromCurrent = [currentLocation distanceFromLocation:objectLocation];
				newVenue.animatesDrop = mapPinsPlaced;
			}
            
			// At this point, newAllPosts contains a new list of post objects.
			// We should add everything in newPosts to the map, remove everything in postsToRemove,
			// and add newPosts to allPosts.
			[mapView removeAnnotations:venuesToRemove];
			[mapView addAnnotations:newVenues];
			[allVenues addObjectsFromArray:newVenues];
			[allVenues removeObjectsInArray:venuesToRemove];
            
			self.mapPinsPlaced = YES;
		}
	}];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
