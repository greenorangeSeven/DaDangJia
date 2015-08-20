//
//  OderSubmitVO.h
//  WHDLife
//
//  Created by mac on 15/1/30.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 订单
 */
@interface OderSubmitVO : NSObject

/**
 * 注册用户id
 */
@property (copy, nonatomic) NSString *regUserId;

/**
 * 用户下单留言
 */
@property (copy, nonatomic) NSString *remark;

/**
 * 收货人姓名
 */
@property (copy, nonatomic) NSString *receivingUserName;

/**
 * 收货地址
 */
@property (copy, nonatomic) NSString *receivingAddress;

/**
 * 联系电话
 */
@property (copy, nonatomic) NSString *phone;

/**
 * 支付方式
 */
@property int payType;

/**
 * 订单商家列表
 */
@property (strong, nonatomic) NSMutableArray *shopList;

@end
