//
//  NearbyCell.h
//  DaDangJia
//
//  Created by Seven on 15/9/8.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearbyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgIv;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UILabel *phoneLb;

@end
