//
//  GroupBuy.h
//  DaDangJia
//
//  Created by Seven on 15/8/31.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupBuy : Jastor

@property int joinCount;
@property (copy, nonatomic) NSString *groupId;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *des;
@property double marketPrice;
@property double price;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *address;
@property int personCount;
@property (copy, nonatomic) NSString *starttime;
@property (copy, nonatomic) NSString *endtime;
@property int isHot;
@property (copy, nonatomic) NSString *imgFull;
@property (copy, nonatomic) NSString *titlePageFull;
@property long starttimeStamp;
@property long endtimeStamp;
@property (copy, nonatomic) NSString *content;

@end
