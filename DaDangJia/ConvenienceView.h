//
//  ConvenienceView.h
//  DaDangJia
//
//  Created by Seven on 15/8/19.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConvenienceView : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *types;
    MBProgressHUD *hud;
}

@property (weak, nonatomic) UIView *frameView;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end
