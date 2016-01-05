//
//  MyRedPacketView.m
//  DaDangJia
//
//  Created by Seven on 15/9/9.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "MyRedPacketView.h"
#import "MyRedPacket.h"
#import "MyRedPactetCell.h"
#import "UIImageView+WebCache.h"

@interface MyRedPacketView ()
{
    UserInfo *userInfo;
    double totalMoney;
}

@end

@implementation MyRedPacketView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的红包";
    
    totalMoney = 0.00;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    //    设置无分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableHeaderView = self.headerView;
    
    userInfo = [[UserModel Instance] getUserInfo];
    
    self.faceIv.layer.masksToBounds=YES;
    self.faceIv.layer.cornerRadius = self.faceIv.frame.size.width/2;
    [self.faceIv sd_setImageWithURL:[NSURL URLWithString:userInfo.photoFull] placeholderImage:[UIImage imageNamed:@"default_head.png"]];
    
    self.nickNameLb.text = userInfo.nickName;
    self.userInfoLb.text = userInfo.mobileNo;
    self.integralLb.text = [NSString stringWithFormat:@"%d", [userInfo.integral intValue]];
    
    [self getRedPacket];
}

- (void)getRedPacket
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        
        //生成获取新闻列表URL
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:userInfo.regUserId forKey:@"regUserId"];
        [param setValue:@"1" forKey:@"pageNumbers"];
        [param setValue:@"999" forKey:@"countPerPages"];
        NSString *getMyRedPacketListUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findRhUserRedpackageByUserId] params:param];
        
        [[AFOSCClient sharedClient]getPath:getMyRedPacketListUrl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       
                                       NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                                       NSError *error;
                                       NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                       
                                       NSArray *resultsList = [[json objectForKey:@"data"] objectForKey:@"resultsList"];
                                       
                                       @try {
                                           redPackets = [NSMutableArray arrayWithArray:[Tool readJsonToObjArray:resultsList andObjClass:[MyRedPacket class]]];
                                           for (MyRedPacket *r in redPackets) {
                                               r.getTimeStr = [Tool TimestampToDateStr:[r.getTimeStamp stringValue] andFormatterStr:@"yyyy-MM-dd HH:mm"];
                                               r.useTimeStr = [Tool TimestampToDateStr:[r.useTimeStamp stringValue] andFormatterStr:@"yyyy-MM-dd HH:mm"];
                                               if (r.stateId == 0) {
                                                   totalMoney += r.money;
                                               }
                                           }
                                           self.integralLb.text = [NSString stringWithFormat:@"%.2f元", totalMoney];
                                           
                                           [self.tableView reloadData];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                       }
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       NSLog(@"列表获取出错");
                                       
                                       if ([UserModel Instance].isNetworkRunning == NO) {
                                           return;
                                       }
                                       if ([UserModel Instance].isNetworkRunning) {
                                           [Tool showCustomHUD:@"网络不给力" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
                                       }
                                   }];
    }
}

#pragma TableView的处理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return redPackets.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 114.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    cell.backgroundColor = [Tool getBackgroundColor];
}

//列表数据渲染
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    MyRedPactetCell *cell = [tableView dequeueReusableCellWithIdentifier:MyRedPactetCellIdentifier];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"MyRedPactetCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[MyRedPactetCell class]]) {
                cell = (MyRedPactetCell *)o;
                break;
            }
        }
    }
    MyRedPacket *i = [redPackets objectAtIndex:row];
    cell.moneyLb.text = [NSString stringWithFormat:@"%.2f元红包金额", i.money];
    
    cell.stateLb.layer.masksToBounds=YES;
    cell.stateLb.layer.cornerRadius = cell.stateLb.frame.size.height/2;
    if (i.stateId == 0) {
        cell.stateLb.text = @"已领取";
        [cell.stateLb setBackgroundColor:[UIColor colorWithRed:0.51 green:0.73 blue:0.4 alpha:1]];
    }
    else
    {
        cell.stateLb.text = @"已使用";
        [cell.stateLb setBackgroundColor:[UIColor colorWithRed:0.93 green:0.35 blue:0.42 alpha:1]];
    }
    
    if ([i.getTimeStamp longValue] == 0) {
        cell.getTimeLb.hidden = YES;
    }
    else
    {
        cell.getTimeLb.text = [NSString stringWithFormat:@"领取时间:%@", i.getTimeStr];
        cell.getTimeLb.hidden = NO;
    }
    if ([i.useTimeStamp longValue] == 0) {
        cell.useTimeLb.hidden = YES;
    }
    else
    {
        cell.useTimeLb.text = [NSString stringWithFormat:@"使用时间:%@", i.useTimeStr];
        cell.useTimeLb.hidden = NO;
    }
    
    return cell;
}

//表格行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

@end
