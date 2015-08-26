//
//  ConvenienceShopView.h
//  DaDangJia
//
//  Created by Seven on 15/8/22.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BMapKit.h"

@interface ConvenienceShopView : UIViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate,MBProgressHUDDelegate,CLLocationManagerDelegate,BMKLocationServiceDelegate>
{
    NSMutableArray *shops;
    BOOL isLoading;
    BOOL isLoadOver;
    int allCount;
    
    //下拉刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    MBProgressHUD *hud;
    
    BMKMapPoint myPoint;
    BMKLocationService* _locService;
    double latitude;
    double longitude;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) ShopType *type;
@property (strong, nonatomic) CLLocationManager *locationManager;

- (void)reload:(BOOL)noRefresh;

//清空
- (void)clear;

//下拉刷新
- (void)refresh;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
