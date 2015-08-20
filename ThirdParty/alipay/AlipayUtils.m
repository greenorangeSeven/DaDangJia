//
//  AlipayUtils.m
//  AlipaySdkDemo
//
//  Created by mac on 14-8-19.
//  Copyright (c) 2014年 Alipay. All rights reserved.
//

#import "AlipayUtils.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation AlipayUtils

+ (void)doPay:(NSString *)payOrderStr AndScheme:(NSString *)scheme
{
    [[AlipaySDK defaultService] payOrder:payOrderStr fromScheme:scheme callback:^(NSDictionary *resultDic)
    {
        NSLog(@"reslut = %@",resultDic);
    }];
}

@end
