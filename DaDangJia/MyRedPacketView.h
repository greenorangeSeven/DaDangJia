//
//  MyRedPacketView.h
//  DaDangJia
//
//  Created by Seven on 15/9/9.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRedPacketView : UIViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate,MBProgressHUDDelegate>
{
    NSMutableArray *redPackets;
}

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *faceIv;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLb;
@property (weak, nonatomic) IBOutlet UILabel *userInfoLb;
@property (weak, nonatomic) IBOutlet UILabel *integralLb;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
