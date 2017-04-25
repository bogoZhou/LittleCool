//
//  AddressBookViewController.m
//  Qian
//
//  Created by 周博 on 17/2/6.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "AddressBookViewController.h"
#import "AddressBookTableViewCell.h"
#import "ChatDetailViewController.h"
#import "NewFriendsViewController.h"

#define kCellName @"AddressBookTableViewCell"

@interface AddressBookViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    //搜索结果显示控制器 (内部有个tableView 经常 和UISearchBar一起使用)
    UISearchDisplayController *_disPlayC;
    
    //搜索结果数据源数组
    NSMutableArray *_resultsArr;
    
    //保存每个分区的 展开状态
    NSMutableArray *_sectionsStatuArr;
    
    NSInteger _itemsNum;
}
@property (nonatomic,strong) UIButton *rightBTN;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation AddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navBarTitle:@"通讯录"];
    [self navBarRButton];
    [_searchBar setBackgroundImage:[UIImage new]];
    UITextField *textField = [_searchBar valueForKey:@"_searchField"];
    textField.layer.masksToBounds = YES;
    textField.layer.borderWidth = 0.5;
    textField.layer.borderColor = [kColorFrom0x(0xdedee0) CGColor];
    textField.layer.cornerRadius = kButtonCornerRadius ;
//    _searchBar.searchBarStyle =UISearchBarStyleMinimal;
//    [self stetp];
//    NSMutableArray *array = [[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable];
//    NSLog(@"%@",array);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
//    NSMutableArray *array = [[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable];
//    if (_itemsNum != array.count) {
        [self stetp];
        [self.tableView reloadInputViews];
        [self.tableView reloadData];
//    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    BGNotiView *notiView2 = [[BGNotiView alloc] initWithFrame:CGRectMake(kScreenSize.width/2, 64 + _searchBar.sizeHeight + 30, 165, 50) contentText:@"点击添加更多好友" direction:up];
    [[BGNotiView defaultManager] showNotiViewByFrame:CGRectMake(kScreenSize.width/2 - 165/2, _searchBar.sizeHeight + 30, 165, 50) contentText:@"点击添加更多好友" direction:up inVC:self];
}

- (void)navBarRButton{
    _rightBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBTN setFrame:CGRectMake(0, 0, 50, 50)];
    [_rightBTN setImage:[UIImage imageNamed:@"contacts_add_friend"] forState:UIControlStateNormal];
    [_rightBTN addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBTN];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -20;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, rightItem, nil];
    
}

- (void)addFriend{
    //并没有用
}

//点击添加朋友
- (IBAction)addNewFriends:(UIButton *)sender {
    UIStoryboard *storyboard = kWechatStroyboard;
    NewFriendsViewController *newFriendsVC = [storyboard instantiateViewControllerWithIdentifier:@"NewFriendsViewController"];
    newFriendsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newFriendsVC animated:YES];
}

- (void)stetp{
    self.dataArray = [NSMutableArray array];
    [self dataInit];
}


#pragma mark - tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSMutableArray *array = [[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable];
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressBookTableViewCell *cell = (AddressBookTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellName];
//    NSMutableArray *array = [[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable];
    UserInfoModel *model = self.dataArray[indexPath.section][indexPath.row];

    cell.imageViewheader.image = [UIImage imageWithData:model.headImage];
    cell.labelName.text = [NSString stringWithFormat:@"%@",model.name];

    if ([self.dataArray[indexPath.section] count]-1== indexPath.row) {
        cell.imageViewUnderLine.hidden = YES;
    }else{
        cell.imageViewUnderLine.hidden = NO;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([self.dataArray[section] count] == 0) {
        return 0;
    }else{
        return 22;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = kWechatStroyboard;
    UserInfoModel *model = self.dataArray[indexPath.section][indexPath.row];
    ChatDetailViewController *chatDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"ChatDetailViewController"];
    [chatDetailVC navBarTitle:model.name];
//    [chatDetailVC showDataWithUserInfo:model];
    ChatListModel *listModel = [[[FMDBHelper fmManger] selectChatListWhereValue1:@"userId" value2:model.Id isNeed:YES] lastObject];
    if ([model.Id isEqualToString:listModel.userId]) {
        chatDetailVC.roomId = listModel.chatRoomId;
    }
    chatDetailVC.userId = model.Id;
    chatDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatDetailVC animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    footer.textLabel.font = [UIFont systemFontOfSize:14];
    [footer.textLabel setTextColor:kColorFrom0x(0x8e8e93)];
    footer.backgroundView.backgroundColor = [UIColor groupTableViewBackgroundColor];
}



#pragma mark - 数据排序
- (void)dataInit {
    
    _sectionsStatuArr = [[NSMutableArray alloc] init];
    //初始化26个状态
    //    for (NSInteger i = 0; i < 26; i++) {
    //        //默认关闭
    //        [_sectionsStatuArr addObject:@(kStatusOpen)];
    //    }
    
    //数据源数组
    self.dataArray = [[NSMutableArray alloc] init];
    
    //创建 26个 一维数组  对应 26个分区
    for (NSInteger i = 0; i < 27; i++) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [self.dataArray addObject:arr];
    }
    [self getData];
    _tableView.sectionIndexColor = kWechatBlack;
    _tableView.sectionIndexBackgroundColor = kClearColor;
}

- (void)getData{
    NSMutableArray *array = [[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable];
    _itemsNum = array.count;
    for (UserInfoModel *model in array) {
        NSMutableString *mutableStr = [NSMutableString stringWithString:model.name];
        /**
         *  可以把汉字转化为拼音 把mutableStr  直接修改 如果 转换成功 返回yes 失败返回 no
         参数1  要转换可变字符串地址 需要强制转换成底层的
         2. 转换的范围 转换汉字的范围 0/NULL 转换全部
         3. 转换的拼音是否带声调
         kCFStringTransformMandarinLatin  带声调
         kCFStringTransformStripDiacritics  不带声调
         4. 是否逆序
         */
//        NSLog(@"%@",model.name);
        BOOL ret = CFStringTransform((__bridge CFMutableStringRef)mutableStr, NULL, kCFStringTransformMandarinLatin, NO);
        if (ret) {
            
            //在转换成不带声调的(先转成带声调 再转不带声调)
            CFStringTransform((__bridge CFMutableStringRef)mutableStr, NULL, kCFStringTransformStripDiacritics, NO);
            //获取姓的第一个字符 放入指定的一维数组中
            unichar c = [mutableStr characterAtIndex:0];
            if (c-'a' < 0 || c-'a'>=26) {
                [self.dataArray[26] addObject:model];
            }else{
                [self.dataArray[c-'a'] addObject:model];
            }
            
        }
    }
//    for (int i = 0; i < _dataArray.count; i ++) {
//        NSMutableArray *array = [NSMutableArray array];
//        array = _dataArray[i];
//        if (array.count == 0) {
//            [_dataArray removeObject:array];
//        }
//    }
//    NSLog(@"");
}
//右侧 索引 一般是和 分区 对应
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *arr = [NSMutableArray array];
    //第0个显示#
    [arr addObject:UITableViewIndexSearch];
    for (NSInteger i = 0; i < _dataArray.count; i++) {
        NSString * str;
        if (i == 26) {
            str = [NSString stringWithFormat:@"%C",(unichar)('#')];
        }else{
            if ([_dataArray[i] count] == 0) {
                continue;
            }else{
                str = [NSString stringWithFormat:@"%C",(unichar)('A'+i)];
            }
            
        }
        //NSString *str = [NSString stringWithFormat:@"%d",i];
        //把一个索引字符串 放入数组
        [arr addObject:str];
    }
    
    return arr;//返回数组 这个数组中的字符串 可以对应26个分区
}
//点击右侧 索引 会调用
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    //index  就是 点击的 第几个索引
    //title 就是 索引标题
    return index-1;
    //返回 对应的索引值（和分区对应）
}

//头标
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self.dataArray[section] count] == 0) {
        return nil;
    }else if (section == self.dataArray.count - 1){
        return @"#";
    }else{
        return [NSString stringWithFormat:@"%C",(unichar)('A'+section)];
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
