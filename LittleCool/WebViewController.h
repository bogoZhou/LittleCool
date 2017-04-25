//
//  WebViewController.h
//  LittleCool
//
//  Created by 周博 on 17/4/11.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BaseViewController.h"

@interface WebViewController : BaseViewController
@property (nonatomic,strong) NSString *jumpUrl;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
