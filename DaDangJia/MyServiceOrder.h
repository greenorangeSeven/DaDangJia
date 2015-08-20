//
//  MyServiceOrder.h
//  SXJTX
//
//  Created by Seven on 15/2/28.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyServiceOrder : NSObject

/**
 *  我的预约ID
 */
@property (copy, nonatomic) NSString *shopId;

/**
 *  预约时间
 */
@property (copy, nonatomic) NSString *starttime;

/**
 *  预约时间戳
 */
@property (nonatomic, retain) NSNumber *starttimeStamp;

/**
 *  预约事由
 */
@property (copy, nonatomic) NSString *content;

/**
 *  状态0：未查阅   1：已查阅
 */
@property int stateId;

@end
