//
//  TopicPageView.m
//  DaDangJia
//
//  Created by Seven on 15/9/7.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "TopicPageView.h"
#import "CommodityFooterView.h"
#import "UIImageView+WebCache.h"
#import "TopicListCell.h"
#import "TopicFull.h"
#import "TopicDetailView.h"
#import "ConveneDetailView.h"
#import "ExChangeDetailView.h"
#import "TopicListView.h"

@interface TopicPageView ()

@end

@implementation TopicPageView
{
    CommodityFooterView *footerView;
    UserInfo *userInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height = self.frameView.frame.size.height;
    viewFrame.size.width = self.frameView.frame.size.width;
    self.view.frame = viewFrame;
    
    userInfo = [[UserModel Instance] getUserInfo];
    
    [self.collectionView registerClass:[CommodityFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CommodityFooter"];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[TopicListCell class] forCellWithReuseIdentifier:TopicListCellIdentifier];
    
    allCount = 0;
    //添加的代码
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -320.0f, self.view.frame.size.width, 320)];
        view.delegate = self;
        [self.collectionView addSubview:view];
        _refreshHeaderView = view;
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    topics = [[NSMutableArray alloc] initWithCapacity:20];
    [self reload:YES];
}

- (void)viewDidUnload
{
    [self setCollectionView:nil];
    _refreshHeaderView = nil;
    [topics removeAllObjects];
    topics = nil;
    [super viewDidUnload];
}

- (void)clear
{
    allCount = 0;
    [topics removeAllObjects];
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
        
        //生成获取朋友圈列表URL
        NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
        [param setValue:userInfo.defaultUserHouse.cellId forKey:@"cellId"];
        [param setValue:userInfo.regUserId forKey:@"userId"];
//        [param setValue:self.typeId forKey:@"typeId"];
        [param setValue:@"starttime-desc" forKey:@"sort"];
        [param setValue:[NSString stringWithFormat:@"%d", pageIndex] forKey:@"pageNumbers"];
        [param setValue:@"20" forKey:@"countPerPages"];
        [param setValue:@"0" forKey:@"stateId"];
        NSString *topicInfoByPageUrl = [Tool serializeURL:[NSString stringWithFormat:@"%@%@", api_base_url, api_findTopicInfoByPageForApp] params:param];
        
        [[AFOSCClient sharedClient]getPath:topicInfoByPageUrl parameters:Nil
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       
                                       NSMutableArray *topicNews = [Tool readJsonStrToTopicFullArray:operation.responseString];
                                       isLoading = NO;
                                       if (!noRefresh) {
                                           [self clear];
                                       }
                                       
                                       @try {
                                           NSInteger count = [topicNews count];
                                           if(count == 0)
                                           {
                                               [Tool showCustomHUD:@"暂无发布" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
                                           }
                                           allCount += count;
                                           if (count < 20)
                                           {
                                               isLoadOver = YES;
                                               footerView.moreLb.text = @"已加载全部";
                                           }
                                           [topics addObjectsFromArray:topicNews];
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
                                       NSLog(@"列表获取出错");
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
    }
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [topics count];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TopicListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TopicListCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"TopicListCell" owner:self options:nil];
        for (NSObject *o in objects) {
            if ([o isKindOfClass:[TopicListCell class]]) {
                cell = (TopicListCell *)o;
                break;
            }
        }
    }
    NSInteger indexRow = [indexPath row];
    TopicFull *topic = (TopicFull *)[topics objectAtIndex:indexRow];
    if([topic.imgUrlList count] > 0)
    {
        [cell.imgIv sd_setImageWithURL:[NSURL URLWithString:topic.imgUrlList[0]] placeholderImage:[UIImage imageNamed:@"loadpic.png"]];
    }
    cell.typeNameLb.text = topic.typeName;
    cell.titleLb.text = topic.content;
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    return CGSizeMake(width/2-1, width/2+25);
    
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
    TopicFull *topic = (TopicFull *)[topics objectAtIndex:indexRow];
    if (topic) {
        if (topic.typeId == 0) {
            ConveneDetailView *detailView = [[ConveneDetailView alloc] init];
            detailView.topic = topic;
            detailView.typeName = topic.typeName;
            [self.navigationController pushViewController:detailView animated:YES];
        }
        else if (topic.typeId == 2) {
            ExChangeDetailView *detailView = [[ExChangeDetailView alloc] init];
            detailView.topic = topic;
            detailView.typeName = topic.typeName;
            [self.navigationController pushViewController:detailView animated:YES];
        }
        else
        {
            TopicDetailView *detailView = [[TopicDetailView alloc] init];
            detailView.topic = topic;
            detailView.typeName = topic.typeName;
            [self.navigationController pushViewController:detailView animated:YES];
        }
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

- (IBAction)helpAction:(id)sender {
    TopicListView *helpView = [[TopicListView alloc] init];
    helpView.typeName = @"帮帮忙";
    helpView.typeId = @"1";
    helpView.adId = @"1141856653531200";
    [self.navigationController pushViewController:helpView animated:YES];
}

- (IBAction)zjlAction:(id)sender {
    TopicListView *zjlView = [[TopicListView alloc] init];
    zjlView.typeName = @"召集令";
    zjlView.typeId = @"0";
    zjlView.adId = @"1141857144700000";
    [self.navigationController pushViewController:zjlView animated:YES];
}

- (IBAction)hyhAction:(id)sender {
    TopicListView *exChangeView = [[TopicListView alloc] init];
    exChangeView.typeName = @"换一换";
    exChangeView.typeId = @"2";
    exChangeView.adId = @"1141857157067500";
    [self.navigationController pushViewController:exChangeView animated:YES];
}

- (IBAction)jjzzAction:(id)sender {
    TopicListView *exChangeView = [[TopicListView alloc] init];
    exChangeView.typeName = @"叽叽喳喳";
    exChangeView.typeId = @"3";
    exChangeView.adId = @"1141895702711700";
    [self.navigationController pushViewController:exChangeView animated:YES];
}

- (IBAction)tsjyAction:(id)sender {
    TopicListView *exChangeView = [[TopicListView alloc] init];
    exChangeView.typeName = @"投诉建议";
    exChangeView.typeId = @"4";
    exChangeView.adId = @"1142357056821000";
    [self.navigationController pushViewController:exChangeView animated:YES];
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
    return reusableview;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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