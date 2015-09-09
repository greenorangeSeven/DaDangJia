//
//  NearbyView.h
//  DaDangJia
//
//  Created by Seven on 15/9/7.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearbyView : UIViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate,MBProgressHUDDelegate>
{
    NSMutableArray *shops;
    BOOL isLoading;
    BOOL isLoadOver;
    int allCount;
    
    //下拉刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    MBProgressHUD *hud;
}

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)reload:(BOOL)noRefresh;

//清空
- (void)clear;

//下拉刷新
- (void)refresh;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@property (weak, nonatomic) UIView *frameView;

@property (weak, nonatomic) IBOutlet UILabel *cityLb;
@property (weak, nonatomic) IBOutlet UILabel *cellLb;
@property (weak, nonatomic) IBOutlet UILabel *typeLb;

@property (weak, nonatomic) IBOutlet UIButton *citySelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *cellSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *typeSelectBtn;
- (IBAction)citySelectAction:(UIButton *)sender;
- (IBAction)cellSelectAction:(id)sender;
- (IBAction)typeSelectAction:(id)sender;

@end
