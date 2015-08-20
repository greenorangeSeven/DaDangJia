//
//  Commodity.h
//  WHDLife
//
//  Created by Seven on 15-1-16.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Commodity : NSObject

@property (nonatomic, retain) NSString *shopId;
@property (nonatomic, retain) NSString *shopName;
@property (nonatomic, retain) NSString *commodityId;
@property (nonatomic, retain) NSString *commodityName;
@property (nonatomic, retain) NSString *details;
@property double marketPrice;
@property double price;
@property int commentCount;
@property double sorce;
@property int stateId;
@property int isCollection;
@property (nonatomic, retain) NSArray *imgList;
@property (nonatomic, retain) NSMutableArray *imgStrList;
@property (nonatomic, retain) NSArray *properyList;
@property (nonatomic, retain) NSMutableArray *properyStrList;

@property int integral;

@end
