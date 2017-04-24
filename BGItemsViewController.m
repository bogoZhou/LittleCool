//
//  BGItemsViewController.m
//  JumpViewItemsDemo
//
//  Created by 周博 on 16/12/22.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//

#import "BGItemsViewController.h"

@interface BGItemsAction    ()

@end

@implementation BGItemsAction

+ (instancetype)actionWithTitle:(NSString *)titleStr handler:(void (^)(BGItemsAction *))handler{
    BGItemsAction * bgItem = [BGItemsAction new];
    bgItem.titleS = titleStr;
    bgItem.actionHandler = handler;
    return bgItem;
}

@end

#define kThemeColor [UIColor colorWithRed:94/255.0 green:96/255.0 blue:102/255.0 alpha:1]
#define kButtonHeight 40

@interface BGItemsViewController ()
{
    UIView * _shadowView;
    UIView * _contentView;
    UIImageView * _underLine;
    
    BOOL _firstDisplay;
    
}

@property (strong, nonatomic) NSMutableArray *mutableActions;

@property (nonatomic,strong) NSArray *iconsArray;

@end

@implementation BGItemsViewController
+ (instancetype)viewWithFrameBySuperView:(UIView *)superView{
    BGItemsViewController * bgItemsView = [BGItemsViewController new];
//    bgItemsView.itemsWidth = superView.frame.size.width;
    bgItemsView.itemsWidth = 135;
    bgItemsView.superV = superView;
    return bgItemsView;
}

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
    
    _iconsArray = @[@"DropDown Menu White Bubble.png",@"Add Friend.png",@"Scan.png",@"Yen.png"];
    
    [self creatShadowView];
    
    [self creatContentView];
    
    [self creatAllButtons];
    
    [self creatAllSeparatorLine];
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.view.backgroundColor = [UIColor clearColor];
//    _itemsWidth = 125;
    [self updateAllButtonsFrame];
    [self updateAllSeparatorLineFrame];
    [self updateShadowAndContentViewFrame];
    [self showAppearAnimation];
}

//阴影层
- (void)creatShadowView {
    _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _itemsWidth, 175)];
    _shadowView.layer.masksToBounds = NO;
//    _shadowView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.25].CGColor;
//    _shadowView.layer.shadowRadius = 20;
//    _shadowView.layer.shadowOpacity = 1;
//    _shadowView.layer.shadowOffset = CGSizeMake(0, 10);
    
    [self.view addSubview:_shadowView];
}

//内容层
- (void)creatContentView {
//    CGRect fram = _shadowView.frame;
//    fram.origin.y = 15;
//    fram.size.height = _shadowView.frame.size.height + 15;
//    _shadowView.frame = fram;
    
    _contentView = [[UIView alloc] initWithFrame:_shadowView.frame];
//    _contentView.backgroundColor = [UIColor colorWithRed:250/255.0 green:251/255.0 blue:252/255.0 alpha:1];
    _contentView.backgroundColor = kColorFrom0x(0x49484A);
    _contentView.layer.cornerRadius = 2;
    _contentView.clipsToBounds = YES;
    
    UIImageView *imageView =[[UIImageView alloc] initWithFrame:CGRectMake(_shadowView.center.x + 70/2, -9, 15, 10)];
    imageView.image = [UIImage imageNamed:@"xiaosanjiao.png"];
    [_shadowView addSubview:imageView];
    
    [_shadowView addSubview:_contentView];
}

//创建所有按钮
- (void)creatAllButtons {
    
    for (int i=0; i<self.actions.count; i++) {
        
        UIImageView * iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15 , 10 + kButtonHeight * i, 20, 20)];
        
        iconImageView.image = [UIImage imageNamed:_iconsArray[i]];
        iconImageView.layer.masksToBounds = YES;
        iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.tag = 10+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [btn setTitle:self.actions[i].titleS forState:UIControlStateNormal];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
        [btn addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [_contentView addSubview:iconImageView];
        [_contentView addSubview:btn];
    }
}

//创建所有的分割线
- (void)creatAllSeparatorLine {
    
    if (!self.actions.count) {
        return;
    }
    
    //要创建的分割线条数
    NSInteger linesAmount = self.actions.count>1 ? self.actions.count : 0;
    
    for (int i=0; i<linesAmount-1; i++) {
        
        UIView *separatorLine = [UIView new];
        separatorLine.tag = 1000+i;
//        separatorLine.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1];
        separatorLine.backgroundColor = kColorFrom0x(0x5B5A5D);
        [_contentView addSubview:separatorLine];
    }
}

- (void)updateAllButtonsFrame {
    
    if (!self.actions.count) {
        return;
    }
    for (int i=0; i<self.actions.count; i++) {
        UIButton *btn = [_contentView viewWithTag:10+i];
        btn.frame = CGRectMake(0, kButtonHeight * i, _itemsWidth, kButtonHeight);
        
    }
}

- (void)updateAllSeparatorLineFrame {
    
    //分割线的条数
    NSInteger linesAmount = self.actions.count>1 ? self.actions.count : 0;
    for (int i=0; i<linesAmount; i++) {
        //获取到分割线
        UIView *separatorLine = [_contentView viewWithTag:1000+i];

        CGFloat x = 10;
        CGFloat y = kButtonHeight * (i+1) - 1;
        CGFloat width = _itemsWidth - x * 2;
        separatorLine.frame = CGRectMake(x, y, width, 0.5);
    }
}

- (void)updateShadowAndContentViewFrame {
    
    CGRect viewFrame = [self siziOfView:_superV];
    
    CGFloat allButtonHeight;
    if (!self.actions.count) {
        allButtonHeight = 0;
    }
    else {
        allButtonHeight = kButtonHeight*self.actions.count;
    }
    
    //更新警告框的frame
    CGRect frame = _shadowView.frame;
    frame.size.height = allButtonHeight;
    frame.origin.x = _superV.center.x - _itemsWidth + 20;
    frame.origin.y = viewFrame.origin.y + viewFrame.size.height + 13;
    _shadowView.frame = frame;
    
//    _shadowView.center = self.view.center;
    _contentView.frame = _shadowView.bounds;
}

#pragma mark - 事件响应
- (void)didClickButton:(UIButton *)sender {
    BGItemsAction *action = self.actions[sender.tag-10];
    if (action.actionHandler) {
        action.actionHandler(action);
    }
    [self showDisappearAnimation];
}

//隐藏view
- (void)showDisappearAnimation {
    
    [UIView animateWithDuration:0 animations:^{
        _contentView.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark - 其他方法

- (void)addActions:(BGItemsAction *)actions;{
    [self.mutableActions addObject:actions];
}

- (UILabel *)creatLabelWithFontSize:(CGFloat)fontSize {
    
    UILabel *label = [UILabel new];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = kThemeColor;
    return label;
}

- (void)showAppearAnimation {
    
    if (_firstDisplay) {
        _firstDisplay = NO;
        _shadowView.alpha = 0;
        _shadowView.transform = CGAffineTransformMakeTranslation(0, -20);
//        _shadowView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _shadowView.transform = CGAffineTransformIdentity;
            _shadowView.alpha = 1;
        } completion:nil];
    }
}

- (void)showDisappearAnimation1 {
    
    [UIView animateWithDuration:0.1 animations:^{
        _contentView.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark - getter & setter

- (NSString *)title {
    return [super title];
}

- (NSArray<BGItemsAction *> *)actions {
    return [NSArray arrayWithArray:self.mutableActions];
}

- (NSMutableArray *)mutableActions {
    if (!_mutableActions) {
        _mutableActions = [NSMutableArray array];
    }
    return _mutableActions;
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
