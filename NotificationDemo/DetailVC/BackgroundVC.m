//
//  BackgroundVC.m
//  NotificationDemo
//
//  Created by 易博 on 2017/3/29.
//  Copyright © 2017年 易博. All rights reserved.
//

#import "BackgroundVC.h"
#import <UserNotifications/UserNotifications.h>

#define sWidth self.view.frame.size.width

@interface BackgroundVC ()<UITextFieldDelegate>

@property(nonatomic,strong) UIButton *sendMsg;

@property(nonatomic,strong) UITextField *timeField;

//提示信息
@property(nonatomic,strong) UILabel *label2;

@end

@implementation BackgroundVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"BackGround";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.timeField];
    [self.view addSubview:self.sendMsg];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 184, sWidth - 40, 40)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"需要退到后台才能看到通知";
    [self.view addSubview:label1];
    
    [self.view addSubview:self.label2];
}

-(void)btnClicked
{
    //收起键盘
    [self.timeField resignFirstResponder];
    
    //判断文本框的值是否有效
    NSInteger timeValue = [self.timeField.text integerValue];
    if(timeValue > 0)
    {
        self.label2.text = @"";
        
        //创建通知
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
        content.title = @"iOS 10通知";
        content.body = @"这是一个iOS 10的消息通知...";
        
        //创建一个触发事件
        UNNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeValue repeats:NO];
        
        //设置通知的唯一标识
        NSString *requestIdentifer = @"timeInterval";
        
        //创建通知的请求
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (!error) {
                self.label2.text = error.localizedDescription;
            }
            else
            {
                self.label2.text = @"发送成功...";
            }
        }];
    }
    else
    {
        self.label2.text = @"输入的时间无效";
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(UILabel *)label2
{
    if (!_label2) {
        _label2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 234, sWidth - 40, 40)];
        _label2.text = @"";
        _label2.textAlignment = NSTextAlignmentCenter;
        _label2.textColor = [UIColor redColor];
    }
    return _label2;
}

-(UIButton *)sendMsg
{
    if (!_sendMsg) {
        _sendMsg = [[UIButton alloc]initWithFrame:CGRectMake(50, 124, sWidth - 100, 50)];
        [_sendMsg setTitle:@"Send" forState:UIControlStateNormal];
        [_sendMsg setBackgroundColor:[UIColor lightGrayColor]];
        [_sendMsg addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendMsg;
}

-(UITextField *)timeField
{
    if (!_timeField) {
        _timeField = [[UITextField alloc]initWithFrame:CGRectMake(30, 74, sWidth - 60, 30)];
        _timeField.placeholder = @"几秒之后发送通知，10秒以内";
        _timeField.backgroundColor = [UIColor lightGrayColor];
        _timeField.returnKeyType = UIReturnKeyDone;
        _timeField.delegate = self;
    }
    return _timeField;
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
