//
//  ConvenienceDetailView.m
//  DaDangJia
//
//  Created by Seven on 15/8/23.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "ConvenienceDetailView.h"
#import "UIImageView+WebCache.h"

@interface ConvenienceDetailView ()

@end

@implementation ConvenienceDetailView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.shopInfo.shopName;
    [self.shopImageIv sd_setImageWithURL:[NSURL URLWithString:self.shopInfo.imgUrlFull] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.shopNameLb.text = self.shopInfo.shopName;
    self.phoneLb.text = [NSString stringWithFormat:@"电       话:%@", self.shopInfo.phone];
    self.addressLb.text = [NSString stringWithFormat:@"地       址:%@", self.shopInfo.shopAddress];
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
