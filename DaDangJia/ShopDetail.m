//
//  ShopDetail.m
//  DaDangJia
//
//  Created by Seven on 15/9/5.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "ShopDetail.h"
#import "GroupBuyComment.h"

@implementation ShopDetail

+(Class)commentList_class
{
    return [GroupBuyComment class];
}

@end
