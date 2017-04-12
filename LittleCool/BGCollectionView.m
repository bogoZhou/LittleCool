//
//  BGCollectionView.m
//  LittleCool
//
//  Created by 周博 on 17/3/13.
//  Copyright © 2017年 BogoZhou. All rights reserved.
//

#import "BGCollectionView.h"
#import "BGCollectionViewCell.h"
#import "MainDetailViewController.h"
#import "VideosModel.h"

#define kCellName @"BGCollectionViewCell"

@interface BGCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    
}

@end

@implementation BGCollectionView

- (instancetype)initWithFrame:(CGRect)frame withDataArray:(NSMutableArray *)dataArray
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataArray = dataArray;
        [self creatCollectionView];
    }
    return self;
}


- (void)creatCollectionView{
    UICollectionViewFlowLayout *floatLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (self.sizeWidth - 40) /2;
    CGFloat height= width * (262.0/340);
    floatLayout.itemSize = CGSizeMake(width, height);//设置每个cell的大小
    floatLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);//设置内容的内边距
    floatLayout.minimumInteritemSpacing = 20;//设置每个cell之间的最小间距
    floatLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//设置滚动方向
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.sizeWidth, self.sizeHeight) collectionViewLayout:floatLayout];
    _collectionView.backgroundColor = kWhiteColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerNib:[UINib nibWithNibName:kCellName bundle:nil] forCellWithReuseIdentifier:kCellName];
    [self addSubview:_collectionView];
}

- (void)reloadDataByArray:(NSMutableArray *)array{
    _dataArray = array;
    [_collectionView reloadData];
}

#pragma mark - collectionDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BGCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellName forIndexPath:indexPath];
    VideosModel *model = _dataArray[indexPath.row];
    [cell.imageViewImg sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:[UIImage imageNamed:@"ditu"]];
    cell.labelName.text = model.title;
    cell.imageViewNew.hidden = model.statusNew.integerValue > 0 ? NO : YES;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{    
    VideosModel *model = _dataArray[indexPath.row];
    
    UIStoryboard *storyboard = kMainStroyboard;
    MainDetailViewController *mainDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"MainDetailViewController"];
    mainDetailVC.hidesBottomBarWhenPushed = YES;
    mainDetailVC.model = model;
    [[self findViewController:self].navigationController pushViewController:mainDetailVC animated:YES];
}


#pragma mark - 找到当前view所在的控制器
- (UIViewController *)findViewController:(UIView *)sourceView
{
    id target=sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
