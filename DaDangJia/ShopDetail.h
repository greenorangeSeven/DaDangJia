//
//  ShopDetail.h
//  DaDangJia
//
//  Created by Seven on 15/9/5.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopDetail : Jastor

@property (nonatomic, retain) NSString *shopId;
@property (nonatomic, retain) NSString *shopName;
@property (nonatomic, retain) NSString *shopAddress;
@property (nonatomic, retain) NSString *phone;
@property double longitude;
@property double latitude;
@property double distance;
@property (nonatomic, retain) NSString *remark;
@property (nonatomic, retain) NSString *imgUrlFull;
@property int heartCount;

@property (strong, nonatomic) NSArray *commentList;

@end
