//
//  Coupon.m
//  DaDangJia
//
//  Created by Seven on 15/9/4.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "Coupon.h"
#import "GroupBuyHeart.h"
#import "GroupBuyComment.h"

@implementation Coupon

+(Class)heartList_class
{
    return [GroupBuyHeart class];
}

+(Class)commentList_class
{
    return [GroupBuyComment class];
}

@end
