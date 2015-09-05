//
//  Coupon.h
//  DaDangJia
//
//  Created by Seven on 15/9/4.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Coupon : Jastor

@property (copy, nonatomic) NSString *couponId;
@property (copy, nonatomic) NSString *couponName;
@property (copy, nonatomic) NSString *des;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *useLimit;
@property (copy, nonatomic) NSString *img;
@property int isClose;
@property (copy, nonatomic) NSString *imgFull;

@end
