//
//  VideosListViewController.m
//  LittleCool
//
//  Created by 周博 on 17/3/14.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "VideosListViewController.h"
#import "VideosListTableViewCell.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AssetModel.h"
#import <Photos/Photos.h>
#import "PlayViewController.h"
#define kCellName   @"VideosListTableViewCell"

@interface VideosListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isChanged;
}
@property (nonatomic,strong) NSMutableArray *selectIndexPathArray;
@property (nonatomic,assign) NSInteger times;
@property (nonatomic,strong) UIView *deepBar;
@property (nonatomic,strong) UILabel *numLabel;
@property (nonatomic,strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong) NSMutableArray *unselectArray;
@end

@implementation VideosListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navBarTitle:@"配音视频列表"];
    [self navBarbackButton:@"        "];
    [self rightButtonClick:@"管理"];
    _dataArray = [NSMutableArray array];
    _unselectArray = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fresh) name:@"fresh" object:nil];
    _isChanged = YES;
    [self getVideos];
}

- (void)viewWillAppear:(BOOL)animated{
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    // Set the label text.
    _hud.label.text = NSLocalizedString(@"正在获取视频...", @"HUD loading title");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_hud hideAnimated:YES];
    [_tableView reloadData];
}

- (void)fresh{
//    [_hud hideAnimated:YES];
    [_tableView reloadData];
}

- (void)getVideos{
    
    [_dataArray removeAllObjects];

    _assetsLibrary = [[ALAssetsLibrary alloc]init];
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            NSString *string = [group valueForProperty:ALAssetsGroupPropertyName];
            if ([string isEqualToString:@"有点逗"]) {
                [group setAssetsFilter:[ALAssetsFilter allVideos]];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                        if (! result) return;
                        
                        if (result) {
                            
                            ALAssetRepresentation* representation = [result defaultRepresentation];
                            
                            UIImage *image = [UIImage imageWithCGImage:[representation fullResolutionImage]];
                            
                            NSString *name = [representation filename];
                            
                            NSURL *url = [result valueForProperty:ALAssetPropertyAssetURL];
                            
                            NSDate* pictureDate = [result valueForProperty:ALAssetPropertyDate];
                            
                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                            [formatter setDateStyle:NSDateFormatterMediumStyle];
                            [formatter setTimeStyle:NSDateFormatterShortStyle];
                            [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
                            NSString *nowtimeStr = [formatter stringFromDate:pictureDate];
                            
                            AssetModel *model = [[AssetModel alloc] init];
                            model.headImage = image;
                            model.titleName = name;
                            model.DateString = nowtimeStr;
                            model.url = url;
                            
                            [_dataArray addObject:model];
                            if (_dataArray.count == group.numberOfAssets) {
                                NSLog(@"%@",_dataArray);
                                *stop = YES;
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"fresh" object:nil];
                            }
                            
                        }else{
//                            [_tableView reloadData];
                            
                            *stop = YES;
                        }
                    }];
                });
            }
        }else{
//            [_tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"error:%@",error);
    }];
}

- (void)creatDeepBar{
    if (!_deepBar) {
        _deepBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenSize.height - 50 - 64, kScreenSize.width, 50)];
        _deepBar.layer.masksToBounds = YES;
        _deepBar.layer.borderWidth = 0.5f;
        _deepBar.layer.borderColor = [kColorFrom0x(0xf4f4f4) CGColor];
        
        //小蓝点
        UIImageView *pointImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17.5, 15, 15)];
        pointImageView.image = [UIImage imageNamed:@"selecte.png"];
        [_deepBar addSubview:pointImageView];
        
        //全选label
        UILabel *allChooseLabel = [[UILabel alloc] initWithFrame:CGRectMake(pointImageView.allWidth + 15, 15, 40, 20)];
        allChooseLabel.text = @"全选";
        allChooseLabel.font = [UIFont systemFontOfSize:14];
        [_deepBar addSubview:allChooseLabel];
        
        //全选按钮
        UIButton *allChooseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, allChooseLabel.allWidth, _deepBar.sizeHeight)];
        [allChooseButton setTitle:@"" forState:UIControlStateNormal];
        [allChooseButton addTarget:self action:@selector(allChooseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_deepBar addSubview:allChooseButton];
        
        //共几个文件
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(allChooseLabel.allWidth + 15, 18, 100, 14)];
        _numLabel.font = [UIFont systemFontOfSize:10];
        _numLabel.text = [NSString stringWithFormat:@"共%ld个文件",_dataArray.count];
        [_deepBar addSubview:_numLabel];
        
        UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenSize.width - 80, 0, 40, _deepBar.sizeHeight)];
        [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        deleteButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [deleteButton setTitleColor:kBlackColor forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_deepBar addSubview:deleteButton];
        [self.view addSubview:_deepBar];
    }
}

- (void)showDeepBarView{
    _deepBar.hidden = NO;
    [self creatDeepBar];
}

-(void)hiddenDeepBarView{
    _deepBar.hidden = YES;
}

- (void)deletePhotos:(NSMutableArray *)array{
    PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:array options:nil];
    NSMutableArray *assetArray = [NSMutableArray array];
    for (int i = 0; i < result.count; i ++) {
        PHAsset *asset = result[i];
        [assetArray addObject:asset];
    }
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest deleteAssets:assetArray];
    } completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            kAlert(@"删除成功");
            NSLog(@"已删除");
//            [_dataArray removeAllObjects];
//            [_dataArray addObjectsFromArray:_unselectArray];
//            [self.tableView reloadData];
            [self getVideos];
        }else{
            kAlert(@"删除失败");
            NSLog(@"Error: %@", error);
        }
        
    }];
}

#pragma mark - 点击事件

- (void)rightNavButtonClick{
    if (_isChanged) {
        [self rightButtonClick:@"完成"];
        [self showDeepBarView];
        _tableView.frame = CGRectMake(_tableView.orginX, _tableView.orginY, _tableView.sizeWidth, _tableView.sizeHeight - 50);
    }else{
        [self rightButtonClick:@"管理"];
        [self hiddenDeepBarView];
        _tableView.frame = CGRectMake(_tableView.orginX, _tableView.orginY, _tableView.sizeWidth, _tableView.sizeHeight + 50);
        
        for (AssetModel *model in _dataArray) {
            model.type = @"0";
        }
        [_tableView reloadData];
    }
    _isChanged = !_isChanged;
    
//    kAlert(@"点击管理");
}
//点击全选按钮
- (void)allChooseButtonClick:(UIButton *)button{
//    kAlert(@"点击全选");
    for (AssetModel *model in _dataArray) {
        model.type = @"1";
    }
    [_tableView reloadData];
}

//点击删除按钮
- (void)deleteButtonClick:(UIButton *)button{
//    kAlert(@"点击删除");
    [_unselectArray removeAllObjects];
    NSMutableArray *array = [NSMutableArray array];
    for (AssetModel *model in _dataArray) {
        if (model.type.integerValue == 1) {
            NSURL *url = model.url;
            [array addObject:url];
        }else{
            [_unselectArray addObject:model];
        }
    }
    if (array.count > 0) {
        [self deletePhotos:array];
    }else{
        kAlert(@"请选择要删除的视频");
    }
    
}
#pragma mark - tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    [_hud hideAnimated:YES];
    VideosListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellName];

    AssetModel *model = _dataArray[indexPath.row];
    
    cell.imageViewHeader.image = model.headImage;
    
    cell.labelTitle.text = model.titleName;

    cell.labelDate.text =model.DateString;
    
    cell.imageViewSelect.hidden = model.type.integerValue == 0 ? YES : NO;
    
//    NSLog(@"url -> %@",model.url);

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_isChanged) {
        AssetModel *model = _dataArray[indexPath.row];
        model.type = model.type.integerValue == 0 ? @"1" : @"0";
        [_tableView reloadData];
    }else{
        AssetModel *model = _dataArray[indexPath.row];
        UIStoryboard *storyboard = kMainStroyboard;
        PlayViewController *playVC = [storyboard instantiateViewControllerWithIdentifier:@"PlayViewController"];
        playVC.url = model.url;
        [self.navigationController pushViewController:playVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
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

