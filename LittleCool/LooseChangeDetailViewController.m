//
//  LooseChangeDetailViewController.m
//  Qian
//
//  Created by 周博 on 17/2/8.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "LooseChangeDetailViewController.h"
#import "LooseChangeDetailTableViewCell.h"
#import "MoneyListViewController.h"
#import "BGItemsViewController.h"

@interface LooseChangeDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *_type;
}
@property (nonatomic,strong) NSMutableArray  *dataArray;
@end

@implementation LooseChangeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navBarbackButton:@"返回"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    BGNotiView *notiView = [[BGNotiView alloc] initWithFrame:CGRectMake(_tableView.center.x/2, 64 , 165, 50) contentText:@"点击添加更多条目" direction:up];
    [[BGNotiView defaultManager] showNotiViewByFrame:CGRectMake(kScreenSize.width/2 - 165/2, 0 , 165, 50) contentText:@"点击添加更多条目" direction:up inVC:self];
}

- (void)loadData{
    _dataArray = [NSMutableArray array];
    [[FMDBHelper fmManger] getFMDBBySQLName:kCreatSQL];
    [[FMDBHelper fmManger] createMoneyTable];
    
    _dataArray  = [[FMDBHelper fmManger] selectMoneyWhereValue1:nil value2:nil isNeed:NO];
    if (_dataArray.count == 0) {
        for (int i = 0; i < 8; i ++) {
            [[FMDBHelper fmManger] insertMoneyDataByName:@"微信转账" type:@"-1" date:@"2016-05-08 00:00:00" money:@"1000"];
        }
        _dataArray  = [[FMDBHelper fmManger] selectMoneyWhereValue1:nil value2:nil isNeed:NO];
    }
    [self.tableView reloadData];
}

- (void)clickNavTitle:(UIButton *)button{
    BGItemsViewController *bgItemsVC = [BGItemsViewController viewWithFrameBySuperView:self.navigationItem.titleView];
    BGItemsAction * action = [BGItemsAction actionWithTitle:@"添加明细" handler:^(BGItemsAction *action) {
        [[FMDBHelper fmManger] insertMoneyDataByName:@"微信转账" type:@"-1" date:@"2016-05-08 00:00:00" money:@"1000"];
        _dataArray  = [[FMDBHelper fmManger] selectMoneyWhereValue1:nil value2:nil isNeed:NO];
        [self.tableView reloadData];
    }];
    [bgItemsVC addActions:action];
    [self presentViewController:bgItemsVC animated:YES completion:nil];
}

#pragma mark - tableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MoneyModel *model = _dataArray[indexPath.row];
    LooseChangeDetailTableViewCell *cell = (LooseChangeDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"LooseChangeDetailTableViewCell"];
    cell.labelName.text = model.name;
    cell.labelDate.text = model.date;
    cell.labelMoney.text = [NSString stringWithFormat:@"%@ %.2lf",model.type.integerValue > 0 ? @"+" : @"-",model.money.doubleValue];
    if (model.type.integerValue > 0) {
        cell.labelMoney.textColor = kWechatTabBarColor;
    }else{
        cell.labelMoney.textColor = [UIColor blackColor];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MoneyModel *model = _dataArray[indexPath.row];
    
    UIStoryboard *storyboard = kWechatStroyboard;
    MoneyListViewController *moneyListVC = [storyboard instantiateViewControllerWithIdentifier:@"MoneyListViewController"];
    moneyListVC.moneyModel = model;
    [moneyListVC navBarTitle:@"明细详情编辑"];
    [moneyListVC wechatRightButtonClick:@"完成"];
    [moneyListVC navBarbackButton:@""];
    [self.navigationController pushViewController:moneyListVC animated:YES];
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
