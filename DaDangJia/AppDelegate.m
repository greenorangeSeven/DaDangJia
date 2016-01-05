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
#import "CommDetailView.h"

#import "XGPush.h"
#import "XGSetting.h"

#define _IPHONE80_ 80000

BMKMapManager* _mapManager;

@interface AppDelegate ()
{
    NSString *appPath;
}

@property (nonatomic, assign) BOOL isFirst;
@property (copy, nonatomic) NSDictionary *pushInfo;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //检查网络是否存在 如果不存在 则弹出提示
    [UserModel Instance].isNetworkRunning = [CheckNetwork isExistenceNetwork];
    
    //设置UINavigationController背景
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"top_bg"]  forBarMetrics:UIBarMetricsDefault];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    MainFrameView *mainView = [[MainFrameView alloc] initWithNibName:@"MainFrameView" bundle:nil];
    UINavigationController *mainFrameNav = [[UINavigationController alloc] initWithRootViewController:mainView];
    
    LeftView *leftViewController=[[LeftView alloc]initWithNibName:@"LeftView" bundle:nil];
    
    _sideViewController=[[YRSideViewController alloc]initWithNibName:nil bundle:nil];
    _sideViewController.rootViewController=mainFrameNav;
    _sideViewController.leftViewController=leftViewController;
    
    _sideViewController.leftViewShowWidth=230;
    _sideViewController.needSwipeShowMenu=true;//默认开启的可滑动展示
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.isFirst = [prefs boolForKey:@"kAppLaunched"];
    
    if (!self.isFirst) {
        [prefs setBool:YES forKey:@"kAppLaunched"];
        [prefs synchronize];
        //启动页
        StartView *startPage = [[StartView alloc] initWithNibName:@"StartView" bundle:nil];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = startPage ;
        [NSThread sleepForTimeInterval:2.0];
        [self.window makeKeyAndVisible];
    }
    else
    {
//        MainFrameView *mainView = [[MainFrameView alloc] initWithNibName:@"MainFrameView" bundle:nil];
//        UINavigationController *mainFrameNav = [[UINavigationController alloc] initWithRootViewController:mainView];
//        
//        LeftView *leftViewController=[[LeftView alloc]initWithNibName:@"LeftView" bundle:nil];
//        
//        _sideViewController=[[YRSideViewController alloc]initWithNibName:nil bundle:nil];
//        _sideViewController.rootViewController=mainFrameNav;
//        _sideViewController.leftViewController=leftViewController;
//        
//        _sideViewController.leftViewShowWidth=230;
//        _sideViewController.needSwipeShowMenu=true;//默认开启的可滑动展示
        
        self.window.rootViewController = _sideViewController;
        [NSThread sleepForTimeInterval:2.0];
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
    
    //集成信鸽start
    [XGPush startApp:2200147860 appKey:@"I8V8AJ1XI86T"];
    
    //注销之后需要再次注册前的准备
    void (^successCallback)(void) = ^(void){
        //如果变成需要注册状态
        if(![XGPush isUnRegisterStatus])
        {
            //iOS8注册push方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
            
            float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
            if(sysVer < 8){
                [self registerPush];
            }
            else{
                [self registerPushForIOS8];
            }
#else
            //iOS8之前注册push方法
            //注册Push服务，注册后才能收到推送
            [self registerPush];
#endif
        }
    };
    [XGPush initForReregister:successCallback];
    
    //推送反馈(app不在前台运行时，点击推送激活时)
    [XGPush handleLaunching:launchOptions];
    
    //推送反馈回调版本示例
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]handleLaunching's successBlock");
        [self pushNotificationHandle];
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        //        NSLog(@"[XGPush]handleLaunching's errorBlock");
    };
    //清除所有通知(包含本地通知)
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [XGPush handleLaunching:launchOptions successCallback:successBlock errorCallback:errorBlock];
    //信鸽END
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //清除所有通知(包含本地通知)
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    _isForeground = YES;
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

- (void)registerPushForIOS8{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

- (void)registerPush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

//信鸽
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    //notification是发送推送时传入的字典信息
    [XGPush localNotificationAtFrontEnd:notification userInfoKey:@"clockID" userInfoValue:@"myid"];
    
    //删除推送列表中的这一条
    [XGPush delLocalNotification:notification];
    //[XGPush delLocalNotification:@"clockID" userInfoValue:@"myid"];
    
    //清空推送列表
    //[XGPush clearLocalNotifications];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_

//注册UserNotification成功的回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //用户已经允许接收以下类型的推送
    //UIUserNotificationType allowedTypes = [notificationSettings types];
    
}

//按钮点击事件回调
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    if([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]){
        NSLog(@"ACCEPT_IDENTIFIER is clicked");
    }
    
    completionHandler();
}

#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken];
    
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]register successBlock ,deviceToken: %@",deviceTokenStr);
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]register errorBlock");
    };
    
    UserInfo *userInfo = [[UserModel Instance] getUserInfo];
    
    if (userInfo.mobileNo != nil && [userInfo.mobileNo length] > 0) {
        [XGPush setAccount:userInfo.mobileNo];
    }
    
    //注册设备
    [[XGSetting getInstance] setChannel:@"appstore"];
    //    [[XGSetting getInstance] setGameServer:@"巨神峰"];
    [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
    //    [XGPush setTag:@"0"];
    //如果不需要回调
    //[XGPush registerDevice:deviceToken];
    
    //打印获取的deviceToken的字符串
    NSLog(@"deviceTokenStr is %@",deviceTokenStr);
}

//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@",err];
    
    NSLog(@"%@",str);
    
}

//点击通知出发事件
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    //推送反馈(app运行时)
    [XGPush handleReceiveNotification:userInfo];
    self.pushInfo = userInfo;
    
    //回调版本示例
    /**/
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]handleReceiveNotification successBlock");
        if (_isForeground == YES) {
            [self pushNotificationHandle];
        }
        else
        {
            NSString *alertStr = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
            UIAlertView *notificationAlert = [[UIAlertView alloc] initWithTitle:@"推送消息" message:alertStr delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"查看", nil];
            notificationAlert.tag = 1;
            [notificationAlert show];
        }
        
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]handleReceiveNotification errorBlock");
    };
    
    void (^completion)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[xg push completion]userInfo is %@",userInfo);
    };
    
    [XGPush handleReceiveNotification:userInfo successCallback:successBlock errorCallback:errorBlock completion:completion];
}

//推送通知处理
- (void)pushNotificationHandle
{
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //清除所有通知(包含本地通知)
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    NSString *type = [self.pushInfo  objectForKey:@"type"];
    if ([type isEqualToString:@"notice"] == YES) {
        NSString *pushDetailHtm = [NSString stringWithFormat:@"%@%@", api_base_url, [self.pushInfo  objectForKey:@"url"]];
        CommDetailView *detailView = [[CommDetailView alloc] initWithNibName:@"CommDetailView" bundle:nil];
        detailView.present = @"present";
        detailView.titleStr = @"通知";
        detailView.urlStr = pushDetailHtm;
        UINavigationController *detailViewNav = [[UINavigationController alloc] initWithRootViewController:detailView];
        [self.window.rootViewController presentViewController:detailViewNav animated:YES completion:^{
            _isForeground = NO;
        }];
    }
}

//信鸽

@end
