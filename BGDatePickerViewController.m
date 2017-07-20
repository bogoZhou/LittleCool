//
//  BGDatePickerViewController.m
//  Qian
//
//  Created by 周博 on 17/2/22.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BGDatePickerViewController.h"

@interface BGDatePickerAction ()

@end

@implementation BGDatePickerAction

+ (instancetype)actionWithTitle:(NSString *)titleStr handler:(void (^)(BGDatePickerAction *))handler{
    BGDatePickerAction * bgItem = [BGDatePickerAction new];
    bgItem.titleS = titleStr;
    bgItem.actionHandler = handler;
    return bgItem;
}

@end

@interface BGDatePickerViewController ()
{
    
}
@property (nonatomic,strong) BGDatePickerAction *moreAction;
@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic,strong) NSString *dateString;
@end

@implementation BGDatePickerViewController

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
    
    
    //创建datePicker
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0 , kScreenSize.width, 250)];
    
    [_datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    // 设置时区
    [_datePicker setTimeZone:[NSTimeZone localTimeZone]];
    
    // 设置当前显示时间
    [_datePicker setDate:[NSDate date] animated:YES];
    // 设置显示最大时间（此处为当前时间）
    [_datePicker setMaximumDate:[NSDate date]];
    // 设置UIDatePicker的显示模式
    [_datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    // 当值发生改变的时候调用的方法
    [_datePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    [pickerView addSubview:_datePicker];
    
    
    [titleView addSubview:cancelButton];
    [titleView addSubview:sureButton];
    [pickerBackView addSubview:pickerView];
    [self.view addSubview:pickerBackView];
}

- (void)datePickerValueChanged{
    NSLog(@"%@",_datePicker.date);
    
    NSDate *date = _datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _dateString = [dateFormatter stringFromDate:date];
    
}

#pragma mark - 事件响应
- (void)didClickButton:(UIButton *)sender {
    BGDatePickerAction *action = _moreAction;

    
    NSDate *date = _datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _dateString = [dateFormatter stringFromDate:date];
    
    if (action.actionHandler) {
        action.titleS = _dateString;
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

- (void)addAction:(BGDatePickerAction *)action{
    _moreAction = action;
}

#pragma mark - getter & setter

- (NSString *)title {
    return [super title];
}

- (BGDatePickerAction  *)actions {
    return _moreAction;
}

- (BGDatePickerAction *)moreAction {
    if (!_moreAction) {
        _moreAction = [[BGDatePickerAction alloc] init];
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
