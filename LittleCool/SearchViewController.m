//
//  SearchViewController.m
//  LittleCool
//
//  Created by 周博 on 17/3/15.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "SearchViewController.h"
#import "BGCollectionView.h"
#import "VideosModel.h"

@interface SearchViewController ()<UISearchBarDelegate>
{
    NSInteger _pageIndex;
}
@property (nonatomic,strong) BGCollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *myDataArray;
@property (nonatomic,strong) MBProgressHUD *hud;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navBarTitle:@"搜索视频"];
    [self navBarbackButton:@"        "];
    [self firstStept];
    [self creatCollectionView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [_searchBar becomeFirstResponder];
}


- (void)firstStept{
    _myDataArray = [NSMutableArray array];
}

- (void)creatCollectionView{
    _collectionView = [[BGCollectionView alloc] initWithFrame:CGRectMake(0, _searchBar.allHeight, kScreenSize.width, kScreenSize.height -_searchBar.allHeight - 64)withDataArray:_myDataArray];
    // 下拉刷新
    __unsafe_unretained __typeof(self) weakSelf = self;
    self.collectionView.collectionView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        //        kAlert(@"下拉刷新");
        _pageIndex = 0;
        [self loadData];
        [weakSelf.collectionView.collectionView.mj_header endRefreshing];
    }];
    // 上拉刷新
    self.collectionView.collectionView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        //        kAlert(@"上拉刷新");
        _pageIndex ++ ;
        [self loadData];
        [weakSelf.collectionView.collectionView.mj_footer endRefreshing];
    }];
    [self.view addSubview:_collectionView];
}

#pragma mark - loadData

- (void)loadData{
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set the label text.
    _hud.label.text = NSLocalizedString(@"加载中...", @"HUD loading title");
    NSString *pageIndex = [NSString stringWithFormat:@"%ld",_pageIndex];
    [[AFClient shareInstance] getSearchVideosByUserId:kUserId udid:UDID title:_searchBar.text page_index:pageIndex page_size:kPageSize progressBlock:^(NSProgress *progress) {
        
    } success:^(id responseBody) {
        if ([responseBody[@"code"] integerValue] == 200) {
            if ([responseBody[@"data"] count] == 0) {
                if (_pageIndex == 0) {
                    kAlert(@"未搜索到符合条件的数据");
                }else{
                    kAlert(@"没有更多数据了");
                }
                
            }else{
                if (_pageIndex == 0) {
                    [_myDataArray removeAllObjects];
                }
            }
            for (NSDictionary *dic in responseBody[@"data"]) {
                VideosModel *model = [[VideosModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                model.statusNew = dic[@"new_status"];
                [_myDataArray addObject:model];
            }
            [_collectionView reloadDataByArray:_myDataArray];
            [_hud hideAnimated:YES];
        }else{
            kAlert(responseBody[@"message"]);
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - searchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
//    kAlert(@"点击完成");
    _pageIndex = 0;
    [self loadData];
    [_searchBar resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
