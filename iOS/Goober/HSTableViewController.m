//
//  HSTableViewController.m
//  Goober
//
//  Created by Hikari Senju on 9/6/14.
//  Copyright (c) 2014 Hikari Senju. All rights reserved.
//

#import "HSTableViewController.h"
#import "HSAppDelegate.h"
#import "HSTableViewCell.h"
#import "HSVenue.h"
#import "NSString+UrlEncode.h"
#import <AFHTTPRequestOperationManager.h>

@interface HSTableViewController ()

@property (strong, nonatomic) UIWebView* webView;

@end

@implementation HSTableViewController

@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // The className to query on
		self.parseClassName = @"Venue";
        
		// The key of the PFObject to display in the label of the default cell style
		self.textKey = kHSParseTextKey;
        
        // Whether the built-in pull-to-refresh is enabled
        if (NSClassFromString(@"UIRefreshControl")) {
            self.pullToRefreshEnabled = NO;
        } else {
            self.pullToRefreshEnabled = YES;
        }
		
		// Whether the built-in pagination is enabled
		self.paginationEnabled = NO;
        
		// The number of objects to show per page
		self.objectsPerPage = kHSSearch;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (NSClassFromString(@"UIRefreshControl")) {
        // Use the new iOS 6 refresh control.
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        self.refreshControl = refreshControl;
        self.refreshControl.tintColor = [UIColor colorWithRed:118.0f/255.0f green:117.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
        [self.refreshControl addTarget:self action:@selector(refreshControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.pullToRefreshEnabled = NO;
    }
    
    self.paginationEnabled = NO;
    self.objectsPerPage = kHSSearch;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationDidChange:) name:kHSLocationChangeNotification object:nil];

    // Do any additional setup after loading the view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - PFQueryTableViewController

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
    if (NSClassFromString(@"UIRefreshControl")) {
        [self.refreshControl endRefreshing];
    }
}

- (void)objectsWillLoad {
    [webView stopLoading];
    [super objectsWillLoad];
    
    
    // This method is called before a PFQuery is fired to get more objects
}

// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    HSAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
	PFQuery *query = [PFQuery queryWithClassName:@"Venue"];
    query.limit = 5;//kHSSearch;
	// If no objects are loaded in memory, we look to the cache first to fill the table
	// and then subsequently do a query against the network.
	if ([self.objects count] == 0) {
		query.cachePolicy = kPFCachePolicyCacheThenNetwork;
	}
    
	// Query for posts near our current location.
    
	// Get our current location:

	CLLocation *currentLocation = appDelegate.currentLocation;
    
	// And set the query to look by location
	PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
	[query whereKey:kHSParseLocationKey nearGeoPoint:point withinKilometers:50];
    [query orderByAscending:@"pop"];
    
    
    
	return query;
}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
	// Reuse identifiers for left and right cells
	static NSString *CellIdentifier = @"HSTableCell";
    
	HSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HSTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsZero;
        }
        
        cell.contentView.backgroundColor = [UIColor whiteColor];
    
    }

    [cell updateCell:[NSString stringWithFormat:@"%ld",indexPath.row + 1] address:[object objectForKey:@"addr"] name:[object objectForKey:@"name"]];
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    return [self HTTPRequestOperationWithRequest:urlRequest success:success failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"uber://"]]) {
        
        __block NSString *productID;
        
        HSAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        NSString *string =[NSString stringWithFormat:@"https://api.uber.com/v1/products?latitude=%f&longitude=%f&server_token=h7EsMvwXfvo6F1RSmOaxtdw26aJ5Cz9ohNaNmHfJ",appDelegate.currentLocation.coordinate.latitude,appDelegate.currentLocation.coordinate.longitude];
        NSURL *url = [NSURL URLWithString:string];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id JSON) {
            NSArray *innerJSON = [JSON objectForKey:@"products"];
            
            for (id product in innerJSON){
                if ([[product objectForKey:@"display_name"] isEqualToString: @"uberX"]){
                    
                    productID = [product objectForKey:@"product_id"];
                    
                    PFObject *object = [self.objects objectAtIndex:indexPath.row];
                    HSVenue *venueFromObject = [[HSVenue alloc] initWithPFObject:object];
                    NSString *dropoffAddressString = [venueFromObject.address urlEncode];
                    
                    if (!webView){
                        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
                        [self.view addSubview:webView];}
                    NSString *uber = [NSString stringWithFormat:@"uber://?action=setPickup&pickup[latitude]=%f&pickup[longitude]=%f&dropoff[latitude]=%f&dropoff[longitude]=%f&dropoff[formatted_address]=%@&product_id=%@", appDelegate.currentLocation.coordinate.latitude, appDelegate.currentLocation.coordinate.longitude, venueFromObject.coordinate.latitude, venueFromObject.coordinate.longitude, dropoffAddressString, productID];
                    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:uber]]];
            
                }
            }

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            // 4
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        }];
        
        // 5
        [operation start];
        
    }
    else {
        // No Uber app! Open Mobile Website.
    }

}

- (void)locationDidChange:(NSNotification *)note {
    [self loadObjects];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshControlValueChanged:(UIRefreshControl *)refreshControl {
    [self loadObjects];
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
