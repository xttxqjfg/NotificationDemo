//
//  AuthInfoVC.m
//  NotificationDemo
//
//  Created by 易博 on 2017/3/27.
//  Copyright © 2017年 易博. All rights reserved.
//

#import "AuthInfoVC.h"
#import <UserNotifications/UserNotifications.h>

@interface AuthInfoVC ()
//device token
@property (nonatomic,strong) UILabel *deviceTokenLabel;
//Sound
@property (nonatomic,strong) UILabel *soundLabel;
//Badge
@property (nonatomic,strong) UILabel *badgeLabel;
//alert
@property (nonatomic,strong) UILabel *alertLabel;
//car play
@property (nonatomic,strong) UILabel *carPlayLabel;
//alert style
@property (nonatomic,strong) UILabel *alertStyleLabel;
//look screen
@property (nonatomic,strong) UILabel *lockScreenLabel;
//center
@property (nonatomic,strong) UILabel *centerLabel;

@end

@implementation AuthInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = @"Auth";
    
    [self setUpUI];
    
    [self setData];
}

-(void)setData
{
    self.deviceTokenLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    __weak typeof(&*self) weakSelf = self;
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        weakSelf.centerLabel.text = [weakSelf getSettingDescribe:settings.notificationCenterSetting];
        weakSelf.soundLabel.text = [weakSelf getSettingDescribe:settings.soundSetting];
        weakSelf.badgeLabel.text = [weakSelf getSettingDescribe:settings.badgeSetting];
        weakSelf.lockScreenLabel.text = [weakSelf getSettingDescribe:settings.lockScreenSetting];
        weakSelf.alertLabel.text = [weakSelf getSettingDescribe:settings.alertSetting];
        weakSelf.carPlayLabel.text = [weakSelf getSettingDescribe:settings.carPlaySetting];
        weakSelf.alertStyleLabel.text = [weakSelf getAlertStyleDescribe:settings.alertStyle];
    }];
}

-(NSString *)getAlertStyleDescribe:(NSInteger)alertStyle
{
    NSString *backStr = @"";
    switch (alertStyle) {
        case 0:
            backStr = @"UNAlertStyleNone";
            break;
        case 1:
            backStr = @"UNAlertStyleBanner";
            break;
        case 2:
            backStr = @"UNAlertStyleAlert";
            break;
        default:
            backStr = @"UNKNOW";
            break;
    }
    return backStr;
}

-(NSString *)getSettingDescribe:(NSInteger)setting
{
    NSString *backStr = @"";
    switch (setting) {
        case 0:
            backStr = @"NotSupported";
            break;
        case 1:
            backStr = @"Disabled";
            break;
        case 2:
            backStr = @"Enabled";
            break;
        default:
            backStr = @"UNKNOW";
            break;
    }
    return backStr;
}

-(void)setUpUI
{
    CGFloat sWidth = self.view.frame.size.width;
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, sWidth, 30)];
    label1.text = @"Device Token";
    label1.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label1];
    
    self.deviceTokenLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label1.frame), sWidth, 60)];
    self.deviceTokenLabel.textAlignment = NSTextAlignmentCenter;
    self.deviceTokenLabel.numberOfLines = 2;
    [self.view addSubview:self.deviceTokenLabel];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.deviceTokenLabel.frame), sWidth, 30)];
    label2.text = @"UNNotificationSettings";
    label2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label2];
    
    //center
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(label2.frame), sWidth / 3 - 20, 30)];
    label3.text = @"center";
    label3.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:label3];
    
    self.centerLabel = [[UILabel alloc]initWithFrame:CGRectMake(sWidth / 3, CGRectGetMaxY(label2.frame), sWidth * 0.65 - 20, 30)];
    self.centerLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.centerLabel];
    
    //sound
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(label3.frame), sWidth / 3 - 20, 30)];
    label4.text = @"Sound";
    label4.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:label4];
    
    self.soundLabel = [[UILabel alloc]initWithFrame:CGRectMake(sWidth / 3, CGRectGetMaxY(label3.frame), sWidth * 0.65 - 20, 30)];
    self.soundLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.soundLabel];
    
    //badge
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(label4.frame), sWidth / 3 - 20, 30)];
    label5.text = @"badge";
    label5.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:label5];
    
    self.badgeLabel = [[UILabel alloc]initWithFrame:CGRectMake(sWidth / 3, CGRectGetMaxY(label4.frame), sWidth * 0.65 - 20, 30)];
    self.badgeLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.badgeLabel];
    
    //alert
    UILabel *label6 = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(label5.frame), sWidth / 3 - 20, 30)];
    label6.text = @"alert";
    label6.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:label6];
    
    self.alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(sWidth / 3, CGRectGetMaxY(label5.frame), sWidth * 0.65 - 20, 30)];
    self.alertLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.alertLabel];
    
    //car play
    UILabel *label7 = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(label6.frame), sWidth / 3 - 20, 30)];
    label7.text = @"car play";
    label7.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:label7];
    
    self.carPlayLabel = [[UILabel alloc]initWithFrame:CGRectMake(sWidth / 3, CGRectGetMaxY(label6.frame), sWidth * 0.65 - 20, 30)];
    self.carPlayLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.carPlayLabel];
    
    //alert style
    UILabel *label8 = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(label7.frame), sWidth / 3 - 20, 30)];
    label8.text = @"alert style";
    label8.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:label8];
    
    self.alertStyleLabel = [[UILabel alloc]initWithFrame:CGRectMake(sWidth / 3, CGRectGetMaxY(label7.frame), sWidth * 0.65 - 20, 30)];
    self.alertStyleLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.alertStyleLabel];
    
    //look screen
    UILabel *label9 = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(label8.frame), sWidth / 3 - 20, 30)];
    label9.text = @"lock screen";
    label9.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:label9];
    
    self.lockScreenLabel = [[UILabel alloc]initWithFrame:CGRectMake(sWidth / 3, CGRectGetMaxY(label8.frame), sWidth * 0.65 - 20, 30)];
    self.lockScreenLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.lockScreenLabel];
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
