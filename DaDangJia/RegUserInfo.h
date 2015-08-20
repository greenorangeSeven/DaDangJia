//
//  RegUserInfo.h
//  AnYiDian
//
//  Created by Seven on 15/7/23.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegUserInfo : Jastor

@property (copy, nonatomic) NSString *regUserId;
@property (copy, nonatomic) NSString *regUserName;
@property (copy, nonatomic) NSString *mobileNo;
@property (copy, nonatomic) NSString *nickName;
@property int isVolunteer;
@property (copy, nonatomic) NSString *photoFull;

@end
