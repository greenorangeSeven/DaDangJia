//
//  ShopCarItem.h
//  WHDLife
//
//  Created by Seven on 15-1-18.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCarItem : NSObject

@property int dbid;
@property (nonatomic, retain) NSString *commodityid;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *properyStr;
@property (nonatomic, retain) NSString *imagefull;
@property (nonatomic, retain) NSString *shopId;
@property (nonatomic, retain) NSString *shopName;
@property double price;
@property int integral;
@property int number;
@property double subtotal;
@property (nonatomic, retain) NSString *ischeck;


@end
