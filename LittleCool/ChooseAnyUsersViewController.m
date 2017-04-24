//
//  ChooseAnyUsersViewController.m
//  Qian
//
//  Created by 周博 on 17/2/25.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "ChooseAnyUsersViewController.h"
#import "AddressBookTableViewCell.h"

#define kCellName @"AddressBookTableViewCell"


@interface ChooseAnyUsersViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    //搜索结果数据源数组
    NSMutableArray *_resultsArr;
    
    //保存每个分区的 展开状态
    NSMutableArray *_sectionsStatuArr;
    
    NSInteger _itemsNum;
    NSInteger _chooseCount;
    BOOL _isFirst;
}
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *chooseArray;
@property (nonatomic,strong) NSMutableArray *copyedChooseArray;

@end

@implementation ChooseAnyUsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navBarTitle:@""];
    [self wechatRightButtonClick:@"完成"];
    [self navBarbackButton:@"返回"];
    [self stetp];
//    NSMutableArray *array = [[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable];
}


- (void)addFriend{
    
}

- (void)rightNavButtonClick{
    NSMutableArray *chooseCities = [NSMutableArray array];
    for (int i = 0; i < _chooseArray.count; i ++ ) {//读取分区
        NSMutableArray *sonArr = _chooseArray[i];
        for (int j = 0; j < sonArr.count; j ++) {//对每个分区进行解析
            NSString *str = sonArr[j];
            if ([str isEqualToString:@"1"]) {
                [chooseCities addObject:_dataArray[i][j]];
            }
        }
    }
    
//    NSLog(@"%@",chooseCities);

    
    
//    if (_chooseNum.integerValue == 1) {
//        UserInfoModel *model = chooseCities.lastObject;
//        [[NSNotificationCenter defaultCenter] postNotificationName:_notiName object:model.Id];
//    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:_notiName object:chooseCities];
//    }

    [self.navigationController popViewControllerAnimated:YES];
}




- (void)stetp{
    NSArray *choosedUserArray = [[FMDBHelper fmManger] selectGetRedPacketUserWhereValue1:@"redId" value2:_redPacketId isNeed:YES];
    _chooseNum = [NSString stringWithFormat:@"%ld",_chooseNum.integerValue - choosedUserArray.count];
    _isFirst = YES;
    self.copyedChooseArray = [NSMutableArray array];
    self.chooseArray = [NSMutableArray array];
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
    UserInfoModel *model = self.dataArray[indexPath.section][indexPath.row];
    NSInteger i = 0;
    //如果红包id存在  查抢红包用户表 看是否已经有人抢过
    if (_redPacketId) {
        [[FMDBHelper fmManger] createGetRedPacketUserTable];
        NSArray *choosedUserArray = [[FMDBHelper fmManger] selectGetRedPacketUserWhereValue1:@"redId" value2:_redPacketId isNeed:YES];
        if (i < choosedUserArray.count) {
            //有人抢过
            if (choosedUserArray.count > 0) {
                //遍历抢红包用户表,比对userId 若存在则改变选择数组的值
                for (GetRedUserModel *getRedModel in choosedUserArray) {
                    if ([getRedModel.userId isEqualToString:model.Id]) {
                        self.chooseArray[indexPath.section][indexPath.row] = @"1";
                        _copyedChooseArray[indexPath.section][indexPath.row] = @"1";
                    }
                }
            }
            i++;
        }
    }
    NSString *chooseStr = self.chooseArray[indexPath.section][indexPath.row];

    //    NSMutableArray *array = [[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable];
    
    
    if ([chooseStr isEqualToString:@"1"]) {
        cell.imageViewSelect.image = kSelect1;
    }else{
        cell.imageViewSelect.image = kUnselect1;
    }
    
   
    
//    cell.imageViewheader.image = [UIImage imageWithData:model.headImage];
    cell.imageViewheader.image = [BGFunctionHelper getImageFromSandBoxByImagePath:model.headImage];
    cell.labelName.text = [NSString stringWithFormat:@"%@",model.name];
//    [cell showImageSelect:kSelect];
    if ([self.dataArray[indexPath.section] count] -1== indexPath.row) {
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
    AddressBookTableViewCell *cell = (AddressBookTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    NSString *chooseStr = self.chooseArray[indexPath.section][indexPath.row];

    
    
    NSString *copyChooseStr = _copyedChooseArray[indexPath.section][indexPath.row];
    
    
    
    if ([chooseStr isEqualToString:@"0"]) {//选中
        if (_chooseNum.integerValue == -1) {
            self.chooseArray[indexPath.section][indexPath.row] = @"1";
            cell.imageViewSelect.image = kUnselect;
            _chooseCount ++;
        }else if (_chooseCount < _chooseNum.integerValue) {
            self.chooseArray[indexPath.section][indexPath.row] = @"1";
            cell.imageViewSelect.image = kUnselect;
            _chooseCount ++;
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"最多选取%@个对象",_chooseNum] message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction: action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }else{//未选中
        if ([copyChooseStr isEqualToString:@"1"]) {
            kAlert(@"已经选过,不可更改");
            return;
        }

        self.chooseArray[indexPath.section][indexPath.row] = @"0";
        cell.imageViewSelect.image = kSelect1;
        _chooseCount --;
        
    }
    [self.tableView reloadData];
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
    
    for (int j = 0; j < self.dataArray.count; j ++) {
        NSMutableArray * arr = self.dataArray[j];
        NSMutableArray *sonArr = [NSMutableArray array];
        NSMutableArray *sonArr2 = [NSMutableArray array];
        [sonArr removeAllObjects];
        [sonArr2 removeAllObjects];
        for (int i = 0; i < [arr count]; i ++ ) {
            [sonArr addObject:@"0"];
            [sonArr2 addObject:@"0"];
        }
        [self.chooseArray addObject:sonArr];
        [_copyedChooseArray addObject:sonArr2];
    }
    _tableView.sectionIndexColor = kWechatBlack;
    _tableView.sectionIndexBackgroundColor = kClearColor;
}

- (void)getData{
    NSMutableArray *array = [NSMutableArray array];
    if (_userIds) {
        NSArray *userIdArray = [_userIds componentsSeparatedByString:@","];
        for (NSString *userId in userIdArray) {
            [array addObject:[[[FMDBHelper fmManger] selectUserInfoDataByValueName:@"Id" value:userId] firstObject]];
        }
    }else{
        array = [[FMDBHelper fmManger] selectDataByTableName:kOthreUserTable];
    }
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
//    NSLog(@"");
}
//右侧 索引 一般是和 分区 对应
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *arr = [NSMutableArray array];
    //第0个显示#
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
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
//    //index  就是 点击的 第几个索引
//    //title 就是 索引标题
//    return index-1;
//    //返回 对应的索引值（和分区对应）
//}

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
