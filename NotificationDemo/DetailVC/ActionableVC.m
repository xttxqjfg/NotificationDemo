//
//  ActionableVC.m
//  NotificationDemo
//
//  Created by 易博 on 2017/3/30.
//  Copyright © 2017年 易博. All rights reserved.
//

#import "ActionableVC.h"
#import <UserNotifications/UserNotifications.h>

#define sWidth self.view.frame.size.width

@interface ActionableVC ()

@end

@implementation ActionableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"事件";
    // Do any additional setup after loading the view.
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 70, sWidth - 40, 40)];
    label.text = @"发送一个带事件的通知";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(50, 120, sWidth - 100, 30)];
    [btn setTitle:@"发送" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)btnClicked
{
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
    content.body = @"这是一个带交互事件的通知";
    content.title = @"交互事件通知";
    content.categoryIdentifier = @"comment";
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:3 repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"actionable" content:content trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        //
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
