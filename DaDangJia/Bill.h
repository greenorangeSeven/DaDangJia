//
//  Bill.h
//  WHDLife
//
//  Created by Seven on 15-1-21.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bill : NSObject

@property (nonatomic, retain) NSString *billId;
@property (nonatomic, retain) NSString *billName;
@property (nonatomic, retain) NSString *detailsId; //订单ID用于支付
@property (nonatomic, retain) NSString *month;
@property (nonatomic, retain) NSString *monthStr;
@property double totalMoney; //应付
@property double totalFee;  //支付宝反馈用户实际支付金额
@property int stateId;  //0未缴，1已缴
@property int typeId;  //0物业，1电，2停车

@end
