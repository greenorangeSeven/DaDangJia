//
//  MyOrderCommodity.h
//  WHDLife
//
//  Created by Seven on 15-1-28.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrderCommodity : NSObject

@property (nonatomic, retain) NSString *commodityId;
@property (nonatomic, retain) NSString *commodityName;
@property (nonatomic, retain) NSString *imgUrlFull;
@property double price;
@property int num;
@property (nonatomic, retain) NSString *skuName;

@end
