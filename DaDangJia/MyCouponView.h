//
//  MyCouponView.h
//  DaDangJia
//
//  Created by Seven on 15/9/9.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCouponView : UIViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate,MBProgressHUDDelegate>
{
    NSMutableArray *coupons;
    BOOL isLoading;
    BOOL isLoadOver;
    int allCount;
    
    //下拉刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)reload:(BOOL)noRefresh;

//清空
- (void)clear;

//下拉刷新
- (void)refresh;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end