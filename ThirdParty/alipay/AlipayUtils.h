//
//  AlipayUtils.h
//  AlipaySdkDemo
//
//  Created by mac on 14-8-19.
//  Copyright (c) 2014年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlipayUtils : NSObject

+ (void)doPay:(NSString *)payOrderStr AndScheme:(NSString *)scheme;

@end
