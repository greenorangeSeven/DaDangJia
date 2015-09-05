//
//  RedPacket.h
//  DaDangJia
//
//  Created by Seven on 15/9/4.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedPacket : Jastor

@property (copy, nonatomic) NSString *rpRuleId;
@property (copy, nonatomic) NSString *rpName;
@property (copy, nonatomic) NSString *starttime;
@property (copy, nonatomic) NSString *endtime;
@property double totalMoney;
@property double drawingCount;
@property (copy, nonatomic) NSString *img;
@property long starttimeStamp;
@property long endtimeStamp;
@property (copy, nonatomic) NSString *imgFull;

@end
