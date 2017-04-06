//
//  MediaVC.m
//  NotificationDemo
//
//  Created by 易博 on 2017/3/30.
//  Copyright © 2017年 易博. All rights reserved.
//

#import "MediaVC.h"
#import <UserNotifications/UserNotifications.h>

#define sWidth self.view.frame.size.width

@interface MediaVC ()

@end

@implementation MediaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"多媒体";
    // Do any additional setup after loading the view.
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 70, sWidth - 40, 40)];
    label.text = @"发送一个多媒体的通知";
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
    content.body = @"显示一个图片";
    
    //需要显示多个图片就需要用到自定义的UI
    
    NSString *imageUrlStr = @"http://172.20.90.117/www2/img/taishan.mp4";
    
    [self downloadAndSave:[[NSURL alloc] initWithString:imageUrlStr] handler:^(NSURL *localUrl) {
        
        UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"attachment" URL:localUrl options:nil error:nil];
        
        content.attachments = @[attachment];
        
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
        NSString *identifier = @"media";
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            //
        }];
    }];
}

-(void)downloadAndSave:(NSURL *)url handler: (void (^)(NSURL *localUrl)) handler
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // location是沙盒中tmp文件夹下的一个临时url,文件下载后会存到这个位置,
        //由于tmp中的文件随时可能被删除,所以我们需要自己需要把下载的文件挪到需要的地方
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        // 剪切文件
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:path] error:nil];
        handler([NSURL fileURLWithPath:path]);
    }];
    [task resume];
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
