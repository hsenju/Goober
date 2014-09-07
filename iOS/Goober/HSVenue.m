//
//  HSVenue.m
//  Goober
//
//  Created by Hikari Senju on 9/6/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import "HSVenue.h"

@interface HSVenue ()

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
    self.address = [anObject objectForKey:kHSParseAddressKey];
    self.name = [anObject objectForKey:kHSParseNameKey];
    
	[anObject fetchIfNeeded];
	CLLocationCoordinate2D aCoordinate = CLLocationCoordinate2DMake(self.geopoint.latitude, self.geopoint.longitude);

    
	return [self initWithCoordinate:aCoordinate];
}

- (BOOL)equalToPost:(HSVenue *)aVenue {
	if (aVenue == nil) {
		return NO;
	}
    
	if (aVenue.object && self.object) {
		if ([aVenue.object.objectId compare:self.object.objectId] != NSOrderedSame) {
			return NO;
		}
		return YES;
	} else {
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