//
//  AppDelegate.m
//  LittleCool
//
//  Created by 周博 on 17/3/12.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "AppDelegate.h"
#import "UncaughtExceptionHandler.h"
#import "BGLeadPageVC.h"
#import "Reachability.h"

@interface AppDelegate ()<WXApiDelegate>
@property (nonatomic)Reachability *hostReach;

@end

@implementation AppDelegate

/**
 *  注册登录
 */
- (void)signNoti:(id)noti{
    UIStoryboard *storyboard = kSignStroyboard;
    self.window.rootViewController = [storyboard instantiateInitialViewController];
    [self.window makeKeyWindow];
}

/**
 *  主页
 */
- (void)loginNoti:(id)noti{
    UIStoryboard *storyboard = kMainStroyboard;
    self.window.rootViewController = [storyboard instantiateInitialViewController];
    [self.window makeKeyWindow];
}

//- (void)notiLoginNoti:(id)noti{
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController * ctrl = (UIViewController *)[storyBoard instantiateInitialViewController];
//    self.window.rootViewController = ctrl;
//    [self.window makeKeyWindow];
//    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"select"];
//    ((UITabBarController *)(self.window.rootViewController)).selectedIndex = 4;
//}

/**
 *  跳转到LaunchScreen页面
 *
 *  @param sender
 */
- (void)launchScreenPage:(id)sender{
    BGLeadPageVC *leadPageVC = [[BGLeadPageVC alloc] init];
    self.window.rootViewController = leadPageVC;
    [self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"payStatus"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"chackVerson"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signNoti:) name:@"sign" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNoti:) name:@"login" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiLoginNoti:) name:@"notiLoginNoti" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(launchScreenPage:) name:@"launch" object:nil];
//    NSLog(@"%@",[DLUDID value]);
    [UncaughtExceptionHandler installUncaughtExceptionHandler:YES showAlert:YES];

    [self weChatInfo];
    
    [self launchScreenPage:nil];
//    [self doNotFindNet];
    return YES;
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - wechat
- (void)weChatInfo{
    [WXApi registerApp:@"wxb1e4458be71faee9" withDescription:@"wechat"];
    
    //向微信注册支持的文件类型
    UInt64 typeFlag = MMAPP_SUPPORT_TEXT | MMAPP_SUPPORT_PICTURE | MMAPP_SUPPORT_LOCATION;
    
    [WXApi registerAppSupportContentFlag:typeFlag];
}

- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)req {
    NSLog(@"");
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}


/**
 *  如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，
 *  会切到微信终端程序界面。
 */
- (void)onResp:(BaseResp *)resp {
    SendAuthResp *aresp = (SendAuthResp *)resp;
    if (aresp.errCode == 0) { // 用户同意
        NSLog(@"errCode = %d", aresp.errCode);
        NSLog(@"code = %@", aresp.code);
        
        // 获取access_token
        //      格式：https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
        NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", @"wxb1e4458be71faee9", @"5ae9f5767bef4a3ff9245b3a7f4aa054", aresp.code];
        //wxb1e4458be71faee9
        //5ae9f5767bef4a3ff9245b3a7f4aa054
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *zoneUrl = [NSURL URLWithString:url];
            NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
            NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (data) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    _openid = [dic objectForKey:@"openid"]; // 初始化
                    _access_token = [dic objectForKey:@"access_token"];
                    NSLog(@"openid = %@", _openid);
                    NSLog(@"access = %@", [dic objectForKey:@"access_token"]);
                    NSLog(@"dic = %@", dic);
                    self.headimgurl = [dic objectForKey:@"headimgurl"]; // 传递头像地址
                    self.nickname = [dic objectForKey:@"nickname"]; // 传递昵称
                    self.openid = [dic objectForKey:@"openid"];
                    self.unionId = [dic objectForKey:@"unionid"];
                    [self getUserInfo]; // 获取用户信息
                }
            });
        });
    } else if (aresp.errCode == -2) {
        NSLog(@"用户取消登录");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Note1" object:nil];
    } else if (aresp.errCode == -4) {
        NSLog(@"用户拒绝登录");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Note1" object:nil];
    } else {
        NSLog(@"errCode = %d", aresp.errCode);
        NSLog(@"code = %@", aresp.code);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Note1" object:nil];
    }
}

// 获取用户信息
- (void)getUserInfo {
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", self.access_token, self.openid];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"openid = %@", [dic objectForKey:@"openid"]);
                NSLog(@"nickname = %@", [dic objectForKey:@"nickname"]);
                NSLog(@"sex = %@", [dic objectForKey:@"sex"]);
                NSLog(@"country = %@", [dic objectForKey:@"country"]);
                NSLog(@"province = %@", [dic objectForKey:@"province"]);
                NSLog(@"city = %@", [dic objectForKey:@"city"]);
                NSLog(@"headimgurl = %@", [dic objectForKey:@"headimgurl"]);
                NSLog(@"unionid = %@", [dic objectForKey:@"unionid"]);
                NSLog(@"privilege = %@", [dic objectForKey:@"privilege"]);
                
                self.headimgurl = [dic objectForKey:@"headimgurl"]; // 传递头像地址
                self.nickname = [dic objectForKey:@"nickname"]; // 传递昵称
                self.openid = [dic objectForKey:@"openid"];
                self.unionId = [dic objectForKey:@"unionid"];
                //                NSLog(@"appdelegate.headimgurl == %@", appdelegate.headimgurl); // 测试
                //                NSLog(@"appdelegate.nickname == %@", appdelegate.nickname);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Note" object:dic]; // 发送通知
            }
        });
    });
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Note1" object:nil];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return YES;
}


// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    return [WXApi handleOpenURL:url delegate:self];
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"LittleCool"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

#pragma mark - 监听网络链接

-(void)doNotFindNet{
//    self.isReachable = YES;
    //开启网络状况的监听
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"] ;
    [self.hostReach startNotifier];  //开始监听,会启动一个run loop
}
//网络链接改变时会调用的方法

-(void)reachabilityChanged:(NSNotification *)note{
    //     [self creatTopView];
    Reachability *currReach = [note object];
    NSParameterAssert([currReach isKindOfClass:[Reachability class]]);
    //对连接改变做出响应处理动作
    NetworkStatus status = [currReach currentReachabilityStatus];
    //如果没有连接到网络就弹出提醒实况
    NSString *titleString;
    if(status == NotReachable){
//        self.isReachable = NO;
        titleString = @"网络状态改变\n暂无网络";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:titleString message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"查看网络" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //在这里打开设置
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];

            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //无动作
        }];
        
        [alert addAction:cancelAction];
        [alert addAction:sureAction];
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }else if (status == kReachableViaWiFi){
        titleString = @"网络状态改变\nWiFi模式";
    }
    else{
        titleString = @"网络状态改变\n蜂窝移动网络模式";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:titleString message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"查看网络" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //在这里打开设置
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //无动作
        }];
        
        [alert addAction:cancelAction];
        [alert addAction:sureAction];
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }

    
    //    _times ++;
}


@end
