//
//  MyRedPacket.h
//  DaDangJia
//
//  Created by Seven on 15/9/9.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "Jastor.h"

@interface MyRedPacket : Jastor

@property (copy, nonatomic) NSString *regUserName;
@property (copy, nonatomic) NSString *stateName;
@property double money;
@property (copy, nonatomic) NSString *rpRuleId;
@property (copy, nonatomic) NSString *regUserId;
@property int stateId;

@property (copy, nonatomic) NSNumber *getTimeStamp;
@property (copy, nonatomic) NSNumber *useTimeStamp;

@property (copy, nonatomic) NSString *getTimeStr;
@property (copy, nonatomic) NSString *useTimeStr;

@end
