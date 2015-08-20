//
//  OrderCommodityVO.h
//  WHDLife
//
//  Created by mac on 15/1/30.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderCommodityVO : NSObject

/**
 * 商品ID
 */
@property (copy, nonatomic) NSString *commodityId;

/**
 * 购买数量
 */
@property int num;

/**
 * 所选规格名称(多个则展示为："颜色:红,尺码:L")
 */
@property (copy, nonatomic) NSString *skuName;
@end
