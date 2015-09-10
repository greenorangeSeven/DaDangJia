//
//  AppDelegate.m
//  DaDangJia
//
//  Created by Seven on 15/8/18.
//  Copyright (c) 2015年 Seven. All rights reserved.
//

#import "AppDelegate.h"
#import "MainFrameView.h"
#import "LeftView.h"
#import "CheckNetwork.h"
#import "StartView.h"

BMKMapManager* _mapManager;

@interface AppDelegate ()

@property (nonatomic, assign) BOOL isFirst;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //检查网络是否存在 如果不存在 则弹出提示
    [UserModel Instance].isNetworkRunning = [CheckNetwork isExistenceNetwork];
    
    //设置UINavigationController背景
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"top_bg"]  forBarMetrics:UIBarMetricsDefault];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.isFirst = [prefs boolForKey:@"kAppLaunched"];
    
    if (!self.isFirst) {
        [prefs setBool:YES forKey:@"kAppLaunched"];
        [prefs synchronize];
        //启动页
        StartView *startPage = [[StartView alloc] initWithNibName:@"StartView" bundle:nil];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = startPage ;
        [self.window makeKeyAndVisible];
    }
    else
    {
        MainFrameView *mainView = [[MainFrameView alloc] initWithNibName:@"MainFrameView" bundle:nil];
        UINavigationController *mainFrameNav = [[UINavigationController alloc] initWithRootViewController:mainView];
        
        LeftView *leftViewController=[[LeftView alloc]initWithNibName:@"LeftView" bundle:nil];
        
        _sideViewController=[[YRSideViewController alloc]initWithNibName:nil bundle:nil];
        _sideViewController.rootViewController=mainFrameNav;
        _sideViewController.leftViewController=leftViewController;
        
        _sideViewController.leftViewShowWidth=230;
        _sideViewController.needSwipeShowMenu=true;//默认开启的可滑动展示
        
        self.window.rootViewController = _sideViewController;
        [self.window makeKeyAndVisible];
    }
        
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"VTDwinrIst2tcojx8ui8igCZ" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    //设置目录不进行IOS自动同步！否则审核不能通过
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [NSString stringWithFormat:@"%@/cfg", [paths objectAtIndex:0]];
    NSURL *dbURLPath = [NSURL fileURLWithPath:directory];
    [self addSkipBackupAttributeToItemAtURL:dbURLPath];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}


@end
