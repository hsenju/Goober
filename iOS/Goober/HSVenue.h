//
//  HSVenue.h
//  Goober
//
//  Created by Hikari Senju on 9/6/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSVenue.h"
#import <MapKit/MapKit.h>

@interface HSVenue : NSObject <MKAnnotation>

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSString *address;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, strong) PFObject *object;
@property (nonatomic, readonly, strong) PFGeoPoint *geopoint;
@property (nonatomic, assign) BOOL animatesDrop;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (id)initWithPFObject:(PFObject *)object;
- (BOOL)equalToPost:(HSVenue *)aPost;

@end
