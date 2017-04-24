//
//  ChooseChatViewController.m
//  Qian
//
//  Created by 周博 on 17/3/2.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "ChooseChatViewController.h"
#import "CreatSingleChatViewController.h"
#import "CreatGroupChatViewController.h"

@interface ChooseChatViewController ()

@end

@implementation ChooseChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navBarTitle:@"请选择"];
    [self navBarbackButton:@"返回"];
    [self buttonSetting];
}

- (void)buttonSetting{
    _buttonSingle.layer.masksToBounds = YES;
    _buttonSingle.layer.cornerRadius = kButtonCornerRadius;
    
    _buttonGroup.layer.masksToBounds = YES;
    _buttonGroup.layer.cornerRadius = kButtonCornerRadius;
}

- (IBAction)creatChatButtonClick:(UIButton *)sender {
    
    UIStoryboard *storyboard = kWechatStroyboard;
    
    if (sender.tag == 101) {
        CreatSingleChatViewController *singleVC = [storyboard instantiateViewControllerWithIdentifier:@"CreatSingleChatViewController"];
        [self.navigationController pushViewController:singleVC animated:YES];
    }else{
        CreatGroupChatViewController *groupVC = [storyboard instantiateViewControllerWithIdentifier:@"CreatGroupChatViewController"];
        [self.navigationController pushViewController:groupVC animated:YES];
    }
    
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
