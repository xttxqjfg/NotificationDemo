//
//  ManagerNotificationVC.m
//  NotificationDemo
//
//  Created by 易博 on 2017/3/29.
//  Copyright © 2017年 易博. All rights reserved.
//

#import "ManagerNotificationVC.h"
#import <UserNotifications/UserNotifications.h>

#define sWidth self.view.frame.size.width

@interface ManagerNotificationVC ()

@end

@implementation ManagerNotificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Manager";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    UILabel *labelTop = [[UILabel alloc]initWithFrame:CGRectMake(20, 70, sWidth - 40, 45)];
    labelTop.text = @"按下按钮之后可以下滑，打开通知页面查看效果";
    labelTop.textColor = [UIColor redColor];
    labelTop.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:labelTop];
    
    //发送然后取消
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 120, sWidth - 40, 60)];
    label1.text = @"发送&取消\n发送一个消息之后，在没有到达之前取消";
    label1.textAlignment = NSTextAlignmentLeft;
    label1.numberOfLines = 2;
    [self.view addSubview:label1];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(50, 190, sWidth - 100, 30)];
    [btn1 setTitle:@"发送&取消" forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[UIColor lightGrayColor]];
    btn1.tag = 1001;
    [btn1 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    //发送然后修改
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 230, sWidth - 40, 60)];
    label2.text = @"发送&修改\n发送一个消息之后，在没有到达之前修改消息内容";
    label2.textAlignment = NSTextAlignmentLeft;
    label2.numberOfLines = 2;
    [self.view addSubview:label2];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(50, 300, sWidth - 100, 30)];
    [btn2 setTitle:@"发送&修改" forState:UIControlStateNormal];
    [btn2 setBackgroundColor:[UIColor lightGrayColor]];
    btn2.tag = 1002;
    [btn2 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    //发送然后删除
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 340, sWidth - 40, 60)];
    label3.text = @"发送&删除\n发送一个消息之后，在到达之后删除";
    label3.textAlignment = NSTextAlignmentLeft;
    label3.numberOfLines = 2;
    [self.view addSubview:label3];
    
    UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(50, 410, sWidth - 100, 30)];
    [btn3 setTitle:@"发送&删除" forState:UIControlStateNormal];
    [btn3 setBackgroundColor:[UIColor lightGrayColor]];
    btn3.tag = 1003;
    [btn3 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    //发送然后修改
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(20, 450, sWidth - 40, 60)];
    label4.text = @"发送&修改\n发送一个消息之后，在到达之后修改";
    label4.textAlignment = NSTextAlignmentLeft;
    label4.numberOfLines = 2;
    [self.view addSubview:label4];
    
    UIButton *btn4 = [[UIButton alloc]initWithFrame:CGRectMake(50, 520, sWidth - 100, 30)];
    [btn4 setTitle:@"发送&修改" forState:UIControlStateNormal];
    [btn4 setBackgroundColor:[UIColor lightGrayColor]];
    btn4.tag = 1004;
    [btn4 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
}

-(void)btnClicked:(UIButton *)sender
{
    //创建两个用于测试的消息体
    UNMutableNotificationContent *content1 = [[UNMutableNotificationContent alloc]init];
    content1.title = @"1";
    content1.body = @"通知1";
    
    UNMutableNotificationContent *content2 = [[UNMutableNotificationContent alloc]init];
    content2.title = @"2";
    content2.body = @"通知2";
    
    switch (sender.tag) {
        case 1001:
        {
            //发送  取消
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
            NSString *identifier = @"pendingRemoval";
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content1 trigger:trigger];
            
            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                //
            }];
            
            //延迟2秒之后执行
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[identifier]];
            });
            break;
        }
        case 1002:
        {
            //发送  更新
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
            NSString *identifier = @"pendingUpdate";
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content1 trigger:trigger];
            
            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                //
            }];
            
            //延迟2秒之后执行
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                //用相同的标识再次发送即可覆盖
                UNTimeIntervalNotificationTrigger *triggerNew = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:3 repeats:NO];
                
                UNNotificationRequest *requestNew = [UNNotificationRequest requestWithIdentifier:identifier content:content2 trigger:triggerNew];
                
                [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:requestNew withCompletionHandler:^(NSError * _Nullable error) {
                    //
                }];
            });

            break;
        }
        case 1003:
        {
            //发送  删除
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:3 repeats:NO];
            NSString *identifier = @"deliveredRemoval";
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content1 trigger:trigger];
            
            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                //
            }];
            
            //延迟4秒之后执行
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:@[identifier]];
            });
            
            break;
        }
        case 1004:
        {
            //发送 修改
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:3 repeats:NO];
            NSString *identifier = @"deliveredUpdate";
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content1 trigger:trigger];
            
            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                //
            }];
            
            //延迟4秒之后执行
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0/*延迟执行时间*/ * NSEC_PER_SEC));
            
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                //用相同的标识再次发送即可覆盖
                UNTimeIntervalNotificationTrigger *triggerNew = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:3 repeats:NO];
                
                UNNotificationRequest *requestNew = [UNNotificationRequest requestWithIdentifier:identifier content:content2 trigger:triggerNew];
                
                [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:requestNew withCompletionHandler:^(NSError * _Nullable error) {
                    //
                }];
                
            });
            break;
        }

        default:
            break;
    }
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
