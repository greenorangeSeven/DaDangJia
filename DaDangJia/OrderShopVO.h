//
//  OrderShopVO.h
//  WHDLife
//
//  Created by mac on 15/1/30.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 代表一个商户商品
 */
@interface OrderShopVO : NSObject

/**
 * 商户ID
 */
@property (copy, nonatomic) NSString *shopId;

/**
 * 下单商品列表
 */
@property (strong, nonatomic) NSMutableArray *commodityList;

@end
