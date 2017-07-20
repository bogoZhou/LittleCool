//
//  FriendsViewController.m
//  Qian
//
//  Created by 周博 on 17/2/12.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "FriendsViewController.h"

@interface FriendsViewController ()
{
    
}

@property (nonatomic,strong) UIButton *rightBTN;

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self UISetting];
}

- (void)UISetting{
    [self navBarTitle:@"朋友圈"];
    [self navBarbackButton:@"发现"];
    [self navBarRButton];
}

- (void)navBarRButton{
    _rightBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBTN setFrame:CGRectMake(0, 0, 30, 30)];
    [_rightBTN setImage:[UIImage imageNamed:@"barbuttonicon_add.png"] forState:UIControlStateNormal];
    [_rightBTN addTarget:self action:@selector(addFriends) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBTN];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightItem, nil];
    
}

#pragma 点击事件

- (void)addFriends{
    kAlert(@"添加朋友圈信息");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
