//
//  TopicPageView.h
//  DaDangJia
//
//  Created by Seven on 15/9/7.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicPageView : UIViewController<EGORefreshTableHeaderDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *topics;
    
    //下拉刷新
    BOOL _reloading;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL isLoading;
    BOOL isLoadOver;
    int allCount;
    
}

@property (weak, nonatomic) UIView *frameView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//下拉刷新
- (void)refresh;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

- (IBAction)helpAction:(id)sender;
- (IBAction)zjlAction:(id)sender;
- (IBAction)hyhAction:(id)sender;
- (IBAction)jjzzAction:(id)sender;
- (IBAction)tsjyAction:(id)sender;


@end
