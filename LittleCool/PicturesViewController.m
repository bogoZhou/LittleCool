//
//  PicturesViewController.m
//  LittleCool
//
//  Created by 周博 on 17/4/10.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "PicturesViewController.h"
#import "CellModel.h"
#import "WSCollectionCell.h"
#import "WSLayout.h"
#import "LabelsModel.h"
#import "MSSBrowseDefine.h"

@interface PicturesViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,UIViewControllerTransitioningDelegate,UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSInteger _buttonTag;
    
    NSInteger _pageIndex;
}
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) WSLayout *wslayout;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *labelsArray;
@property (nonatomic,strong) UIView *labelsView;
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong) NSString *labelsId;

@end

@implementation PicturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navBarTitle:@"图片素材"];
    [self navBarbackButton:@"        "];
    _dataArray = [NSMutableArray array];
    _labelsArray = [NSMutableArray array];
    [self loadLabels];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)creatTopLabels{
    _labelsView = [[UIView alloc] init];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, kScreenSize.width - 40, 20)];
    titleLabel.text = @"微商都在用";
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = kBlueColor;
    
    [_labelsView addSubview:titleLabel];
    
    
    
    CGFloat width = 0;
    CGFloat lines = 0;
    for (NSInteger i = 0; i < _labelsArray.count; i ++) {
        LabelsModel *model = _labelsArray[i];
        NSString *nameStr = [NSString stringWithFormat:@"  %@  ",model.name];
        CGSize titleSize = [nameStr boundingRectWithSize:CGSizeMake(kScreenSize.width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
        
        if (width + 15 + titleSize.width + 5 >= kScreenSize.width) {
            lines ++;
            width = 0;
        }
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15 + width, titleLabel.allHeight +20+ (20 + 30) *lines,titleSize.width, 30)];
        width += 15 + titleSize.width;
        button.backgroundColor = kWhiteColor;
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [kBlueColor CGColor];
        button.layer.cornerRadius = 15;
        [button setTitle:model.name forState:UIControlStateNormal];
        [button setTitleColor:kBlueColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        button.tag = 1000 + i;
        [button addTarget:self action:@selector(labelsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_labelsView addSubview:button];
    }
    _labelsView.frame = CGRectMake(0, 0, kScreenSize.width,50 + lines * 50 +titleLabel.allHeight + 10);
    [self.view addSubview:_labelsView];
    [self loadData:nil];
}

- (void)labelsButtonClick:(UIButton *)button{

    if (_buttonTag > 0) {
        UIButton *newButton = (UIButton *)[self.view viewWithTag:_buttonTag];
        newButton.layer.borderColor = [kBlueColor CGColor];
        newButton.backgroundColor = kWhiteColor;
        [newButton setTitleColor:kBlueColor forState:UIControlStateNormal];
    }
    
    _buttonTag = button.tag;
    UIButton *oldButton = (UIButton *)[self.view viewWithTag:button.tag];
    oldButton.layer.borderColor = [kWhiteColor CGColor];
    oldButton.backgroundColor = kBlueColor;
    [oldButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    
    LabelsModel *model = _labelsArray[button.tag - 1000];
    _labelsId = model.id;
    _pageIndex = 0;
    [self loadData:_labelsId];
    
}

#pragma mark - 数据下载
//加载所有标签
- (void)loadLabels{
    [[AFClient shareInstance] getPictureLabelsByUserId:kUserId udid:UDID progressBlock:^(NSProgress *progress) {
        
    } success:^(id responseBody) {
        if ([responseBody[@"code"] integerValue] == 200) {
            for (NSDictionary *dic in responseBody[@"data"]) {
                LabelsModel *model = [[LabelsModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_labelsArray addObject:model];
            }
            [self creatTopLabels];

        }
    } failure:^(NSError *error) {
        
    }];
}

//加载所有内容
- (void)loadData:(NSString *)labelsId{
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];

    // Set the label text.
    _hud.label.text = NSLocalizedString(@"加载中...", @"HUD loading title");
    
    NSString *pageIndexStr = [NSString stringWithFormat:@"%ld",_pageIndex];
    [[AFClient shareInstance] getPictureInfoByUserId:kUserId udid:UDID material_label_id:labelsId title:nil page_index:@"0" page_size:@"10000" progressBlock:^(NSProgress *progress) {
        
    } success:^(id responseBody) {
        if ([responseBody[@"code"] integerValue] == 200) {
            [_hud hideAnimated:YES];
            if (_pageIndex == 0) {
                 [_dataArray removeAllObjects];
            }
            for (NSDictionary *dic in responseBody[@"data"]) {
                CellModel *model = [[CellModel alloc]init];
                model.imgURL = dic[@"img_url"];
                model.imgWidth = [dic[@"img_width"] floatValue];
                model.imgHeight = [dic[@"img_height"] floatValue];
                model.title = dic[@"id"];
                model.imageContent = dic[@"introduce"];
                [_dataArray addObject:model];
            }

            
//            if (_collectionView) {
//                [_collectionView reloadData];
//            }else{
                [self _creatSubView];
//            }
        }
    } failure:^(NSError *error) {
        
    }];
 }

- (void)_creatSubView {

    if (self.collectionView) {
        [self.collectionView removeFromSuperview];
        self.collectionView = nil;
        self.wslayout = nil;
    }
    
    self.wslayout = [[WSLayout alloc] init];
    self.wslayout.lineNumber = 3; //列数
    self.wslayout.rowSpacing = 5; //行间距
    self.wslayout.lineSpacing = 5; //列间距
    self.wslayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    // 透明时用这个属性(保证collectionView 不会被遮挡, 也不会向下移)
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    // 不透明时用这个属性
    //self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, _labelsView.sizeHeight, self.view.frame.size.width, self.view.frame.size.height - _labelsView.sizeHeight) collectionViewLayout:self.wslayout];
    
    [self.collectionView registerClass:[WSCollectionCell class] forCellWithReuseIdentifier:@"collectCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    // 下拉刷新
    __unsafe_unretained __typeof(self) weakSelf = self;
    self.collectionView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        //        kAlert(@"下拉刷新");
        [weakSelf loadData:_labelsId];
        [weakSelf.collectionView.mj_header endRefreshing];
    }];
//    // 上拉刷新
//    self.collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//        //        kAlert(@"上拉刷新");
//        _pageIndex ++ ;
//        [weakSelf loadData:_labelsId];
//        [weakSelf.collectionView.mj_footer endRefreshing];
//    }];
    


    //返回每个cell的高   对应indexPath
    [self.wslayout computeIndexCellHeightWithWidthBlock:^CGFloat(NSIndexPath *indexPath, CGFloat width) {
        
        CellModel *model = _dataArray[indexPath.row];
        CGFloat oldWidth = model.imgWidth;
        CGFloat oldHeight = model.imgHeight;

        
        CGFloat newWidth = width;
        CGFloat newHeigth;
        if (oldWidth > 0) {
            newHeigth = oldHeight*newWidth / oldWidth;
        }else{
            newHeigth = 0;
        }
        return newHeigth;
    }];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WSCollectionCell *cell = (WSCollectionCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"collectCell" forIndexPath:indexPath];
    
    cell.model = _dataArray[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"选中了第%ld个item",indexPath.row);
    
    // 加载网络图片
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    int i = 0;
    for(i = 0;i < _dataArray.count;i++)
    {
        CellModel *model = _dataArray[i];
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        browseItem.bigImageUrl = model.imgURL;// 加载网络图片大图地址
        browseItem.imageContent = model.imageContent;
        [browseItemArray addObject:browseItem];
    }
    MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:indexPath.row];
    [bvc showBrowseViewController];
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
