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

@interface AMapController ()<WYPopoverControllerDelegate,MUserLocation>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong)WYPopoverController *popoverViewController;
@property (nonatomic) AMapSearchType searchType;
@property (nonatomic, strong) AMapRoute *route;
@property (nonatomic) NSInteger currentCourse;
@end

@implementation AMapController

@synthesize popoverViewController = _popoverViewController;
@synthesize mapView = _mapView;
//@synthesize searchType = _searchType;
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

-(void)userLocationUpdated:(CLLocation *)location
{
    
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
    self.mapView.visibleMapRect = [CommonUtility mapRectForOverlays:polylines];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.currentCourse = 0;
    
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
