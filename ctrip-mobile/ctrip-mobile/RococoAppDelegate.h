//
//  RococoAppDelegate.h
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-11.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MWindow.h"
#import "MNetWork.h"
#import <CoreData/CoreData.h>
#import "MNavigationController.h"
#import "MUserLocation.h"

@class MItemListController;
@class SWRevealViewController;


@interface RococoAppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,jsonDelegate>
{
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}


@property (strong, nonatomic) MWindow *window;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MItemListController *viewController;
@property (strong, nonatomic) SWRevealViewController *swRevealViewController;
@property (strong, nonatomic) MNetWork *network;
@property (nonatomic,strong) MNavigationController *nav;


@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong,nonatomic) NSObject<MUserLocation>* delegate;


- (NSString *)applicationDocumentsDirectory;
- (void)saveContext;

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;
@end
