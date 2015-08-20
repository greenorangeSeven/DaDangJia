//
//  EstateActivity.h
//  AnYiDian
//
//  Created by Seven on 15/7/20.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EstateActivity : Jastor

@property (copy, nonatomic) NSString *activityId;
@property (copy, nonatomic) NSString *activityName;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *qq;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *qualifications;
@property (copy, nonatomic) NSString *imgUrlFull;
@property long starttimeStamp;
@property long endtimeStamp;
@property int userCount;
@property int heartCountNew;
@property int heartCount;
@property (copy, nonatomic) NSString *isJoin;
@property (copy, nonatomic) NSString *isHeart;

@end
