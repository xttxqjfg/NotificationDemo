//
//  NotificationService.m
//  modify通知内容
//
//  Created by 易博 on 2017/3/30.
//  Copyright © 2017年 易博. All rights reserved.
//

#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
    
    if([self.bestAttemptContent.categoryIdentifier isEqualToString:@"modify"])
    {
        //修改消息内容
        self.bestAttemptContent.body = [NSString stringWithFormat:@"%@,modify by NotificationService",self.bestAttemptContent.body];
        self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
        
        self.contentHandler(self.bestAttemptContent);
    }
    else if([self.bestAttemptContent.categoryIdentifier isEqualToString:@"media"])
    {
        //多媒体通知，包括图片、音乐、视频
        NSString *mediaUrlStr = [self.bestAttemptContent.userInfo objectForKey:@"mediaUrl"];
        NSURL *mediaUrl = [[NSURL alloc]initWithString:mediaUrlStr];
        
        [self downloadAndSave:mediaUrl handler:^(NSURL *localUrl) {
            UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"attachment" URL:localUrl options:nil error:nil];
            self.bestAttemptContent.attachments = @[attachment];
            self.contentHandler(self.bestAttemptContent);
        }];
    }
    else
    {
        self.contentHandler(self.bestAttemptContent);
    }
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


- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
