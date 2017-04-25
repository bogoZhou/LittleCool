//
//  ChooseLabelViewController.m
//  LittleCool
//
//  Created by 周博 on 17/3/14.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "ChooseLabelViewController.h"
#import "CitysModel.h"

@interface ChooseLabelViewController ()

@end

@implementation ChooseLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatContentView];
}

- (void)creatContentView{
    CGFloat width = (kScreenSize.width)/4;
    for (int i = 0 ; i < _dataArray.count; i ++) {
        CitysModel *model = _dataArray[i];
        
        UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(width * (i%4), 40 * (i/4), width, 30)];
        labelView.tag = 10000+i;
//        labelView.backgroundColor = kColorFrom0x(0xf6f6f6);
        labelView.backgroundColor = kClearColor;
        labelView.layer.masksToBounds = YES;
//        labelView.layer.cornerRadius = kButtonCornerRadius * 5;
        
        
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelView.sizeWidth, labelView.sizeHeight)];
        name.text = model.name;
        name.font = [UIFont systemFontOfSize:15];
        name.textAlignment = NSTextAlignmentCenter;
        name.tag = 11000+i;
        if (_buttonTag.integerValue == i) {
            name.textColor = kColorFrom0x(0x529df4);
        }
        [labelView addSubview:name];
        
        UIButton *button = [[UIButton alloc] initWithFrame:name.frame];
        [button setTitle:@"" forState:UIControlStateNormal];
        button.tag = 12000+i;
        [button addTarget:self action:@selector(chooseAnyLabel:) forControlEvents:UIControlEventTouchUpInside];
        [labelView addSubview:button];
        [_scrollViewContent addSubview:labelView];
        
        CGSize titleSize = [name.text boundingRectWithSize:CGSizeMake(kScreenSize.width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        
        UILabel *redLabel = [[UILabel alloc] initWithFrame:CGRectMake((labelView.sizeWidth - titleSize.width)/2 + titleSize.width - 4, 4, 10, 10)];
        redLabel.text = model.countNew;
        redLabel.textColor = kWhiteColor;
        redLabel.font = [UIFont systemFontOfSize:7];
        redLabel.backgroundColor = kRedColor;
        redLabel.textAlignment = NSTextAlignmentCenter;
        redLabel.layer.masksToBounds = YES;
        redLabel.layer.cornerRadius = 5;
        redLabel.hidden = model.countNew.integerValue > 0 ? NO :YES;
        [labelView addSubview:redLabel];
    }
    NSInteger lines = _dataArray.count%4 > 0 ? _dataArray.count/4+1:_dataArray.count/4;
    _scrollViewContent.contentSize = CGSizeMake(kScreenSize.width, 40*lines > _scrollViewContent.sizeHeight ? 40 *lines : _scrollViewContent.sizeHeight);
}

- (void)changeItems:(UIView *)view{
    view.layer.cornerRadius = 5;
    
    view.layer.shadowRadius = 1.6;
    view.layer.shadowColor = [[UIColor blackColor] CGColor];
    view.layer.shadowOffset = CGSizeMake(5, 7);
    view.layer.shadowOpacity=0.2;
}

#pragma mark - 点击事件
- (IBAction)backButtonClick:(UIButton *)sender {
    CATransition * animation = [CATransition animation];
    
    animation.duration = 0.5;    //  时间
    
    /**  type：动画类型
     *  pageCurl       向上翻一页
     *  pageUnCurl     向下翻一页
     *  rippleEffect   水滴
     *  suckEffect     收缩
     *  cube           方块
     *  oglFlip        上下翻转
     */
    animation.type = @"pageCurl";
    
    /**  type：页面转换类型
     *  kCATransitionFade       淡出
     *  kCATransitionMoveIn     覆盖
     *  kCATransitionReveal     底部显示
     *  kCATransitionPush       推出
     */
    animation.type = kCATransitionPush;
    
    //PS：type 更多效果请 搜索： CATransition
    
    /**  subtype：出现的方向
     *  kCATransitionFromRight       右
     *  kCATransitionFromLeft        左
     *  kCATransitionFromTop         上
     *  kCATransitionFromBottom      下
     */
    animation.subtype = kCATransitionFromTop;
    
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)chooseAnyLabel:(UIButton *)button{
    NSString *buttonTag = [NSString stringWithFormat:@"%ld",button.tag - 12000];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseItem" object:buttonTag];
    [self backButtonClick:nil];
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
