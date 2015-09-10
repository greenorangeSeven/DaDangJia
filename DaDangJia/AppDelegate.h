//
//  AppDelegate.h
//  DaDangJia
//
//  Created by Seven on 15/8/18.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRSideViewController.h"
#import "BMapKit.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;

@property BOOL isForeground;

@property (strong,nonatomic) YRSideViewController *sideViewController;

@end

