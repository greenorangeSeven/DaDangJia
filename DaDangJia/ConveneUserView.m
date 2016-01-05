//
//  ConveneUserView.m
//  DaDangJia
//
//  Created by Seven on 15/9/20.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "ConveneUserView.h"
#import "ConveneUserCell.h"
#import "TopicUserJoin.h"

@interface ConveneUserView ()
{
    UIWebView *phoneWebView;
}

@end

@implementation ConveneUserView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"参与人";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma TableView的处理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.users.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    cell.backgroundColor = [Tool getBackgroundColor];
}

//列表数据渲染
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConveneUserCell *cell = [tableView dequeueReusableCellWithIdentifier:ConveneUserCellIdentifier];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"ConveneUserCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[ConveneUserCell class]]) {
                cell = (ConveneUserCell *)o;
                break;
            }
        }
    }
    NSInteger row = [indexPath row];
    TopicUserJoin *user = [self.users objectAtIndex:row];
    cell.userNameLb.text = user.regUserName;
    [cell.phoneBtn setTitle:user.mobileNo forState:UIControlStateNormal];
    [cell.phoneBtn addTarget:self action:@selector(telAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.phoneBtn.tag = row;
    
    return cell;
}

- (void)telAction:(id)sender
{
    UIButton *tap = (UIButton *)sender;
    if (tap) {
        TopicUserJoin *user = [self.users objectAtIndex:tap.tag];
        if (user)
        {
            NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", user.mobileNo]];
            if (!phoneWebView) {
                phoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
            }
            [phoneWebView loadRequest:[NSURLRequest requestWithURL:phoneUrl]];
        }
    }
}

//表格行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
