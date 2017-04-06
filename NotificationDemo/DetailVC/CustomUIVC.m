//
//  CustomUIVC.m
//  NotificationDemo
//
//  Created by 易博 on 2017/3/30.
//  Copyright © 2017年 易博. All rights reserved.
//

#import "CustomUIVC.h"
#import <UserNotifications/UserNotifications.h>

#define sWidth self.view.frame.size.width

@interface CustomUIVC ()

@end

@implementation CustomUIVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"自定义";
    // Do any additional setup after loading the view.
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 70, sWidth - 40, 40)];
    label.text = @"发送一个自定义UI的通知";
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
    content.title = @"多媒体通知";
    content.body = @"显示多张图片";
    
    content.userInfo = @{@"items":@[@{@"title":@"奥迪1",@"text":@"奥迪R8",@"imageUrl":@"http://172.20.90.117/www2/img/r8.jpg"},
                                    @{@"title":@"奥迪2",@"text":@"奥迪超跑",@"imageUrl":@"http://172.20.90.117/www2/img/r8-1.jpg"}]};
    
    content.categoryIdentifier = @"customUI";
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
    NSString *indentifier = @"customUI";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:indentifier content:content trigger:trigger];
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
