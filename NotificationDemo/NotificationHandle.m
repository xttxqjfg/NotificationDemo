//
//  NotificationHandle.m
//  NotificationDemo
//
//  Created by 易博 on 2017/3/31.
//  Copyright © 2017年 易博. All rights reserved.
//

#import "NotificationHandle.h"

@implementation NotificationHandle

+(NotificationHandle *) shareInstance
{
    static NotificationHandle *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

//注册通知中的action事件
-(void)registerNotificationCategory
{
    //带评论的通知事件注册
    UNTextInputNotificationAction *inputAction = [UNTextInputNotificationAction actionWithIdentifier:@"input" title:@"评论" options:UNNotificationActionOptionForeground textInputButtonTitle:@"发送" textInputPlaceholder:@"请输入评论内容.."];
    UNNotificationAction *openAction = [UNNotificationAction actionWithIdentifier:@"open" title:@"打开" options:UNNotificationActionOptionForeground];
    UNNotificationAction *cancleAction = [UNNotificationAction actionWithIdentifier:@"cancle" title:@"取消" options:UNNotificationActionOptionDestructive];
    
    UNNotificationCategory *tapCategory = [UNNotificationCategory categoryWithIdentifier:@"comment" actions:@[inputAction,openAction,cancleAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    
    //自定义UI通知的时间注册
    UNNotificationAction *nextAction = [UNNotificationAction actionWithIdentifier:@"switch" title:@"切换" options:UNNotificationActionOptionAuthenticationRequired];
    UNNotificationCategory *customCategory = [UNNotificationCategory categoryWithIdentifier:@"customUI" actions:@[nextAction,openAction,cancleAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
    
    //
    NSSet *set = [[NSSet alloc]initWithObjects:tapCategory, customCategory, nil];
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:set];
}

-(void)authorizationPushNotificaton:(UIApplication *)application
{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self; //必须写代理
    [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay completionHandler:^(BOOL granted, NSError * _Nullable error) {
        //注册之后的回调
        if (!error && granted) {
            NSLog(@"注册成功...");
        }
        else{
            NSLog(@"注册失败...");
        }
    }];
    
    //获取注册之后的权限设置
    //之前注册推送服务，用户点击了同意还是不同意，以及用户之后又做了怎样的更改我们都无从得知，现在 apple 开放了这个 API，我们可以直接获取到用户的设定信息了。注意UNNotificationSettings是只读对象哦，不能直接修改！
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        NSLog(@"通知配置信息:\n%@",settings);
    }];
    
    //注册通知获取token
    [application registerForRemoteNotifications];
}

#pragma mark UNUserNotificationCenterDelegate
//app处于前台是接收到通知
//只会是app处于前台状态下才会走，后台模式下是不会走这里的
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    //收到推送的请求
    UNNotificationRequest *request = notification.request;
    
    //收到的内容
    UNNotificationContent *content = request.content;
    
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    
    //收到消息的角标
    NSNumber *badge = content.badge;
    
    //收到消息的body
    NSString *body = content.body;
    
    //收到消息的声音
    UNNotificationSound *sound = content.sound;
    
    //推送消息的副标题
    NSString *subtitle = content.subtitle;
    
    //推送消息的标题
    NSString *title = content.title;
    
    if ([notification.request.trigger isKindOfClass:[UNNotificationTrigger class]]) {
        NSLog(@"前台收到通知:%@\n",userInfo);
    }
    else{
        NSLog(@"前台收到通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@}",body,title,subtitle,badge,sound,userInfo);
    }
    //不管前台后台状态下。推送消息的横幅都可以展示出来！有Badge、Sound、Alert三种类型可以设置
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}


//app通知的点击事件
//只会是用户点击消息才会触发，如果使用户长按（3DTouch）、Action等并不会触发
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    //收到推送的请求
    UNNotificationRequest *request = response.notification.request;
    
    //收到的内容
    UNNotificationContent *content = request.content;
    
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    
    //收到消息的角标
    NSNumber *badge = content.badge;
    
    //收到消息的body
    NSString *body = content.body;
    
    //收到消息的声音
    UNNotificationSound *sound = content.sound;
    
    //推送消息的副标题
    NSString *subtitle = content.subtitle;
    
    //推送消息的标题
    NSString *title = content.title;
    
    if ([response.notification.request.trigger isKindOfClass:[UNNotificationTrigger class]]) {
        NSLog(@"点击了通知:%@\n",userInfo);
    }
    else{
        NSLog(@"通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@}",body,title,subtitle,badge,sound,userInfo);
    }
    
    //处理消息的事件
    NSString *category = content.categoryIdentifier;
    if ([category isEqualToString:@"comment"]) {
        [self handCommnet:response];
    }
    else if ([category isEqualToString:@"customUI"])
    {
        [self handCustomUI:response];
    }
    
    completionHandler();
}

-(void)handCommnet:(UNNotificationResponse *)response
{
    NSString *actionType = response.actionIdentifier;
    NSString *textStr = @"";
    
    if ([actionType isEqualToString:@"input"]) {
        UNTextInputNotificationResponse *temp = (UNTextInputNotificationResponse *)response;
        textStr = temp.userText;
    }
    else if ([actionType isEqualToString:@"open"])
    {
        textStr = @"open";
    }
    else if ([actionType isEqualToString:@"cancle"])
    {
        textStr = @"";
    }
    
    NSLog(@"你刚输入的内容是:%@",textStr);
}

-(void)handCustomUI:(UNNotificationResponse *)response
{
    NSLog(@"操作是:%@",response.actionIdentifier);
}

@end
