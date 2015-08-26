//
//  ConvenienceDetailView.h
//  DaDangJia
//
//  Created by Seven on 15/8/23.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopInfo.h"

@interface ConvenienceDetailView : UIViewController

@property (weak, nonatomic) ShopInfo *shopInfo;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *shopImageIv;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLb;
@property (weak, nonatomic) IBOutlet UILabel *projectLb;
@property (weak, nonatomic) IBOutlet UILabel *phoneLb;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;

@end
