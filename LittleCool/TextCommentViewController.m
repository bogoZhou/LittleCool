//
//  TextCommentViewController.m
//  Qian
//
//  Created by 周博 on 17/2/19.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "TextCommentViewController.h"
#import "JTSTextView.h"

@interface TextCommentViewController ()<JTSTextViewDelegate>
{
    
}
@property (nonatomic,strong) JTSTextView *textView;
@end

@implementation TextCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self UISetting];
}

- (void)UISetting{
    [self rightButtonClick:@"发送" width:50 color:kWechatTabBarColor];
    
    _textView = [[JTSTextView alloc] initWithFrame:CGRectMake(5, 5, kScreenSize.width - 10, _viewText.frame.size.height) fontSize:16];
    [_viewText addSubview:_textView];
    _textView.tintColor = kWechatBlack;
//    _textView.textViewDelegate = self;
    [self.textView setText:@""];
}

- (void)rightButtonClick:(NSString *)string width:(CGFloat)width color:(UIColor *)color{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, width, 30)];
    [button setTitle:string forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    button.titleLabel.textColor = color;
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    [button addTarget:self action:@selector(rightNavButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -20;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,leftItem, nil];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

#pragma mark - 点击事件

- (void)rightNavButtonClick{
    kAlert(@"发送");
}

//选择位置
- (IBAction)chooseAddress:(UIButton *)sender {
    kAlert(@"正在开发中...");
}

//选择发送人
- (IBAction)choosePersonButtonClick:(UIButton *)sender {
    kAlert(@"选择发送人");
}

//选择发送时间
- (IBAction)chooseDateButtonClick:(UIButton *)sender {
    kAlert(@"选择发送时间");
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
