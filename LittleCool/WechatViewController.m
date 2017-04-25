//
//  WechatViewController.m
//  Qian
//
//  Created by 周博 on 17/2/6.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "WechatViewController.h"
#import "ChatTableViewCell.h"
#import "AddView.h"
#import "BGItemsViewController.h"
#import "ChatDetailViewController.h"
#import "UnReadNumViewController.h"
#import "BorderHelper.h"
#import "ChooseChatViewController.h"
#import "WechatPayViewController.h"



#define kCellName @"ChatTableViewCell"

@interface WechatViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isHidden;
}
@property (nonatomic,strong) AddView *addView;
@property (nonatomic,strong) UIButton *rightBTN;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UIView *jumpView;
@end

@implementation WechatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBar];
//    [self navBarbackButton:@"        "];
//    [self loadImage];
    [self reSettingUI];
//    [self creatUSER];
}

//- (void)backLastPage{
//    [self.tabBarController.navigationController popViewControllerAnimated:YES];
//}

- (void)clickNavTitle:(UIButton *)button{
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithImage:[UIImage new]
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:@selector(onBack:)];
    self.tabBarController.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    [self getData];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    BGNotiView *notiView = [[BGNotiView alloc] initWithFrame:CGRectMake(0, (kScreenSize.height - 64)/2, 150, 50) contentText:@"侧滑返回上一页" direction:left];
    [[BGNotiView defaultManager] showNotiViewByFrame:CGRectMake(kScreenSize.width/2 - 75, 0, 150, 50) contentText:@"点我返回上一页" direction:up inVC:self];
    
//    BGNotiView *notiView2 = [[BGNotiView alloc] initWithFrame:CGRectMake(kScreenSize.width/2, 64 + _searchBar.sizeHeight + 65, 165, 50) contentText:@"侧滑进行更多操作" direction:up];
    [[BGNotiView defaultManager] showNotiViewByFrame:CGRectMake(kScreenSize.width/2 - 165/2,  _searchBar.sizeHeight + 65, 165, 50) contentText:@"侧滑进行更多操作" direction:up inVC:self];
    
}

- (void)setNavBar{
    _isHidden = NO;
    [self navBarTitle:@"微信"];
    [self navBarRButton];
    [_searchBar setBackgroundImage:[UIImage new]];
    UITextField *textField = [_searchBar valueForKey:@"_searchField"];
    textField.layer.masksToBounds = YES;
    textField.layer.borderWidth = 0.5;
    textField.layer.borderColor = [kColorFrom0x(0xdedee0) CGColor];
    textField.layer.cornerRadius = kButtonCornerRadius ;
    [BorderHelper setOnlyUnderLineColor:kColorFrom0x(0xd9d9d9) view:_searchBar];
}

- (void)navBarRButton{
    _rightBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBTN setFrame:CGRectMake(0, 0, 30, 30)];
    [_rightBTN setImage:[UIImage imageNamed:@"barbuttonicon_add.png"] forState:UIControlStateNormal];
    [_rightBTN addTarget:self action:@selector(searchProgram) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBTN];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -10;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightItem, nil];
    
}

- (void)reSettingUI{
    
    [[FMDBHelper fmManger] getFMDBBySQLName:kCreatSQL];
//    [[FMDBHelper fmManger] createTableByTableName:kUserTable];
    [[FMDBHelper fmManger] createTableByTableName:kOthreUserTable];
    UserInfoModel *model = [[UserInfoModel alloc] init];
    
    model = [[[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable] lastObject];
    UIImage *image;
    
    image = [UIImage imageWithData:model.headImage];
    if (!image) {
        [[FMDBHelper fmManger] getFMDBBySQLName:kCreatSQL];
        [[FMDBHelper fmManger] createTableByTableName:kOthreUserTable];
        
        UIImage *image = [UIImage imageNamed:@"pengyouquan_head.jpg"];
        NSData *imageData = UIImagePNGRepresentation(image);

//        [[FMDBHelper fmManger] insertMyUserInfoDataByTableName:kUserTable Id:@"1" name:@"有点逗" headImage:imageData wechatNum:@"cool" money:@"666"];
//        [[FMDBHelper fmManger] insertMyUserInfoDataByTableName:kOthreUserTable Id:@"1" name:@"有点逗" headImage:imageData wechatNum:@"cool" money:@"666"];
        [[FMDBHelper fmManger] insertOtherUserInfoDataByTableName:kOthreUserTable Id:@"1" name:@"有点逗" headImage:imageData wechatNum:@"cool" money:@"666"];
    }
}

#pragma mark - 点击右上角添加按钮
- (void)searchProgram{
    
    BGItemsViewController *bgC = [BGItemsViewController viewWithFrameBySuperView:_rightBTN];
    
    BGItemsAction * action1 = [BGItemsAction actionWithTitle:@"未读消息" handler:^(BGItemsAction *action) {
        NSLog(@"点击item1");
        UIStoryboard *storyboard = kWechatStroyboard;
        UnReadNumViewController *unread = [storyboard instantiateViewControllerWithIdentifier:@"UnReadNumViewController"];
        unread.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:unread animated:YES];
    }];
    
    BGItemsAction * action2 = [BGItemsAction actionWithTitle:@"添加朋友" handler:^(BGItemsAction *action) {
        
        UIStoryboard *storyboard = kWechatStroyboard;
        ChooseChatViewController *chooseChatVC = [storyboard instantiateViewControllerWithIdentifier:@"ChooseChatViewController"];
        chooseChatVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chooseChatVC animated:YES];
        
    }];
    
    BGItemsAction * action3 = [BGItemsAction actionWithTitle:@"清空列表" handler:^(BGItemsAction *action) {
        [[FMDBHelper fmManger] deleteTable:kChatListTable];
        [[FMDBHelper fmManger] deleteTable:kChatDetailTable];
        [self getData];
        [self.tableView reloadData];
    }];
    
    BGItemsAction * action4 = [BGItemsAction actionWithTitle:@"微信支付" handler:^(BGItemsAction *action) {
//        NSLog(@"点击item4");
//        kAlert(@"正在开发中...");
        
        NSInteger allNum = 0;
        NSArray *array = [[FMDBHelper fmManger] selectChatListWhereValue1:@"" value2:@"" isNeed:NO];
        for (ChatListModel *listModel in array) {
            allNum += listModel.redNum.integerValue;
        }
        
        UIStoryboard *storyboard = kWechatStroyboard;
        WechatPayViewController *payVC = [storyboard instantiateViewControllerWithIdentifier:@"WechatPayViewController"];
        [payVC navBarTitle:@"微信支付"];
        
        NSString *rightName = @"微信";
        NSString *rightName2 = [NSString stringWithFormat:@"%@(%ld)",@"微信",allNum];
        
        [payVC navBarbackButton:allNum > 0 ? rightName2 : rightName];
        payVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:payVC animated:YES];
    }];
    
    [bgC addActions:action1];
    [bgC addActions:action2];
    [bgC addActions:action3];
    [bgC addActions:action4];
    [self presentViewController:bgC animated:NO completion:nil];
}

- (void)getData{
    _dataArray = [NSMutableArray array];
    NSMutableArray *reverseArray = [NSMutableArray array];
    reverseArray = [[FMDBHelper fmManger] selectChatListWhereValue1:nil value2:nil isNeed:NO];
    _dataArray = (NSMutableArray *)[[reverseArray reverseObjectEnumerator] allObjects];
    [self countDeepNum];
}

- (void)creatAddView{
    if (!_addView) {
        _addView = [[[NSBundle mainBundle] loadNibNamed:@"AddView" owner:nil options:nil] lastObject];
        _addView.frame = CGRectMake(kScreenSize.width - 133, 4, 125, 146);
        [self creatGestureOnScrollView];
    }
    _addView.hidden = _isHidden;
    _isHidden = !_isHidden;
    [self.view addSubview:_addView];
}

#pragma mark - 设置tableview代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatListModel *model = _dataArray[indexPath.row];
    ChatTableViewCell *cell = (ChatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellName];
    if (!cell) {
        cell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellName];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageViewHeader.image = [UIImage imageWithData:model.userImage];
    cell.labelName.text = model.userName;
    cell.labelTime.text = [BGDateHelper getTimeStringFromNumberTimer:model.lastTime isMinuteLater:YES];
    cell.labelContent.text = model.lastContent;
    cell.imageViewLingdang.hidden = model.isNoti.integerValue > 0 ? YES : NO;
    cell.labelRed.hidden = model.redNum.integerValue > 0 ? NO : YES;
    cell.labelRed.text = model.redNum.integerValue > 99 ? @"···" : model.redNum;
    if (model.redNum.integerValue > 0 && model.redNum.integerValue < 10) {
        cell.labelRed.frame = CGRectMake(49, cell.labelRed.frame.origin.y, 17, cell.labelRed.frame.size.height);
    }else if (model.redNum.integerValue >= 10){
//        CGSize size = [@"···" boundingRectWithSize:CGSizeMake(kScreenSize.width - 65, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
        cell.labelRed.frame = CGRectMake(49 - 12 , cell.labelRed.frame.origin.y, 28, cell.labelRed.frame.size.height);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 67;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatListModel *model = _dataArray[indexPath.row];
    UserInfoModel *userModel = [[UserInfoModel alloc] init];
    userModel.headImage = model.userImage;
    userModel.name = model.userName;
    userModel.Id = model.userId;
    UIStoryboard *storyboard = kWechatStroyboard;
    ChatDetailViewController *chatDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"ChatDetailViewController"];
    chatDetailVC.roomId = model.chatRoomId;
    NSArray *isGroup = [userModel.Id componentsSeparatedByString:@","];
    if (isGroup.count > 1) {
        chatDetailVC.groupUsersId = userModel.Id;
        [chatDetailVC navBarTitle:[NSString stringWithFormat:@"%@(%@)",model.userName,model.chatDetailId]];
    }else{
        chatDetailVC.userId = userModel.Id;
        [chatDetailVC navBarTitle:model.userName];
    }
    chatDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatDetailVC animated:YES];
}

#pragma mark - 编辑删除按钮

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        kAlert(@"点击了删除")
        ChatListModel *model = _dataArray[indexPath.row];
        [[FMDBHelper fmManger] deleteDataByTableName:kChatListTable TypeName:@"chatRoomId" TypeValue:model.chatRoomId];
        [_dataArray removeObjectAtIndex:indexPath.row];
        [self countDeepNum];
        [_tableView reloadData];
    }];
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"标记未读" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        kAlert(@"点击了标记未读");
        [self creatJumpView:@"请输入未读数量" indexPath:indexPath.row];
    }];
    editAction.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return @[deleteAction, editAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    editingStyle = UITableViewCellEditingStyleDelete;
}


- (void)creatGestureOnScrollView{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewHiddenKeyboard)];
    tapGesture.numberOfTouchesRequired = 1;
    [_tableView addGestureRecognizer:tapGesture];
}

- (void)scrollViewHiddenKeyboard{
    _addView.hidden = YES;
    _isHidden = NO;
}

#pragma mark - 载入对象

- (void)creatUSER{
    //JSON文件的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"name.json" ofType:nil];
    [[FMDBHelper fmManger] createTableByTableName:kOthreUserTable];
    //加载JSON文件
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    //将JSON数据转为NSArray或NSDictionary
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray *nameArray = [NSMutableArray array];
    for (NSDictionary * nameDic in dict[@"data"]) {
        NSString *name = nameDic[@"name"];
        [nameArray addObject:name];
    }
    [[FMDBHelper fmManger] getFMDBBySQLName:kCreatSQL];

    NSMutableArray *array = [[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable];
    if (array.count == 0) {
        UserInfoModel * model = [[[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable] firstObject];

        [[FMDBHelper fmManger] insertOtherUserInfoDataByTableName:kOthreUserTable Id:@"1" name:model.name headImage:model.headImage wechatNum:@"666666" money:@"666"];
        
        
        [[FMDBHelper fmManger] creatImageTable];
        for (int i = 1; i <= nameArray.count ;i ++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"jpg%d.jpg",i]];
            NSData *imageData = UIImagePNGRepresentation(image);
            [[FMDBHelper fmManger] insertOtherUserInfoDataByTableName:kOthreUserTable Id:@"1" name:nameArray[i-1] headImage:imageData wechatNum:@"1" money:@"1"];
        }
        NSMutableArray *array = [[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable];
        NSLog(@"imageArray -> %@",array);
    }else{
        NSLog(@"已存在");
    }
}

#pragma mark - 创建弹框view
- (void)creatJumpView:(NSString *)title indexPath:(NSInteger)index{
    UILabel *titleLabel;
    UIButton *sureButton;
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"notiNum"];
    if (!_jumpView) {
        _jumpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
        _jumpView.backgroundColor = kClearColor;
        [self.view addSubview:_jumpView];
        
        //创建backButton
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, _jumpView.frame.size.width, _jumpView.frame.size.height);
//        [backButton addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
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
        
        sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
        sureButton.frame = CGRectMake(contentView.frame.size.width/2, _textField.frame.origin.y + _textField.frame.size.height + 30, contentView.frame.size.width/2, 40);
        [sureButton setTitle:@"确定" forState:UIControlStateNormal];
        
        [BorderHelper setBorderWithColor:[UIColor groupTableViewBackgroundColor] view:sureButton];
        [sureButton addTarget:self action:@selector(updateUserRed:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:sureButton];
        
        contentView.frame = CGRectMake(contentView.frame.origin.x, contentView.frame.origin.y, contentView.frame.size.width, sureButton.frame.size.height + sureButton.frame.origin.y);
    }
    
    _textField.text = @"";
    titleLabel.text = title;
    [self showView];
}

- (void)updateUserRed:(UIButton *)button{
    if ([BGFunctionHelper isNULLOfString:_textField.text]) {
        kAlert(@"请输入内容");
        return;
    }
    if (_textField.text.integerValue < 0) {
        kAlert(@"请输入正确数值");
        return;
    }
    NSString *num = [NSString stringWithFormat:@"%ld",_textField.text.integerValue];
    NSInteger notiNum = [[NSUserDefaults standardUserDefaults] integerForKey:@"notiNum"];
    ChatListModel *chatListModel = _dataArray[notiNum];
    [[FMDBHelper fmManger] updateDataByTableName:kChatListTable TypeName:@"redNum" typeValue0:num typeValue1:@"chatRoomId" typeValue2:chatListModel.chatRoomId];
    [self hiddenView];
    [self getData];
    [self countDeepNum];
    [self.tableView reloadData];
}

- (void)countDeepNum{
    NSInteger allNum = 0;
    NSArray *array = [[FMDBHelper fmManger] selectChatListWhereValue1:@"" value2:@"" isNeed:NO];
    for (ChatListModel *listModel in array) {
        allNum += listModel.redNum.integerValue;
    }
    if (allNum >0) {
        [[[self.tabBarController tabBar] items] objectAtIndex:0].badgeValue = [NSString stringWithFormat:@"%ld",allNum];
        [self navBarTitle:[NSString stringWithFormat:@"微信(%ld)",allNum]];
        if (allNum > 99) {
            [[[self.tabBarController tabBar] items] objectAtIndex:0].badgeValue = @"...";
            //···
        }
    }else{
        [[[self.tabBarController tabBar] items] objectAtIndex:0].badgeValue = nil;
        [self navBarTitle:@"微信"];
    }
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
