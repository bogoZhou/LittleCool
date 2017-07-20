//
//  PosterMainViewController.m
//  LittleCool
//
//  Created by 周博 on 2017/4/25.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "PosterMainViewController.h"
#import "PosterMainTableViewCellTitle.h"
#import "PosterMainTableViewCellItems.h"

#import "PosterListModel.h"
#import "MubanModel.h"

#define kCell1 @"PosterMainTableViewCellTitle"
#define kCell2 @"PosterMainTableViewCellItems"


@interface PosterMainViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation PosterMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray = [NSMutableArray array];
    [self loadData];
}

#pragma mark - 下载数据
- (void)loadData{
    [[AFClient shareInstance] posterGetLabelsMubanById:kUserId udid:UDID progressBlock:nil success:^(id responseBody) {
        if ([responseBody[@"code"] integerValue] == 200) {
            for (NSDictionary *dic in responseBody[@"data"]) {
                PosterListModel *listModel = [[PosterListModel alloc] init];
                [listModel setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:listModel];
            }
            [_tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark  - 点击事件

/**
 选择 -> 推荐  全部,101   102
 
 @param sender nil
 */
- (IBAction)typeButtonClick:(UIButton *)sender {
    if (sender.tag == 101) {//推荐
        _imageViewTuijian.image = [UIImage imageNamed:@"hb_recommended"];
        _labelTuijian.textColor = kPosterRed;
        _viewTuijian.backgroundColor = kSystemBlack;
        
        _imageViewQuanbu.image = [UIImage imageNamed:@"hb_all"];
        _labelQuanbu.textColor = kWhiteColor;
        _viewQuanbu.backgroundColor =kClearColor;
    }else{//全部
        _imageViewTuijian.image = [UIImage imageNamed:@"hb_recommended02"];
        _labelTuijian.textColor = kWhiteColor;
        _viewTuijian.backgroundColor = kClearColor;
        
        _imageViewQuanbu.image = [UIImage imageNamed:@"hb_all02"];
        _labelQuanbu.textColor = kPosterRed;
        _viewQuanbu.backgroundColor =kSystemBlack;
    }
}


/**
 点击返回

 @param sender nil
 */
- (IBAction)backButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//        PosterMainTableViewCellTitle *cell = (PosterMainTableViewCellTitle *)[tableView dequeueReusableCellWithIdentifier:kCell1];
//        return cell;
//    }else{
        PosterMainTableViewCellItems *cell = (PosterMainTableViewCellItems *)[tableView dequeueReusableCellWithIdentifier:kCell2];
    PosterListModel *model = _dataArray[indexPath.section];
    [cell showDataWithModel:model];
        return cell;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//        return 100  ;
//    }else{
        return 300;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    
    PosterListModel *model = _dataArray[section];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenSize.width - 30, 50)];
    label.text = model.label;
    label.textColor = kWhiteColor;
    [view addSubview:label];
    
    return view;
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
