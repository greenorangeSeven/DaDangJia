//
//  ShopCar.h
//  WHDLife
//
//  Created by Seven on 15-1-18.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCar : NSObject

@property (nonatomic, retain) NSString *shopId;
@property (nonatomic, retain) NSString *shopName;
@property int commodityCount;
@property (nonatomic, retain) NSMutableArray *commodityList;
@property double total;

@property BOOL shopIsCheck;

@end
