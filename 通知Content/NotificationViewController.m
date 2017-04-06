//
//  NotificationViewController.m
//  通知Content
//
//  Created by 易博 on 2017/3/30.
//  Copyright © 2017年 易博. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>
#import "NotificationItem.h"


@interface NotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,strong) NSMutableArray *itemArr;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
}

//收到远程消息
- (void)didReceiveNotification:(UNNotification *)notification {
    
    UNNotificationContent *content = notification.request.content;
    //获取通知中发过来的需要展示的内容
    NSMutableArray *imageArr = [[NSMutableArray alloc]initWithArray:[content.userInfo objectForKey:@"items"]];
    
    self.itemArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < imageArr.count; i++) {
        //创建数据模型，包含url、title、text三个属性
        NotificationItem *item = [[NotificationItem alloc]init];
        if (i > content.attachments.count - 1) {
            continue;
        }
        
        item.title = [[imageArr objectAtIndex:i] objectForKey:@"title"];
        item.text = [[imageArr objectAtIndex:i] objectForKey:@"text"];
        item.url = [[NSURL alloc] initWithString:[[imageArr objectAtIndex:i] objectForKey:@"imageUrl"]];
        [self.itemArr addObject:item];
    }
    [self uploadUI:0];
}

//更新界面
-(void)uploadUI:(NSInteger)index
{
    NotificationItem *item = [self.itemArr objectAtIndex:index];
    
    //用sd_webimage来获取远程图片
    [self.imageView sd_setImageWithURL:item.url placeholderImage:[UIImage imageNamed:@"11"]];
    self.label.text = item.title;
    self.textView.text = item.text;
    
    self.index = index;
}

//交互事件的获取
-(void)didReceiveNotificationResponse:(UNNotificationResponse *)response completionHandler:(void (^)(UNNotificationContentExtensionResponseOption))completion
{
    //用户点击了切换
    if ([response.actionIdentifier isEqualToString:@"switch"]) {
        if (0 == self.index) {
            self.index = 1;
        }
        else
        {
            self.index = 0;
        }
        [self uploadUI:self.index];
        completion(UNNotificationContentExtensionResponseOptionDoNotDismiss);
    }
    else if ([response.actionIdentifier isEqualToString:@"open"])
    {
        completion(UNNotificationContentExtensionResponseOptionDismissAndForwardAction);
    }
    else if ([response.actionIdentifier isEqualToString:@"cancle"])
    {
        completion(UNNotificationContentExtensionResponseOptionDismiss);
    }
    else
    {
        completion(UNNotificationContentExtensionResponseOptionDismissAndForwardAction);
    }
}

@end
