//
//  NotificationHandle.h
//  NotificationDemo
//
//  Created by 易博 on 2017/3/31.
//  Copyright © 2017年 易博. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@interface NotificationHandle : NSObject<UNUserNotificationCenterDelegate>

+(NotificationHandle *) shareInstance;

-(void)registerNotificationCategory;

-(void)authorizationPushNotificaton:(UIApplication *)application;
@end
