//
//  TuanPageView.m
//  DaDangJia
//
//  Created by Seven on 15/8/30.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "TuanPageView.h"
#import "CommodityFooterView.h"
#import "TuanItemCell.h"
#import "GroupBuy.h"
#import "UIImageView+WebCache.h"
#import "AdView.h"
#import "TuanHeaderView.h"
#import "HotGroupBuyDetailView.h"
#import "EveryDayGroupBuyDetailView.h"
#import "HistoryGroupBuyView.h"

@interface TuanPageView ()
{
    CommodityFooterView *footerView;
//    TuanHeaderView *headerView;
    AdView * adView;
    UserInfo *userInfo;
    NSMutableArray *hotDatas;
}

@end

@implementation TuanPageView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"实惠团";
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle: @"往期团购" style:UIBarButtonItemStyleBordered target:self action:@selector(historyGroupBuyAction:)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    self.joinBtn.layer.cornerRadius=self.joinBtn.frame.size.height/2;
    
//    [self.collectionView registerClass:[TuanHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TuanHeader"];
    
    [self.collectionView registerClass:[CommodityFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CommodityFooter"];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
//    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[TuanItemCell class] forCellWithReuseIdentifier:TuanItemCellIdentifier];
    
    allCount = 0;
    //添加的代码
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -320.0f, self.view.frame.size.width, 320)];
        view.delegate = self;
        [self.collectionView addSubview:view];
        _refreshHeaderView = view;
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    tuans = [[NSMutableArray alloc] initWithCapacity:20];
    [self reload:YES];
    [self getHotGroupBuyData];
}

- (void)historyGroupBuyAction:(id)sender
{
    HistoryGroupBuyView *historyView = [[HistoryGroupBuyView alloc] init];
    [self.navigationController pushViewController:historyView animated:YES];
}

- (void)getHotGroupBuyData
{
    //生成获取团购URL
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:@"1" forKey:@"pageNumbers"];
    [param setValue:@"20" forKey:@"countPerPages"];
    [param setValue:@"0" forKey:@"isOver"];
    [param setValue:@"1" forKey:@"isHot"];
    
    NSString *findGroupBuyingUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findGroupBuyingInfoByPage] params:param];
    [[AFOSCClient sharedClient]getPath:findGroupBuyingUrl parameters:Nil
                               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                                   NSError *error;
                                   NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                   
                                   NSDictionary *datas = [json objectForKey:@"data"];
                                   NSArray *array = [datas objectForKey:@"resultsList"];
                                   
                                   hotDatas = [NSMutableArray arrayWithArray:[Tool readJsonToObjArray:array andObjClass:[GroupBuy class]]];
                                   
                                   
                                   @try {
                                       NSInteger length = [hotDatas count];
                                       NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
                                       if (length > 1)
                                       {
                                           GroupBuy *adv = [hotDatas objectAtIndex:length-1];
                                           
                                           SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:nil image:adv.imgFull tag:length-1];
                                           [itemArray addObject:item];
                                       }
                                       for (int i = 0; i < length; i++)
                                       {
                                           GroupBuy *adv = [hotDatas objectAtIndex:i];
                                           
                                           SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:nil image:adv.imgFull tag:i];
                                           [itemArray addObject:item];
                                           
                                       }
                                       //添加第一张图 用于循环
                                       if (length >1)
                                       {
                                           GroupBuy *adv = [hotDatas objectAtIndex:0];
                                           
                                           SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:nil image:adv.imgFull tag:0];
                                           [itemArray addObject:item];
                                       }
                                       bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 195) delegate:self imageItems:itemArray isAuto:YES];
                                       [bannerView scrollToIndex:0];
                                       [self.hotGroupBuyView addSubview:bannerView];
                                       
                                       GroupBuy *tuan = (GroupBuy *)[hotDatas objectAtIndex:0];
                                       self.titleLb.text = tuan.title;
                                       self.priceLb.text = [NSString stringWithFormat:@"市场价:%0.2f  已报名:%d人", tuan.marketPrice, tuan.joinCount];
                                       self.personLb.text = [NSString stringWithFormat:@"已报名:%d", tuan.joinCount];
                                       
                                   }
                                   @catch (NSException *exception) {
                                       [NdUncaughtExceptionHandler TakeException:exception];
                                   }
                                   @finally {
                                   }
                               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                   if ([UserModel Instance].isNetworkRunning == NO) {
                                       return;
                                   }
                                   if ([UserModel Instance].isNetworkRunning) {
                                       [Tool showCustomHUD:@"网络不给力" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
                                   }
                               }];
}

//顶部图片滑动点击委托协议实现事件
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    GroupBuy *tuan = (GroupBuy *)[hotDatas objectAtIndex:advIndex];
    if (tuan)
    {
        HotGroupBuyDetailView *hotDetailView = [[HotGroupBuyDetailView alloc] init];
        hotDetailView.groupId = tuan.groupId;
        [self.navigationController pushViewController:hotDetailView animated:YES];
    }
}

//顶部图片自动滑动委托协议实现事件
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame currentItem:(int)index;
{
    advIndex = index;
    GroupBuy *tuan = (GroupBuy *)[hotDatas objectAtIndex:index];
    self.titleLb.text = tuan.title;
    self.priceLb.text = [NSString stringWithFormat:@"市场价:%0.2f  已报名:%d人", tuan.marketPrice, tuan.joinCount];
    self.personLb.text = [NSString stringWithFormat:@"已报名:%d", tuan.joinCount];
}
//
//- (void)initAdView
//{
//    CGFloat width = [UIScreen mainScreen].bounds.size.width;
//    
//    NSMutableArray *imagesURL = [[NSMutableArray alloc] init];
//    NSMutableArray *titles = [[NSMutableArray alloc] init];
//    if ([hotDatas count] > 0) {
//        for (GroupBuy *ad in hotDatas) {
//            [imagesURL addObject:ad.imgFull];
//            [titles addObject:ad.title];
//        }
//    }
//    
//    //如果你的这个广告视图是添加到导航控制器子控制器的View上,请添加此句,否则可忽略此句
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    
//    adView = [AdView adScrollViewWithFrame:CGRectMake(0, 0, width, 160)  \
//                              imageLinkURL:imagesURL\
//                       placeHoderImageName:@"placeHoder.jpg" \
//                      pageControlShowStyle:UIPageControlShowStyleLeft];
//    
//    //    是否需要支持定时循环滚动，默认为YES
//    //    adView.isNeedCycleRoll = YES;
//    
//    [adView setAdTitleArray:nil withShowStyle:AdTitleShowStyleNone];
//    //    设置图片滚动时间,默认3s
//    //    adView.adMoveTime = 2.0;
//    
//    //图片被点击后回调的方法
//    adView.callBack = ^(NSInteger index,NSString * imageURL)
//    {
//        NSLog(@"被点中图片的索引:%ld---地址:%@",index,imageURL);
////        ADInfo *adv = (ADInfo *)[advDatas objectAtIndex:index];
////        NSString *adDetailHtm = [NSString stringWithFormat:@"%@%@%@", api_base_url, htm_adDetail ,adv.adId];
////        CommDetailView *detailView = [[CommDetailView alloc] init];
////        detailView.titleStr = @"详情";
////        detailView.urlStr = adDetailHtm;
////        detailView.hidesBottomBarWhenPushed = YES;
////        [self.navigationController pushViewController:detailView animated:YES];
//    };
//    [headerView.hotTuanView addSubview:adView];
//}

- (void)viewDidUnload
{
    [self setCollectionView:nil];
    _refreshHeaderView = nil;
    [tuans removeAllObjects];
    tuans = nil;
    [super viewDidUnload];
}

- (void)clear
{
    allCount = 0;
    [tuans removeAllObjects];
    isLoadOver = NO;
}

- (void)reload:(BOOL)noRefresh
{
    //如果有网络连接
    if ([UserModel Instance].isNetworkRunning) {
        if (isLoading || isLoadOver) {
            return;
        }
        if (!noRefresh) {
            allCount = 0;
        }
        int pageIndex = allCount/20 + 1;
        //生成获取团购URL
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:[NSString stringWithFormat:@"%d", pageIndex] forKey:@"pageNumbers"];
        [param setValue:@"20" forKey:@"countPerPages"];
        [param setValue:@"0" forKey:@"isOver"];
        [param setValue:@"0" forKey:@"isHot"];
        
        NSString *findGroupBuyingUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findGroupBuyingInfoByPage] params:param];
        [[AFOSCClient sharedClient]getPath:findGroupBuyingUrl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       NSData *data = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
                                       NSError *error;
                                       NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                       
                                       NSDictionary *datas = [json objectForKey:@"data"];
                                       NSArray *array = [datas objectForKey:@"resultsList"];
                                       
                                       NSMutableArray *tuanNews = [NSMutableArray arrayWithArray:[Tool readJsonToObjArray:array andObjClass:[GroupBuy class]]];
                                       
                                       isLoading = NO;
                                       if (!noRefresh) {
                                           [self clear];
                                       }
                                       
                                       @try {
                                           NSInteger count = [tuanNews count];
                                           if(count == 0)
                                           {
                                               [Tool showCustomHUD:@"暂无团购" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
                                           }
                                           allCount += count;
                                           if (count < 20)
                                           {
                                               isLoadOver = YES;
                                               footerView.moreLb.text = @"已加载全部";
                                           }
                                           [tuans addObjectsFromArray:tuanNews];
                                           [self.collectionView reloadData];
                                           [self doneLoadingTableViewData];
                                       }
                                       @catch (NSException *exception) {
                                           [NdUncaughtExceptionHandler TakeException:exception];
                                       }
                                       @finally {
                                           [self doneLoadingTableViewData];
                                       }
                                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       //如果是刷新
                                       [self doneLoadingTableViewData];
                                       
                                       if ([UserModel Instance].isNetworkRunning == NO) {
                                           return;
                                       }
                                       isLoading = NO;
                                       if ([UserModel Instance].isNetworkRunning) {
                                           [Tool showCustomHUD:@"网络不给力" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
                                       }
                                   }];
        isLoading = YES;
        //        [self.newsTable reloadData];
    }
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [tuans count];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TuanItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TuanItemCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"TuanItemCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[TuanItemCell class]]) {
                cell = (TuanItemCell *)o;
                break;
            }
        }
    }
    NSInteger indexRow = [indexPath row];
    GroupBuy *g = [tuans objectAtIndex:indexRow];
    [cell.imageIv sd_setImageWithURL:[NSURL URLWithString:g.titlePageFull] placeholderImage:[UIImage imageNamed:@"loadpic.png"]];
    cell.titleLb.text = g.title;
    cell.desLb.text = [NSString stringWithFormat:@"团购价:%0.2f", g.price];;
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(width/2-1, width/2+10);
    
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 5, 0);
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger indexRow = [indexPath row];
    GroupBuy *tuan = (GroupBuy *)[tuans objectAtIndex:indexRow];
    if (tuan) {
        EveryDayGroupBuyDetailView *everyDetailView = [[EveryDayGroupBuyDetailView alloc] init];
        everyDetailView.groupId = tuan.groupId;
        [self.navigationController pushViewController:everyDetailView animated:YES];
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma 下提刷新
- (void)reloadTableViewDataSource
{
    _reloading = YES;
}

- (void)doneLoadingTableViewData
{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.collectionView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self reloadTableViewDataSource];
    [self refresh];
}

// tableView添加拉更新
- (void)egoRefreshTableHeaderDidTriggerToBottom
{
    if (!isLoading) {
        [self performSelector:@selector(reload:)];
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _reloading;
}
- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}
- (void)refresh
{
    if ([UserModel Instance].isNetworkRunning) {
        isLoadOver = NO;
        [self reload:NO];
    }
}

- (void)dealloc
{
    [self.collectionView setDelegate:nil];
}

// 返回headview或footview
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionFooter){
        footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CommodityFooter" forIndexPath:indexPath];
        reusableview = footerView;
    }
//    if (kind == UICollectionElementKindSectionHeader){
//        headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TuanHeader" forIndexPath:indexPath];
//        reusableview = headerView;
//        [self getHotGroupBuyData];
//    }
    return reusableview;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    bannerView.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    bannerView.delegate = self;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.hidden = NO;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
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
