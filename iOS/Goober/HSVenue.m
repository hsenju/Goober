//
//  HSVenue.m
//  Goober
//
//  Created by Hikari Senju on 9/6/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import "HSVenue.h"

@interface HSVenue ()

// Redefine these properties to make them read/write for internal class accesses and mutations.
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;

@property (nonatomic, strong) PFObject *object;
@property (nonatomic, strong) PFGeoPoint *geopoint;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, assign) MKPinAnnotationColor pinColor;

@end

@implementation HSVenue

- (id)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate {
	self = [super init];
	if (self) {
		self.coordinate = aCoordinate;
		self.animatesDrop = NO;
	}
	return self;
}

- (id)initWithPFObject:(PFObject *)anObject {
	self.object = anObject;
	self.geopoint = [anObject objectForKey:kHSParseLocationKey];
	self.user = [anObject objectForKey:kHSParseUserKey];
    
	[anObject fetchIfNeeded];
	CLLocationCoordinate2D aCoordinate = CLLocationCoordinate2DMake(self.geopoint.latitude, self.geopoint.longitude);

    
	return [self initWithCoordinate:aCoordinate];
}

- (BOOL)equalToPost:(HSVenue *)aVenue {
	if (aVenue == nil) {
		return NO;
	}
    
	if (aVenue.object && self.object) {
		// We have a PFObject inside the PAWPost, use that instead.
		if ([aVenue.object.objectId compare:self.object.objectId] != NSOrderedSame) {
			return NO;
		}
		return YES;
	} else {
		// Fallback code:
        
		if ([aVenue.title compare:self.title] != NSOrderedSame ||
			[aVenue.subtitle compare:self.subtitle] != NSOrderedSame ||
			aVenue.coordinate.latitude != self.coordinate.latitude ||
			aVenue.coordinate.longitude != self.coordinate.longitude ) {
			return NO;
		}
        
		return YES;
	}
}

@end