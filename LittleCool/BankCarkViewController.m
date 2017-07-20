//
//  BankCarkViewController.m
//  Qian
//
//  Created by 周博 on 17/3/6.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BankCarkViewController.h"
#import "BankCardTableViewCell.h"
#import "BankCardModel.h"
#import "CreatBankViewController.h"

#define kCellName @"BankCardTableViewCell"

@interface BankCarkViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation BankCarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navBarbackButton:@"返回"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self firstStept];
}

- (void)firstStept{
    _dataArray = [NSMutableArray array];
    
    [[FMDBHelper fmManger] createBankTable];
    
    _dataArray = [[FMDBHelper fmManger] selectBankCardWhereValue1:nil value2:nil isNeed:NO];
    
    BankCardModel *bankModel = [[BankCardModel alloc] init];
    bankModel.bankName = @"1";
    [_dataArray addObject:bankModel];
    [self.tableView reloadData];
}

#pragma mark - tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BankCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellName];
    
    
    BankCardModel *model = [[BankCardModel alloc] init] ;
    model = _dataArray[indexPath.row];
    if ([model.bankName isEqualToString:@"1"]) {//新卡
        cell.labelCard.hidden = YES;
        cell.labelRate.hidden = YES;
        cell.labelNewCark.hidden = NO;
        
    }else{//已存在的卡
        
        cell.labelCard.hidden = NO;
        cell.labelRate.hidden = NO;
        cell.labelNewCark.hidden = YES;
        
        cell.labelCard.text = [NSString stringWithFormat:@"%@ (%@)",model.bankName,model.bankNum];
        cell.labelRate.text = [NSString stringWithFormat:@"提现到%@，手续费率%@",model.bankName,@"0.1%"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _dataArray.count -1) {//如果是添加新卡,跳转创建新卡页面
//        kAlert(@"点击使用新卡");
        UIStoryboard *storyboard = kWechatStroyboard;
        CreatBankViewController *creatBankVC = [storyboard instantiateViewControllerWithIdentifier:@"CreatBankViewController"];
        [creatBankVC navBarTitle:@""];
        [creatBankVC navBarbackButton:@"返回"];
        [creatBankVC wechatRightButtonClick:@"完成"];
        [self.navigationController pushViewController:creatBankVC animated:YES];
    }else{//若不是新卡,则选中该卡
//        kAlert(@"选中银行卡");
        BankCardModel *bank = self.dataArray[indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"bank" object:bank];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 45)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 100, 20)];
    label.text = @"到账银行卡";
    label.textColor = [UIColor darkTextColor];
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
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
