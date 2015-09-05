//
//  GroupBuyDetail.m
//  DaDangJia
//
//  Created by Seven on 15/9/1.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "GroupBuyDetail.h"
#import "GroupBuyHeart.h"
#import "GroupBuyComment.h"

@implementation GroupBuyDetail

+(Class)heartList_class
{
    return [GroupBuyHeart class];
}

+(Class)commentList_class
{
    return [GroupBuyComment class];
}

@end
