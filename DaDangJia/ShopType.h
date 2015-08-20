//
//  ShopType.h
//  BBK
//
//  Created by Seven on 14-12-9.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"

@interface ShopType : Jastor

@property (nonatomic, retain) NSString *shopTypeId;
@property (nonatomic, retain) NSString *shopTypeName;
@property (nonatomic, retain) NSString *imgUrlFull;

@property (nonatomic, retain) UIImage *imgData;

@end
