//
//  MItemDetailController.m
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-19.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import "MItemDetailController.h"
#import "MDetailCell.h"
#import "NSString+Category.h"
#import "MOrderCreateController.h"
//#import "MMapController.h"
#import "AMapController.h"
#import "TOrder.h"
#import "UIImageView+AFNetworking.h"
#import "Const.h"
#import <QuartzCore/QuartzCore.h>
#import "InsetsLabel.h"
#import "MDescriptionController.h"
@interface MItemDetailController ()

@property (nonatomic,strong)NSArray *cellHeightValues;
@end

@implementation MItemDetailController{
    
}

@synthesize detail =_detail;
@synthesize cellHeightValues = _cellHeightValues;



-(void)setJSON:(id)json fromRequest:(NSURLRequest *)request
{

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)orderProduct
{
    TOrder *order = [[TOrder alloc] init];
    order.productID = [ NSString stringWithFormat:@"%d",self.detail.productID];
    order.productName = self.detail.name;
    order.price = self.detail.price;
    
    MOrderCreateController *controller = [[MOrderCreateController alloc] initWithStyle:UITableViewStyleGrouped];
    
    controller.order = order;
    
    [self.navigationController pushViewController:controller animated:YES];
    
}
-(void)share
{
    NSString *shareURL = self.detail.oURL;
    NSArray *shareObjects = [NSArray arrayWithObjects:shareURL, nil];
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:shareObjects applicationActivities:nil];
    
    controller.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    
    [self presentViewController:controller animated:YES completion:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    // Add padding to the top of the table view
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.contentInset = inset;
    //back button
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
    
    self.navigationItem.backBarButtonItem = backButton;
    
    
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (systemVersion>6.0) {
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStyleBordered target:self action:@selector(share)];
        
        self.navigationItem.rightBarButtonItem = barItem;
    }
        
    
    
    
    self.title = @"酒店详情";//self.detail.name;
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark xlcycle delegate

-(NSInteger)numberOfPages
{
    return self.detail.imageDictList.count;
    //return self.detail.imageList.count ;
}

-(UIView *) pageAtIndex:(NSInteger)index
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 180)];
    
    NSDictionary *dict = [self.detail.imageDictList objectAtIndex:index];
    
    NSString *str = [NSString stringWithFormat:@"%@%d/?url=%@",THUMBNAIL_URL,THUMBNAIL_IMAGE_WIDTH,[(NSString *)[dict objectForKey:@"url"] URLEncode]];
    
    NSURL *url = [NSURL URLWithString:str];
    
    [imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    CALayer *layer = [imageView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:7.0];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    view.backgroundColor = [UIColor grayColor];
    [view addSubview:imageView];
   
    return view;
}

#pragma mark table view delegate and datasource



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    //return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    
    if (section ==1) {
        return 1;
    }
    
    if (section == 2) {
        return 3+3;
    }
    
    if (section == 3) {
        return self.detail.headDescList.count;
    }
    
    if (section == 4) {
        return self.detail.descList.count;
    }
    
    if (section == 5) {
        return self.detail.ruleDescList.count;
    }
    
   
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row  =[indexPath row];
    NSUInteger section =  [indexPath section];
    NSString *cellIdentify = [NSString stringWithFormat:@"cell%d%d",row,section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    

    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
        
        
        
        if (section == 0) {
            XLCycleScrollView *csView = [[XLCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 220)];
            csView.datasource =self;
            csView.delegate = self;
            csView.backgroundColor = [UIColor grayColor];
            [cell addSubview:csView];
        }
        
        if (section == 1) {
            cell.textLabel.text = self.detail.name;
        }
        
        
        if (section == 2) {
            switch (row) {
                case 0:
                    cell.textLabel.text = [NSString stringWithFormat:@"价格：¥ %@",self.detail.price];
                    cell.textLabel.textColor = [UIColor orangeColor];
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                case 1:
                    if (self.detail.address.length >0) {
                        cell.textLabel.text = [NSString stringWithFormat:@"地址：%@",self.detail.address];
                        
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    }
                    else
                    {
                        cell.textLabel.text = @"地址：- -";
                    }
                    break;
                case 2:
                    
                    if (self.detail.tel.length>0) {
                        cell.textLabel.text = [NSString stringWithFormat:@"电话：%@", self.detail.tel];
                        
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    }
                    else
                    {
                        cell.textLabel.text = @"电话：- -";
                    }
                    break;
                case 3:
                    cell.textLabel.text =@"描述";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                case 4:
                    cell.textLabel.text = @"包含项目";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                case 5:
                    cell.textLabel.text = @"特别提示";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                default:
                    break;
            }
        }
        
        
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger section = [indexPath section];
    if (section == 0) {
        return 220;
    }
    
    return 44;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    if (section == 2 && row == 1) {
        //address view
        AMapController *controller = [[AMapController alloc] init];
        
        controller.name = [NSString stringWithString:self.detail.name];
        controller.address = [NSString stringWithString:self.detail.address];
        controller.coordinate = self.detail.location;
        
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    
    if (section == 2 && row ==0) {
        [self orderProduct];
    }
    
    if (section == 2 && row == 2) {
        
        NSString *num = self.detail.tel;
        UIAlertView *alert =[ [UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"是否确认拨打：%@",num] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alert show];
        
        
    }
    
    NSArray *titleList = @[@"描述",@"包含项目",@"特别提示"];
    NSArray *descriptionList = @[self.detail.descList,self.detail.headDescList,self.detail.ruleDescList];
    
    if (section ==2 && row > 2) {
        MDescriptionController *controller = [[MDescriptionController alloc] initWithDescription:[descriptionList objectAtIndex:row-3]];
        
        controller.title = [titleList objectAtIndex:row-3];
        
        [self.navigationController pushViewController:controller animated:YES];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
    
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.detail.tel]]];
    }
}
@end
