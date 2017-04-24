//
//  RedDetailViewController.m
//  Qian
//
//  Created by 周博 on 17/3/9.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "RedDetailViewController.h"
#import "RedDetailTableViewCell.h"

#define kCellName @"RedDetailTableViewCell"

@interface RedDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIImageView *navBarHairlineImageView;
}
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) ChatRedPacketModel *redModel;
@end

@implementation RedDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    
    [self navBarTitle:@"微信红包"];
    [self navBarbackButton:@"返回" textFloat:11];
    
    [self getData];
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    navBarHairlineImageView.hidden = YES;
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"state.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"WechatNavBar.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
}

#pragma mark - getData

- (void)getData{
    _dataArray = [NSMutableArray array];
    _redModel = [[[FMDBHelper fmManger] selectRedPacketWhereValue1:@"Id" value2:_redId isNeed:YES] lastObject];
    _dataArray = [[FMDBHelper fmManger] selectGetRedPacketUserWhereValue1:@"redId" value2:_redId isNeed:YES];
    [self updateView];
    [_tableView reloadData];
}

- (void)updateView{
    UserInfoModel *myModel = [[[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable] firstObject];
    
//    _imageViewHeader.image = [UIImage imageWithData:myModel.headImage];
    _imageViewHeader.image = [BGFunctionHelper getImageFromSandBoxByImagePath:myModel.headImage];
    _imageViewHeader.layer.masksToBounds = YES;
    _imageViewHeader.layer.cornerRadius = kButtonCornerRadius;
    _imageViewHeader.layer.borderWidth = 1;
    _imageViewHeader.layer.borderColor = [kColorFrom0x(0xfeba2b) CGColor];
    
    _labelName.text = [NSString stringWithFormat:@"%@的红包",myModel.name];
    
    _labelRedContent.text = _redModel.redContent;
    
    _labelMoney.font = [UIFont fontWithName:kWechatNumFont size:50];
    
    _labelContent.textColor = kColorFrom0x(0x9b9b9b);
    _labelContent.text = [NSString stringWithFormat:@"%@个红包共%@元，%lld秒被抢光",_redModel.redNum,_redModel.redMoney,(_redModel.endDate.longLongValue - _redModel.creatDate.longLongValue)/1000];
    
    BOOL haveMe = NO;
    for (GetRedUserModel *redUser in _dataArray) {
        if ([redUser.userId isEqualToString:myModel.Id]) {
            haveMe = YES;
            _labelMoney.text = redUser.getMoneyNum;
            break;
        }
    }
    if (!haveMe) {
        _viewMyGet.hidden = YES;
        _layoutHeadImageHeight.constant = 270 - _viewMyGet.sizeHeight;
        _headView.frame = CGRectMake(_tableView.tableHeaderView.orginX, _tableView.tableHeaderView.orginY  + 100, _headView.sizeWidth, _headView.sizeHeight - _viewMyGet.sizeHeight);
        _layoutContentHeight.constant = _layoutContentHeight.constant - _viewMyGet.sizeHeight;
        _imageViewBg.frame = CGRectMake(100, 100, kScreenSize.width, 150);
    }
}



#pragma mark - 创建导航栏
- (void)navBarbackButton:(NSString *)title textFloat:(CGFloat)tFloat{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 6, 11, 18)];
    [button setImage:[UIImage imageNamed:@"return1.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backLastPage) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button1 setFrame:CGRectMake(tFloat, 0, 40, 30)];
    [button1 setTitle:title forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:16];
    button1.tintColor = kColorFrom0x(0xffe0ab);
    [button1 setTitleColor:kColorFrom0x(0xffe0ab) forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(backLastPage) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    
    UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    
    [leftView addSubview:button];
    [leftView addSubview:button1];
    
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,leftItem, nil];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}
/**
 返回键点击事件
 */
- (void)backLastPage{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navBarTitle:(NSString *)title{
    UILabel *titleLabel = [[UILabel
                            alloc] initWithFrame:CGRectMake(0,0, 200, 44)];
    titleLabel.backgroundColor = kClearColor;
    
    titleLabel.font = [UIFont boldSystemFontOfSize:19];
    
    
    titleLabel.textColor = kColorFrom0x(0xffe0ab);
    
    titleLabel.textAlignment =  NSTextAlignmentCenter;
    
    titleLabel.text = title;
    
    self.navigationItem.titleView = titleLabel;
}

#pragma mark - tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RedDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellName];
    
    GetRedUserModel *getRedUser = _dataArray[indexPath.row];
    
    UserInfoModel *user = [[[FMDBHelper fmManger] selectUserInfoDataByValueName:@"Id" value:getRedUser.userId] lastObject];
    
//    cell.imageViewHeader.image = [UIImage imageWithData:user.headImage];
    cell.imageViewHeader.image = [BGFunctionHelper getImageFromSandBoxByImagePath:user.headImage];
    
    cell.labelName.text = user.name;
    
    if (getRedUser.userId.integerValue == 1) {//我
        cell.labelDate.textColor = kColorFrom0x(0x647297);
        cell.labelDate.text = @"留言";
    }else{
        cell.labelDate.textColor = kColorFrom0x(0x9b9b9b);
        cell.labelDate.text = [BGDateHelper getTimeArrayByTimeString:getRedUser.getMoneyDate][5];
    }
    
    
    cell.labelMoney.text = [NSString stringWithFormat:@"%@元",getRedUser.getMoneyNum];

    cell.viewBest.hidden = getRedUser.isGreat.integerValue > 0 ? NO : YES;
    
    cell.imageViewTopView.hidden = indexPath.row == 0 ? NO : YES;
    
    cell.imageViewDeepLong.hidden = indexPath.row == _dataArray.count -1 ? NO : YES;
    
    cell.imaegViewDeepShort.hidden = indexPath.row == _dataArray.count -1 ? YES : NO;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
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
