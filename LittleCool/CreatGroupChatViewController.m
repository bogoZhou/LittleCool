//
//  CreatGroupChatViewController.m
//  Qian
//
//  Created by 周博 on 17/3/2.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "CreatGroupChatViewController.h"
#import "ChooseAnyUsersViewController.h"
#import "UIImage+Addtions.h"
#import "loadUserModel.h"

@interface CreatGroupChatViewController ()
{
    NSInteger _addressNum;
    NSInteger _autoNum;
}
@property (nonatomic,strong) UIView *addressBookView;

@property (nonatomic,strong) UIView *autoView;

@property (nonatomic,strong) NSMutableArray *allUserArray;

@property (nonatomic,strong) NSArray *addressArray;

@property (nonatomic,strong) NSMutableArray *autoArray;
@end

@implementation CreatGroupChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navBarTitle:@"创建群聊"];
    [self navBarbackButton:@"返回"];
    [self wechatRightButtonClick:@"完成"];
    [self creatGestureOnScrollView:_backScroll];
    [self autoAddTextViewSetting];
    self.allUserArray = [NSMutableArray array];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newPersons:) name:@"qunliao" object:nil];
    [self labelTrueNumSetting];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    BGNotiView *notiView2 = [[BGNotiView alloc] initWithFrame:CGRectMake(kScreenSize.width/2, 300, 170, 110) contentText:@"若人数不足,请输入自动添加数量\n待数据加载完毕后点击完成" direction:up];
    [[BGNotiView defaultManager] showNotiViewByFrame:CGRectMake(kScreenSize.width/2, 236, 170, 110) contentText:@"若人数不足,请输入自动添加数量\n待数据加载完毕后点击完成" direction:up inVC:self];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
//    _layoutHeight.constant = _viewAutoAdd.frame.size.height + _viewAutoAdd.frame.origin.y;
//    _layoutWidth.constant = kScreenSize.width;
}

- (void)autoAddTextViewSetting{
    [_textFieldAutoAdd addTarget:self action:@selector(endAutoAddTextViewEditing) forControlEvents:UIControlEventEditingDidEnd];
//    _textFieldAutoAdd.delegate = self;
}

//设置实际聊天人数
- (void)labelTrueNumSetting{
    _labelTrueNum.text = [NSString stringWithFormat:@"实际聊天对象(%ld)人",_addressNum + _autoNum];

}

#pragma mark - 创建选择用户下方数量

- (void)creatUserListFromAddressBook:(NSArray *)array{
    if (array == nil || array.count == 0) {
        return;
    }
    [_addressBookView removeFromSuperview];
    _addressBookView = nil;
    _addressBookView = [[UIView alloc] initWithFrame:CGRectMake(0, _viewAddressBook.frame.size.height + _viewAddressBook.frame.origin.y, kScreenSize.width, 0)];
    
    /**
     每行取商,如果刚好被除尽直接取商,若除不尽则+1
     */
    CGFloat imageWidth = (kScreenSize.width - 60)/5;
    int k = 5;
    for (int i = 0 ; i < (array.count-1)/5 +1; i ++) {
        
        if (i == array.count/5) {
            k = array.count%5;
        }
        
        for (int j = 0 ; j < k; j ++) {
            UserInfoModel *user = array[5*i+j];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 +(10 + imageWidth) * j,10 + (10 + imageWidth) * i, imageWidth, imageWidth)];
            
//            imageView.image = [UIImage imageWithData:user.headImage];
            imageView.image = [BGFunctionHelper getImageFromSandBoxByImagePath:user.headImage];
            imageView.userInteractionEnabled = YES;
            [_addressBookView addSubview:imageView];
        }
    }
    _addressBookView.frame = CGRectMake(0, _viewAddressBook.frame.size.height + _viewAddressBook.frame.origin.y, kScreenSize.width, (imageWidth + 10) *((array.count -1)/5 + 1) + 10);
    [self.viewScroll addSubview:_addressBookView];
    
    _viewAutoAdd.frame = CGRectMake(0, _addressBookView.frame.size.height + _addressBookView.frame.origin.y, kScreenSize.width, _viewAutoAdd.frame.size.height);
    
    if (_autoView) {
        _autoView.frame = CGRectMake(0, _viewAutoAdd.frame.origin.y + _viewAutoAdd.frame.size.height, kScreenSize.width, _autoView.frame.size.height);
        
        self.backScroll.contentSize = CGSizeMake(kScreenSize.width, _autoView.frame.size.height + _autoView.frame.origin.y + 50);
    }else{
        
        self.backScroll.contentSize = CGSizeMake(kScreenSize.width, _viewAutoAdd.frame.size.height + _viewAutoAdd.frame.origin.y + 50);
    }

    [self updateViewConstraints];
}

- (void)creatUserListFromAutoPerson:(NSArray *)array{
    if (array == nil || array.count == 0) {
        return;
    }
    [_autoView removeFromSuperview];
    _autoView = nil;
    _autoView = [[UIView alloc] initWithFrame:CGRectMake(0, _viewAutoAdd.frame.origin.y + _viewAutoAdd.frame.size.height, kScreenSize.width, 0)];
    
    /**
     每行取商,如果刚好被除尽直接取商,若除不尽则+1
     */
    CGFloat imageWidth = (kScreenSize.width - 60)/5;
    int k = 5;
    for (int i = 0 ; i < (array.count-1)/5 +1; i ++) {
        
        if (i == array.count/5) {
            k = array.count%5;
        }
        
        for (int j = 0 ; j < k; j ++) {
            UserInfoModel *user = array[5*i+j];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 +(10 + imageWidth) * j,10 + (10 + imageWidth) * i, imageWidth, imageWidth)];
            
//            imageView.image = [UIImage imageWithData:user.headImage];
            imageView.image = [BGFunctionHelper getImageFromSandBoxByImagePath:user.headImage];
            imageView.userInteractionEnabled = YES;
            [_autoView addSubview:imageView];
        }
        _autoView.frame = CGRectMake(0, _viewAutoAdd.frame.origin.y + _viewAutoAdd.frame.size.height, kScreenSize.width, (imageWidth + 10) *((array.count -1)/5 + 1) + 10);
        
        self.backScroll.contentSize = CGSizeMake(kScreenSize.width, _autoView.frame.size.height + _autoView.frame.origin.y + 50);
        
        [self.viewScroll addSubview:_autoView];
    }
}

- (void)creatAutoUserListFromAutoPerson:(NSArray *)array{
    if (array == nil || array.count == 0) {
        return;
    }
    [_autoView removeFromSuperview];
    _autoView = nil;
    _autoView = [[UIView alloc] initWithFrame:CGRectMake(0, _viewAutoAdd.frame.origin.y + _viewAutoAdd.frame.size.height, kScreenSize.width, 0)];
    
    /**
     每行取商,如果刚好被除尽直接取商,若除不尽则+1
     */
    CGFloat imageWidth = (kScreenSize.width - 60)/5;
    int k = 5;
    for (int i = 0 ; i < (array.count-1)/5 +1; i ++) {
        
        if (i == array.count/5) {
            k = array.count%5;
        }
        
        for (int j = 0 ; j < k; j ++) {
            loadUserModel *user = array[5*i+j];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 +(10 + imageWidth) * j,10 + (10 + imageWidth) * i, imageWidth, imageWidth)];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:user.img_url]];
            imageView.userInteractionEnabled = YES;
            [_autoView addSubview:imageView];
        }
        _autoView.frame = CGRectMake(0, _viewAutoAdd.frame.origin.y + _viewAutoAdd.frame.size.height, kScreenSize.width, (imageWidth + 10) *((array.count -1)/5 + 1) + 10);
        
        self.backScroll.contentSize = CGSizeMake(kScreenSize.width, _autoView.frame.size.height + _autoView.frame.origin.y + 50);
        
        [self.viewScroll addSubview:_autoView];
    }
}

#pragma mark - 通知事件

- (void)newPersons:(NSNotification *)noti{
    //用数组来接受
    NSArray *array = noti.object;
    _addressNum = array.count;
    
    _addressArray = array;
    
    [self labelTrueNumSetting];
    
    [self creatUserListFromAddressBook:array];
}

- (void)endAutoAddTextViewEditing{
    _autoNum = _textFieldAutoAdd.text.integerValue;
    
    _autoArray = [NSMutableArray array];

    [[AFClient shareInstance] getRandomUserByCounts:_textFieldAutoAdd.text progressBlock:nil success:^(id responseBody) {
        if ([responseBody[@"code"] integerValue] == 200) {
            for (NSDictionary *dic in responseBody[@"data"]) {

                NSString *imgUrl = dic[@"img_url"];

                loadUserModel *userInfo = [[loadUserModel alloc] init];
                userInfo.name = dic[@"name"];
                userInfo.img_url = imgUrl;

                [_autoArray addObject:userInfo];
            }
            [self labelTrueNumSetting];

            [self creatAutoUserListFromAutoPerson:_autoArray];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 点击事件

- (IBAction)addFromAddressBook:(UIButton *)sender {
    [self.view endEditing:YES];
    UIStoryboard *storyboard = kWechatStroyboard;
    ChooseAnyUsersViewController *chooseAnyVC = [storyboard instantiateViewControllerWithIdentifier:@"ChooseAnyUsersViewController"];
    chooseAnyVC.chooseNum = @"-1";
    chooseAnyVC.notiName = @"qunliao";
    [self.navigationController pushViewController:chooseAnyVC animated:YES];
}


//完成
- (void)rightNavButtonClick{
    [self.view endEditing:YES];
    if ([BGFunctionHelper isNULLOfString:_textFieldGroupName.text]) {
        kAlert(@"请输入群名称");
        return;
    }
    if (_autoNum + _addressNum == 0) {
        kAlert(@"实际群聊人数不应该少于0");
        return;
    }
    if (_addressNum + _autoNum > _textFieldGroupNum.text.integerValue) {
        kAlert(@"实际群聊人数不应该多于群人数");
        return;
    }
    
//    //将我自己添加到聊天数组中
//    UserInfoModel *me = [[[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable] firstObject];
//    [_allUserArray addObject:me];
    
    //将选中的所有用户添加到alluserArray 中
    for (UserInfoModel *model in _addressArray) {
        [_allUserArray addObject:model];
    }
    for (loadUserModel *model in _autoArray) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.img_url]];
        [[FMDBHelper fmManger] insertOtherUserInfoDataByTableName:kOthreUserTable Id:@"1" name:model.name headImage:[BGFunctionHelper saveImageToSandBoxByImage:imageView.image] wechatNum:@"1" money:@"1"];
        UserInfoModel *user = [[[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable] lastObject];
        [_allUserArray addObject:user];
    }
    
    //拼接userID
    NSString *usersId ;
    
    NSMutableArray *imgArr = [NSMutableArray array];
    
    for (UserInfoModel *user in _allUserArray) {
        if (!usersId) {
            usersId = user.Id;
        }else{
            usersId = [NSString stringWithFormat:@"%@,%@",usersId,user.Id];
        }
        UIImage *image = [BGFunctionHelper getImageFromSandBoxByImagePath:user.headImage];
        [imgArr addObject:image];
    }
    
    //创建聊天list图片
    
    UIImage *headImage = [UIImage groupIconWith:imgArr bgColor:kColorFrom0x(0xdddee0)];
    
    [[FMDBHelper fmManger] creatChatListTable];
    
    [[FMDBHelper fmManger] insertChatListByTableName:kChatListTable lastTime:[BGDateHelper getTimeStempByString:[BGDateHelper seeDay][5] havehh:YES] chatDetailId:_textFieldGroupNum.text isNoti:@"1" userImage:[BGFunctionHelper saveImageToSandBoxByImage:headImage] userName:_textFieldGroupName.text lastContent:@""  userId:usersId];

    [self.navigationController popToViewController:[self.navigationController.viewControllers firstObject] animated:YES];
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
