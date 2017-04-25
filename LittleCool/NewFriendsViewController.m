//
//  NewFriendsViewController.m
//  Qian
//
//  Created by 周博 on 17/3/6.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "NewFriendsViewController.h"
#import "NewFriendsTableViewCell.h"
#import "loadUserModel.h"
#import "BGItemsViewController.h"
#import "BorderHelper.h"

#define kCellName @"NewFriendsTableViewCell"

@interface NewFriendsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *_getCount;
}
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIView *jumpView;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) NSString *type;
@end

@implementation NewFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self UISetting];
    [self getNoti];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    BGNotiView *notiView2 = [[BGNotiView alloc] initWithFrame:CGRectMake(kScreenSize.width - 140, 64, 165, 50) contentText:@"点击添加更多好友" direction:up];
    [[BGNotiView defaultManager] showNotiViewByFrame:CGRectMake(kScreenSize.width - 165, 0, 165, 50) contentText:@"点击添加更多好友" direction:up inVC:self];
}

- (void)UISetting{
    _dataArray = [NSMutableArray array];
    _getCount = @"10";
    [self navBarTitle:@"      新的朋友"];
    [self navBarbackButton:@"通讯录" textFloat:10];
    [self wechatRightButtonClick:@"添加朋友"];
    [_searchBar setBackgroundImage:[UIImage new]];
    UITextField *textField = [_searchBar valueForKey:@"_searchField"];
    textField.layer.masksToBounds = YES;
    textField.layer.borderWidth = 0.5;
    textField.layer.borderColor = [kColorFrom0x(0xdedee0) CGColor];
    textField.layer.cornerRadius = kButtonCornerRadius ;
}

- (void)getNoti{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allowFriends:) name:@"allowFriends" object:nil];
}

- (void)navBarbackButton:(NSString *)title textFloat:(CGFloat)tFloat{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 6, 11, 18)];
    [button setImage:[UIImage imageNamed:@"zuokuohao.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backLastPage) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button1 setFrame:CGRectMake(tFloat, 0, 60, 30)];
    [button1 setTitle:title forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:16];
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

#pragma mark - 下载用户数据

- (void)loadUserData{
    [self hiddenView];
    if ([BGFunctionHelper isNULLOfString:_textField.text]) {
        kAlert(@"请输入有效数字");
        return;
    }
    if (_textField.text.integerValue <= 0) {
        kAlert(@"请输入有效数字");
        return;
    }
    
    [[AFClient shareInstance] getRandomUserByCounts:[NSString stringWithFormat:@"%ld",_textField.text.integerValue] progressBlock:nil success:^(id responseBody) {
        if ([responseBody[@"code"] integerValue] == 200) {
            if (_type.integerValue == 1) {//新建列表
                [self.dataArray removeAllObjects];
            }else if (_type.integerValue == 2){//添加列表

            }
            for (NSDictionary *dic in responseBody[@"data"]) {
                loadUserModel *user = [[loadUserModel alloc] init];
                [user setValuesForKeysWithDictionary:dic];
                user.type = @"1";
                [_dataArray addObject:user];
            }
            [_tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 点击事件

- (void)rightNavButtonClick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"新建列表" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _type = @"1";
        [self creatJumpView:@"请填写新建好友数"];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"添加列表" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _type = @"2";
        [self creatJumpView:@"请填写添加好友数"];
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"刷新列表" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _type = @"1";
        _textField.text = _dataArray.count > 0 ? [NSString stringWithFormat:@"%ld",_dataArray.count] : @"10";
        [self loadUserData];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)creatJumpView:(NSString *)title{
    UILabel *titleLabel;
    if (!_jumpView) {
        _jumpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
        _jumpView.backgroundColor = kClearColor;
        [self.view addSubview:_jumpView];
        
        //创建backButton
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, _jumpView.frame.size.width, _jumpView.frame.size.height);
        [backButton addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
        backButton.backgroundColor = kBlackColor;
        backButton.alpha = 0.3f;
        [_jumpView addSubview:backButton];
        
        //创建内容view
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(kScreenSize.width/6 , 120, kScreenSize.width/3*2, 160)];
        contentView.backgroundColor = kWhiteColor;
        contentView.layer.masksToBounds = YES;
        contentView.layer.cornerRadius = 10;
        [BorderHelper setBorderWithColor:kChatWhiteBorder view:contentView];
        [_jumpView addSubview:contentView];
        
        //titleLable
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, contentView.frame.size.width, 20)];
        titleLabel.text = title;
        titleLabel.textColor = kBlackColor;
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:titleLabel];
        
        //分割线
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, titleLabel.frame.size.height + titleLabel.frame.origin.y +10, contentView.frame.size.width, 0.5)];
        lineImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [contentView addSubview:lineImageView];
        
        //textField
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(20, titleLabel.frame.origin.y +titleLabel.frame.size.height +40, contentView.frame.size.width - 40, 30)];
        _textField.placeholder = @"请输入人数";
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        [contentView addSubview:_textField];
        
        //取消和确定按钮
        UIButton *cancelbutton = [UIButton buttonWithType:UIButtonTypeSystem];
        cancelbutton.frame = CGRectMake(0, _textField.frame.origin.y + _textField.frame.size.height + 30, contentView.frame.size.width/2, 40);
        [cancelbutton setTitle:@"取消" forState:UIControlStateNormal];
        [BorderHelper setBorderWithColor:[UIColor groupTableViewBackgroundColor] view:cancelbutton];
        [cancelbutton addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:cancelbutton];
        
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
        sureButton.frame = CGRectMake(contentView.frame.size.width/2, _textField.frame.origin.y + _textField.frame.size.height + 30, contentView.frame.size.width/2, 40);
        [sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [BorderHelper setBorderWithColor:[UIColor groupTableViewBackgroundColor] view:sureButton];
        [sureButton addTarget:self action:@selector(loadUserData) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:sureButton];
        
        contentView.frame = CGRectMake(contentView.frame.origin.x, contentView.frame.origin.y, contentView.frame.size.width, sureButton.frame.size.height + sureButton.frame.origin.y);
    }
    _textField.text = @"";
    titleLabel.text = title;
    [self showView];
}

- (void)hiddenView{
    [_textField resignFirstResponder];
    [UIView animateWithDuration:0.1 animations:^{
        _jumpView.alpha = 0;
    }];
}

- (void)showView{
    [_textField becomeFirstResponder];
    [UIView animateWithDuration:0.1 animations:^{
        _jumpView.alpha = 1;
    }];
}

/**
 返回键点击事件
 */
- (void)backLastPage{
    [self.navigationController popViewControllerAnimated:YES];
}

//添加朋友
- (void)allowFriends:(NSNotification *)noti{
    NSString *row = noti.object;
    loadUserModel *user = _dataArray[row.integerValue];

    UIImageView *imageV = [[UIImageView alloc] init];
    [imageV sd_setImageWithURL:[NSURL URLWithString:user.img_url]];
    
    [[FMDBHelper fmManger] createTableByTableName:kOthreUserTable];

    [[FMDBHelper fmManger] insertOtherUserInfoDataByTableName:kOthreUserTable Id:@"1" name:user.name headImage:UIImagePNGRepresentation(imageV.image) wechatNum:@"1" money:@"1"];

    user.type = @"-1";
    
    [_tableView reloadData];
    
}

#pragma mark - tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellName];
    loadUserModel *user = _dataArray[indexPath.row];
    cell.buttonGet.tag = indexPath.row;
    [cell showDataWithModel:user];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
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
