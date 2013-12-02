//
//  AMapController.m
//  ctrip-mobile
//
//  Created by caoguangyao on 8/14/13.
//  Copyright (c) 2013 caoguangyao. All rights reserved.
//

#import "AMapController.h"
#import "Pods/WYPopoverController/WYPopoverController/WYPopoverController.h"
#import "MapOptionController.h"
#import "MUserLocation.h"
#import "RococoAppDelegate.h"
#import "CommonUtility.h"
#import "LineDashPolyline.h"
#import "MapOptions.h"

@interface AMapController ()<WYPopoverControllerDelegate,MUserLocation,MapOptions>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong)WYPopoverController *popoverViewController;
@property (nonatomic) AMapSearchType searchType;
@property (nonatomic, strong) AMapRoute *route;
@property (nonatomic) NSInteger currentCourse;
@property (nonatomic, strong) AMapSearchAPI *search;

@end

@implementation AMapController

@synthesize popoverViewController = _popoverViewController;
@synthesize mapView = _mapView;
@synthesize search = _search;
@synthesize route = _route;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)mapOptions:(id)sender{
    MapOptionController *optionController = [[MapOptionController alloc] initWithStyle:UITableViewStyleGrouped];
    optionController.preferredContentSize = CGSizeMake(280, 280);
    optionController.title = @"选项";
    optionController.modalInPopover = NO;
    optionController.delegate = self;
    
    UINavigationController *contentController = [[UINavigationController alloc] initWithRootViewController:optionController];
    self.popoverViewController = [[WYPopoverController alloc] initWithContentViewController:contentController];
    self.popoverViewController.delegate = self;
    [self.popoverViewController presentPopoverFromBarButtonItem:sender permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
    
    
}

- (BOOL)popoverControllerShouldDismissPopover:(WYPopoverController *)aPopoverController
{
    return YES;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)aPopoverController
{
    self.popoverViewController.delegate = nil;
    self.popoverViewController = nil;
    
}

# pragma mark -- set popover appearance
- (void)initPopoverAppearance
{
    UIColor* greenColor = [UIColor colorWithRed:26.f/255.f green:188.f/255.f blue:156.f/255.f alpha:0.5];
    
    WYPopoverBackgroundView* popoverAppearance = [WYPopoverBackgroundView appearance];
    
    [popoverAppearance setOuterCornerRadius:4];
    [popoverAppearance setOuterShadowBlurRadius:0];
    [popoverAppearance setOuterShadowColor:[UIColor clearColor]];
    [popoverAppearance setOuterShadowOffset:CGSizeMake(0, 0)];
    
    [popoverAppearance setGlossShadowColor:[UIColor clearColor]];
    [popoverAppearance setGlossShadowOffset:CGSizeMake(0, 0)];
    
    [popoverAppearance setBorderWidth:8];
    [popoverAppearance setArrowHeight:10];
    [popoverAppearance setArrowBase:15];
    
    [popoverAppearance setInnerCornerRadius:4];
    [popoverAppearance setInnerShadowBlurRadius:0];
    [popoverAppearance setInnerShadowColor:[UIColor clearColor]];
    [popoverAppearance setInnerShadowOffset:CGSizeMake(0, 0)];
    
    [popoverAppearance setFillTopColor:greenColor];
    [popoverAppearance setFillBottomColor:greenColor];
    [popoverAppearance setOuterStrokeColor:greenColor];
    [popoverAppearance setInnerStrokeColor:greenColor];
    /*
    UINavigationBar* navBarInPopoverAppearance = [UINavigationBar appearanceWhenContainedIn:[UINavigationController class], [WYPopoverController class], nil];
    [navBarInPopoverAppearance setTitleTextAttributes: @{
                                                         UITextAttributeTextColor : [UIColor whiteColor],
                                                         UITextAttributeTextShadowColor : [UIColor clearColor],
                                                         UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetMake(0, -1)]}];
     */
}

# pragma mark -- user location delegate method
-(void)userLocationUpdated:(CLLocation *)location
{
    
}

#pragma mark - AMapSearchDelegate

- (void)search:(id)searchRequest error:(NSString *)errInfo
{
    NSLog(@"%s: searchRequest = %@, errInfo= %@", __func__, [searchRequest class], errInfo);
}


# pragma mark -- AMap search delegate and method
-(void) onNavigationSearchDone:(AMapNavigationSearchRequest *)request response:(AMapNavigationSearchResponse *)response
{
    if (self.searchType != request.searchType)
    {
        return;
    }
    
    if (response.route == nil)
    {
        return;
    }

    
    self.route = response.route;
    self.currentCourse = 0;
    [self presentCurrentCourse];
}

-(void)initSearch
{
    self.search = [[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey Delegate:nil];
    self.search.delegate = self;
    
}

-(void)clearSearch
{
    self.search.delegate = nil;
}


- (void) searchTypeForIndexPath:(NSIndexPath *)indexPath
{
    [self clearMapViewOverylays];
    
    self.searchType = 0;
    
    NSInteger selectedIndex = [indexPath row];
    
    switch (selectedIndex)
    {
        case 0: self.searchType = AMapSearchType_NaviWalking;   break;
        case 1: self.searchType = AMapSearchType_NaviBus; break;
        case 2: self.searchType = AMapSearchType_NaviDrive;     break;
        default:NSAssert(NO, @"%s: selectedindex = %d is invalid for Navigation", __func__, selectedIndex); break;
    }
    
    
    CLLocationCoordinate2D userCoordinate = self.mapView.userLocation.location.coordinate;
    CLLocationCoordinate2D destinationCoordinate = self.coordinate;
    
    [self searchNavi:self.searchType originLocation:userCoordinate destinationLocation:destinationCoordinate];
    
    [self.popoverViewController dismissPopoverAnimated:YES];

}

-(void)searchNavi:(AMapSearchType)searchType originLocation:(CLLocationCoordinate2D)origin destinationLocation:(CLLocationCoordinate2D)destination
{
    AMapNavigationSearchRequest *navi = [[AMapNavigationSearchRequest alloc] init];
    navi.searchType = searchType;
    navi.requireExtension = YES;
    
    if (searchType == AMapSearchType_NaviBus) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        navi.city = [defaults valueForKey:@"city"];
    }
    
    
    navi.origin = [AMapGeoPoint locationWithLatitude:origin.latitude longitude:origin.longitude];
    navi.destination = [AMapGeoPoint locationWithLatitude:destination.latitude longitude:destination.longitude];
    
    [self.search AMapNavigationSearch:navi];
}


- (void)presentCurrentCourse
{
    NSArray *polylines = nil;
    
    /* 公交导航. */
    if (self.searchType == AMapSearchType_NaviBus)
    {
        polylines = [CommonUtility polylinesForTransit:self.route.transits[self.currentCourse]];
    }
    /* 步行，驾车导航. */
    else
    {
        polylines = [CommonUtility polylinesForPath:self.route.paths[self.currentCourse]];
    }
    
    [self.mapView addOverlays:polylines];
    
    /* 缩放地图使其适应polylines的展示. */
    //self.mapView.visibleMapRect = [CommonUtility mapRectForOverlays:polylines];
}

#pragma mark - MAMapViewDelegate

-(void) clearMapViewOverylays
{
    [self.mapView removeOverlays:self.mapView.overlays];
}

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineView *overlayView = [[MAPolylineView alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        
        overlayView.lineWidth   = 2;
        overlayView.strokeColor = [UIColor redColor];
        overlayView.lineDash = YES;
        
        return overlayView;
    }
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *overlayView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        overlayView.lineWidth   = 2;
        overlayView.strokeColor = [UIColor redColor];
        
        return overlayView;
    }
    
    return nil;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initPopoverAppearance];
	// Do any additional setup after loading the view.
    self.currentCourse = 0;
    [self initSearch];
    
    RococoAppDelegate *appInstance = (RococoAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appInstance.delegate = self;
    
    self.title = self.name;
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(mapOptions:)];
    self.navigationItem.rightBarButtonItem = item;
    
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.frame];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    MACoordinateRegion region;
    
    region.span.latitudeDelta = 0.05;
    region.span.longitudeDelta = 0.05;
    region.center = self.coordinate;
    
    [self.mapView setRegion:region];
    //[mapView setCameraDegree:22.0 animated:YES duration:1.0];
    //[mapView setRotationDegree:45 animated:YES duration:1.0];
    
    [self.view addSubview:self.mapView];
    
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
	annotation.coordinate = self.coordinate;
    annotation.title = self.address;
    annotation.subtitle =self.name;
    
    [self.mapView addAnnotation:annotation];
}



#pragma mark -- MAMapkit delegate method

-(MAAnnotationView *) mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    MAPinAnnotationView *pinView = nil;
    
    static NSString *pinIdentify = @"pinindetify";
    
    pinView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinIdentify];
    
    if (pinView == nil) {
        pinView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinIdentify];
        
        pinView.pinColor = MAPinAnnotationColorRed;
        pinView.canShowCallout = YES;
        pinView.animatesDrop = YES;
        
    }
    
    return pinView;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
