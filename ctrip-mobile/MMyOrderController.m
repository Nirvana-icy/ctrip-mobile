//
//  MMyOrderController.m
//  ctrip-mobile
//
//  Created by cao guangyao on 13-5-4.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import "MMyOrderController.h"
#import "OrderEntity.h"
#import <CoreData/CoreData.h>
#import "RococoAppDelegate.h"
#import "MOrderCell.h"
#import "UIAlertView+Blocks.h"
#import "Utility.h"
#import "MOrderDetailController.h"
#import "NSString+Category.h"
#import "Const.h"
@interface MMyOrderController ()

@property (nonatomic,retain) NSMutableArray *orderEntitys;
@end

@implementation MMyOrderController
@synthesize orderEntitys=_orderEntitys;

#pragma mark -- network delegate


-(void)setJSON:(id)json fromRequest:(NSURLRequest *)request
{
    NSURL *url = [request URL];
    NSString *path = [url path];
    NSDictionary *params =[[Utility sharedObject] getRequestParams:request];
    //get order id from url 
    NSString *orderID = [params valueForKey:@"order_id"];
    
    NSManagedObjectContext *context =[(RococoAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"OrderEntity" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSLog(@"@38,%@",path);
    
    if ([path isEqualToString:@"/api/group_order_list"]) {
        if ([json isKindOfClass:[NSDictionary class]]) {
            if ([json objectForKey:@"error_msg"]) {
                [[Utility sharedObject] setAlertView:@"" withMessage:[json valueForKey:@"error_msg"]];
                [fetchRequest release];
                return;
            }
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(orderID = %@)",orderID];
            
            [fetchRequest setPredicate:predicate];
            
            NSError *error;
            
            NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
            
            if ([objects count]==0) {
                NSLog(@"no matches");
            }
            else{
                OrderEntity *o = [objects objectAtIndex:0];
                
                o.orderStatus = [json valueForKey:@"status"];

                
                NSString *strURL = [NSString stringWithFormat:@"%@%@/?order_id=%@",API_BASE_URL,GROUP_QUERY_TICKETS_PARAMTER,o.orderID];
                
                [self.network httpJsonResponse:strURL byController:self];
            }
            
            
        }
    }
    else if([path isEqualToString:@"/api/group_query_tickets"]){
        if ([json isKindOfClass:[NSArray class]]) {
            NSArray *array = (NSArray *)json;
            NSDictionary *d = [array lastObject];
               NSString *orderID = [d valueForKey:@"order_id"];
                NSString *ticketID = [d valueForKey:@"ticket_number"];
                NSString *ticketPassword = [d valueForKey:@"ticket_pwd"];
                NSString *ticketExpirationDate = [d valueForKey:@"expiration_date"];
                NSString *ticketStatus = [d valueForKey:@"ticket_status"];
               
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(orderID=%@)",orderID];
                [fetchRequest setPredicate:predicate];
                
                NSError *error;
                NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
                
                if ([objects count] == 0) {
                    NSLog(@"no matches");
                }
                else{
                    OrderEntity *o = [objects objectAtIndex:0];
                    o.ticketID = ticketID;
                    o.ticketPassword = ticketPassword;
                    o.expirationDate = ticketExpirationDate;
                    o.orderStatus = ticketStatus;
                    
                }
            
        }
        else if ([json isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *d = (NSDictionary *)json;
            NSLog(@"@124,%@",d);
        }
        
        MOrderDetailController *controller =  [[[MOrderDetailController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
        controller.orderID = orderID;
        
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    NSError *error;
        
    if (![context save:&error]) {
        NSLog(@"error!");
    }else {
        NSLog(@"save order ok.");
    }
    [fetchRequest release];
}

#pragma mark -- load table view data

-(void)loadDataFromDB
{
    NSManagedObjectContext *context = [(RococoAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"OrderEntity" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSArray *results = [context executeFetchRequest:request error:nil];
    NSMutableArray *objects = [[[NSMutableArray alloc] init] autorelease];
    
    for (id object in results) {
        if ([object isKindOfClass:[OrderEntity class]]) {
            OrderEntity *o = (OrderEntity *)object;
            NSLog(@"@48,%@",o);
            [objects addObject:o];
        }
    }
    
    self.orderEntitys = [NSMutableArray arrayWithArray:objects];
    [request release];
    
    [self.tableView reloadData];
}

#pragma mark -- viewcontroller
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    // Remove table cell separator
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadDataFromDB];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.orderEntitys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSInteger row = [indexPath row];
    
    if (cell == nil) {
        cell = [[[MOrderCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        
    }
    
    OrderEntity *o = [self.orderEntitys objectAtIndex:row];
    
    //cell.textLabel.text = o.productName;
    //cell.detailTextLabel.text = o.orderStatus;
    
    UILabel *productLabel = [[[UILabel alloc] init] autorelease];
    
    productLabel.text = o.productName;
    
    productLabel.backgroundColor = [UIColor clearColor];
    
    productLabel.frame = CGRectMake(20, 15, 280, 20);
    
    [cell addSubview:productLabel];
    
    UILabel *statusLabel = [[[UILabel alloc] init] autorelease];
    
    statusLabel.text = o.orderStatus;
    
    statusLabel.backgroundColor = [UIColor clearColor];
    
    statusLabel.textColor = [UIColor grayColor];
    
    statusLabel.frame = CGRectMake(20, 40, 100, 20);
    
    [cell addSubview:statusLabel];
    
    UILabel *priceLabel = [[[UILabel alloc] init]autorelease];
    
    priceLabel.text = [NSString stringWithFormat:@"¥ %@",o.orderPrice];
    
    priceLabel.textColor = [UIColor orangeColor];
    
    priceLabel.backgroundColor= [UIColor clearColor];
    
    [priceLabel setFrame:CGRectMake(240, 40, 100, 20)];
    [cell addSubview:priceLabel];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;

    
    return cell;
}

- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [self tableView:[self tableView] numberOfRowsInSection:0];
    NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    
    if (rowIndex == 0) {
        background = [UIImage imageNamed:@"cell_top.png"];
    } else if (rowIndex == rowCount - 1) {
        background = [UIImage imageNamed:@"cell_bottom.png"];
    } else {
        background = [UIImage imageNamed:@"cell_middle.png"];
    }
    
    return background;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    OrderEntity *o = [self.orderEntitys objectAtIndex:row];
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSString *strToday = [formater stringFromDate:date];
    
    NSString *strURL = [NSString stringWithFormat:@"%@/group_order_list/?order_id=%@&begin_date=%@&end_date=%@",api_,o.orderID,strToday,strToday];
    
    
    [self.network httpJsonResponse:strURL byController:self];
}


@end
