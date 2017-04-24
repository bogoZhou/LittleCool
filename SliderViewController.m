//
//  SliderViewController.m
//  Qian
//
//  Created by 周博 on 17/2/22.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "SliderViewController.h"

@interface BGSliderHelper ()

@end

@implementation BGSliderHelper

+ (instancetype)actionWithTitle:(NSString *)titleStr handler:(void (^)(BGSliderHelper *))handler{
    BGSliderHelper * bgItem = [BGSliderHelper new];
    bgItem.titleS = titleStr;
    bgItem.actionHandler = handler;
    return bgItem;
}

@end

@interface SliderViewController ()
{
    
}
@property (nonatomic,strong) BGSliderHelper *moreAction;
@property (nonatomic,strong) UISlider *slider;
@property (nonatomic,strong) NSString *sliderNum;
@property (nonatomic,strong) UILabel *targetLabel;
@end

@implementation SliderViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kClearColor;
    [self creatPickerView];

}

#pragma mark - 创建pickerView

- (void)creatPickerView{
    UIView *backGroundView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
    backGroundView.backgroundColor = [UIColor blackColor];
    backGroundView.alpha = 0.1;
    [self.view addSubview:backGroundView];
    
    UIView *pickerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenSize.height - 280, kScreenSize.width, 280)];
    pickerBackView.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = CGRectMake(0, 0, 80, 30);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(showDisappearAnimation) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    sureButton.frame = CGRectMake(kScreenSize.width - 80, 0, 80, 30);
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 30)];
    titleView.backgroundColor = [UIColor lightTextColor];
    [pickerBackView addSubview:titleView];
    
    
    UIView *pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, kScreenSize.width, 250)];
    pickerView.backgroundColor = kWhiteColor;
    
    _slider=[[UISlider alloc]initWithFrame:CGRectMake(60,130 ,kScreenSize.width - 120,30)];
    
    //设置最大值
    
    _slider.maximumValue=1;
    
    //设置最小值
    
    _slider.minimumValue=0.1/6;
    
    //设置默认值
    
    _slider.value=0.5f;
    
    //设置值（带有动画）
    
    //[slider setValue:.5 animated:YES];
    
    //添加事件
    
    [_slider addTarget:self action:@selector(valueChange) forControlEvents:(UIControlEventValueChanged)];
    
    //把slider添加到视图上进行显示
    
    
    _targetLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, kScreenSize.width, 30)];
    _targetLabel.textAlignment = NSTextAlignmentCenter;
    NSString * num = [NSString stringWithFormat:@"%f",_slider.value * 60];
    _targetLabel.text = [NSString stringWithFormat:@"%ld秒",num.integerValue];
    
    [pickerView addSubview:_targetLabel];
    [pickerView addSubview:_slider];
    
    
    [titleView addSubview:cancelButton];
    [titleView addSubview:sureButton];
    [pickerBackView addSubview:pickerView];
    [self.view addSubview:pickerBackView];
}

- (void)valueChange{
    NSString * num = [NSString stringWithFormat:@"%f",_slider.value * 60];
    _targetLabel.text = [NSString stringWithFormat:@"%ld秒",num.integerValue];
}

#pragma mark - 事件响应
- (void)didClickButton:(UIButton *)sender {
    BGSliderHelper *action = _moreAction;
    
    if (action.actionHandler) {
        action.titleS = [NSString stringWithFormat:@"%ld",_targetLabel.text.integerValue];
        action.actionHandler(action);
    }
    [self showDisappearAnimation];
}

//隐藏view
- (void)showDisappearAnimation {
    
    [UIView animateWithDuration:0 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark - 其他方法

- (void)addAction:(BGSliderHelper *)action{
    _moreAction = action;
}

#pragma mark - getter & setter

- (NSString *)title {
    return [super title];
}

- (BGSliderHelper  *)actions {
    return _moreAction;
}

- (BGSliderHelper *)moreAction {
    if (!_moreAction) {
        _moreAction = [[BGSliderHelper alloc] init];
    }
    return _moreAction;
}

//计算传入触发时间的view的绝对frame
- (CGRect)siziOfView:(UIView *)view{
    
    CGRect worldFrame = [view convertRect:view.frame toView:[[view superview] superview]];
    
    return worldFrame;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self showDisappearAnimation];
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
