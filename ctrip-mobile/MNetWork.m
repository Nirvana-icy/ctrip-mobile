//
//  MNetWork.m
//  ctrip-mobile
//
//  Created by caoguangyao on 13-4-19.
//  Copyright (c) 2013年 caoguangyao. All rights reserved.
//

#import "MNetWork.h"
#import "Pods/AFNetworking/AFNetworking/AFNetworking.h"
#import "Pods/AFNetworking/UIKit+AFNetworking/AFNetworkActivityIndicatorManager.h"
#import "UIAlertView+Blocks.h"

@implementation MNetWork

@synthesize delegate=_delegate;

#pragma mark -- mbprogresshud delegate

-(void) hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
	hud = nil;
}

-(void) showHUD:(MBProgressHUD *)hud
{
    [hud setLabelText:@"请稍后"];
    
    [hud setDetailsLabelText:@"正在读取数据..."];
    
    [hud setSquare:YES];
    
    [hud show:YES];
}

-(void)httpJsonResponse:(NSString *)str byController:(UIViewController *)controller
{
    NSLog(@"@28,%@",str);
    
    NSURL *url = [NSURL URLWithString:str];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFNetworkActivityIndicatorManager *indicatorManger = [AFNetworkActivityIndicatorManager sharedManager];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:controller.view];
    
    [controller.view addSubview:hud];
    
    [hud setDelegate:self];
    
    [self showHUD:hud];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //[manager setResponseSerializer:[AFJSONRequestSerializer new]];
    
    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [indicatorManger setEnabled:NO];
        
        [hud hide:YES];
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        [self.delegate setJSON:responseObject fromRequest:request];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed:@25,%@",[error localizedDescription]);
        
        [indicatorManger setEnabled:NO];
        
        [hud hide:YES];
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        
        RIButtonItem *retryButton = [RIButtonItem item];
        retryButton.label =@"重试";
        retryButton.action = ^{
            [self httpJsonResponse:str byController:controller];
        };
        
        RIButtonItem *cancelButton = [RIButtonItem itemWithLabel:@"取消"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"发生异常，请检查网络连接，让后重试。" cancelButtonItem:cancelButton otherButtonItems:retryButton, nil];
        [alert show];
        
    }];
    /*
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [indicatorManger setEnabled:NO];
        
        [hud hide:YES];
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        [self.delegate setJSON:JSON fromRequest:request];
        //[self.delegate setJson:JSON];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"Failed:@25,%@",[error localizedDescription]);
        
        [indicatorManger setEnabled:NO];
        
        [hud hide:YES];
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        
        RIButtonItem *retryButton = [RIButtonItem item];
        retryButton.label =@"重试";
        retryButton.action = ^{
            [self httpJsonResponse:str byController:controller];
        };
        
        RIButtonItem *cancelButton = [RIButtonItem itemWithLabel:@"取消"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"发生异常，请检查网络连接，让后重试。" cancelButtonItem:cancelButton otherButtonItems:retryButton, nil];
        [alert show];
        
        
        
    }];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
     */
    
    [indicatorManger setEnabled:YES];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    //[op start];
    
}



@end
