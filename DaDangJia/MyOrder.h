//
//  MyOrder.h
//  WHDLife
//
//  Created by Seven on 15-1-28.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrder : NSObject

@property (nonatomic, retain) NSString *orderId;
@property (nonatomic, retain) NSString *shopId;
@property (nonatomic, retain) NSString *shopName;
@property int stateId;
@property int payType;
@property (nonatomic, retain) NSString *payTypeName;
@property (nonatomic, retain) NSString *stateName;
@property int starttimeStamp;
@property int payTimeStamp;
@property int sendTimeStamp;
@property (nonatomic, retain) NSString *receivingUserName;
@property (nonatomic, retain) NSString *receivingAddress;
@property (nonatomic, retain) NSString *phone;
@property double totalPrice;

@property (nonatomic, retain) NSMutableArray *commodityList;
@property (nonatomic, retain) NSMutableArray *commodityObjectList;

@end
