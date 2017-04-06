//
//  RootViewController.m
//  NotificationDemo
//
//  Created by 易博 on 2017/3/27.
//  Copyright © 2017年 易博. All rights reserved.
//

#import "RootViewController.h"
#import "AuthInfoVC.h"
#import "BackgroundVC.h"
#import "ForeGroundVC.h"
#import "ManagerNotificationVC.h"
#import "ActionableVC.h"
#import "MediaVC.h"
#import "CustomUIVC.h"

@interface RootViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *cellData;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"UserNotification";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:self.tableView];
}

-(void)jumpToPage:(NSInteger) row
{
    
    switch (row) {
        case 0:
        {
            BackgroundVC *backVC = [[BackgroundVC alloc]init];
            [self.navigationController pushViewController:backVC animated:YES];
            
            break;
        }
        case 1:
        {
            ForeGroundVC *foreVC = [[ForeGroundVC alloc]init];
            [self.navigationController pushViewController:foreVC animated:YES];
            
            break;
        }
        case 2:
        {
            ManagerNotificationVC *managerVC = [[ManagerNotificationVC alloc]init];
            [self.navigationController pushViewController:managerVC animated:YES];
            
            break;
        }
        case 3:
        {
            ActionableVC *actionVC = [[ActionableVC alloc]init];
            [self.navigationController pushViewController:actionVC animated:YES];
            
            break;
        }
        case 4:
        {
            MediaVC *mediaVC = [[MediaVC alloc]init];
            [self.navigationController pushViewController:mediaVC animated:YES];
            
            break;
        }
        case 5:
        {
            CustomUIVC *customVC = [[CustomUIVC alloc]init];
            [self.navigationController pushViewController:customVC animated:YES];
            
            break;
        }
        default:
            break;
    }
}

#pragma mark uitableview delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultIdentifier"];
    cell.textLabel.text = [[self.cellData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (0 == indexPath.section) {
        //直接跳转到认证信息页面
        
        AuthInfoVC *infoVC = [[AuthInfoVC alloc]init];
        [self.navigationController pushViewController:infoVC animated:YES];
    }
    else{
        [self jumpToPage:indexPath.row];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) {
        return [[self.cellData objectAtIndex:0] count];
    }
    return [[self.cellData objectAtIndex:1] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.cellData count];
}

//cell行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

//分组头高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

//分组尾高
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

//设置组标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return @"注册 & 配置";
    }
    return @"通知";
}


#pragma mark 懒加载
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(NSArray *)cellData
{
    if (!_cellData) {
        _cellData = @[@[@"注册信息"],@[@"通知-后台",
                                    @"通知-前台",
                                    @"通知管理",
                                    @"带事件",
                                    @"多媒体",
                                    @"自定义UI",]];
    }
    return _cellData;
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
