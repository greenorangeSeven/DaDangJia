//
//  TuanPageView.h
//  DaDangJia
//
//  Created by Seven on 15/8/30.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"

@interface TuanPageView : UIViewController<EGORefreshTableHeaderDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SGFocusImageFrameDelegate>
{
    NSMutableArray *tuans;
    
    //下拉刷新
    BOOL _reloading;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL isLoading;
    BOOL isLoadOver;
    int allCount;
    
    SGFocusImageFrame *bannerView;
    int advIndex;
}

@property (weak, nonatomic) UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *hotGroupBuyView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//下拉刷新
- (void)refresh;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
@property (weak, nonatomic) IBOutlet UILabel *personLb;


@end
