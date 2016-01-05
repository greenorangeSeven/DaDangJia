//
//  MyPublicClassView.m
//  DaDangJia
//
//  Created by Seven on 15/9/16.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "MyPublicClassView.h"
#import "TopicClass.h"
#import "MyPublicClassCell.h"
#import "MyPublicView.h"
#import "UIImageView+WebCache.h"

@interface MyPublicClassView ()
{
    UserInfo *userInfo;
    NSMutableArray *classes;
}

@end

@implementation MyPublicClassView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的发布";
    
    userInfo = [[UserModel Instance] getUserInfo];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    //    设置无分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self getClassType];
}

- (void)getClassType
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        
        //生成获取新闻列表URL
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:userInfo.regUserId forKey:@"regUserId"];
        NSString *getUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findAllTopicType] params:nil];
        
        [[AFOSCClient sharedClient]getPath:getUrl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       
                                       NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                                       NSError *error;
                                       NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                       
                                       NSArray *resultsList = [json objectForKey:@"data"];
                                       
                                       @try {
                                           classes = [NSMutableArray arrayWithArray:[Tool readJsonToObjArray:resultsList andObjClass:[TopicClass class]]];
                                           
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
    return classes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 139.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    cell.backgroundColor = [Tool getBackgroundColor];
}

//列表数据渲染
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    
    MyPublicClassCell *cell = [tableView dequeueReusableCellWithIdentifier:MyPublicClassCellIdentifier];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"MyPublicClassCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[MyPublicClassCell class]]) {
                cell = (MyPublicClassCell *)o;
                break;
            }
        }
    }
    TopicClass *c = [classes objectAtIndex:row];
    cell.typeNameLb.text = c.typeName;
    [cell.imgIv sd_setImageWithURL:[NSURL URLWithString:c.typeImgFull] placeholderImage:[UIImage imageNamed:@"loadpic.png"]];
    return cell;
}

//表格行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TopicClass *c = [classes objectAtIndex:[indexPath row]];
    MyPublicView *myPublic = [[MyPublicView alloc] init];
    myPublic.typeId = [NSString stringWithFormat:@"%d", c.typeId];
    myPublic.typeName = c.typeName;
    [self.navigationController pushViewController:myPublic animated:YES];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.hidden = NO;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
}

@end
